#' Read a FARS, csv data file
#'
#' This function reads Fatal Analysis Reporting System (FARS) data
#' from fars, csv files. \code{fars_read} takes a single argument;
#' \code{filename}; the name of the fars file to read. \code{fars_read}
#' will stop and report an error, if the given \code{filename} doesn't exist.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @param filename A character string giving the name of the
#'     Fatal Analysis Reporting System (FARS) file to load.
#'
#' @return This function returns a \code{data.frame} (\code{tbl_df}).
#'    The \code{data.frame} reflects the data in the file given
#'    by the \code{filename} argument.
#'
#' @note This function also reads compressed, csv files, so there's
#' no need to uncompress them beforehand.
#'
#' @examples
#' fars_read("accident_2015.csv")
#' fars_read("accident_2015.csv.bz2")
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}
