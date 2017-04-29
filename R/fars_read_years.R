#' Read FARS, csv data files to find record Months and Years
#'
#' This function reads one or more Fatal Analysis Reporting System (FARS) data
#' from fars, csv files for a given vector of years.  It returns the months and
#' years of each record that they contain.  \code{fars_read_years} takes a
#' single argument; \code{years}; a vector of years for which FARS data's to be read.
#' \code{fars_read_years} returns NULL and prints a warning in respect of invalid years.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#' @param years A vector, or list, of years.  The elements of the list/vector
#'     must be coerceible to integers e.g. character string "2012".
#'
#' @return This function returns a \code{list} of \code{data.frame}s (\code{tbl_df}s).
#'    The \code{data.frame}s reflect the month and year of each record in each FARS file
#'    read.
#'
#' @examples
#' \dontrun{
#' fars_read_years(c(2012, 2013, 2014))
#' fars_read_years(c("2012", "2013", "2014"))
#' }
#'
#' @export
fars_read_years <- function(years) {

  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}
