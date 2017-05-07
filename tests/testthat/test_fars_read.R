context("fars_read")


test_that('FARS file loads with correct number of records', {
  file_name <- fars::make_filename(2013)
  full_path <- system.file("extdata", file_name, package = "fars")
  data      <- fars::fars_read(full_path)
  no_rows   <- nrow(data)
  expect_equal(no_rows, 30202)
})


test_that('FARS fails if the file doesnt exist', {
  expect_error(fars::fars_read("does_not_exist.csv"), "file 'does_not_exist.csv' does not exist")
})
