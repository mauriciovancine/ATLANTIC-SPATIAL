#' ----
#' title: spatial atlantic - hydrologic metrics
#' author: mauricio vancine
#' date: 2023-11-11
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# font
# https://baharmon.github.io/watersheds-in-grass

# packages
library(tidyverse)
library(rgrass)
library(terra)

# source
source("00_scripts/lsm_hidrography.R")
source("00_scripts/lsm_hidrography_basin.R")

# connect grass -----------------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb",
                  location = "sirgas2000_albers",
                  mapset = "PERMANENT",
                  override = TRUE)

# calculate ---------------------------------------------------------------

# hydrology ----
lsm_hidrography_basin(input = "fabdem_v12_af_lim",
                      output = "_buffer1km",
                      basin = "hybas_af_lv05",
                      threshold = 100,
                      stream_raster = TRUE,
                      stream_vector = TRUE,
                      spring_raster = TRUE,
                      spring_vector = TRUE,
                      delete_vector = FALSE,
                      delete_raster = FALSE,
                      nprocs = 10,
                      memory = 1e4)

# region
rgrass::execGRASS(cmd = "g.region", flags = "a", raster = "fabdem_v12_af_lim")
rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", raster = "fabdem_v12_af_lim")

# patch
files_stream <- rgrass::stringexecGRASS("g.list type=raster pattern='*_stream_binary'", intern = TRUE)
files_spring <- rgrass::stringexecGRASS("g.list type=raster pattern='*_spring_binary'", intern = TRUE)

rgrass::execGRASS(cmd = "r.patch", flags = "overwrite", input = paste0(files_stream[2:65], collapse = ","), output = "fabdem_v12_af_lim_stream_binary01", nprocs = parallel::detectCores()-1, memory = 1e5)
rgrass::execGRASS(cmd = "r.patch", flags = "overwrite", input = paste0(files_stream[66:113], collapse = ","), output = "fabdem_v12_af_lim_stream_binary02", nprocs = parallel::detectCores()-1, memory = 1e5)
rgrass::execGRASS(cmd = "r.patch", input = "fabdem_v12_af_lim_stream_binary01,fabdem_v12_af_lim_stream_binary02", output = "fabdem_v12_af_lim_stream_binary", nprocs = parallel::detectCores()-1, memory = 1e5)

rgrass::execGRASS(cmd = "r.patch", input = paste0(files_spring[1:65], collapse = ","), output = "fabdem_v12_af_lim_spring_binary01", nprocs = parallel::detectCores()-1, memory = 1e5)
rgrass::execGRASS(cmd = "r.patch", input = paste0(files_spring[66:112], collapse = ","), output = "fabdem_v12_af_lim_spring_binary02", nprocs = parallel::detectCores()-1, memory = 1e5)
rgrass::execGRASS(cmd = "r.patch", input = "fabdem_v12_af_lim_spring_binary01,fabdem_v12_af_lim_spring_binary02", output = "fabdem_v12_af_lim_spring_binary", nprocs = parallel::detectCores()-1, memory = 1e5)

# delete masses of water ----
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_stream_binary_masses_water=fabdem_v12_af_lim_stream_binary+masses_water_binary_10")
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_spring_binary_masses_water=fabdem_v12_af_lim_spring_binary+masses_water_binary_10")

rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_stream_binary_masses_water_deleted=if(fabdem_v12_af_lim_stream_binary_masses_water==1, 1, 0)")
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_spring_binary_masses_water_deleted=if(fabdem_v12_af_lim_spring_binary_masses_water==1, 1, 0)")


rgrass::execGRASS(cmd = "r.mask", raster = "fabdem_v12_af_lim")
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_stream_masses_water_deleted_binary=fabdem_v12_af_lim_stream_binary_masses_water_deleted")
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_spring_masses_water_deleted_binary=fabdem_v12_af_lim_spring_binary_masses_water_deleted")

rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_stream_masses_water_deleted_null=if(fabdem_v12_af_lim_stream_masses_water_deleted_binary == 0, null(), 1)")
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "fabdem_v12_af_lim_spring_masses_water_deleted_null=if(fabdem_v12_af_lim_spring_masses_water_deleted_binary == 0, null(), 1)")


# stream distance ----
rgrass::execGRASS(cmd = "r.grow.distance", flags = "overwrite", input = "fabdem_v12_af_lim_stream_null", distance = "fabdem_v12_af_lim_stream_distance")
rgrass::execGRASS(cmd = "r.colors", flags = c("a", "n"), map = "fabdem_v12_af_lim_stream_distance", color = "water")

# spring kernel ----
for(i in c(50, 100, 150, 200, 250, 500, 750, 1000, 1500, 2000, 2500)){

  rgrass::execGRASS(cmd = "v.kernel",
                    flags = c("overwrite", "quiet"),
                    input = "fabdem_v12_af_lim_spring_masses_water_deleted_null",
                    output = paste0("fabdem_v12_af_lim_spring_masses_water_deleted_null_kde_", i),
                    radius = i)

  rgrass::execGRASS(cmd = "r.colors",
                    map = paste0("fabdem_v12_af_lim_spring_masses_water_deleted_null_kde_", i),
                    color = "bcyr")

}

# end ---------------------------------------------------------------------
