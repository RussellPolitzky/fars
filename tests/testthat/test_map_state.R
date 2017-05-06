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

# fars_map_state:  This one's hard to test because it's called or its side effects.
# We would need to be able to mock the map to easily test this

library(maps)
data(stateMapEnv)
fars_map_state(51, 2013)


state.num <- 30
year      <- 2013
fars::fars_map_state(state.num, year)


sapply(2013:2015, delete_file)


