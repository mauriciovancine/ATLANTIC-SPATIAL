#' ----
#' title: atlantic spatial - download - topographic
#' author: mauricio vancine
#' date: 2023-10-12
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r ---------------------------------------------------------------

# packages
library(tidyverse)
library(terra)
library(sf)

# options
options(timeout = 1e6)

# download ----------------------------------------------------------------

# download
download.file(url = "https://data.bris.ac.uk/datasets/s5hqmjcdj8yo2ibzi9b4ew3sn/FABDEM_v1-2_tiles.geojson",
              destfile = "01_data/03_topography/00_raw/FABDEM_v1-2_tiles.geojson")

# tiles
tiles <- sf::st_read("01_data/03_topography/00_raw/FABDEM_v1-2_tiles.geojson")
tiles

# af
af <- sf::st_read("01_data/01_limits/ma_limite_integrador_muylaert_et_al_2018_wgs84_geodesic_v1_2_0.shp")
af

# filter
tiles_af <- tiles[af, ]
tiles_af

plot(tiles_af$geometry)

# url
urls <- paste0("https://data.bris.ac.uk/datasets/s5hqmjcdj8yo2ibzi9b4ew3sn/", tiles_af$zipfile_name) %>%
  unique() %>%
  sub("S-", "S", .)
urls

# download
for(i in urls){

  download.file(url = i, destfile = paste0("01_data/03_topography/00_raw/", basename(i)), mode = "wb")

}

# unzip
list_zip <- dir(path = "01_data/03_topography/00_raw", pattern = ".zip", full.names = TRUE)
list_zip

for(i in list_zip){

  unzip(zipfile = i, exdir = "01_data/03_topography/00_raw")

}

# end ---------------------------------------------------------------------
