#Week 1 - Foundations
## What I covered
- **Day 1–2:** pandas basics, merges, data cleaning, numpy
- **Day 3–4:** SQL — GROUP BY, HAVING, JOINs, window functions, CTEs
- **Day 5:** Data modeling — star schema, EightyDays schema + ERD

## Key concepts learned
- Fact vs dimension tables
- fillna → drop_duplicates order matters
- Window functions: ROW_NUMBER, RANK, LAG, running totals
- CTE pattern for filtering on window function results
- Normalisation — store once, reference everywhere

## Files
| File | Description |
|------|-------------|
| python/day1_pandas.py | Load, filter, sort, groupby, apply |
| python/day2_pandas.py | Merges, cleaning, numpy |
| sql/day3.sql | GROUP BY, HAVING, JOINs |
| schema/eightydays_schema.sql | EightyDays database schema |
| schema/eightydays_erd.png | Entity relationship diagram |

## Mistakes I made and fixed
1. Running drop_duplicates before fillna
2. Using groupby when idxmax was the right tool
3. Initialised git in wrong folder — fixed with clean repo