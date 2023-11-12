#' ----
#' title: atlantic spatial - download - landscape
#' author: mauricio vancine
#' date: 2023-10-12
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r ---------------------------------------------------------------

# packages
library(tidyverse)
library(rgee)

# options
sf::sf_use_s2(FALSE)
options(timeout = 1e5)

# prepare rgee ------------------------------------------------------------

# install
rgee::ee_install(py_env = "rgee")
rgee::ee_clean_pyenv()

# check
rgee::ee_check()

# initialize
rgee::ee_users()
rgee::ee_Initialize(drive = TRUE)
rgee::ee_user_info()

# mapbiomas brazil v7 -----------------------------------------------------

# mapbiomas brazil
url <- paste0("https://storage.googleapis.com/mapbiomas-public/brasil/collection-7/lclu/coverage/brasil_coverage_2020.tif")
url

destfile <- paste0("01_data/02_landscape/00_raw/mapbiomas_v7_", basename(url))
destfile

# download
download.file(url, destfile, mode = "wb")

# mapbiomas trinacional ---------------------------------------------------

# import collection
mapbiomas_trinacional_v2 <- rgee::ee$Image("projects/mapbiomas_af_trinacional/public/collection2/mapbiomas_atlantic_forest_collection20_integration_v1") %>%
    rgee::ee$Image$select(paste0("classification_2020"))
mapbiomas_trinacional_v2

# class
class(mapbiomas_trinacional_v2)

# information
mapbiomas_trinacional_v2$bandNames()$getInfo()

# export to drive
task_image <- rgee::ee_image_to_drive(
    image = mapbiomas_trinacional_v2,
    fileNamePrefix = "mapbiomas_trinacional_v2",
    fileFormat = "GEO_TIFF",
    scale = 30,
    maxPixels = 1e13)
task_image

rgee::task_image$start()
rgee::ee_monitoring(task_image)

# download
rgee::ee_drive_to_local(task = task_img,
                  dsn = paste0("01_data/02_landscape/00_raw/mapbiomas_trinacional_v2_2020.tif"))

# end ---------------------------------------------------------------------
