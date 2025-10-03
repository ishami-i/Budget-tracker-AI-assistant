# Budget Recommender Backend (FastAPI)

This backend loads your trained model and encoders saved in a single bundle file `recommender_bundle.pkl` and exposes a `/predict` endpoint.

## Files
- `backend.py` — FastAPI server
- `requirements.txt` — Python dependencies
- `recommender_bundle.pkl` — place your saved bundle here (created in Colab)

## Create the bundle in Colab (example)
Save the model, encoders, and feature order together:

```python
import joblib
bundle = {
    'model': rf_model,  # or log_model
    'encoders': {
        'category': encoder_category,
        'priority_flag': encoder_priority,
        'currency': encoder_currency,
    },
    'feature_order': [
        'income_x','income_y','expense_amount',
        'category_enc','priority_enc','cutoff_rate',
        'total_expenses','expense_ratio','risk_flag'
    ]
}
joblib.dump(bundle, 'recommender_bundle.pkl')
```

## Setup & Run
```bash
python -m venv .venv
. .venv/Scripts/activate  # PowerShell on Windows: .venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn backend:app --host 0.0.0.0 --port 8000
```

- Android emulator: use base URL `http://10.0.2.2:8000`
- iOS simulator: `http://localhost:8000`
- Real device: `http://<your-lan-ip>:8000`

## Request body (JSON)
```json
{
  "income_x": 3000,
  "income_y": 1000,
  "expense_amount": 200,
  "category": "Food",
  "priority_flag": "planned",
  "cutoff_rate": 0.1,
  "total_expenses": 1500,
  "expense_ratio": 0.2,
  "risk_flag": 0,
  "currency": "Rwf"
}
```

Response:
```json
{"recommend_flag": 1}
```


