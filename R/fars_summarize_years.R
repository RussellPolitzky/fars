#' Generate a summary of fatalities per month.
#'
#' This function generates a summary of fatalities per month, for the
#' given vector/list of years.  \code{fars_summarize_years} takes a
#' single argument; \code{years}; a vector/list of years that the summary
#' will cover.
#'
#' @inheritParams fars_read_years
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom tidyr spread
#'
#' @return This function returns a summary, \code{data.frame} (\code{tbl_df}) listing
#'    the number of fatalities per month for each given year.
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(c(2012, 2013, 2014))
#' fars_summarize_years(c("2012", "2013", "2014"))
#' }
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  rbindlist(dat_list)[, .N , by = c("year", "MONTH") ] %>%
    dcast(MONTH ~ year, value.var = "N")
}
