#' ----
#' title: atlantic spatial - colors
#' author: mauricio vancine
#' date: 2023-11-11
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r ---------------------------------------------------------------

# packages
library(terra)
library(viridsi)

# maps ----
files <- dir("E:/data/atlantic_spatial/atlantic_spatial", pattern = ".tif", full.names = TRUE)

for(i in files){

  print(i)

  r <- terra::rast(i)

  png(paste0(sub(".tif", ".png", basename(i))), width = 20, height = 20, units = "cm", res = 300)
  plot(r, col = viridis::viridis(100))
  dev.off()

}

# grassdb ----
rgrass::initGRASS(gisBase = "C:/Program Files/GRASS GIS 8.3",
                  gisDbase = "grassdb",
                  location = "newLocation",
                  mapset = "PERMANENT",
                  override = TRUE)


files <- dir("E:/data/atlantic_spatial/atlantic_spatial", pattern = ".tif", full.names = TRUE)
files

for(i in files){

  print(basename(i))
  rgrass::execGRASS(cmd = "r.in.gdal",
                    input = i,
                    output = basename(i))

}


# colors ----
mapbiomas <- tabulizer::extract_tables("EN__Codigos_da_legenda_Colecao_7.pdf",
                                       output = "data.frame") %>%
  .[[1]] %>%
  dplyr::slice(-c(1, 2)) %>%
  dplyr::rename(desc_pt = 1, desc_en = 2, class = 3, color = 4) %>%
  dplyr::select(-5) %>%
  dplyr::mutate(desc_pt = stringr::str_replace_all(desc_pt, "[:digit:]", ""),
                desc_pt = stringr::str_replace_all(desc_pt, "[.]", ""),
                desc_pt = stringr::str_trim(desc_pt),
                desc_en = stringr::str_replace_all(desc_en, "[:digit:]", ""),
                desc_en = stringr::str_replace_all(desc_en, "[.]", ""),
                desc_en = stringr::str_trim(desc_en),
                class = as.numeric(class))
mapbiomas

# rename
files <- rgrass::execGRASS("g.list", type = "raster", intern = TRUE)
files

for(i in files[-c(1, 500)]){

  rgrass::execGRASS("g.rename", raster = paste0(i, ",", sub(".tif", "", i)))

}


# 001
readr::write_delim(x = tibble::tibble(values = mapbiomas$class, colors = mapbiomas$color),
                   file = "table_color_001.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "001_atlantic_spatial_all_classes", rules = "table_color_001.txt")

# 002
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "002_atlantic_spatial_grouped_classes", rules = "table_color_002.txt")

# 003
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#008000")),
                   file = "table_color_003.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "003_atlantic_spatial_forest_vegetation_binary", rules = "table_color_003.txt")

# 004
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#ff8000")),
                   file = "table_color_004.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "004_atlantic_spatial_natural_vegetation_binary", rules = "table_color_004.txt")

# 005
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#ff8000")),
                   file = "table_color_004.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "", rules = "table_color_004.txt")

# 004
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#ff8000")),
                   file = "table_color_004.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "004_atlantic_spatial_natural_vegetation_binary", rules = "table_color_004.txt")

# 477
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#80ff80")),
                   file = "table_color_477.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "477_atlantic_spatial_forest_plantation_binary", rules = "table_color_477.txt")

# 479
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#ffff80")),
                   file = "table_color_479.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "479_atlantic_spatial_pasture_binary", rules = "table_color_479.txt")

# 481
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#ff80c0")),
                   file = "table_color_481.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "481_atlantic_spatial_temporary_crop_binary", rules = "table_color_481.txt")

# 483
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#8080c0")),
                   file = "table_color_483.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "483_atlantic_spatial_perennial_crop_binary", rules = "table_color_483.txt")

# 485
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#808080")),
                   file = "table_color_485.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "485_atlantic_spatial_urban_areas_binary", rules = "table_color_485.txt")

# 487
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#ff0000")),
                   file = "table_color_487.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "487_atlantic_spatial_mining_binary", rules = "table_color_487.txt")

# 489
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#0080ff")),
                   file = "table_color_489.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "489_atlantic_spatial_water_binary", rules = "table_color_489.txt")

# 491
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#000000")),
                   file = "table_color_491.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "491_atlantic_spatial_roads_binary", rules = "table_color_491.txt")

# 493
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#000000")),
                   file = "table_color_493.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "493_atlantic_spatial_railways_binary", rules = "table_color_493.txt")

# 495
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#000000")),
                   file = "table_color_495.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "495_atlantic_spatial_roads_railways_binary", rules = "table_color_495.txt")

# 497
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#ffdc3d")),
                   file = "table_color_497.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "497_atlantic_spatial_protected_areas_binary", rules = "table_color_497.txt")

# 499
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#1d2cf7")),
                   file = "table_color_499.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "499_atlantic_spatial_indigenous_territory_binary", rules = "table_color_499.txt")

# topography
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "457_atlantic_spatial_elevation", color = "srtm_plus")
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "458_atlantic_spatial_slope", color = "slope")
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "459_atlantic_spatial_aspect", color = "aspect")
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "460_atlantic_spatial_pcurvature", color = "curvature")
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "461_atlantic_spatial_tcurvature", color = "curvature")

# hydro
readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#00bbfe")),
                   file = "table_color_463.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "463_atlantic_spatial_stream_binary", rules = "table_color_463.txt")

readr::write_delim(x = tibble::tibble(values = 0:1, colors = c("#cacaca", "#00bbfe")),
                   file = "table_color_465.txt", delim = " ", col_names = FALSE)
rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = "465_atlantic_spatial_spring_binary", rules = "table_color_465.txt")

files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*kernel*", intern = TRUE)
files

for(i in files){

  rgrass::execGRASS(cmd = "r.colors", map = i, color = "bcyr")

}

# ids
files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*_id*", intern = TRUE)
files

for(i in files){

  rgrass::execGRASS(cmd = "r.colors", map = i, color = "random")

}

# areas
files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*_area", intern = TRUE)
files

for(i in files){

  rgrass::execGRASS(cmd = "r.colors", flags = "g", map = i, color = "ryg")

}

# core percentage
files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*pct*", intern = TRUE) %>%
  stringr::str_subset("core")
files

for(i in files){

  rgrass::execGRASS(cmd = "r.colors", flags = "g", map = i, color = "blues")

}

# edge percentage
files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*pct*", intern = TRUE) %>%
  stringr::str_subset("edge")
files

for(i in files){

  rgrass::execGRASS(cmd = "r.colors", flags = "g", map = i, color = "oranges")

}

# perimeter
files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*perimeter*", intern = TRUE)
files

for(i in files){

  rgrass::execGRASS(cmd = "r.colors", flags = "g", map = i, color = "bgyr")

}

# distance
files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*distance*", intern = TRUE)
files

for(i in files){

  rgrass::execGRASS(cmd = "r.colors", flags = "g", map = i, color = "plasma")

}

# export ------------------------------------------------------------------

files <- rgrass::execGRASS("g.list", type = "raster", pattern = "*", intern = TRUE)
files

for(i in files[-1]){

  print(i)
  rgrass::execGRASS(cmd = "r.out.gdal",
                    input = i,
                    output = paste0("atlantic_spatial_colored/", i, ".tif"),
                    createopt = "COMPRESS=DEFLATE,TFW=YES")

}

# end ---------------------------------------------------------------------
