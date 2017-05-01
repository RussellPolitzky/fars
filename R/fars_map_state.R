#' Plot points at all fatal accident sites for a given year and state.
#'
#' This function plots points on a map, showing the location of all
#' fatal accidents that occured in the given year and state.
#' \code{fars_map_state} takes two arguments, \code{state.num} and \code{year}.
#' \code{state.num} specifies the state while \code{year}
#' specifies the year for which fatal accident, location points
#' should be plotted.  If the data doesn't have \code{state.num}
#' then \code{fars_map_state} throws an error.  If no fatal accidents
#' were recorded in the given state and year then \code{fars_map_state}
#' prints an associated message, without plotting any points.
#'
#' @importFrom dplyr filter
#' @importFrom graphics points
#' @importFrom maps map
#'
#' @param state.num a number representing a state.  The number must be
#'    coercible to an integer.
#'
#' @param year year as a four digit number, or anything coercible to
#'    four digit number.
#'
#' @return NULL - this function is called for its side-effects.
#'
#' @examples
#' \dontrun{
#' fars_map_state(15,  2013)
#' fars_map_state(5, "2013")
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
    filename <- make_filename(year)
    data <- fars_read(filename)
    state.num <- as.integer(state.num)

    if(!(state.num %in% unique(data$STATE)))
            stop("invalid STATE number: ", state.num)
    data.sub <- dplyr::filter(data, "STATE" == state.num)
    if(nrow(data.sub) == 0L) {
            message("no accidents to plot")
            return(invisible(NULL))
    }
    is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
    is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
    with(data.sub, {
            maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                      xlim = range(LONGITUD, na.rm = TRUE))
            graphics::points(LONGITUD, LATITUDE, pch = 46)
    })
}
