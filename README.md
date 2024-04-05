# ATLANTIC SPATIAL

### Description

<p align="justify">

A compilation of spatial covariates data of landscape, topographic, hydrologic, and anthropogenic metrics for the entire AF at fine spatial resolution (30-m) for the year 2020.

ATLANTIC SPATIAL dataset is part of the <a href="https://github.com/LEEClab/Atlantic_series">ATLANTIC series</a>, on which research teams are compiling biodiversity information of Atlantic Forest. This paper follows previous published data papers in <a href="https://esajournals.onlinelibrary.wiley.com/doi/toc/10.1002/(ISSN)1939-9170.AtlanticPapers">Ecology</a>.

</p>

### Citation

<p align="justify">

Vancine, M. H., B. B. Niebuhr, R. L. Muylaert, J. E. F. Oshima, V. Tonetti, R. Bernardo, R. S. C. Alves, E. M. Zanette, V. C. Souza, J. G. R. Giovanelli, C. H. Grohmann, M. C. Ribeiro. ATLANTIC SPATIAL: a dataset of landscape, topographic, hydrologic and anthropogenic metrics for the Atlantic Forests. Ecology (*in review*).

</p>

### Abstract

<p align="justify">

Space is one of the main drivers of biodiversity, once it regulates the underlying processes affecting the distribution and dynamics of species. It is a fundamental factor in face of the rapid climate and land use and land cover changes at local and global scales, which are linked to habitat loss and fragmentation and their impacts on various organisms. The Atlantic Forest of South America (AF) is among the global biodiversity hotspots because of its high species richness and endemism. Most of the threats to the AF biodiversity is due to the expansion of urbanization and industry, extensive agricultural and livestock production, and mining. Here, we make available integrated and fine-scale spatial information (resolution = 30 m) for the entire AF extent for the year 2020. The metrics consider different vegetation classes (forest and forest plus other natural vegetation), effects of linear structure (roads and railways) and multiple scales (radius buffer from 50 m to 2,500 m and up to 10 km for some metrics). The entire data set is composed of 500 rasters and the AF delimitation vector, available through the R package *atlanticr*, which we developed in order to facilitate the organization and acquisition of the data. The metrics consists of: land cover (31 classes), distance to grouped land cover classes (forest vegetation, natural vegetation, pasture, temporary crop, perennial crop, forest plantation, urban areas, mining, and water), a set of landscape, topographic, and hydrologic metrics, and anthropogenic infrastructure. The landscape metrics include landscape morphology (classification as matrix, core, edge, corridor, stepping stone, branch, and perforation), fragment area and proportion, area and number of patches, edge and core areas and proportion, structural and functional connectivity (for different organisms' gap-crossing capabilities), distance to fragment edges, fragment perimeter and perimeter-area ratio, and landscape diversity. Topographic metrics include elevation, slope, aspect, curvatures, and landform elements (peak, ridge, shoulder, spur, slope, hollow, footslope, valley, pit, and ﬂat), hydrologic metrics comprise potential springs and its kernel and potential streams and respective distances, and anthropogenic infrastructure maps contain roads, railways, protected areas, and indigenous territories and the respective distance to each of them. These data sets will allow for efficient integration of biodiversity and environmental data for the AF in future ecological studies, and we expect it to be an important reference and data source for landscape planning, biodiversity conservation, and forest restoration programs.

<p align="center">

<img src="https://github.com/mauriciovancine/ATLANTIC-SPATIAL/blob/main/figures/fig02a.png" height="350" width="250"/> <img src="https://github.com/mauriciovancine/ATLANTIC-SPATIAL/blob/main/figures/fig02b.png" height="350" width="250"/> <img src="https://github.com/mauriciovancine/ATLANTIC-SPATIAL/blob/main/figures/fig02c.png" height="350" width="250"/>

</p>

<p align="justify">

<b>Figure 1.</b> Data framework used to summarize land use land cover (LULC) classes into Atlantic Forest habitat types. (a) The LULC classes refer to MapBiomas in the AF (Brazil, Argentina, and Paraguay). (b) Grouped land cover classes. (c) Two vegetation classes were considered as habitat to calculate the landscape metrics.

</p>

------------------------------------------------------------------------

### R package

We created the R package [atlanticr](https://mauriciovancine.github.io/atlanticr/) which, in addition to facilitating access to other data papers, provides a table with all metrics and their information "atlantic_spatial" and a function to download rasters "atlantic_spatial_download()".

```{r}
# install package
devtools::install_githun("mauriciovancine/atlanticr")

# load package
library(atlanticr)

# dataset
head(atlanticr::atlantic_spatial)

# download
atlanticr::atlantic_spatial_download(id, 
                                     metric, 
                                     metric_group,
                                     metric_type,
                                     lulc_class,
                                     edge_depth,
                                     gap_crossing,
                                     scale_buffer_radius,
                                     resolution,
                                     path)
```

------------------------------------------------------------------------

## code

All analyses were performed in [R language](https://www.r-project.org/) and [GRASS GIS](https://grass.osgeo.org/) through [*rgrass*](https://rsbivand.github.io/rgrass/) R package. This folder contains all R code files used:

-   `01_01_download_limits.R`: download Atlantic Forest limit
-   `01_02_download_landscape.R`: download Land Use and Land Cover from [MapBiomas Brazil v07](https://brasil.mapbiomas.org/) and [MapBiomas Bosque Atlántico v02](https://bosqueatlantico.mapbiomas.org/)
-   `01_03_download_topographic.R`: download topographic data from [FABDEM v1.2](https://data.bris.ac.uk/data/dataset/s5hqmjcdj8yo2ibzi9b4ew3sn)
-   `01_04_download_hydrologic.R`: download hydrologic data from [HydroBASINS](https://www.hydrosheds.org/products/hydrobasins) and [HydroLAKES](https://www.hydrosheds.org/products/hydrolakes), and official databases from Brazil ([IBGE](https://www.ibge.gov.br/)), Argentina ([IGN](https://www.ign.gob.ar)) and Paraguay ([INE](https://www.ine.gov.py)),
-   `01_05_download_anthropogenic_roads_railways.R`: download roads and railways from official databases from Brazil ([IBGE](https://www.ibge.gov.br/)), Argentina ([IGN](https://www.ign.gob.ar)) and Paraguay ([INE](https://www.ine.gov.py))
-   `01_06_download_anthropogenic_protected_areas.R`: download protected areas from [Protected Planet](https://www.protectedplanet.net/en)
-   `01_07_download_anthropogenic_indigenous_territories.R`: download indigenous territories from official databases from Brazil ([FUNAI](https://www.gov.br/funai/pt-br)) and Paraguay ([Tierras Indígenas](https://www.tierrasindigenas.org))
-   `01_08_download_anthropogenic_urban_areas.R`: download urban areas data from official databases from Brazil ([IBGE](https://www.ibge.gov.br/)), Argentina ([IGN](https://www.ign.gob.ar)) and Paraguay ([INE](https://www.ine.gov.py))
-   `02_01_grassgis_import_prepare_data_limit.R`: import and prepare Atlantic Forest limit data on the GRASS GIS\
-   `02_02_grassgis_import_prepare_data_landscape.R`: import and prepare Mapbiomas LULC rasters data on the GRASS GIS
-   `02_03_grass_gis_import_prepare_data_topographic.R`: import and prepare FABDEM rasters data on the GRASS GIS
-   `02_04_grassgis_import_prepare_data_hydrologic.R`: import and prepare hydrologic data on the GRASS GIS
-   `02_05_grassgis_import_anthropogenic_roads_railways.R`: import and prepare road and railway data on the GRASS GIS
-   `02_06_grassgis_import_anthropogenic_protected_areas.R`: import and prepare protected areas data on the GRASS GIS
-   `02_07_grassgis_import_anthropogenic_indigenous_territories.R`: import and prepare indigenous territories data on the GRASS GIS
-   `02_08_grassgis_import_anthropogenic_urban_areas.R`: import and prepare urban area data on the GRASS GIS
-   `03_02_grassgis_metrics_landscape.R`: calculate landscape metrics on the GRASS GIS
-   `03_03_grassgis_metrics_topographic.R`: calculate topographic metrics on the GRASS GIS
-   `03_04_grassgis_metrics_hydrologic.R`: calculate hydrologic metrics on the GRASS GIS
-   `03_05_grassgis_metrics_anthropogenic.R`: calculate anthropogenic metrics on the GRASS GIS
-   `04_grass_gis_color.R`: define raster colors on the GRASS GIS
-   `05_googledrive_organize_data.R`: organize data on the Google Drive
-   `lsm_hydrologic.R`: function to calculate spring and streams from DEM raster
-   `lsm_hydrologic_basin.R`: function to calculate spring and streams by basins from DEM raster

## data

Table with layer information and download links.

## figures

All figures in the paper in high definition.

------------------------------------------------------------------------

## Principal Investigators

<ins>[Maurício Humberto Vancine](https://mauriciovancine.github.io/)</ins>

Universidade Estadual Paulista (UNESP), Instituto de Biociências, Departamento de Ecologia, Laboratório de Ecologia Espacial e Conservação, Rio Claro, Brazil

<ins>[Bernardo Brandão Niebuhr](https://www.nina.no/english/Contact/Employees/Employee-info?AnsattID=16449)</ins>

Department of Terrestrial Biodiversity, Norwegian Institute for Nature Research (NINA), Trondheim, Norway

<ins>[Renata L. Muylaert](https://renatamuy.github.io/)</ins>

Molecular Epidemiology and Public Health Laboratory, Hopkirk Research Institute, Massey University, Palmerston North, New Zealand

<ins>[Milton Cezar Ribeiro]()</ins>

Universidade Estadual Paulista (UNESP), Instituto de Biociências, Departamento de Ecologia, Laboratório de Ecologia Espacial e Conservação, Rio Claro, Brazil

Universidade Estadual Paulista (UNESP), Instituto de Biociências, Departamento de Zoologia e Centro de Aquicultura (CAUNESP), Rio Claro, SP, Brazil
