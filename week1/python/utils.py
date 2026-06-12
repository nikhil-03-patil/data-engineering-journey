import pandas as pd
import numpy as np

def load_csv(filepath):
    """Load a CSV file and print basic info."""
    df = pd.read_csv(filepath)
    print(f"Loaded {len(df)} rows, {len(df.columns)} columns")
    print(f"Nulls:\n{df.isna().sum()}\n")
    return df

def clean_dataframe(df):
    """Standard cleaning: lowercase strings, fill nulls, drop duplicates."""
    for col in df.select_dtypes(include=[np.number]).columns:
        df[col] = df[col].fillna(df[col].mean())
    for col in df.select_dtypes(include=['object']).columns:
        df[col] = df[col].str.lower().str.strip()
    df = df.drop_duplicates()
    return df

def get_top_n(df, column, n=5):
    """Return top N rows by a given column."""
    return df.nlargest(n, column)

