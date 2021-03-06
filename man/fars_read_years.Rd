% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_read_years.R
\name{fars_read_years}
\alias{fars_read_years}
\title{Read FARS, csv data files to find record Months and Years}
\usage{
fars_read_years(years)
}
\arguments{
\item{years}{A vector, or list, of years.  The elements of the list/vector
must be coerceible to integers e.g. character string "2012".}
}
\value{
This function returns a \code{list} of \code{data.frame}s (\code{tbl_df}s).
   The \code{data.frame}s reflect the month and year of each record in each FARS file
   read.
}
\description{
This function reads one or more Fatal Analysis Reporting System (FARS) data
from fars, csv files for a given vector of years.  It returns the months and
years of each record that they contain.  \code{fars_read_years} takes a
single argument; \code{years}; a vector of years for which FARS data's to be read.
\code{fars_read_years} returns NULL and prints a warning in respect of invalid years.
}
\examples{
\dontrun{
fars_read_years(c(2012, 2013, 2014))
fars_read_years(c("2012", "2013", "2014"))
}

}
