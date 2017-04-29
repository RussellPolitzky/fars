#' Read a FARS, csv data file
#'
#' This function reads Fatal Analysis Reporting System (FARS) data
#' from fars, csv files. \code{fars_read} takes a single argument;
#' \code{filename}; the name of the fars file to read. \code{fars_read}
#' will stop and report an error, if the given \code{filename} doesn't exist.
#'
#' @import readr::read_csv
#' @import dplyr::tbl_df
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


#' Read FARS, csv data files to find record Months and Years
#'
#' This function reads one or more Fatal Analysis Reporting System (FARS) data
#' from fars, csv files for a given vector of years.  It returns the months and
#' years of each record that they contain.  \code{fars_read_years} takes a
#' single argument; \code{years}; a vector of years for which FARS data's to be read.
#' \code{fars_read_years} returns NULL and prints a warning in respect of invalid years.
#'
#' @import dplyr::mutate
#' @import dplyr::select
#'
#' @param years A vector, or list, of years.  The elements of the list/vector
#'     must be coerceible to integers e.g. character string "2012".
#'
#' @return This function returns a \code{list} of \code{data.frame}s (\code{tbl_df}s).
#'    The \code{data.frame}s reflect the month and year of each record in each FARS file
#'    read.
#'
#' @examples
#' fars_read_years(c(2012, 2013, 2014))
#' fars_read_years(c("2012", "2013", "2014"))
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


#' Generate a summary of fatalities per month.
#'
#' This function generates a summary of fatalities per month, for the
#' given vector/list of years.  \code{fars_summarize_years} takes a
#' single argument; \code{years}; a vector/list of years that the summary
#' will cover.
#'
#' @inheritParams fars_read_years
#'
#' @import dplyr::bind_rows
#' @import dplyr::group_by
#' @import dplyr::summarize
#' @import tidyr::spread
#'
#' @return This function returns a summary, \code{data.frame} (\code{tbl_df}) listing
#'    the number of fatalities per month for each given year.
#'
#' @examples
#' fars_summarize_years(c(2012, 2013, 2014))
#' fars_summarize_years(c("2012", "2013", "2014"))
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}


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
#' This function imports \code{dplyr::filter()}, \code{maps::map()} and
#' \code{graphics::points()}
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
#' fars_map_state(15, 2012)
#' fars_map_state(5, "2012")
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
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
