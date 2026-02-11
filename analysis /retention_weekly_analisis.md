# Weekly Retention Analysis

This document describes the logic, methodology, and SQL implementation used to calculate **weekly retention** for the Casual Wear dataset.

---

## 📌 What is Weekly Retention?

Weekly retention measures how many users return to the product **N weeks after their first activity**.

- **Week 0** — the week of the user's first activity (cohort size)
- **Week 1** — users who returned 1 week later
- **Week 2** — users who returned 2 weeks later
- etc.

Retention is calculated as:

\[
\text{Retention}_N = \frac{\text{Users active in week } N}{\text{Users active in week } 0}
\]


