# run_example.R
# -------------------------------------------------------
# Example workflow for the SSNPT-R reporting package
# Uses simulated Qualtrics-style data.
# -------------------------------------------------------

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
# 4. Compare respondent with district and overall sample
# -------------------------------------------------------

result <- compute_individual_comparison(
  df_scored = df_scored,
  response_id = response_id,
  min_n = 5
)

# Print respondent information
result$response_id
result$district_code
result$district_n
result$district_suppressed

# View comparison table
result$comparison

# -------------------------------------------------------
# 5. Save comparison table
# -------------------------------------------------------

comparison_file <- generate_individual_report(
  df_scored = df_scored,
  response_id = response_id,
  min_n = 5,
  output_dir = "individual_reports"
)

comparison_file