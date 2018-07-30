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

# A bit of cleanup - applies to 2018, maybe other years
# Age 0 messes up several plots. Omit
dataset <- dataset[dataset$age > 0,]

# Start time is 8:30. Omit early starters
dataset <- dataset[dataset$start > 8 * 3600 * 1000,]

