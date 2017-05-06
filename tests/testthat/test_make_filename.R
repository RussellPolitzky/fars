test_that('fars file names are correctly composed using integer years', {
  file_name <- fars::make_filename(2013L) # Note integer input
  expect_equal(file_name, "accident_2013.csv.bz2")
})


test_that('fars file names are correctly composed using numeric years', {
  file_name <- fars::make_filename(2013) # Note integer input
  expect_equal(file_name, "accident_2013.csv.bz2")
})


test_that('fars file names are correctly composed using character years', {
  file_name <- fars::make_filename("2013")
  expect_equal(file_name, "accident_2013.csv.bz2")
})
