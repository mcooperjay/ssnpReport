#' Generate an individual SSNPT-R report
#'
#' Generates a report for one respondent showing their SSNPT-R
#' subscale scores alongside their district and overall averages.
#'
#' @param df_scored Data frame that has already been passed through
#'   compute_subscale_scores().
#' @param response_id The ResponseID of the respondent.
#' @param min_n Minimum number of respondents required to display
#'   district-level results.
#' @param output_dir Directory where the report will be saved.
#'
#' @return Invisibly returns the path to the generated report.
#' @export
generate_individual_report <- function(
    df_scored,
    response_id,
    min_n = 5,
    output_dir = "individual_reports"
) {

  # Find respondent
  respondent <- df_scored[
    df_scored$ResponseID == response_id,
    ,
    drop = FALSE
  ]

  if (nrow(respondent) == 0) {
    stop("No respondent found with ResponseID: ", response_id)
  }

  if (nrow(respondent) > 1) {
    stop("ResponseID is not unique: ", response_id)
  }

  # Identify district
  district_code <- respondent$DistrictCode[[1]]

  # Find everyone in the same district
  district <- df_scored[
    df_scored$DistrictCode == district_code,
    ,
    drop = FALSE
  ]

  district_n <- nrow(district)

  # Subscale columns
  subscale_cols <- c(
    "A_Practice", "A_Importance",
    "B_Practice", "B_Importance",
    "C_Practice", "C_Importance",
    "D_Practice", "D_Importance"
  )

  # Overall averages
  overall_means <- sapply(
    subscale_cols,
    function(x) mean(df_scored[[x]], na.rm = TRUE)
  )

  # District averages
  if (district_n >= min_n) {

    district_means <- sapply(
      subscale_cols,
      function(x) mean(district[[x]], na.rm = TRUE)
    )

  } else {

    district_means <- rep(NA_real_, length(subscale_cols))
  }

  # Individual scores
  individual_scores <- sapply(
    subscale_cols,
    function(x) respondent[[x]][[1]]
  )

  comparison <- data.frame(
    Subscale = subscale_cols,
    Individual = as.numeric(individual_scores),
    District_Mean = as.numeric(district_means),
    Overall_Mean = as.numeric(overall_means),
    row.names = NULL
  )

  # Create output directory
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  # Save the comparison data for now
  out_file <- file.path(
    output_dir,
    paste0("SSNPT-R_Individual_", response_id, ".csv")
  )

  write.csv(
    comparison,
    out_file,
    row.names = FALSE
  )

  message(
    "Created individual comparison for ",
    response_id,
    " (District ", district_code,
    ", n = ", district_n, ")"
  )

  invisible(out_file)
}