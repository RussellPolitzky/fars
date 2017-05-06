test_that('given a set of years, should be able to read more than one fars file', {
  with_mock(
    `fars::make_filename` = function(year) {
       file_name <- sprintf("accident_%d.csv.bz2", year)
       full_path <- system.file("extdata", file_name, package = "fars")
       return(full_path)
    },
    `fars::fars_read` = function(filename) {
       data_read <- readr::read_csv(filename, progress = FALSE)
       return(data_read)
    },
    expect_equal(
      length(fars::fars_read_years(c(2013, 2014))),
      2) # expecting two files
    )
})


test_that('should be able to read one fars file', {
  with_mock(
    `fars::make_filename` = function(year) {
      file_name <- sprintf("accident_%d.csv.bz2", year)
      full_path <- system.file("extdata", file_name, package = "fars")
      return(full_path)
    },
    `fars::fars_read` = function(filename) {
      data_read <- readr::read_csv(filename, progress = FALSE)
      return(data_read)
    },
    expect_equal(
      length(fars::fars_read_years(c(2013))),
      1) # expecting two files
  )
})


test_that('should return null IRO file that does not exist', {
  with_mock(
    `fars::make_filename` = function(year) {
      file_name <- sprintf("accident_%d.csv.bz2", year)
      full_path <- system.file("extdata", file_name, package = "fars")
      return(full_path)
    },
    `fars::fars_read` = function(filename) {
      data_read <- readr::read_csv(filename, progress = FALSE)
      return(data_read)
    },
    expect_warning(fars::fars_read_years(2017)),
    suppressWarnings({
      result <- fars::fars_read_years(2017)
      expect_null(result[[1]])
    })
  )
})
