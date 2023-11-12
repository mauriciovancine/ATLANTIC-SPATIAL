#' ----
#' title: atlantic spatial - import and prepare data - landscape
#' author: mauricio vancine
#' date: 2022-10-27
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

# import mapbiomas brazil
rgrass::execGRASS("r.in.gdal",
                  flags = "overwrite",
                  input = "01_data/02_landscape/00_raw/mapbiomas_v7_brasil_coverage_2020.tif",
                  output = "mapbiomas_brazil_2020")

# import mapbiomas trinacional
rgrass::execGRASS("r.in.gdal",
                  flags = "overwrite",
                  input = "01_data/02_landscape/00_raw/af_trinacional_2020-0000065536-0000000000.tif",
                  output = "mapbiomas_af_trinacional_2020")

# merge mapbiomas brazil and trinacional
# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), res = "00:00:01",
                  n = "-21.83", s = "-29.04", e = "-53.52", w = "-58.33")

# mapcalc
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_brazil_2020_e = if(mapbiomas_brazil_2020> 0, null(), 1)")

rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_af_trinacional_2020_e = mapbiomas_af_trinacional_2020 * mapbiomas_brazil_2020_e")

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), vector = "af_lim", res = "00:00:01")

# patch
rgrass::execGRASS(cmd = "r.patch",
                  flags = "overwrite",
                  input = "mapbiomas_af_trinacional_2020_e,mapbiomas_brazil_2020",
                  output = "mapbiomas_brazil_af_trinacional_2020")

# remove
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_brazil_2020")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_brazil_2020_e")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_af_trinacional_2020")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_af_trinacional_2020_e")

# select habitat
rgrass::execGRASS("r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_brazil_af_trinacional_2020_forest=if(mapbiomas_brazil_af_trinacional_2020 == 3 || mapbiomas_brazil_af_trinacional_2020 == 5 || mapbiomas_brazil_af_trinacional_2020 == 49, 1, 0)")

rgrass::execGRASS("r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_brazil_af_trinacional_2020_natural=if(mapbiomas_brazil_af_trinacional_2020 == 3 || mapbiomas_brazil_af_trinacional_2020 == 4 || mapbiomas_brazil_af_trinacional_2020 == 5 || mapbiomas_brazil_af_trinacional_2020 == 11 || mapbiomas_brazil_af_trinacional_2020 == 12 || mapbiomas_brazil_af_trinacional_2020 == 13 || mapbiomas_brazil_af_trinacional_2020 == 32 || mapbiomas_brazil_af_trinacional_2020 == 49 || mapbiomas_brazil_af_trinacional_2020 == 50, 1, 0)")

# export
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = "mapbiomas_brazil_af_trinacional_2020", res = "00:00:01")
rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", vector = "af_lim")

rgrass::execGRASS(cmd = "r.out.gdal",
                  flags = c("c", "overwrite"),
                  input = "mapbiomas_brazil_af_trinacional_2020",
                  output = "01_data/02_landscape/mapbiomas_brazil_af_trinacional_af_lim_2020.tif",
                  createopt = "TFW=TRUE,COMPRESS=DEFLATE")

rgrass::execGRASS(cmd = "r.out.gdal",
                  flags = c("c", "overwrite"),
                  input = "mapbiomas_brazil_af_trinacional_2020_forest",
                  output = "01_data/02_landscape/mapbiomas_brazil_af_trinacional_af_lim_2020_forest.tif",
                  createopt = "TFW=TRUE,COMPRESS=DEFLATE")

rgrass::execGRASS(cmd = "r.out.gdal",
                  flags = c("c", "overwrite"),
                  input = "mapbiomas_brazil_af_trinacional_2020_natural",
                  output = "01_data/02_landscape/mapbiomas_brazil_af_trinacional_af_lim_2020_natural.tif",
                  createopt = "TFW=TRUE,COMPRESS=DEFLATE")

# grass sirgas2000 albers -------------------------------------------------

# before run 02_05_grassgis_import_prepare_data_anthropogenic_roads_railways

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/00_grassdb",
                  location = "sirgas2000_albers",
                  mapset = "PERMANENT",
                  override = TRUE)

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), vector = "af_lim", res = "30")

# mask
rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", vector = "af_lim")

# import
rgrass::execGRASS(cmd = "r.import",
                  flags = "overwrite",
                  input = "01_data/02_landscape/mapbiomas_brazil_af_trinacional_af_lim_2020.tif",
                  output = "mapbiomas_brazil_af_trinacional_2020")

rgrass::execGRASS(cmd = "r.import",
                  flags = "overwrite",
                  input = "01_data/02_landscape/mapbiomas_brazil_af_trinacional_af_lim_2020_forest.tif",
                  output = "mapbiomas_brazil_af_trinacional_2020_forest")

rgrass::execGRASS(cmd = "r.import",
                  flags = "overwrite",
                  input = "01_data/02_landscape/mapbiomas_brazil_af_trinacional_af_lim_2020_natural.tif",
                  output = "mapbiomas_brazil_af_trinacional_2020_natural")

