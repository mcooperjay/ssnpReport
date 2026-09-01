#' SSNPT-R item specification
#'
#' Returns the current SSNPT-R dimension/item structure.
#'
#' NOTE:
#' The revised 2026 document currently specifies:
#'   A = 10 items
#'   B = 7 items
#'   C = 7 items
#'   D = 7 items
#' for a total of 31 dimensioned items.
#'
#' Confirm this structure with the research team before using
#' the package for production scoring.

ssnpt_items <- function() {

  data.frame(
    item = c(
      paste0("A", 1:10),
      paste0("B", 1:7),
      paste0("C", 1:7),
      paste0("D", 1:7)
    ),
    dimension = c(
      rep("A", 10),
      rep("B", 7),
      rep("C", 7),
      rep("D", 7)
    ),
    dimension_name = c(
      rep("Using the Nursing Process", 10),
      rep("Applying Evidence to Improve Practice", 7),
      rep("Connecting with Community", 7),
      rep("Leveraging the School and Family Team", 7)
    ),
    stringsAsFactors = FALSE
  )
}