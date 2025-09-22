#' ----
#' title: atlantic spatial - landscape metrics
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

# calculate ---------------------------------------------------------------

## fragment area ----
lsmetrics::lsm_fragment_area(input = "003_atlantic_spatial_forest_vegetation_binary", id = TRUE)
lsmetrics::lsm_fragment_area(input = "004_atlantic_spatial_natural_vegetation_binary", id = TRUE)

## fragment percentage ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "af_lim", res = "30")

for(i in c(50, 100, 150, 200, 250, 500, 750, 1000, 1500, 2000, 2500, 3000, 4000, 5000, 7500, 10000)){

  print(i)

  lsmetrics::lsm_percentage_parallel(input = "003_atlantic_spatial_forest_vegetation_binary", buffer_radius = i, grid_size = 800000, buffer_circular = TRUE, nprocs = parallel::detectCores()-1, memory = 1e5)
  lsmetrics::lsm_percentage_parallel(input = "004_atlantic_spatial_natural_vegetation_binary", buffer_radius = i, grid_size = 800000, buffer_circular = TRUE, nprocs = parallel::detectCores()-1, memory = 1e5)

}

## patch area ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "af_lim", res = "30")

lsmetrics::lsm_patch_area(input = "003_atlantic_spatial_forest_vegetation_binary", id = TRUE, patch_original = TRUE, patch_number = TRUE)
lsmetrics::lsm_patch_area(input = "004_atlantic_spatial_natural_vegetation_binary", id = TRUE, patch_original = TRUE, patch_number = TRUE)

## morphology ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "003_atlantic_spatial_forest_vegetation_binary", res = "30")

lsmetrics::lsm_morphology(input = "003_atlantic_spatial_forest_vegetation_binary", nprocs = parallelly::availableCores(omit = 2), memory = 1e5)
lsmetrics::lsm_morphology(input = "004_atlantic_spatial_natural_vegetation_binary", nprocs = parallelly::availableCores(omit = 2), memory = 1e5)

## edge core ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "af_lim", res = "30")

for(i in c(30, 60, 90, 120, 240)){

    lsmetrics::lsm_core_edge(input = "003_atlantic_spatial_forest_vegetation_binary",
                             edge_depth = i,
                             core_edge_type = "both",
                             id = TRUE,
                             calculate_area = TRUE,
                             core_edge_original = TRUE,
                             core_number = TRUE,
                             nprocs = parallelly::availableCores(omit = 2),
                             memory = 1e5)

  lsmetrics::lsm_core_edge(input = "004_atlantic_spatial_natural_vegetation_binary",
                           edge_depth = i,
                           core_edge_type = "both",
                           id = TRUE,
                           calculate_area = TRUE,
                           core_edge_original = TRUE,
                           core_number = TRUE,
                           nprocs = parallelly::availableCores(omit = 2),
                           memory = 1e5)

}

## edge core percent ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "003_atlantic_spatial_forest_vegetation_binary", res = "30")

for(i in c(30, 60, 90, 120, 240)){

  for(j in c(50, 100, 150, 200, 250, 500, 750, 1000, 1500, 2000, 2500)){

    print(paste0("core_edge:", i, " | radius:", j))

    lsmetrics::lsm_percentage_parallel(input = paste0("003_atlantic_spatial_forest_vegetation_binary_edge", i), buffer_radius = j, buffer_circular = TRUE, grid_size = 800000, nprocs = parallel::detectCores()-1, memory = 1e5)
    lsmetrics::lsm_percentage_parallel(input = paste0("003_atlantic_spatial_forest_vegetation_binary_core", i), buffer_radius = j, buffer_circular = TRUE, grid_size = 800000, nprocs = parallel::detectCores()-1, memory = 1e5)
    lsmetrics::lsm_percentage_parallel(input = paste0("004_atlantic_spatial_natural_vegetation_binary_edge", i), buffer_radius = j, buffer_circular = TRUE, grid_size = 800000, nprocs = parallel::detectCores()-1, memory = 1e5)
    lsmetrics::lsm_percentage_parallel(input = paste0("004_atlantic_spatial_natural_vegetation_binary_core", i), buffer_radius = j, buffer_circular = TRUE, grid_size = 800000, nprocs = parallel::detectCores()-1, memory = 1e5)

  }

}

## perimeter ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "af_lim", res = "30")

lsmetrics::lsm_perimeter(input = "003_atlantic_spatial_forest_vegetation_binary", perimeter_area_ratio = TRUE, nprocs = parallelly::availableCores(omit = 2), memory = 1e5)
lsmetrics::lsm_perimeter(input = "004_atlantic_spatial_natural_vegetation_binary", perimeter_area_ratio = TRUE, nprocs = parallelly::availableCores(omit = 2), memory = 1e5)

## distance ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "af_lim", res = "30")

lsmetrics::lsm_distance(input = "003_atlantic_spatial_forest_vegetation_binary", distance_type = "both")
lsmetrics::lsm_distance(input = "004_atlantic_spatial_natural_vegetation_binary", distance_type = "both")

rgrass::execGRASS(cmd = "r.mapcalc", expression = "379_atlantic_spatial_forest_vegetation_distance_inside = 003_atlantic_spatial_forest_vegetation_binary_distance_inside * -1")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "382_atlantic_spatial_natural_vegetation_distance_inside = 004_atlantic_spatial_natural_vegetation_binary_distance_inside * -1")

rgrass::execGRASS(cmd = "r.mapcalc", expression = "381_atlantic_spatial_forest_vegetation_distance = 379_atlantic_spatial_forest_vegetation_distance_inside + 003_atlantic_spatial_forest_vegetation_binary_distance_outside")
rgrass::execGRASS(cmd = "r.mapcalc", expression = "384_atlantic_spatial_natural_vegetation_distance.tif = 382_atlantic_spatial_natural_vegetation_distance_inside + 004_atlantic_spatial_natural_vegetation_binary_outside")

## structural connectivity ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "af_lim", res = "30")

lsmetrics::lsm_structural_connectivity(input = "003_atlantic_spatial_forest_vegetation_binary")
lsmetrics::lsm_structural_connectivity(input = "004_atlantic_spatial_natural_vegetation_binary")

## functional connectivity ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "atlantic_spatial_forest_vegetation", res = "30")

for(i in c(30, 60, 90, 120, 150, 300)){

  lsmetrics::lsm_functional_connectivity(input = "003_atlantic_spatial_forest_vegetation_binary", gap_crossing = i, id = TRUE, dilation = TRUE, nprocs = 1, memory = 1e5)
  lsmetrics::lsm_functional_connectivity(input = "004_atlantic_spatial_natural_vegetation_binary", gap_crossing = i, id = TRUE, dilation = TRUE, nprocs = 1, memory = 1e5)

}

## diversity ----
rgrass::execGRASS("g.region", flags = c("a", "p"), raster = "af_lim", res = "30")

for(i in c(50, 100, 150, 200, 250, 500, 750, 1000, 1500, 2000)){

  for(j in c("shannon", "simpson")){
    lsmetrics::lsm_diversity_parallel(input = "001_atlantic_spatial_all_classes",
                                      buffer_radius = i,
                                      index = j,
                                      grid_size = 2e5,
                                      grid_delete = TRUE,
                                      nprocs = parallel::detectCores() - 1,
                                      memory = 1e5)

  }

}

# end ---------------------------------------------------------------------
