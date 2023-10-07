# library
library(googledrive)

# authorization
googledrive::drive_auth()

# list files
atlantic_spatial_files <- googledrive::drive_ls(path = "atlantic_spatial")
atlantic_spatial_files

# rename

file <- drive_rename(file, name = "renamed-file")

file_id <- googledrive::as_id("1yPGzwXYy8bYqV5xl31W8iFCXJUdRufsF")
file <- googledrive::drive_get(file_id)

googledrive::drive_download(file, overwrite = TRUE)

atlantic_statial <- readr::read_csv("data/atlantic_spatial_description.csv")
atlantic_statial

atlantic_statial %>% 
    dplyr::count(metric_group)

a <- atlantic_statial %>% 
    dplyr::count(unit)
a
