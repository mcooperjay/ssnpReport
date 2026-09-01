# SSNPT-R Reporting Pipeline

## What's here

- `python_plug/simulate_data.py` — generates fake Qualtrics-export-shaped data
  for testing. Later, swap this for a real Qualtrics API pull (same output
  column structure) so the rest of the pipeline doesn't need to change.
- `python_plug/simulated_data.csv` — a sample output of the above (400
  respondents, 15 districts, some deliberately small to test suppression).
- `ssnptReport/` — the R package: scoring, national benchmarks, district
  comparison with minimum-n suppression, and Word report generation.
- `run_example.R` — a top-to-bottom example using the simulated data.

## ⚠️ Important: this R code has not been executed by Claude

I don't have R available in the environment I built this in, so unlike the
Python simulator (which I ran and confirmed works), **the R package has not
actually been run or tested**. It's written carefully and I'm reasonably
confident in the logic, but treat it as a first draft that needs a real test
pass, not verified working code. Please do the following before relying on
it:

1. Install R and RStudio if you don't have them (an R environment your
   professor/university already uses is fine too).
2. Install package dependencies:
   ```r
   install.packages(c("dplyr", "rmarkdown", "officer", "flextable", "devtools"))
   ```
   You'll also need Pandoc installed for Word rendering to work — RStudio
   bundles this automatically; if you're not using RStudio, install Pandoc
   separately.
3. Open `run_example.R` and run it line by line. Watch for errors, especially
   around:
   - Column name matching (`compute_subscale_scores` expects columns named
     exactly `A1_Practice`, `A1_Importance`, ..., `D7_Practice`,
     `D7_Importance` — if your real Qualtrics export uses different column
     names, this will need adjusting or a column-renaming step added).
   - The `flextable`/`officer` Word table rendering — this is the part most
     likely to need small tweaks depending on package versions.
4. Once it runs cleanly on the simulated data, you have a working baseline.
   Only then plug in a real (even small/test) Qualtrics export.

## Known placeholders that need real answers before this goes near real data

- **`min_n = 5`** — the minimum-district-size suppression threshold. This is
  a reasonable starting default, not a validated number. Confirm the real
  threshold with your professor/IRB.
- **Column naming** — real Qualtrics exports often use auto-generated column
  names (like `Q4_1`, `Q4_2`) rather than the readable `A1_Practice` names
  used here. You'll likely need a renaming step when real data arrives,
  mapping Qualtrics's export headers to this naming scheme.
- **Report content/wording** — the Word report template is a plain first
  draft (title, respondent count, one comparison table, a footnote on scale
  interpretation). Formatting, branding, and any additional interpretive text
  your professor wants should be added before this goes out to real districts.
