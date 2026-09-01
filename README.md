# SSNPT-R Reporting Pipeline

An R-based reporting pipeline for the **SSNPT-R School Nursing Practice Survey**.

The goal of this project is to provide a reproducible workflow for scoring SSNPT-R responses and generating reports that allow respondents or districts to compare their results with an appropriate comparison group.

## Current Status

This project is currently in development.

The current prototype can:

* Read simulated Qualtrics-style SSNPT-R data
* Calculate SSNPT-R dimension scores
* Calculate Practice and Importance scores separately
* Calculate district-level averages
* Calculate overall sample benchmarks
* Apply a minimum-respondent suppression rule to district results
* Generate district-level reports
* Generate individual respondent comparison data

The Qualtrics survey is also being developed separately. The final package will eventually be designed to work directly with a Qualtrics export so that users do not need to manually restructure the data.

---

## SSNPT-R Structure

The current 2026 instrument organizes the survey into four dimensions:

| Dimension | Description                           | Items |
| --------- | ------------------------------------- | ----: |
| A         | Using the Nursing Process             |    10 |
| B         | Applying Evidence to Improve Practice |     7 |
| C         | Connecting with Community             |     7 |
| D         | Leveraging the School and Family Team |     7 |

Each item has two ratings:

* **Practice:** How often the behavior occurs
* **Importance:** How important the behavior is perceived to be

Both ratings use a 1–6 scale.

> **Note:** The revised 2026 survey materials should be treated as the authoritative source for the final item structure and scoring rules. The current code reflects the 10 + 7 + 7 + 7 structure being used in the prototype.

---

## Repository Structure

```text
ssnpt_pipeline/
│
├── python_plug/
│   ├── simulate_data.py
│   └── simulated_data.csv
│
├── ssnptReport/
│   ├── DESCRIPTION
│   ├── NAMESPACE
│   ├── R/
│   │   ├── compute_subscale_scores.R
│   │   ├── compute_district_summary.R
│   │   ├── compute_overall_benchmarks.R
│   │   ├── generate_district_report.R
│   │   └── generate_individual_report.R
│   │
│   └── inst/
│       └── rmd/
│           └── district_report_template.qmd
│
├── run_example.R
└── README.md
```

---

## Example Data

The repository includes simulated data so that the analysis pipeline can be tested without using real survey responses.

The simulated dataset contains:

* 400 respondents
* 15 districts
* A unique `ResponseID` for each respondent
* A `DistrictCode` for grouping respondents
* Practice and Importance ratings for each SSNPT-R item

The simulated data are intended only for testing the software and are not real survey responses.

---

## Getting Started

### Requirements

You will need:

* R
* RStudio or another R development environment
* `devtools`
* `rmarkdown`
* `flextable`
* `officer`

Install the packages with:

```r
install.packages(c(
  "devtools",
  "rmarkdown",
  "flextable",
  "officer"
))
```

### Load the package locally

Because the package is currently under development, use `devtools::load_all()`:

```r
devtools::load_all("ssnptReport")
```

### Load the simulated data

```r
df <- read.csv(
  "python_plug/simulated_data.csv",
  stringsAsFactors = FALSE
)
```

### Calculate SSNPT-R scores

```r
df_scored <- compute_subscale_scores(df)
```

This adds eight subscale scores:

```text
A_Practice
A_Importance
B_Practice
B_Importance
C_Practice
C_Importance
D_Practice
D_Importance
```

---

## Individual Comparison

The intended reporting workflow is to allow an individual respondent to compare their results with respondents who share the same district code.

For example:

```r
result <- generate_individual_report(
  df_scored = df_scored,
  response_id = "R_00001",
  min_n = 5
)
```

The function identifies the respondent's district using `DistrictCode` and calculates:

1. The respondent's score
2. The respondent's district average
3. The overall sample average

The current prototype writes the resulting comparison table to an output file. Report formatting is being developed separately.

---

## District Reports

District-level reports can be generated using:

```r
generate_all_district_reports(
  df_scored,
  min_n = 5,
  output_dir = "district_reports"
)
```

A district report compares that district's average scores with the overall sample.

---

## Privacy and Small Groups

District-level results should not be reported when the comparison group is too small.

The current prototype uses:

```r
min_n = 5
```

as a placeholder threshold.

This value **has not yet been established as the final privacy/IRB threshold** and should be confirmed by the research team before the system is used with real survey data.

When a district has fewer than the required number of respondents, district-level averages are suppressed.

---

## Qualtrics Data

The long-term goal is for the package to accept a Qualtrics export with minimal manual preprocessing.

The current prototype expects columns using the following naming convention:

```text
ResponseID
DistrictCode

A1_Practice
A1_Importance
...
A10_Practice
A10_Importance

B1_Practice
B1_Importance
...
```

and similarly for dimensions C and D.

The actual Qualtrics export structure is still being finalized. A future version of the package will include a mapping between Qualtrics question identifiers and SSNPT-R item names so users do not need to rename columns manually.

---

## Example Workflow

The complete simulated-data workflow can be found in:

```text
run_example.R
```

The general workflow is:

```r
# Load package
devtools::load_all("ssnptReport")

# Read data
df <- read.csv("python_plug/simulated_data.csv")

# Score responses
df_scored <- compute_subscale_scores(df)

# Generate an individual comparison
generate_individual_report(
  df_scored,
  response_id = "R_00001",
  min_n = 5
)

# Generate district reports
generate_all_district_reports(
  df_scored,
  min_n = 5
)
```

---

## Development Roadmap

### Current

* [x] Simulated Qualtrics-style dataset
* [x] SSNPT-R subscale scoring
* [x] District-level summaries
* [x] Overall sample benchmarks
* [x] Minimum-n suppression prototype
* [x] Individual comparison calculation
* [x] Quarto district report template
* [ ] Individual comparison report

### Next

* [ ] Finalize the Qualtrics variable mapping
* [ ] Confirm SSNPT-R scoring rules with the research team
* [ ] Confirm missing-response rules
* [ ] Confirm minimum comparison-group size
* [ ] Add automated tests
* [ ] Improve report visualizations
* [ ] Add direct support for raw Qualtrics exports
* [ ] Improve package documentation

### Future

* [ ] Package installation directly from GitHub
* [ ] Fully automated report generation
* [ ] Optional HTML/PDF/DOCX reporting
* [ ] Overall/reference-sample benchmarks when an appropriate reference dataset is available

---

## Important Notes

This repository is a research software prototype.

The scoring rules, privacy thresholds, report language, and final Qualtrics data structure should be reviewed and approved by the SSNPT-R research team before the system is used with real participant data.
