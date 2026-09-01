#' Compute SSNPT-R subscale scores
#'
#' Calculates mean scores for each SSNPT-R dimension separately
#' for Practice and Importance ratings.
#'
#' @param df Data frame containing SSNPT-R item responses.
#' @param min_answered Minimum proportion of items that must be answered
#'   to calculate a subscale score. Defaults to 0.80.
#'
#' @return The input data frame with eight subscale score columns added.
#' @export
compute_subscale_scores <- function(df, min_answered = 0.80) {

  if (min_answered < 0 || min_answered > 1) {
    stop("min_answered must be between 0 and 1.")
  }

  item_spec <- ssnpt_items()

  for (dim_name in unique(item_spec$dimension)) {

    dim_items <- item_spec$item[item_spec$dimension == dim_name]

    for (rating in c("Practice", "Importance")) {

      item_cols <- paste0(dim_items, "_", rating)

      missing_cols <- setdiff(item_cols, names(df))

      if (length(missing_cols) > 0) {
        stop(
          "Missing expected columns: ",
          paste(missing_cols, collapse = ", ")
        )
      }

      score_col <- paste0(dim_name, "_", rating)

      n_required <- ceiling(length(item_cols) * min_answered)

      answered <- rowSums(
        !is.na(df[, item_cols, drop = FALSE])
      )

      scores <- rowMeans(
        df[, item_cols, drop = FALSE],
        na.rm = TRUE
      )

      # rowMeans returns NaN when all items are missing
      scores[answered < n_required] <- NA_real_

      df[[score_col]] <- scores
    }
  }

  df
}