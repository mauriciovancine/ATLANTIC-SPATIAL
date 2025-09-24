#' ----
#' title: atlantic spatial - metrics
#' author: mauricio vancine
#' date: 19/08/2023
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r -------------------------------------------------------------

# packages
library(link2GI)
library(rgrass)
library(lsmetrics) # remotes::install_github("mauriciovancine/lsmtretrics")
library(terra)
library(viridis)
library(cptcity)

# source
source("code/lsm_morphology.R")
source("code/lsm_fragment_area.R")
source("code/lsm_core_edge.R")

# data --------------------------------------------------------------------

# 00 toy landscape ----
toy_landscape <- terra::rast(ncols = 16,
                             nrows = 16,
                             xmin = 234000,
                             xmax = 234000 + (16 * 30),
                             ymin = 7524000,
                             ymax = 7524000 + (16 * 30),
                             crs = "EPSG:32723")
toy_landscape

toy_landscape_binary <- toy_landscape
terra::values(toy_landscape_binary) <- c(
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
    0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
    0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1,
    1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1,
    1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0)

toy_landscape_multiclass <- toy_landscape
terra::values(toy_landscape_multiclass) <- c(
    2, 2, 2, 2, 3, 3, 3, 3, 3, 5, 5, 5, 5, 1, 1, 1,
    2, 1, 1, 1, 3, 3, 3, 1, 1, 1, 1, 5, 5, 1, 1, 1,
    2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 1, 1, 1,
    2, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 5, 5, 5, 5, 5,
    2, 2, 2, 0, 0, 0, 0, 4, 3, 3, 3, 4, 4, 4, 4, 4,
    2, 2, 2, 0, 0, 0, 0, 4, 3, 3, 3, 3, 4, 4, 4, 4,
    2, 2, 2, 0, 0, 0, 4, 4, 3, 3, 3, 4, 4, 4, 4, 4,
    1, 1, 1, 1, 1, 1, 2, 2, 1, 0, 0, 0, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 2, 2, 1, 0, 0, 0, 1, 1, 1, 1,
    1, 5, 5, 5, 1, 1, 2, 2, 4, 0, 0, 0, 1, 1, 1, 1,
    1, 5, 5, 5, 1, 2, 2, 2, 4, 0, 0, 1, 1, 1, 5, 1,
    1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 3, 5, 5, 5, 5, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 5, 3, 3, 5, 5, 4, 4, 1, 1, 1, 1,
    5, 5, 5, 5, 5, 5, 3, 3, 5, 1, 4, 4, 4, 4, 4, 4)

