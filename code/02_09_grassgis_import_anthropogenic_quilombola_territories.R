#' ----
#' title: atlantic spatial - import and prepare data - anthropogenic quilombola territories
#' author: mauricio vancine
#' date: 2024-12-27
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r -------------------------------------------------------------

# packages
library(tidyverse)
library(rgrass)
library(sf)
library(terra)

# connect grass -----------------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb",
                  location = "sirgas2000_albers",
                  mapset = "PERMANENT",
                  override = TRUE)

# read limit
af_lim <- rgrass::read_VECT(vname = "af_lim") %>%
  sf::st_as_sf() %>%
  sf::st_union()
af_lim

# import data -------------------------------------------------------------

# import ----
rgrass::execGRASS(cmd = "v.import",
                  flags = "overwrite",
                  input = "/media/mude/afe69132-ffdb-4892-b809-a0f7d2b8f423/backup_2024_11/data/onedrive/doutorado/cap02/01_data/09_quilombola_territories/quilombos_af.shp",
                  output = "atlantic_spatial_quilombola_territories")

# rasterize ---------------------------------------------------------------

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), vector = "af_lim", res = "30")

# mask
rgrass::execGRASS(cmd = "r.mask", vector = "af_lim")

# rasterize
rgrass::execGRASS(cmd = "v.to.rast",
                  flags = c("overwrite"),
                  input = "atlantic_spatial_quilombola_territories",
                  output = "atlantic_spatial_quilombola_territories_null",
                  use = "val")

# zero
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = c("overwrite"),
                  expression = "501_atlantic_spatial_quilombola_territories_binary=if(isnull(atlantic_spatial_quilombola_territories_null), 0, 1)")

# export ------------------------------------------------------------------

# export
rgrass::execGRASS(cmd = "r.out.gdal",
                  flags = "overwrite",
                  input = "501_atlantic_spatial_quilombola_territories_binary",
                  output = "/media/mude/afe69132-ffdb-4892-b809-a0f7d2b8f423/backup_2024_11/data/onedrive/doutorado/cap02/01_data/09_quilombola_territories/501_atlantic_spatial_quilombola_territories_binary.tif",
                  createopt = "TFW=TRUE,COMPRESS=DEFLATE")

# end ---------------------------------------------------------------------
