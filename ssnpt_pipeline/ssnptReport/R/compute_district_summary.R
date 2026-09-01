#' Compute district-level subscale means, with a minimum-n suppression rule
#'
#' For confidentiality: any district with fewer than \code{min_n} respondents
#' has its subscale means suppressed (set to NA, with a flag) rather than
#' reported, since small-n district averages risk revealing individual
#' responses.
#'
#' @param df_scored Data frame already passed through compute_subscale_scores().
#' @param district_code The district code to summarize (character).
#' @param benchmarks Output of compute_national_benchmarks().
#' @param min_n Minimum number of respondents required to report district
#'   averages. Defaults to 5 -- CONFIRM this threshold with your professor/IRB
#'   before relying on it; this default is a placeholder, not a validated rule.
#' @param subscale_cols Character vector of subscale column names.
#' @return A list with: district_code, n, suppressed (logical), and a data
#'   frame `comparison` (Subscale, District_Mean, National_Mean, National_SD)
#'   when not suppressed, or NULL when suppressed.
#' @export
compute_district_summary <- function(df_scored, district_code, benchmarks,
                                      min_n = 5,
                                      subscale_cols = c("A_Practice", "A_Importance",
                                                         "B_Practice", "B_Importance",
                                                         "C_Practice", "C_Importance",
                                                         "D_Practice", "D_Importance")) {
  sub <- df_scored[df_scored$DistrictCode == district_code, , drop = FALSE]
  n <- nrow(sub)

  if (n < min_n) {
    return(list(
      district_code = district_code,
      n = n,
      suppressed = TRUE,
      comparison = NULL
    ))
  }

  district_means <- sapply(subscale_cols, function(col) mean(sub[[col]], na.rm = TRUE))

  comparison <- data.frame(
    Subscale = subscale_cols,
    District_Mean = as.numeric(district_means),
    row.names = NULL
  )
  comparison <- merge(comparison, benchmarks, by = "Subscale", sort = FALSE)

  list(
    district_code = district_code,
    n = n,
    suppressed = FALSE,
    comparison = comparison
  )
}
