"""
simulate_data.py
-----------------
Generates a fake Qualtrics-style export CSV for the SSNPT-R survey, so the
R reporting package can be built/tested before real data exists.

Later, this file is also the natural place to add a real Qualtrics API pull
(swap out `simulate()` for a function that calls the Qualtrics Export
Responses API and returns the same column structure).

Usage:
    python3 simulate_data.py --n 400 --districts 15 --out simulated_data.csv
"""

import argparse
import random
import csv

# ---- Survey structure: dimension -> number of items ----
DIMENSIONS = {"A": 10, "B": 7, "C": 7, "D": 7}
RATINGS = ["Practice", "Importance"]


def item_columns():
    """Returns the full list of item column names, e.g. A1_Practice, A1_Importance, ..."""
    cols = []
    for dim, n_items in DIMENSIONS.items():
        for i in range(1, n_items + 1):
            for rating in RATINGS:
                cols.append(f"{dim}{i}_{rating}")
    return cols


def simulate_row(district_code, rng):
    """Simulate one respondent's ratings (1-6 scale) with some person-level tendency."""
    row = {"DistrictCode": district_code}
    # a mild per-person tendency so scores aren't pure noise (more realistic)
    person_bias = rng.uniform(-0.5, 0.5)
    for col in item_columns():
        base = 4.0 + person_bias + rng.uniform(-1.5, 1.5)
        val = max(1, min(6, round(base)))
        row[col] = val
    return row


def simulate(n_respondents=400, n_districts=15, seed=42):
    rng = random.Random(seed)
    district_codes = [f"D{str(i).zfill(3)}" for i in range(1, n_districts + 1)]

    # give some districts very few respondents on purpose, to exercise the
    # minimum-n suppression logic downstream
    weights = [rng.uniform(0.3, 3.0) for _ in district_codes]

    rows = []
    for resp_id in range(1, n_respondents + 1):
        district = rng.choices(district_codes, weights=weights, k=1)[0]
        row = simulate_row(district, rng)
        row["ResponseID"] = f"R_{resp_id:05d}"
        rows.append(row)
    return rows


def write_csv(rows, out_path):
    fieldnames = ["ResponseID", "DistrictCode"] + item_columns()
    with open(out_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, default=400, help="number of respondents")
    parser.add_argument("--districts", type=int, default=15, help="number of districts")
    parser.add_argument("--out", type=str, default="simulated_data.csv")
    parser.add_argument("--seed", type=int, default=42)
    args = parser.parse_args()

    rows = simulate(n_respondents=args.n, n_districts=args.districts, seed=args.seed)
    write_csv(rows, args.out)
    print(f"Wrote {len(rows)} simulated responses across {args.districts} districts to {args.out}")