# adjust
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "001_atlantic_spatial_all_classes = mapbiomas_brazil_af_trinacional_2020")

rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_brazil_af_trinacional_2020_forest_af_lim = mapbiomas_brazil_af_trinacional_2020_forest")

rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_brazil_af_trinacional_2020_natural_af_lim = mapbiomas_brazil_af_trinacional_2020_natural")

# delete roads and railways
rgrass::execGRASS("r.mapcalc",
                  flags = "overwrite",
                  expression = paste0("003_atlantic_spatial_forest_vegetation_binary=if(roads_railways_af == 1 & mapbiomas_brazil_af_trinacional_2020_af_lim_forest == 1, 0, mapbiomas_brazil_af_trinacional_2020_af_lim_forest)"))

rgrass::execGRASS("r.mapcalc",
                  flags = "overwrite",
                  expression = paste0("004_atlantic_spatial_natural_vegetation_binary=if(roads_railways_af == 1 & mapbiomas_brazil_af_trinacional_2020_af_lim_natural == 1, 0, mapbiomas_brazil_af_trinacional_2020_af_lim_natural)"))

# classes
rgrass::execGRASS(cmd = "r.mapcalc", expression = "477_atlantic_spatial_forest_plantation_binary = 001_atlantic_spatial_all_classes == 9")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "479_atlantic_spatial_pasture_binary = 001_atlantic_spatial_all_classes == 15")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "481_atlantic_spatial_temporary_crop_binary = 001_atlantic_spatial_all_classes == 19 || 001_atlantic_spatial_all_classes == 20 || 001_atlantic_spatial_all_classes == 39 || 001_atlantic_spatial_all_classes == 40 || 001_atlantic_spatial_all_classes == 41 || 001_atlantic_spatial_all_classes == 62")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "483_atlantic_spatial_perennial_crop_binary = 001_atlantic_spatial_all_classes == 36 || 001_atlantic_spatial_all_classes == 46 || 001_atlantic_spatial_all_classes == 47 || 001_atlantic_spatial_all_classes == 48")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "485_atlantic_spatial_urban_areas_binary = 001_atlantic_spatial_all_classes == 24")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "487_atlantic_spatial_mining_binary = 001_atlantic_spatial_all_classes == 30")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "489_atlantic_spatial_water_binary = 001_atlantic_spatial_all_classes == 33")

# classes grouped
rgrass::execGRASS(cmd = "r.mapcalc", expression = "002_atlantic_spatial_grouped_classes = if(003_atlantic_spatial_forest_vegetation_binary == 1, 1, 0) + if(004_atlantic_spatial_natural_vegetation_binary == 1, 2, 0) + if(477_atlantic_spatial_forest_plantation_binary == 1, 3, 0) + if(479_atlantic_spatial_pasture_binary == 1, 4, 0) + if(481_atlantic_spatial_temporary_crop_binary == 1, 5, 0) + if(483_atlantic_spatial_perennial_crop_binary == 1, 6, 0) + if(485_atlantic_spatial_urban_areas_binary == 1, 7, 0) + if(487_atlantic_spatial_mining_binary == 1, 8, 0) + if(489_atlantic_spatial_water_binary == 1, 9, 0)")

# remove
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_brazil_af_trinacional_2020")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_brazil_af_trinacional_2020_forest")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_brazil_af_trinacional_2020_forest_af_lim")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_brazil_af_trinacional_2020_natural")
rgrass::execGRASS(cmd = "g.remove", flags = "f", type = "raster", name = "mapbiomas_brazil_af_trinacional_2020_natural_af_lim")

# export
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "001_atlantic_spatial_all_classes", output = "001_atlantic_spatial_all_classes.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "002_atlantic_spatial_grouped_classes", output = "002_atlantic_spatial_grouped_classes.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "003_atlantic_spatial_forest_vegetation_binary", output = "003_atlantic_spatial_forest_vegetation_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "004_atlantic_spatial_natural_vegetation_binary", output = "004_atlantic_spatial_natural_vegetation_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "477_atlantic_spatial_forest_plantation_binary", output = "477_atlantic_spatial_forest_plantation_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "479_atlantic_spatial_pasture_binary", output = "479_atlantic_spatial_pasture_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "481_atlantic_spatial_temporary_crop_binary", output = "481_atlantic_spatial_temporary_crop_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "483_atlantic_spatial_perennial_crop_binary", output = "483_atlantic_spatial_perennial_crop_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "485_atlantic_spatial_urban_areas_binary", output = "485_atlantic_spatial_urban_areas_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "487_atlantic_spatial_mining_binary", output = "487_atlantic_spatial_mining_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")
rgrass::execGRASS(cmd = "r.out.gdal", flags = "overwrite", input = "489_atlantic_spatial_water_binary", output = "489_atlantic_spatial_water_binary.tif", createopt = "TFW=YES,COMPRESS=DEFLATE")

# end ---------------------------------------------------------------------
