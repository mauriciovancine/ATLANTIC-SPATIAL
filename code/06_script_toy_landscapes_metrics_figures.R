#' ----
#' title: atlantic spatial - metrics
#' author: mauricio vancine
#' date: 19/08/2023
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r -------------------------------------------------------------

# packages
library(lsmetrics)
library(terra)
library(viridis)
library(cptcity)

# 00 toy landscape ----
r_bin <- lsmetrics::lsm_toy_landscape(type = "binary")
r_bin

png("figures/fig07_landscape_a.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_bin, col = c("white", "#00a600"), legend = FALSE, axes = FALSE, 
     main = "A. Toy landscape (binary)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_bin, cex = 1.5)
dev.off()

r_multiclass <- lsmetrics::lsm_toy_landscape(type = "multiclass")
r_multiclass

png("figures/fig07_landscape_b.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_multiclass,
     col = c("white", "#00a600", "#fffeb6", "#bcb9d8", "#fb7f73", "#7eb0d0"),
     legend = FALSE, axes = FALSE, main = "B. Toy landscape (multi-class)",
     cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_multiclass, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_multiclass, cex = 1.5)
dev.off()

# grassdb
path_grass <- as.character(link2GI::findGRASS()[1]) # windows users need to find, e.g. "C:/Program Files/GRASS GIS 8.2"
path_grass <- "C:/Program Files/GRASS GIS 8.4" # windows users need to find, e.g. "C:/Program Files/GRASS GIS 8.2"
rgrass::initGRASS(gisBase = path_grass,
                  SG = r,
                  gisDbase = "figures/grassdb",
                  location = "newLocation",
                  mapset = "PERMANENT",
                  override = TRUE)

# import raster from r to grass
rgrass::write_RAST(x = r_bin, flags = c("o", "overwrite", "quiet"), vname = "r_bin", verbose = FALSE)
rgrass::write_RAST(x = r_multiclass, flags = c("o", "overwrite", "quiet"), vname = "r_multiclass", verbose = FALSE)

# 01 fragment area --------------------------------------------------------

# metric
lsmetrics::lsm_fragment_area(input = "r_bin", id = TRUE)

# id
r_bin_fragment_id <- rgrass::read_RAST("r_bin_fragment_id", flags = "quiet", return_format = "terra")

png("figures/fig08_01_fragment_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_bin_fragment_id, legend = FALSE, axes = FALSE, main = "1. Fragment ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_bin_fragment_id, cex = 1.5)
dev.off()

# area
r_bin_fragment_area <- rgrass::read_RAST("r_bin_fragment_area_ha", flags = "quiet", return_format = "terra")

png("figures/fig08_02_fragment_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_bin_fragment_area, legend = FALSE, axes = FALSE, main = "2. Fragment area (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_bin_fragment_area, cex = 1.5)
dev.off()

# 02 percentage of fragment -------------------------------------------------

# metric
lsmetrics::lsm_percentage(input = "r_bin", buffer_radius = 100, buffer_circular = TRUE)

# percentage
r_bin_pct_buf100 <- rgrass::read_RAST("r_bin_pct_buf100", flags = "quiet", return_format = "terra")

png("figures/fig09_03_fragment_percentage.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_bin_pct_buf100, legend = FALSE, axes = FALSE, main = "3. Percentage of fragment (%)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_bin_pct_buf100, cex = 1.5)
dev.off()

# 03 patch area -----------------------------------------------------------

# metric
lsmetrics::lsm_patch_area(input = "r_bin", id = TRUE, ncell = TRUE, patch_original = TRUE, patch_number = TRUE)

# id
r_patch_id <- rgrass::read_RAST("r_bin_patch_id", flags = "quiet", return_format = "terra")

png("figures/fig10_04_patch_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_id, legend = FALSE, axes = FALSE, main = "4. Patch ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_patch_id, cex = 1.5)
dev.off()

# area
r_patch_area <- rgrass::read_RAST("r_bin_patch_area_ha", flags = "quiet", return_format = "terra")

png("figures/fig10_05_patch_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_area, legend = FALSE, axes = FALSE, main = "5. Patch area (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_patch_area, cex = 1.5)
dev.off()

# area original
r_patch_area_original <- rgrass::read_RAST("r_bin_patch_area_ha_original", flags = "quiet", return_format = "terra")

png("figures/fig10_06_patch_area_original.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_area_original, legend = FALSE, axes = FALSE, main = "6. Patch area original (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_patch_area_original, cex = 1.5)
dev.off()

# number of patch
r_patch_number <- rgrass::read_RAST("r_bin_patch_number_original", flags = "quiet", return_format = "terra")

png("figures/fig10_07_patch_number.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_patch_number, legend = FALSE, axes = FALSE, main = "7. Number of patches", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_patch_number, cex = 1.5)
dev.off()

# 04 morphologies ---------------------------------------------------------

# metric
lsmetrics::lsm_morphology(input = "r_bin")

# id
r_morphology <- rgrass::read_RAST("r_bin_morphology", flags = "quiet", return_format = "terra")
r_matrix <- rgrass::read_RAST("r_bin_matrix", flags = "quiet", return_format = "terra")
r_core <- rgrass::read_RAST("r_bin_core", flags = "quiet", return_format = "terra")
r_edge <- rgrass::read_RAST("r_bin_edge", flags = "quiet", return_format = "terra")
r_corridor <- rgrass::read_RAST("r_bin_corridor", flags = "quiet", return_format = "terra")
r_branch <- rgrass::read_RAST("r_bin_branch", flags = "quiet", return_format = "terra")
r_stepping_stone <- rgrass::read_RAST("r_bin_stepping_stone", flags = "quiet", return_format = "terra")
r_perforation <- rgrass::read_RAST("r_bin_perforation", flags = "quiet", return_format = "terra")

png("figures/fig11_08_morphology.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_morphology, legend = FALSE, axes = FALSE, main = "8. Morphology", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_morphology, cex = 1.5)
dev.off()

png("figures/fig11_09_matrix.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_matrix, legend = FALSE, axes = FALSE, main = "9. Matrix", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_matrix, cex = 1.5)
dev.off()

png("figures/fig11_10_core.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core, legend = FALSE, axes = FALSE, main = "10. Core", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_core, cex = 1.5)
dev.off()

png("figures/fig11_11_edge.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge, legend = FALSE, axes = FALSE, main = "11. Edge", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_edge, cex = 1.5)
dev.off()

png("figures/fig11_12_corridor.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_corridor, legend = FALSE, axes = FALSE, main = "12. Corridor", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_corridor, cex = 1.5)
dev.off()

png("figures/fig11_13_branch.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_branch, legend = FALSE, axes = FALSE, main = "13. Branch", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_branch, cex = 1.5)
dev.off()

png("figures/fig11_14_stepping_stone.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_stepping_stone, legend = FALSE, axes = FALSE, main = "14. Stepping stone", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_stepping_stone, cex = 1.5)
dev.off()

png("figures/fig11_15_perforation.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_perforation, legend = FALSE, axes = FALSE, main = "15. Perforation", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_perforation, cex = 1.5)
dev.off()

# 05 core and edge ------------------------------------------------------

# metric
lsmetrics::lsm_core_edge(input = "r_bin",
                         edge_depth = 100,
                         core_edge_type = "both",
                         id = TRUE,
                         core_number = TRUE,
                         core_edge_original = TRUE,
                         calculate_area = TRUE,
                         calculate_percentage = TRUE,
                         buffer_radius = 100,
                         buffer_circular = TRUE)

# import from grass to r
r_core100 <- rgrass::read_RAST("r_bin_core100", flags = "quiet", return_format = "terra")
r_core100_id <- rgrass::read_RAST("r_bin_core100_id", flags = "quiet", return_format = "terra")
r_core100_area_ha <- rgrass::read_RAST("r_bin_core100_area_ha", flags = "quiet", return_format = "terra")
r_core100_area_ha_original <- rgrass::read_RAST("r_bin_core100_area_ha_original", flags = "quiet", return_format = "terra")
r_core100_core_number <- rgrass::read_RAST("r_bin_core100_core_number_original", flags = "quiet", return_format = "terra")
r_core100_pct_buf100 <- rgrass::read_RAST("r_bin_core100_pct_buf100", flags = "quiet", return_format = "terra")

r_edge100 <- rgrass::read_RAST("r_bin_edge100", flags = "quiet", return_format = "terra")
r_edge100_id <- rgrass::read_RAST("r_bin_edge100_id", flags = "quiet", return_format = "terra")
r_edge100_area_ha <- rgrass::read_RAST("r_bin_edge100_area_ha", flags = "quiet", return_format = "terra")
r_edge100_area_ha_original <- rgrass::read_RAST("r_bin_edge100_area_ha_original", flags = "quiet", return_format = "terra")
r_edge100_pct_buf100 <- rgrass::read_RAST("r_bin_edge100_pct_buf100", flags = "quiet", return_format = "terra")

# plot
png("figures/fig12_16_core.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core100, legend = FALSE, axes = FALSE, main = "16. Core", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_core100, cex = 1.5)
dev.off()

png("figures/fig12_17_core_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core100_id, legend = FALSE, axes = FALSE, main = "17. Core ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_core100_id, cex = 1.5)
dev.off()

png("figures/fig12_18_core_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core100_area_ha, legend = FALSE, axes = FALSE, main = "18. Core area (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_core100_area_ha, cex = 1.5)
dev.off()

png("figures/fig12_19_core_area_original.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core100_area_ha_original, legend = FALSE, axes = FALSE, main = "19. Core area original (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_core100_area_ha_original, cex = 1.5)
dev.off()

png("figures/fig12_20_core_number.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core100_core_number, legend = FALSE, axes = FALSE, main = "20. Number of cores", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_core100_core_number, cex = 1.5)
dev.off()

png("figures/fig12_21_edge.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge100, legend = FALSE, axes = FALSE, main = "21. Edge", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_edge100, cex = 1.5)
dev.off()

png("figures/fig12_22_edge_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge100_id, legend = FALSE, axes = FALSE, main = "22. Edge ID", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_edge100_id, cex = 1.5)
dev.off()

png("figures/fig12_23_edge_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge100_area_ha, legend = FALSE, axes = FALSE, main = "23. Edge area (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_edge100_area_ha, cex = 1.5)
dev.off()

png("figures/fig12_24_edge_area_original.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge100_area_ha_original, legend = FALSE, axes = FALSE, main = "24. Edge area original (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_edge100_area_ha_original, cex = 1.5)
dev.off()

# 06 percentage of edge and core ------------------------------------------------

png("figures/fig13_25_core_percentage.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_core100_pct_buf100, legend = FALSE, axes = FALSE, main = "25. Percentage of core (buffer 100 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_core100_pct_buf100, cex = 1.5)
dev.off()

png("figures/fig13_26_edge_percentage.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_edge100_pct_buf100, legend = FALSE, axes = FALSE, main = "26. Percentage of edge (buffer 100 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_edge100_pct_buf100, cex = 1.5)
dev.off()

# 07 perimeter ------------------------------------------------

# metric
lsmetrics::lsm_perimeter(input = "r_bin", perimeter_area_ratio = TRUE)

# import from grass to r
r_perimeter <- terra::rast(rgrass::read_RAST("r_bin_perimeter", flags = "quiet", return_format = "SGDF"))
r_perimeter_area_ratio <- terra::rast(rgrass::read_RAST("r_bin_perimeter_area_ratio", flags = "quiet", return_format = "SGDF"))

# plot
png("figures/fig14_27_perimeter.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_perimeter, col = cptcity::cpt("grass_bgyr"), legend = FALSE, axes = FALSE, main = "27. Perimeter (m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_perimeter, cex = 1)
dev.off()

png("figures/fig14_28_perimeter_area_ratio.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_perimeter_area_ratio, col = cptcity::cpt("grass_bgyr"), legend = FALSE, axes = FALSE, main = "28. Perimeter-area ratio", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_perimeter_area_ratio, digits = 3, cex = .8)
dev.off()

# 08 distance ------------------------------------------------

# metric
lsmetrics::lsm_distance(input = "r_bin", distance_type = "both")

# import from grass to r
r_distance_inside <- terra::rast(rgrass::read_RAST("r_bin_distance_inside", flags = "quiet", return_format = "SGDF"))
r_distance_outside <- terra::rast(rgrass::read_RAST("r_bin_distance_outside", flags = "quiet", return_format = "SGDF"))

# plot
png("figures/fig15_29_distance_inside.png", width = 20, height = 20, units = "cm", res = 300)
plot(terra::ifel(r_distance_inside > 0, r_distance_inside, NA) * -1,
     col = viridis::plasma(10, direction = -1),
     legend = FALSE, axes = FALSE, main = "29. Distance inside (m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_distance_inside * -1, cex = 1)
dev.off()

png("figures/fig15_30_distance_outside.png", width = 20, height = 20, units = "cm", res = 300)
plot(terra::ifel(r_distance_outside > 0, r_distance_outside, NA),
     col = viridis::plasma(10, direction = -1),
     legend = FALSE, axes = FALSE, main = "30. Distance outside (m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_distance_outside, cex = 1)
dev.off()

png("figures/fig15_31_distance.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_distance_inside * -1 + r_distance_outside,
     col = viridis::plasma(10, direction = -1),
     legend = FALSE, axes = FALSE, main = "31. Distance  (m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_distance_inside * -1 + r_distance_outside, cex = 1)
dev.off()

# 09 structural connectivity -----------------------------------------------

# metric
lsmetrics::lsm_structural_connectivity(input = "r_bin")

# import from grass to r
r_structural_connectivity <- rgrass::read_RAST("r_bin_structural_connectivity", flags = "quiet", return_format = "terra")
r_structural_connected_area <- rgrass::read_RAST("r_bin_structural_connected_area", flags = "quiet", return_format = "terra")

png("figures/fig16_32_structural_connectivity.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_structural_connectivity, legend = FALSE, axes = FALSE, main = "32. Structural connectivity (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_structural_connectivity, cex = 1.5)
dev.off()

png("figures/fig16_33_structural_connected_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_structural_connected_area, legend = FALSE, axes = FALSE, main = "33. Structural connected area (ha)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_structural_connected_area, cex = 1.5)
dev.off()

# 10 functional connectivity ----------------------------------------------

# metric
lsmetrics::lsm_functional_connectivity(input = "r_bin", gap_crossing = 100, id = TRUE, dilation = TRUE)

# import do r
r_functionally_connected200_dilation <- terra::rast(rgrass::read_RAST("r_bin_functional_connectivity_dilation200_null", flags = "quiet", return_format = "SGDF"))
r_functionally_connected200_id <- terra::rast(rgrass::read_RAST("r_bin_functional_connected_area200_id", flags = "quiet", return_format = "SGDF"))
r_functionally_connected200_area <- rgrass::read_RAST("r_bin_functional_connected_area200", flags = "quiet", return_format = "terra")
r_functional_connectivity200 <- rgrass::read_RAST("r_bin_functional_connectivity200", flags = "quiet", return_format = "terra")

png("figures/fig17_34_functional_connected_area_dilation.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected200_dilation, col = "gray",
     legend = FALSE, axes = FALSE, main = "34. Functionally connected dilation (200 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
dev.off()

png("figures/fig17_35_functional_connected_area_id.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected200_dilation, col = "gray",
     legend = FALSE, axes = FALSE, main = "35. Functionally connected ID (200 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(r_functionally_connected200_id, col = RColorBrewer::brewer.pal(n = 3, name = "Set2"), legend = FALSE, axes = FALSE, add = TRUE)
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_functionally_connected200_id, cex = 1.5)
dev.off()

png("figures/fig17_36_functional_connected_area.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected200_dilation, col = "gray", legend = FALSE, axes = FALSE,
     main = "36. Functionally connected area (ha) (200 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(r_functionally_connected200_area, legend = FALSE, axes = FALSE, add = TRUE)
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_functionally_connected200_area, cex = 1.5)
dev.off()

png("figures/fig17_37_functional_connectivity.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_functionally_connected200_dilation, col = "gray", legend = FALSE, axes = FALSE,
     main = "37. Functional connectivity (ha) (200 m)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(r_functional_connectivity200, legend = FALSE, axes = FALSE, add = TRUE)
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_functional_connectivity200, cex = 1.5)
dev.off()

# 11 diversity -----------------------------------------------------------

# metric
lsmetrics::lsm_diversity(input = "r_multiclass", buffer_radius = 100, index = "shannon")
lsmetrics::lsm_diversity(input = "r_multiclass", buffer_radius = 100, index = "simpson")

# id
r_div_shannon <- terra::rast(rgrass::read_RAST("r_multiclass_diversity_shannon_buffer100", flags = "quiet", return_format = "SGDF"))
r_div_simpson <- terra::rast(rgrass::read_RAST("r_multiclass_diversity_simpson_buffer100", flags = "quiet", return_format = "SGDF"))

png("figures/fig18_38_div_shannon.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_div_shannon, col = viridis::viridis(n = 10, alpha = .85), legend = FALSE,
     axes = FALSE, main = "38. Landscape diversity (Shannon)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_div_shannon, cex = 1, digits = 2)
dev.off()

png("figures/fig18_39_div_simpson.png", width = 20, height = 20, units = "cm", res = 300)
plot(r_div_simpson, col = viridis::viridis(n = 10, alpha = .85), legend = FALSE,
     axes = FALSE, main = "39. Landscape diversity (Simpson)", cex.main = 2, mar = c(1, 0, 2.5, 0))
plot(as.polygons(r_bin, dissolve = FALSE), lwd = .1, add = TRUE)
plot(as.polygons(r_bin), lwd = 2, add = TRUE)
text(r_div_simpson, cex = 1, digits = 2)
dev.off()

# end ---------------------------------------------------------------------

