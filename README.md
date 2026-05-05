# phoneuse

SQL project about Screen Time, Sleep & Stress Analysis Dataset. Data analysis on smartphone usage patterns and their relationship to productivity, stress, and sleep quality among students.

**Dataset:** [Screen Time, Sleep & Stress Analysis Dataset](https://www.kaggle.com/datasets/amar5693/screen-time-sleep-and-stress-analysis-dataset) — ML-ready dataset analyzing smartphone usage and productivity.

---

## Dataset Overview

| Property | Value |
|----------|-------|
| Table name | `phoneuse` |
| Rows | 50,000 |
| Database | PostgreSQL |

### Schema

| Column | Type | Description |
|--------|------|-------------|
| `user_id` | varchar | Unique user identifier |
| `age` | integer | User age |
| `gender` | varchar | Gender |
| `occupation` | varchar | Occupation category |
| `device_type` | varchar | Smartphone platform |
| `daily_phone_hours` | real | Average daily phone usage (hours) |
| `social_media_hours` | real | Daily time spent on social media (hours) |
| `work_productivity_score` | integer | Self-reported productivity score (0–100) |
| `sleep_hours` | real | Average nightly sleep (hours) |
| `stress_level` | integer | Stress score (1–10) |
| `app_usage_count` | integer | Number of distinct apps used daily |
| `caffeine_intake_cups` | integer | Daily caffeine intake (cups) |
| `weekend_screen_time_hours` | real | Weekend screen time (hours) |

---

## Project Structure

```
phoneuse/
├── README.md
└── queries/
    ├── 01_schema.sql             -- Schema inspection & full table scan
    ├── 02_correlation_matrix.sql -- Full Pearson correlation matrix
    ├── 03_distributions.sql      -- Descriptive stats & distributions
    ├── 04_segmentation.sql       -- Cohort analysis & behavioral segments
    ├── 05_demographics.sql       -- Age, gender & occupation breakdowns
    └── 06_data_quality.sql       -- NULL checks & sanity validation
```

## Results
### Correlation matrix
The correlation matrix confirms complete independence between all variables. No pair of numeric columns shows a meaningful linear relationship (all |r| < 0.01), which is consistent with the synthetic nature of the dataset.
