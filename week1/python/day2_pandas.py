import pandas as pd
import numpy as np

#  --- Two related tables
cities = pd.DataFrame({
    'city': ['Mumbai', 'Rome', 'Paris', 'Tokyo', 'Milan', 'Delhi'],
    'country_code': ['IN', 'IT', 'FR', 'JP', 'IT', 'IN'],
    'rating': [4.1, 4.5, 4.7, 4.8, 4.2, 3.9]
})

countries = pd.DataFrame({
    'country_code': ['IN', 'IT', 'FR', 'JP', 'ES'],
    'country_name': ['India', 'Italy', 'France', 'Japan', 'Spain'],
    'continent': ['Asia', 'Europe', 'Europe', 'Asia', 'Europe']
})

# INNER JOIN — only cities that have a matching country
inner = pd.merge(cities, countries, on='country_code', how='inner')
print("Inner:\n", inner)

avg_rating = inner.groupby('continent')['rating'].mean()
print("avg rating per continent:", avg_rating)


# LEFT JOIN — all cities, even if country info is missing
left = pd.merge(cities, countries, on='country_code', how='left')
print("Left:\n", left)

# Notice Spain is in countries but has no cities — does it appear? Why?
outer = pd.merge(cities, countries, on='country_code' , how='outer')
print("Outer:\n", outer)

cities.loc[6] = ['Unknown city', 'TT', 4.5]
left = pd.merge(cities, countries, on='country_code', how='left')
print("Left:\n", left)


# Reason why inner has 6 rows and outer has 7
# INNER JOIN returns only rows with a match in both tables. 
# OUTER JOIN returns everything — matched rows plus unmatched rows from either side, 
# filling gaps with NaN. Spain (ES) appears in the countries table but has no cities, 
# so it shows up in OUTER with NaN for city and rating."

# on: common entity in both tables

# --- Messy dataset — like real world data ---
messy = pd.DataFrame({
    'city': ['Paris', 'paris', 'TOKYO', 'Rome', 'Rome', None, 'Delhi'],
    'country': ['France', 'France', 'Japan', 'Italy', 'Italy', 'India', 'India'],
    'rating': [4.7, 4.7, 4.8, None, 4.5, 4.1, 3.9],
    'cost': [150, 150, 170, 120, 120, 30, None]
})

print("Before cleaning")
print(messy)
print("\nNull Counts\n:" , messy.isna().sum())

# Step 1 — fix inconsistent city names (lowercase everything)
messy['city'] = messy['city'].str.lower().str.strip()




# Step 3 — fill missing rating with the column average
messy['rating'] = messy['rating'].fillna(messy['rating'].mean())

# Step 2 — remove duplicate rows
messy = messy.drop_duplicates()

# Step 4 — fill missing cost with 0 (unknown cost)
messy['cost'] = messy['cost'].fillna(0)

# Step 5 — drop rows where city name is missing entirely
messy = messy.dropna(subset=['city'])

print("After cleaning")
print(messy)
print("\nNull Counts\n:" , messy.isna().sum())


high_ratedCity = messy.loc[messy['rating'].idxmax(), 'city']
print("high rated city:", high_ratedCity)

# Rule: always fill nulls BEFORE deduplicating
# otherwise NaN != 4.5 and duplicates slip through


# --- Numpy: faster math on arrays ---
ratings = np.array([4.1, 4.5, 4.7, 4.8, 4.2, 3.9, 4.6, 4.0])

print("Mean:" , np.mean(ratings))
print("Median:" , np.median(ratings))
print("Std deviation:", np.std(ratings))
print("75th percentile:", np.percentile(ratings, 75))

# np.where — vectorized if/else (faster than apply for simple conditions)
tiers = np.where(ratings > 4.5 , 'top-tier', 'standard')
print("Tiers:", tiers)

costs = np.array([80, 200, 150, 70, 90, 170, 110, 60, 140, 300])
print(np.percentile(costs, 80))