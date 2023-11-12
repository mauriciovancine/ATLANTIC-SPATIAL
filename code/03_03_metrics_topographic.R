#' ----
#' title: atlantic spatial - topographic metrics
#' author: mauricio vancine
#' date: 2023-11-11
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
                  location = "sirgas2000_albers",
                  mapset = "PERMANENT",
                  override = TRUE)

# calculate ---------------------------------------------------------------

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), vector = "af_lim")
rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", vector = "af_lim")

# calculate
rgrass::execGRASS(cmd = "r.slope.aspect",
                  flags = "overwrite",
                  elevation = "457_atlantic_spatial_elevation",
                  precision = "DCELL",
                  slope = "458_atlantic_spatial_slope",
                  aspect = "459_atlantic_spatial_aspect",
                  pcurvature = "460_atlantic_spatial_pcurvature",
                  tcurvature = "461_atlantic_spatial_tcurvature",
                  nprocs = parallel::detectCores() - 1)

# geomorphons
rgrass::execGRASS(cmd = "r.geomorphon", flags = "overwrite", elevation = "457_atlantic_spatial_elevation", forms = "462_atlantic_spatial_geomorph")

# end ---------------------------------------------------------------------
