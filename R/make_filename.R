#' Build an accident data file name
#'
#' Given a four digit \code{year}, this function builds an accident data file name
#' in the "accident_xxxx.csv.bz2" format, where "xxxx" is the supplied \code{year}.
#'
#' @param year Accident data year expressed as a four digit number e.g. 2012.
#'    This parameter may also be any type coercible to a suitable integer,
#'    such as the character string "2012", for example.
#'
#' @return A character string of the form "accident_xxxx.csv.bz2", where
#'    xxxx is the accident data year expressed as a four digit number.
#'
#' @examples
#' make_filename(2012)
#' make_filename("2012")
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}
