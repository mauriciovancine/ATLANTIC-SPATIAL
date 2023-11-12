#' ----
#' title: atlantic spatial - import and prepare data - hydrologic
#' author: mauricio vancine
#' date: 2023-11-11
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r -------------------------------------------------------------

# packages
library(tidyverse)
library(rgrass)
library(sf)

# connect grass -----------------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb",
                  location = "sirgas2000_albers",
                  mapset = "PERMANENT",
                  override = TRUE)

# import masses of water
rgrass::execGRASS(cmd = "v.import",
                  flags = "overwrite",
                  input = "01_data/04_hidrography/00_raw/HydroLAKES_polys_v10.shp",
                  output = "hydrolakes")

rgrass::execGRASS(cmd = "v.import",
                  flags = "overwrite",
                  input = "01_data/04_hidrography/00_raw/massa_dagua_ibge.shp",
                  output = "masses_water_br")

rgrass::execGRASS(cmd = "v.import",
                  flags = "overwrite",
                  input = "01_data/04_hidrography/00_raw/areas_de_aguas_continentales_BH130.shp",
                  output = "masses_water_ar01")

rgrass::execGRASS(cmd = "v.import",
                  flags = "overwrite",
                  input = "01_data/04_hidrography/00_raw/areas_de_aguas_continentales_BH140.shp",
                  output = "masses_water_ar02")

# crop
rgrass::execGRASS(cmd = "v.overlay", ainput = "hydrolakes", binput = "af_lim", operator = "and", output = "hydrolakes_af_lim")
rgrass::execGRASS(cmd = "v.overlay", ainput = "masses_water_br", binput = "af_lim", operator = "and", output = "masses_water_br_af_lim")
rgrass::execGRASS(cmd = "v.overlay", ainput = "masses_water_ar01", binput = "af_lim", operator = "and", output = "masses_water_ar01_af_lim")
rgrass::execGRASS(cmd = "v.overlay", ainput = "masses_water_ar02", binput = "af_lim", operator = "and", output = "masses_water_ar02_af_lim")

# rasterize
rgrass::execGRASS(cmd = "v.to.rast", input = "hydrolakes_af_lim", output = "hydrolakes", use = "val", value = 1)
rgrass::execGRASS(cmd = "v.to.rast", input = "masses_water_br", output = "masses_water_br", use = "val", value = 1)
rgrass::execGRASS(cmd = "v.to.rast", input = "masses_water_ar01", output = "masses_water_ar01", use = "val", value = 1)
rgrass::execGRASS(cmd = "v.to.rast", input = "masses_water_ar02", output = "masses_water_ar02", use = "val", value = 1)

# zeros
rgrass::execGRASS(cmd = "r.mapcalc", expression = "hydrolakes_binary=if(isnull(hydrolakes), 0, 1)")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "masses_water_br_binary=if(isnull(masses_water_br), 0, 1)")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "masses_water_ar01_binary=if(isnull(masses_water_ar01), 0, 1)")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "masses_water_ar02_binary=if(isnull(masses_water_ar02), 0, 1)")

# masses of water
rgrass::execGRASS(cmd = "r.mapcalc", expression = "masses_water_binary=hydrolakes_binary+masses_water_br_binary+masses_water_ar01_binary+masses_water_ar01_binary")
rgrass::execGRASS(cmd = "r.mapcalc", flags = "overwrite", expression = "masses_water_binary_10=if(masses_water_binary > 0, 10, 0)")

# end ---------------------------------------------------------------------
