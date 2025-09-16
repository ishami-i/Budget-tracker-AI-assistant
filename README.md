# Budget Tracker AI Assistant

An intelligent budgeting assistant that helps users:
- Record income and expenses
- Classify expenses (non-negotiable, high, medium, low priority)
- Calculate the **expense-to-income ratio**
- Warn when spending exceeds **80% of income**
- Recommend which expenses to cut first (starting with low/medium priorities)

---

## 🚀 Features
- Interactive dashboard for entering income & expenses
- Priority labels for each expense category
- Automatic calculation of:
  - Total expenses
  - Expense ratio (expenses ÷ income)
  - Risk flag (≥80% of income)
- Personalized advice on where to save
- Notifications to track budgeting progress

---

## 🛠️ Tech Stack

| Area | Technology |
|------|-------------|
| **ML / Backend** | Python, Pandas, PyTorch (future ML models) |
| **Frontend (mobile/web)** | Flutter |
| **Database / Auth** | Firebase |
| **Hosting / Deployment** | Firebase Hosting or Vercel for web dashboard |
| **Version control** | Git & GitHub |
| **IDE** | Google Colab (data exploration), VS Code (backend & API) |

---

## 📁 Project Structure

```
budget-tracker-ai/
│
├── data/
│   ├── sample_expenses.csv
│   └── README_DATA.md
│
├── notebooks/
│   └── expense_ratio_demo.ipynb
│
├── backend/
│   ├── app.py              # FastAPI / Flask for serving predictions
│   └── models/             # Future PyTorch models
│
├── frontend/
│   └── flutter_app/        # Mobile app UI
│
├── README.md
└── requirements.txt
```

---

## 📊 Dataset

Each expense is one row.

| Column | Description |
|--------|-------------|
| `entry_id` | Unique row ID |
| `user_id` | User identifier |
| `period` | Month/Year |
| `income` | Total income |
| `expense_amount` | Expense amount |
| `category` | e.g., Rent, Food, Transport |
| `priority_flag` | non_negotiable / high / medium / low |
| `cutoff_rate` | % that can be reduced |
| `cutoff_note` | Suggestion text |
| `total_expenses` | Derived per user & period |
| `expense_ratio` | total_expenses ÷ income |
| `risk_flag` | 1 if expense_ratio ≥ 0.8 |

---

## 🧑‍💻 Installation & Usage

### 1. Clone the repo
```bash
git clone https://github.com/<yourusername>/budget-tracker-ai.git
cd budget-tracker-ai
```

### 2. Set up Python environment
```bash
python -m venv venv
source venv/bin/activate  # (Linux/macOS)
venv\Scripts\activate     # (Windows)
pip install -r requirements.txt
```

### 3. Explore in Colab or VS Code
- Open `notebooks/expense_ratio_demo.ipynb` in **Colab**.
- Or run the Python script:
```bash
python backend/app.py
```

### 4. Flutter app
- Go to `frontend/flutter_app/` and follow [Flutter setup](https://docs.flutter.dev/get-started/install).

---

## 🔮 Roadmap
- [ ] Build REST API with FastAPI to serve budget advice
- [ ] Train PyTorch model for smarter recommendations
- [ ] Connect Firebase for storage & notifications
- [ ] Polish Flutter UI (onboarding, dashboard, history)
- [ ] Deploy to production

---

## 🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.

---

## 📄 License
MIT License (or the one your team prefers)

