#' ----
#' title: atlantic spatial - import and prepare data - anthropogenic indigenous territories
#' author: mauricio vancine
#' date: 2022-11-01
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
ti_br <- sf::st_read("01_data/indigenous_territory_brazil_wgs84_geo.shp") %>%
  sf::st_make_valid() %>%
  sf::st_transform(sf::st_crs(af_lim)) %>%
  sf::st_intersection(af_lim) %>%
  tibble::rowid_to_column(var = "id") %>%
  dplyr::select(id) %>%
  sf::st_make_valid() %>%
  terra::vect()
rgrass::write_VECT(x = ti_br, vname = "indigenous_territory_brazil", flags = c("overwrite", "quiet"))

ti_py <- sf::st_read("01_data/07_indigenous_territories/indigenous_territory_paraguay_wgs84_geo.shp") %>%
  sf::st_make_valid() %>%
  sf::st_transform(sf::st_crs(af_lim)) %>%
  sf::st_intersection(af_lim) %>%
  tibble::rowid_to_column(var = "id") %>%
  dplyr::select(id) %>%
  sf::st_make_valid() %>%
  terra::vect()
ti_py
rgrass::write_VECT(x = ti_py, vname = "indigenous_territory_paraguay", flags = c("overwrite", "quiet"))

# patch
rgrass::execGRASS(cmd = "v.patch",
                  flags = c("overwrite", "quiet"),
                  input = "indigenous_territory_brazil,indigenous_territory_paraguay",
                  output = "indigenous_territory")

# rasterize ---------------------------------------------------------------

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), vector = "af_lim", res = "30")

# mask
rgrass::execGRASS(cmd = "r.mask", vector = "af_lim")

# rasterize
rgrass::execGRASS(cmd = "v.to.rast",
                  flags = c("overwrite"),
                  input = "indigenous_territory",
                  output = "indigenous_territory_null",
                  use = "val")

# zero
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = c("overwrite"),
                  expression = "499_atlantic_spatial_indigenous_territory_binary=if(isnull(indigenous_territory_null), 0, 1)")

# export ------------------------------------------------------------------

# export
rgrass::execGRASS(cmd = "r.out.gdal",
                  flags = "overwrite",
                  input = "499_atlantic_spatial_indigenous_territory_binary",
                  output = "01_data/07_indigenous_territories/499_atlantic_spatial_indigenous_territory_binary.tif",
                  createopt = "TFW=TRUE,COMPRESS=DEFLATE")

# end ---------------------------------------------------------------------
