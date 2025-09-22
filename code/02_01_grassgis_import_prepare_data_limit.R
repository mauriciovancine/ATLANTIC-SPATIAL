#' ----
#' title: atlantic spatial - import and prepare data - limits
#' author: mauricio vancine
#' date: 2023-10-12
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r -------------------------------------------------------------

# packages
library(tidyverse)
library(rgrass)
library(sf)

# grass wgs84 geodesic ----------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb",
                  location = "wgs84_geodesic",
                  mapset = "PERMANENT",
                  override = TRUE)

# import limit
rgrass::execGRASS("v.in.ogr",
                  flags = c("overwrite"),
                  input = "01_data/01_limits/ma_limite_integrador_muylaert_et_al_2018_wgs84_geodesic_v1_2_0.shp",
                  output = "af_lim")

# rasterize
rgrass::execGRASS(cmd = "v.to.rast", flags = "overwrite", use = "val", input = "af_lim", output = "af_lim")

# grass sirgas2000 albers -------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb",
                  location = "sirgas2000_albers",
                  mapset = "PERMANENT",
                  override = TRUE)

# import af limit
rgrass::execGRASS(cmd = "v.import",
                  flags = "overwrite",
                  input = "01_data/01_limits/ma_limite_integrador_muylaert_et_al_2018_wgs84_geodesic_v1_2_0.shp",
                  output = "af_lim")

# rasterize
rgrass::execGRASS(cmd = "v.to.rast", flags = "overwrite", use = "val", input = "af_lim", output = "af_lim")

# end ---------------------------------------------------------------------
