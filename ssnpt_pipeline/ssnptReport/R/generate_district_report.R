#' Generate a single district's Word report
#'
#' @param district_summary Output of compute_district_summary().
#' @param min_n The minimum-n threshold used (passed through for the report text).
#' @param output_dir Folder to write the .docx file into.
#' @param template_path Path to the .Rmd template. Defaults to the one
#'   bundled with this package.
#' @return (Invisibly) the path to the generated .docx file.
#' @export
generate_district_report <- function(district_summary,
                                      min_n = 5,
                                      output_dir = "district_reports",
                                      template_path = system.file(
                                        "rmd", "district_report_template.Rmd",
                                        package = "ssnptReport"
                                      )) {
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

  out_file <- file.path(
    output_dir,
    paste0("SSNPT-R_Report_", district_summary$district_code, ".docx")
  )

  rmarkdown::render(
    input = template_path,
    output_file = out_file,
    output_format = "word_document",
    params = list(
      district_code = district_summary$district_code,
      n = district_summary$n,
      suppressed = district_summary$suppressed,
      comparison = district_summary$comparison,
      min_n = min_n
    ),
    envir = new.env(),
    quiet = TRUE
  )

  invisible(out_file)
}

#' Generate Word reports for every district in the data
#'
#' Convenience wrapper: computes national benchmarks, then loops over every
#' unique DistrictCode in the data and writes one Word report per district
#' (applying the minimum-n suppression rule automatically).
#'
#' @param df_scored Data frame already passed through compute_subscale_scores().
#' @param min_n Minimum respondents required to report a district's averages.
#' @param output_dir Folder to write the .docx files into.
#' @return (Invisibly) a character vector of the generated file paths.
#' @export
generate_all_district_reports <- function(df_scored, min_n = 5,
                                           output_dir = "district_reports") {
  benchmarks <- compute_national_benchmarks(df_scored)
  districts <- unique(df_scored$DistrictCode)

  paths <- character(0)
  for (d in districts) {
    summary <- compute_district_summary(df_scored, d, benchmarks, min_n = min_n)
    path <- generate_district_report(summary, min_n = min_n, output_dir = output_dir)
    paths <- c(paths, path)
    message("Wrote report for district ", d,
            " (n = ", summary$n,
            if (summary$suppressed) ", SUPPRESSED" else "", ")")
  }
  invisible(paths)
}