# figures
png("figures/fig08_landscape_b.png", width = 20, height = 20, units = "cm", res = 300)
plot(toy_landscape_multiclass,
     col = c("white", "#00a600", "#fffeb6", "#bcb9d8", "#fb7f73", "#7eb0d0"),
     legend = FALSE, axes = FALSE, main = "(b) Toy landscape (multi-class)",
     cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_multiclass, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(toy_landscape_multiclass, cex = 1.5)
dev.off()

png("figures/fig08_landscape_a.png", width = 20, height = 20, units = "cm", res = 300)
plot(toy_landscape_binary, col = c("white", "#00a600"), legend = FALSE, axes = FALSE, 
     main = "(a) Toy landscape (binary)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(toy_landscape_binary, cex = 1.5)
dev.off()

# grassdb -----------------------------------------------------------------

# grass path
path_grass <- as.character(link2GI::findGRASS()[1]) # windows users need to find, e.g. "C:/Program Files/GRASS GIS 8.2"
# path_grass <- "C:/Program Files/GRASS GIS 8.4" # windows users need to find, e.g. "C:/Program Files/GRASS GIS 8.2"

# init grassdb
rgrass::initGRASS(gisBase = path_grass,
                  SG = toy_landscape_binary,
                  gisDbase = "figures/grassdb",
                  location = "newLocation",
                  mapset = "PERMANENT",
                  override = TRUE)

# import raster from r to grass
rgrass::write_RAST(x = toy_landscape_binary, flags = c("o", "overwrite", "quiet"), vname = "toy_landscape_binary", verbose = FALSE)
rgrass::write_RAST(x = toy_landscape_multiclass, flags = c("o", "overwrite", "quiet"), vname = "toy_landscape_multiclass", verbose = FALSE)

# 01 fragment area --------------------------------------------------------

# metric
lsmetrics::lsm_area_fragment(input = "toy_landscape_binary", 
                             area_round_digit = 2, 
                             map_fragment_id = TRUE)

# id
toy_landscape_binary_fragment_id <- rgrass::read_RAST("toy_landscape_binary_fragment_id", flags = "quiet", return_format = "terra")

png("figures/fig09_01_fragment_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(toy_landscape_binary_fragment_id, legend = FALSE, axes = FALSE, main = "(a) 1. Fragment ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(toy_landscape_binary_fragment_id, cex = 1.5)
dev.off()

# area
toy_landscape_binary_fragment_area <- terra::rast(rgrass::read_RAST("toy_landscape_binary_fragment_area", flags = "quiet", return_format = "SGDF"))

png("figures/fig09_02_fragment_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(toy_landscape_binary_fragment_area, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, main = "(b) 2. Fragment area", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(toy_landscape_binary_fragment_area, digits = 2, cex = 1.2)
dev.off()

# 02 percentage of fragment -------------------------------------------------

# metric
lsmetrics::lsm_percentage(input = "toy_landscape_binary", 
                          buffer_radius = 30, 
                          buffer_circular = TRUE)

# percentage
toy_landscape_binary_pct_buf30 <- rgrass::read_RAST("toy_landscape_binary_pct_buf30", flags = "quiet", return_format = "terra")

png("figures/fig10_03_fragment_percentage.png", width = 20, height = 20, units = "cm", res = 300)
plot(toy_landscape_binary_pct_buf30, legend = FALSE, axes = FALSE, main = "3. Percentage of fragments", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(toy_landscape_binary_pct_buf30, cex = 1.5)
dev.off()

# 03 patch area -----------------------------------------------------------

# metric
lsm_area_patch(input = "toy_landscape_binary", 
               area_round_digit = 2, 
               map_patch_id = TRUE, 
               map_patch_ncell = TRUE, 
               map_patch_area_original = TRUE, 
               map_patch_number_original = TRUE)

# id
r_patch_id <- rgrass::read_RAST("toy_landscape_binary_patch_id", flags = "quiet", return_format = "terra")

png("figures/fig11_04_patch_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_id, legend = FALSE, axes = FALSE, main = "(a) 4. Patch ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_patch_id, cex = 1.5)
dev.off()

# area
r_patch_area <- rgrass::read_RAST("toy_landscape_binary_patch_area", flags = "quiet", return_format = "terra")

png("figures/fig11_05_patch_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_area, legend = FALSE, axes = FALSE, main = "(b) 5. Patch area", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_patch_area, digits = 2, cex = 1.2)
dev.off()

# area original
r_patch_area_original <- rgrass::read_RAST("toy_landscape_binary_patch_area_original", flags = "quiet", return_format = "terra")

png("figures/fig11_06_patch_area_original.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_area_original, legend = FALSE, axes = FALSE, main = "(c) 6. Patch area original", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_patch_area_original, digits = 2, cex = 1.2)
dev.off()

# number of patch
r_patch_number <- rgrass::read_RAST("toy_landscape_binary_patch_number_original", flags = "quiet", return_format = "terra")

png("figures/fig11_07_patch_number.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_number, legend = FALSE, axes = FALSE, main = "(d) 7. Number of patches", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_patch_number, cex = 1.5)
dev.off()

# 04 morphologies ---------------------------------------------------------

# metric
lsm_morphology(input = "toy_landscape_binary")

# id
r_morphology <- rgrass::read_RAST("toy_landscape_binary_morphology", flags = "quiet", return_format = "terra")
r_matrix <- rgrass::read_RAST("toy_landscape_binary_morphological_segmentation_matrix", flags = "quiet", return_format = "terra")
r_core <- rgrass::read_RAST("toy_landscape_binary_core", flags = "quiet", return_format = "terra")
r_edge <- rgrass::read_RAST("toy_landscape_binary_edge", flags = "quiet", return_format = "terra")
r_corridor <- rgrass::read_RAST("toy_landscape_binary_corridor", flags = "quiet", return_format = "terra")
r_branch <- rgrass::read_RAST("toy_landscape_binary_branch", flags = "quiet", return_format = "terra")
r_stepping_stone <- rgrass::read_RAST("toy_landscape_binary_stepping_stone", flags = "quiet", return_format = "terra")
r_perforation <- rgrass::read_RAST("toy_landscape_binary_perforation", flags = "quiet", return_format = "terra")

png("figures/fig12_08_morphology.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_morphology, legend = FALSE, axes = FALSE, main = "(a) 8. Landscape morphology", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_morphology, cex = 1.5)
dev.off()

png("figures/fig12_09_matrix.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_matrix, legend = FALSE, axes = FALSE, main = "(b) 9. Landscape morphology - Matrix", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_matrix, cex = 1.5)
dev.off()

png("figures/fig12_10_core.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core, legend = FALSE, axes = FALSE, main = "(c) 10. Landscape morphology - Core", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_core, cex = 1.5)
dev.off()

png("figures/fig12_11_edge.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge, legend = FALSE, axes = FALSE, main = "(d) 11. Landscape morphology - Edge", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_edge, cex = 1.5)
dev.off()

png("figures/fig12_12_corridor.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_corridor, legend = FALSE, axes = FALSE, main = "(e) 12. Landscape morphology - Corridor", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_corridor, cex = 1.5)
dev.off()

png("figures/fig12_13_branch.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_branch, legend = FALSE, axes = FALSE, main = "(f) 13. Landscape morphology - Branch", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_branch, cex = 1.5)
dev.off()

png("figures/fig12_14_stepping_stone.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_stepping_stone, legend = FALSE, axes = FALSE, main = "(g) 14. Landscape morphology - Stepping stone", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_stepping_stone, cex = 1.5)
dev.off()

png("figures/fig12_15_perforation.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_perforation, legend = FALSE, axes = FALSE, main = "(h) 15. Landscape morphology - Perforation", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_perforation, cex = 1.5)
dev.off()

# 05 core and edge ------------------------------------------------------

# metric
lsm_core_edge(input = "toy_landscape_binary",
              edge_depth = 30,
              core_edge_type = "both",
              id = TRUE,
              core_number = TRUE,
              core_edge_original = TRUE,
              calculate_area = TRUE,
              calculate_percentage = TRUE,
              buffer_radius = 30,
              buffer_circular = TRUE)

# import from grass to r
r_core30 <- rgrass::read_RAST("toy_landscape_binary_core30", flags = "quiet", return_format = "terra")
r_core30_id <- rgrass::read_RAST("toy_landscape_binary_core30_id", flags = "quiet", return_format = "terra")
r_core30_area <- terra::rast(rgrass::read_RAST("toy_landscape_binary_core30_area_ha", flags = "quiet", return_format = "SGDF"))
r_core30_area_original <- terra::rast(rgrass::read_RAST("toy_landscape_binary_core30_area_ha_original", flags = "quiet", return_format = "SGDF"))
r_core30_core_number <- rgrass::read_RAST("toy_landscape_binary_core30_core_number_original", flags = "quiet", return_format = "terra")
r_core30_pct_buf30 <- rgrass::read_RAST("toy_landscape_binary_core30_pct_buf30", flags = "quiet", return_format = "terra")

r_edge30 <- rgrass::read_RAST("toy_landscape_binary_edge30", flags = "quiet", return_format = "terra")
r_edge30_id <- rgrass::read_RAST("toy_landscape_binary_edge30_id", flags = "quiet", return_format = "terra")
r_edge30_area <- terra::rast(rgrass::read_RAST("toy_landscape_binary_edge30_area_ha", flags = "quiet", return_format = "SGDF"))
r_edge30_area_original <- terra::rast(rgrass::read_RAST("toy_landscape_binary_edge30_area_ha_original", flags = "quiet", return_format = "SGDF"))
r_edge30_pct_buf30 <- rgrass::read_RAST("toy_landscape_binary_edge30_pct_buf30", flags = "quiet", return_format = "terra")

# plot
png("figures/fig13_16_core.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core30, legend = FALSE, axes = FALSE, main = "(a) 16. Core", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_core30, cex = 1.5)
dev.off()

png("figures/fig13_17_core_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core30_id, legend = FALSE, axes = FALSE, main = "(b) 17. Core ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_core30_id, cex = 1.5)
dev.off()

png("figures/fig13_18_core_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core30_area, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, main = "(c) 18. Core area", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_core30_area, digits = 2, cex = 1.2)
dev.off()

png("figures/fig13_19_core_area_original.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core30_area_original, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, main = "(d) 19. Core area original", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_core30_area_original, digits = 2, cex = 1.2)
dev.off()

png("figures/fig13_20_core_number.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core30_core_number, legend = FALSE, axes = FALSE, main = "(e) 20. Number of cores", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_core30_core_number, cex = 1.5)
dev.off()

png("figures/fig13_21_edge.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge30, legend = FALSE, axes = FALSE, main = "(f) 21. Edge", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_edge30, cex = 1.5)
dev.off()

png("figures/fig13_22_edge_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge30_id, legend = FALSE, axes = FALSE, main = "(g) 22. Edge ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_edge30_id, cex = 1.5)
dev.off()

png("figures/fig13_23_edge_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge30_area, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, main = "(h) 23. Edge area", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_edge30_area, digits = 2, cex = 1.2)
dev.off()

png("figures/fig13_24_edge_area_original.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge30_area_original, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, main = "(i) 24. Edge area original", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_edge30_area_original, digits = 2, cex = 1.2)
dev.off()

# 06 percentage of edge and core ------------------------------------------------

png("figures/fig14_25_core_percentage.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core30_pct_buf30, legend = FALSE, axes = FALSE, main = "(a) 25. Percentage of core (buffer 30 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_core30_pct_buf30, cex = 1.5)
dev.off()

png("figures/fig14_26_edge_percentage.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge30_pct_buf30, legend = FALSE, axes = FALSE, main = "(b) 26. Percentage of edge (buffer 30 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_edge30_pct_buf30, cex = 1.5)
dev.off()

# 07 perimeter ------------------------------------------------

# metric
lsmetrics::lsm_perimeter(input = "toy_landscape_binary",
                         perimeter_round_digit = 2, 
                         map_perimeter_area_ratio_index = TRUE)

# import from grass to r
r_perimeter <- terra::rast(rgrass::read_RAST("toy_landscape_binary_perimeter", flags = "quiet", return_format = "SGDF"))
r_perimeter_area_ratio <- terra::rast(rgrass::read_RAST("toy_landscape_binary_perimeter_area_ratio_index", flags = "quiet", return_format = "SGDF"))

# plot
png("figures/fig15_27_perimeter.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_perimeter, col = cptcity::cpt("grass_bgyr"), legend = FALSE, axes = FALSE, main = "(a) 27. Perimeter", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_perimeter, cex = 1)
dev.off()

png("figures/fig15_28_perimeter_area_ratio.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_perimeter_area_ratio, col = cptcity::cpt("grass_bgyr"), legend = FALSE, axes = FALSE, main = "(b) 28. Perimeter-area ratio", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_perimeter_area_ratio, digits = 3, cex = .8)
dev.off()

# 08 distance ------------------------------------------------

# metric
lsmetrics::lsm_distance(input = "toy_landscape_binary", distance_type = "both")

# import from grass to r
r_distance_inside <- terra::rast(rgrass::read_RAST("toy_landscape_binary_distance_inside", flags = "quiet", return_format = "SGDF"))
r_distance_outside <- terra::rast(rgrass::read_RAST("toy_landscape_binary_distance_outside", flags = "quiet", return_format = "SGDF"))

# plot
png("figures/fig16_29_distance_inside.png", width = 20, height = 20, units = "cm", res = 300)
plot(terra::ifel(r_distance_inside > 0, r_distance_inside, NA) * -1,
     col = adjustcolor(viridis::plasma(10, direction = -1), .7),
     legend = FALSE, axes = FALSE, main = "(a) 29. Distance inside", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_distance_inside * -1, cex = 1)
dev.off()

png("figures/fig16_30_distance_outside.png", width = 20, height = 20, units = "cm", res = 300)
plot(terra::ifel(r_distance_outside > 0, r_distance_outside, NA),
     col = adjustcolor(viridis::plasma(10, direction = -1), .7),
     legend = FALSE, axes = FALSE, main = "(b) 30. Distance outside", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_distance_outside, cex = 1)
dev.off()

png("figures/fig16_31_distance.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_distance_inside * -1 + r_distance_outside,
     col = adjustcolor(viridis::plasma(10, direction = -1), .7),
     legend = FALSE, axes = FALSE, main = "(c) 31. Distance", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_distance_inside * -1 + r_distance_outside, cex = 1)
dev.off()

# 09 structural connectivity -----------------------------------------------

# metric
lsmetrics::lsm_connectivity_structural(input = "toy_landscape_binary", 
                                       area_round_digit = 2, 
                                       map_connec_struct = TRUE, 
                                       map_connec_struct_area = TRUE)

# import from grass to r
r_structural_connectivity <- terra::rast(rgrass::read_RAST("toy_landscape_binary_struct_connec", flags = "quiet", return_format = "SGDF"))
r_structural_connected_area <- terra::rast(rgrass::read_RAST("toy_landscape_binary_struct_connec_area", flags = "quiet", return_format = "SGDF"))

png("figures/fig17_32_structural_connectivity.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_structural_connectivity, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, main = "(a) 32. Structural connectivity", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_structural_connectivity, digits = 2, cex = 1.2)
dev.off()

png("figures/fig17_33_structural_connected_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_structural_connected_area, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, main = "(b) 33. Structural connected area", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_structural_connected_area, digits = 2, cex = 1.2)
dev.off()

# 10 functional connectivity ----------------------------------------------

# metric
lsmetrics::lsm_connectivity_functional(input = "toy_landscape_binary", 
                                       gap_crossing = 30, 
                                       area_round_digit = 2, 
                                       map_func_connec_area =  TRUE,
                                       map_func_connec_id = TRUE, 
                                       map_func_connec_dilation = TRUE)

# import do r
r_functionally_connected_dilation <- terra::rast(rgrass::read_RAST("toy_landscape_binary_func_connec60_dilation", flags = "quiet", return_format = "SGDF"))
r_functionally_connected_id <- terra::rast(rgrass::read_RAST("toy_landscape_binary_func_connec60_id", flags = "quiet", return_format = "SGDF"))
r_functionally_connected_area <- terra::rast(rgrass::read_RAST("toy_landscape_binary_func_connec60_area", flags = "quiet", return_format = "SGDF"))
r_functional_connectivity <- terra::rast(rgrass::read_RAST("toy_landscape_binary_func_connec60", flags = "quiet", return_format = "SGDF"))

png("figures/fig18_34_functional_connected_area_dilation.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected_dilation, col = "gray",
     legend = FALSE, axes = FALSE, main = "(a) 34. Functionally connected dilation (60 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
dev.off()

png("figures/fig18_35_functional_connected_area_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected_dilation, col = "gray",
     legend = FALSE, axes = FALSE, main = "(b) 35. Functionally connected ID (60 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(r_functionally_connected_id, col = RColorBrewer::brewer.pal(n = 3, name = "Set2"), legend = FALSE, axes = FALSE, add = TRUE)
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_functionally_connected_id, cex = 1.5)
dev.off()

png("figures/fig18_36_functional_connected_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected_dilation, col = "gray", legend = FALSE, axes = FALSE,
     main = "(c) 36. Functionally connected area (60 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(r_functionally_connected_area, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, add = TRUE)
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_functionally_connected_area, digits = 2, cex = 1.2)
dev.off()

png("figures/fig18_37_functional_connectivity.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected_dilation, col = "gray", legend = FALSE, axes = FALSE,
     main = "(d) 37. Functional connectivity (60 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(r_functional_connectivity, col = cptcity::cpt("grass_ryg"), legend = FALSE, axes = FALSE, add = TRUE)
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_functional_connectivity, digits = 2, cex = 1.2)
dev.off()

# 11 landscape diversity ---------------------------------------------------

# metric
lsmetrics::lsm_diversity(input = "toy_landscape_multiclass", 
                         buffer_radius = 30, 
                         diversity_index = "shannon")

lsmetrics::lsm_diversity(input = "toy_landscape_multiclass",
                         buffer_radius = 30,
                         diversity_index = "simpson")

# id
r_div_shannon <- terra::rast(rgrass::read_RAST("toy_landscape_multiclass_diversity_shannon_buffer30", flags = "quiet", return_format = "SGDF"))
r_div_simpson <- terra::rast(rgrass::read_RAST("toy_landscape_multiclass_diversity_simpson_buffer30", flags = "quiet", return_format = "SGDF"))

png("figures/fig19_38_div_shannon.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_div_shannon, col = viridis::viridis(n = 10, alpha = .85), legend = FALSE,
     axes = FALSE, main = "(a) 38. Landscape diversity (Shannon)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_div_shannon, cex = 1, digits = 2)
dev.off()

png("figures/fig19_39_div_simpson.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_div_simpson, col = viridis::viridis(n = 10, alpha = .85), legend = FALSE,
     axes = FALSE, main = "(b) 39. Landscape diversity (Simpson)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(toy_landscape_binary, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(toy_landscape_binary), lwd = 2, add = TRUE)
text(r_div_simpson, cex = 1, digits = 2)
dev.off()

# end ---------------------------------------------------------------------

