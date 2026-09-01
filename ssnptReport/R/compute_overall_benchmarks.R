#' Compute overall benchmark statistics for each subscale
#'
#' @param df_scored Data frame that has already been passed through
#'   \code{compute_subscale_scores()}.
#' @param subscale_cols Character vector of subscale column names to
#'   summarize. Defaults to the standard 8 SSNPT-R subscales.
#' @return A data frame with one row per subscale: Subscale, Overall_Mean,
#'   Overall_SD, Overall_N.
#' @export
compute_overall_benchmarks <- function(df_scored,
                                         subscale_cols = c("A_Practice", "A_Importance",
                                                            "B_Practice", "B_Importance",
                                                            "C_Practice", "C_Importance",
                                                            "D_Practice", "D_Importance")) {
  out <- data.frame(
    Subscale = subscale_cols,
    Overall_Mean = sapply(subscale_cols, function(col) mean(df_scored[[col]], na.rm = TRUE)),
    Overall_SD   = sapply(subscale_cols, function(col) stats::sd(df_scored[[col]], na.rm = TRUE)),
    Overall_N    = sapply(subscale_cols, function(col) sum(!is.na(df_scored[[col]]))),
    row.names = NULL
  )
  out
}
