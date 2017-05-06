copy_file <- function(year) {
  file_name <- sprintf("accident_%d.csv.bz2", year)
  full_path <- system.file("extdata", file_name, package = "fars")
  file.copy(full_path, getwd())
}

delete_file <- function(year) {
  file_name <- sprintf("accident_%d.csv.bz2", year)
  file.remove(file_name)
}

# Setup
sapply(2013:2015, copy_file)

test_that('should be able to produce correct summary', {
  expectde_file <- system.file("extdata", "expected_summary_2013-2015.csv", package = "fars")
  expected      <- fread(expectde_file, header = TRUE)
  result        <- fars::fars_summarize_years(c(2013,2014,2015))
  expect_true(all((result-expected) == 0))
})

# Teardown
sapply(2013:2015, delete_file)
