test_that('FARS file can be loaded', {
  file_name <- fars::make_filename(2013)
  full_path <- file.path("../../inst/extdata/", file_name)
  data      <- fars::fars_read(full_path)
  no_rows   <- nrow(data)
  expect_equal(no_rows, 30202)
})


test_that('FARS has correct number of columns', {
  file_name <- fars::make_filename(2013)
  full_path <- file.path("../../inst/extdata/", file_name)
  data      <- fars::fars_read(full_path)
  no_cols   <- length(data)
  expect_equal(no_cols, 50)
})
