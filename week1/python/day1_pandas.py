import pandas as pd
import numpy as np
# load dataset
df = pd.read_csv(r'C:\Users\ashwini\Desktop\data_engineering1\week1\data\cities.csv')


# always run these 3 statements first
print(df.head())        #first 5 rows
print(df.info())        #column names, data types, nulls
print(df.describe())    #stats: mean, max , min

# filter
italy = df[df['country'] == 'Italy']
print(italy)

# get cities with rating > 4.5

top_rated = df[df['rating'] >= 4.5]
print(top_rated)

# ── SORT ──────────────────────────────────────────────
# Sort all cities by rating, best first
best_cities = df.sort_values('rating' , ascending=False)
print(best_cities.head(5))

# ── GROUPBY ───────────────────────────────────────────
# Average rating per country
avg_rating = df.groupby('country')['rating'].mean()
print(avg_rating.sort_values(ascending=True))

# Count of cities per country
city_count = df.groupby('country')['city'].count()
print(city_count)

# ── APPLY (create a new column) ───────────────────────
# Budget tier based on cost
df['budget_tier'] = df['cost_per_day'].apply(
    lambda x: 'budget' if x < 60 else ('mid' if x < 130 else 'expensive')
)

print(df[['city', 'cost_per_day', 'budget_tier']])

# Q1. Which country has the highest average cost per day?
high_avgCost = df.groupby('country')['cost_per_day'].mean()
print(high_avgCost.sort_values(ascending=False))

# Q2. How many cities fall into each budget_tier? (use groupby)
cities_count = df.groupby('budget_tier')['city'].count()
print(cities_count)

# Q3. Add a new column called "visit_score" = rating * 10 - cost_per_day. Which city has the highest visit_score?
df['visit_score'] = df['rating'] * 10 - df['cost_per_day']

high_visitScore = df.loc[df['visit_score'].idxmax(), 'city']
print(high_visitScore)


# Day 1 learnings:
# - groupby() is for groups, idxmax() is for finding one max row
# - direct arithmetic (df['a'] * 10) is cleaner than .apply() for simple math
# - always re-read what you're grouping BY before running


costs_array = df['cost_per_day'].to_numpy()
print(costs_array)
percent_90 = np.percentile(costs_array, 90)
print(percent_90)