from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import joblib
import pandas as pd
import uvicorn
from pathlib import Path
from typing import Optional


# Load trained bundle produced in Colab (path resolved relative to this file)
# bundle = { 'model': rf_model_or_log_model, 'encoders': { 'category': LabelEncoder, 'priority_flag': LabelEncoder, 'currency': LabelEncoder }, 'feature_order': [...] }
backend_dir = Path(__file__).parent
candidate_names = [
    "recommender_bundle.pkl",          # primary expected name
    "recommendation_bundle.pkl",       # common variant
]

bundle_path = None
for name in candidate_names:
    p = backend_dir / name
    if p.exists():
        bundle_path = p
        break

if bundle_path is None:
    tried = ", ".join(str(backend_dir / n) for n in candidate_names)
    raise FileNotFoundError(
        "Model bundle not found. Tried: " + tried + ". "
        "Place the bundle with one of these names or update the code."
    )
loaded = joblib.load(str(bundle_path))

# Defaults if encoders/feature order are not provided
DEFAULT_FEATURE_ORDER = [
    "income_x","income_y","expense_amount",
    "category_enc","priority_enc","cutoff_rate",
    "total_expenses","expense_ratio","risk_flag",
]

model = None
encoders = None
feature_order = DEFAULT_FEATURE_ORDER

if isinstance(loaded, dict):
    model = loaded.get("model")
    encoders = loaded.get("encoders")
    feature_order = loaded.get("feature_order", DEFAULT_FEATURE_ORDER)
else:
    # Loaded a bare sklearn estimator
    model = loaded


app = FastAPI(title="Budget Recommender API", version="1.0.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


class ExpenseInput(BaseModel):
    income_x: float
    income_y: float
    expense_amount: float
    # Raw strings (used when encoders are available)
    category: Optional[str] = None
    priority_flag: Optional[str] = None
    currency: Optional[str] = None
    # Numeric encodings (used when encoders are NOT available)
    category_enc: Optional[int] = None
    priority_enc: Optional[int] = None
    cutoff_rate: float
    total_expenses: float
    expense_ratio: float
    risk_flag: int


@app.get("/")
def root():
    return {
        "status": "ok",
        "message": "Budget Recommender API",
        "bundle_path": str(bundle_path),
    }


@app.post("/predict")
def predict(expense: ExpenseInput):
    # Decide how to obtain encodings
    if encoders is not None:
        if expense.category is None or expense.priority_flag is None:
            raise HTTPException(status_code=400, detail="Provide 'category' and 'priority_flag' as strings.")
        category_enc = int(encoders["category"].transform([expense.category])[0])
        priority_enc = int(encoders["priority_flag"].transform([expense.priority_flag])[0])
        # Optional: currency encoder if your model uses it in the future
        # currency_enc = int(encoders["currency"].transform([expense.currency])[0])
    else:
        if expense.category_enc is None or expense.priority_enc is None:
            raise HTTPException(
                status_code=400,
                detail=(
                    "Model bundle has no encoders. Provide numeric 'category_enc' and 'priority_enc', "
                    "or re-export a bundle with encoders."
                ),
            )
        category_enc = int(expense.category_enc)
        priority_enc = int(expense.priority_enc)

    row = {
        "income_x": expense.income_x,
        "income_y": expense.income_y,
        "expense_amount": expense.expense_amount,
        "category_enc": category_enc,
        "priority_enc": priority_enc,
        "cutoff_rate": expense.cutoff_rate,
        "total_expenses": expense.total_expenses,
        "expense_ratio": expense.expense_ratio,
        "risk_flag": expense.risk_flag,
    }

    X = pd.DataFrame([row])[feature_order]
    pred = int(model.predict(X)[0])
    return {"recommend_flag": pred}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)


