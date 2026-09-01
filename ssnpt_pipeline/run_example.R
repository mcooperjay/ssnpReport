# run_example.R
# -------------------------------------------------------
# Example workflow for the SSNPT-R reporting package
# Uses simulated Qualtrics-style data.
# -------------------------------------------------------

# One-time installation:
# install.packages(c("devtools", "rmarkdown", "quarto",
#                    "flextable", "officer"))

# Load the local package during development
devtools::load_all("ssnptReport")

# -------------------------------------------------------
# 1. Read simulated Qualtrics data
# -------------------------------------------------------

df <- read.csv(
  "python_plug/simulated_data.csv",
  stringsAsFactors = FALSE
)

# Check the data
dim(df)
names(df)[1:10]

# -------------------------------------------------------
# 2. Calculate SSNPT-R subscale scores
# -------------------------------------------------------

df_scored <- compute_subscale_scores(df)

# Look at the new score columns
df_scored[
  1:5,
  c(
    "ResponseID",
    "DistrictCode",
    "A_Practice",
    "A_Importance",
    "B_Practice",
    "B_Importance",
    "C_Practice",
    "C_Importance",
    "D_Practice",
    "D_Importance"
  )
]

# -------------------------------------------------------
# 3. Choose one respondent
# -------------------------------------------------------

response_id <- df_scored$ResponseID[1]

response_id

# Find their district
df_scored[
  df_scored$ResponseID == response_id,
  c("ResponseID", "DistrictCode")
]

# -------------------------------------------------------
# 4. Generate individual comparison
# -------------------------------------------------------

comparison_file <- generate_individual_report(
  df_scored = df_scored,
  response_id = response_id,
  min_n = 5,
  output_dir = "individual_reports"
)

comparison_file

# -------------------------------------------------------
# 5. Generate district reports
# -------------------------------------------------------

generate_all_district_reports(
  df_scored,
  min_n = 5,
  output_dir = "district_reports"
)

# -------------------------------------------------------
# Test individual comparison
# -------------------------------------------------------

# Look at the first respondent
df_scored[1, c("ResponseID", "DistrictCode")]

# Store their ResponseID
response_id <- df_scored$ResponseID[1]

# Generate comparison
result <- compute_individual_comparison(
  df_scored = df_scored,
  response_id = response_id,
  min_n = 5
)

# Print information about the respondent
result$response_id
result$district_code
result$district_n
result$district_suppressed

# View comparison table
result$comparison