year <- 2018
path_to_utils <- "../../classes/data_science/various/wharf2wharf"
datafile <- sprintf("%s/w2w%d.csv", path_to_utils, year)
utils <- sprintf("%s/w2w_utils.R", path_to_utils)
source(utils)
# Override utils' default path to data
path_to_data <- path_to_utils

dataset <- getCleanData(2018)

# is used as "more than %d,000"
thousands_of_participants = round(nrow(dataset) / 1000, 0)


