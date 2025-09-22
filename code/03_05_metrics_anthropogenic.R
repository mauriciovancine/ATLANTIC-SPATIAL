#' ----
#' title: atlantic spatial - anthropogenic metrics
#' author: mauricio vancine
#' date: 2023-11-11
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r ---------------------------------------------------------------

# packages
library(tidyverse)
library(rgrass)
library(sf)
library(lsmetrics) # pak::pkg_install("mauriciovancine/lsmetrics")

# connect grass -----------------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb/",
                  location = "sirgas2000_albers",
                  mapset = "PERMANENT",
                  override = TRUE)

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = "af_lim")
rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", raster = "af_lim")

rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", raster = "499_atlantic_spatial_indigenous_territory_binary@PERMANENT")

# calculate ---------------------------------------------------------------

# distance
lsmetrics::lsm_distance(input = "477_atlantic_spatial_forest_plantation_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "479_atlantic_spatial_pasture_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "481_atlantic_spatial_temporary_crop_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "483_atlantic_spatial_perennial_crop_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "485_atlantic_spatial_urban_areas_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "487_atlantic_spatial_mining_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "489_atlantic_spatial_water_binary", distance_type = "outside")

lsmetrics::lsm_distance(input = "491_atlantic_spatial_roads_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "493_atlantic_spatial_railways_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "495_atlantic_spatial_roads_railways_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "497_atlantic_spatial_protected_areas_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "499_atlantic_spatial_indigenous_territories_binary", distance_type = "outside")
lsmetrics::lsm_distance(input = "501_atlantic_spatial_quilombola_territories_binary", distance_type = "outside")

# end ---------------------------------------------------------------------
