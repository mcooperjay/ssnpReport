#' Compare one respondent with their district and overall sample
#'
#' @param df_scored Scored SSNPT-R data.
#' @param response_id ResponseID identifying the respondent.
#' @param min_n Minimum district sample size required to display
#'   district-level results.
#'
#' @return A list containing the respondent, district information,
#'   and comparison table.
#' @export
compute_individual_comparison <- function(
    df_scored,
    response_id,
    min_n = 5
) {

  if (!"ResponseID" %in% names(df_scored)) {
    stop("Data must contain a ResponseID column.")
  }

  if (!"DistrictCode" %in% names(df_scored)) {
    stop("Data must contain a DistrictCode column.")
  }

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

  district_code <- respondent$DistrictCode[[1]]

  district <- df_scored[
    df_scored$DistrictCode == district_code,
    ,
    drop = FALSE
  ]

  district_n <- nrow(district)

  benchmarks <- compute_overall_benchmarks(df_scored)

  subscale_cols <- benchmarks$Subscale

  individual_values <- sapply(
    subscale_cols,
    function(x) respondent[[x]]
  )

  comparison <- data.frame(
    Subscale = subscale_cols,
    Individual = as.numeric(individual_values)
  )

  comparison <- merge(
    comparison,
    benchmarks,
    by = "Subscale",
    sort = FALSE
  )

  if (district_n >= min_n) {

    district_means <- sapply(
      subscale_cols,
      function(x) mean(district[[x]], na.rm = TRUE)
    )

    comparison$District_Mean <- as.numeric(district_means)

  } else {

    comparison$District_Mean <- NA_real_
  }

  list(
    response_id = response_id,
    district_code = district_code,
    district_n = district_n,
    district_suppressed = district_n < min_n,
    comparison = comparison
  )
}