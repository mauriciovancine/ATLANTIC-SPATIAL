#' ----
#' title: atlantic spatial - import and prepare data - topographic
#' author: mauricio vancine
#' date: 2022-10-27
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r -------------------------------------------------------------

# packages
library(tidyverse)
library(rgrass)

# connect grass -----------------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb",
                  location = "wgs84_geodesic",
                  mapset = "PERMANENT",
                  override = TRUE)

# import ------------------------------------------------------------------

# import
files <- dir(path = "01_data/03_topography/00_raw", pattern = ".tif$", full.names = TRUE)
files

for(i in files){

  print(paste0(which(i == files), " of ", length(files)))
  rgrass::execGRASS(cmd = "r.in.gdal", flags = "overwrite", input = i, output = sub("-", "", sub(".tif", "", basename(i))))

}

# list
files <- rgrass::stringexecGRASS("g.list type='raster' pattern='*FABDEM_V12*'", intern=TRUE)
files

files_groups <- parallel::splitIndices(length(files), 4)
files_groups

# patch
rgrass::execGRASS(cmd = "r.mask", flags = "r")

rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = paste0(files[files_groups[[1]]], collapse = ","))
rgrass::execGRASS(cmd = "r.patch",
                  flags = "overwrite",
                  input = paste0(files[files_groups[[1]]], collapse = ","),
                  output = "fabdem_v12_1",
                  nprocs = parallel::detectCores()-1,
                  memory = 1e5)

rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = paste0(files[files_groups[[2]]], collapse = ","))
rgrass::execGRASS(cmd = "r.patch",
                  flags = "overwrite",
                  input = paste0(files[files_groups[[2]]], collapse = ","),
                  output = "fabdem_v12_2",
                  nprocs = parallel::detectCores()-1,
                  memory = 1e5)

rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = paste0(files[files_groups[[3]]], collapse = ","))
rgrass::execGRASS(cmd = "r.patch",
                  flags = "overwrite",
                  input = paste0(files[files_groups[[3]]], collapse = ","),
                  output = "fabdem_v12_3",
                  nprocs = parallel::detectCores()-1,
                  memory = 1e5)

rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = paste0(files[files_groups[[4]]], collapse = ","))
rgrass::execGRASS(cmd = "r.patch",
                  flags = "overwrite",
                  input = paste0(files[files_groups[[4]]], collapse = ","),
                  output = "fabdem_v12_4",
                  nprocs = parallel::detectCores()-1,
                  memory = 1e5)

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = paste0(files, collapse = ","))

rgrass::execGRASS(cmd = "r.patch",
                  flags = "overwrite",
                  input = c("fabdem_v12_1", "fabdem_v12_2", "fabdem_v12_3", "fabdem_v12_4"),
                  output = "fabdem_v12",
                  nprocs = parallel::detectCores()-1,
                  memory = 1e5)

# mask
rgrass::execGRASS(cmd = "r.mask", vector = "af_lim")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "fabdem_v12_af_lim=fabdem_v12")

# remove
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", pattern = "*FABDEM_V12*")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "fabdem_v12_1")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "fabdem_v12_2")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "fabdem_v12_3")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "fabdem_v12_4")

# export
rgrass::execGRASS(cmd = "r.out.gdal",
                  flags = "overwrite",
                  input = "fabdem_v12_af_lim",
                  output = "fabdem_v12.tif",
                  createopt = "COMPRESS=DEFLATE,BIGTIFF=YES")

# albers ------------------------------------------------------------------

# import
rgrass::execGRASS(cmd = "r.import", flags = "overwrite", input = "01_data/03_topography/fabdem_v12.tif", output = "fabdem_v12")

# mapcalc
rgrass::execGRASS(cmd = "g.region", flags = "a", raster = "mapbiomas_brazil_af_trinacional_2020_af_lim_forest_vegetation")
rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", raster = "mapbiomas_brazil_af_trinacional_2020_af_lim_forest_vegetation")
rgrass::execGRASS(cmd = "r.mapcalc", flags = "overwrite", expression = "fabdem_v12_af_lim=fabdem_v12")

# align
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "457_atlantic_spatial_elevation = fabdem_v12")

# export
rgrass::execGRASS(cmd = "r.out.gdal",
                  flags = "overwrite",
                  input = "457_atlantic_spatial_elevation",
                  output = "457_atlantic_spatial_elevation.tif",
                  createopt = "COMPRESS=DEFLATE,BIGTIFF=YES")

# end ---------------------------------------------------------------------
