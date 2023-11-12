#' ----
#' title: atlantic spatial - download - hydrologic
#' author: mauricio vancine
#' date: 2023-10-12
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r ---------------------------------------------------------------

# options
options(timeout = 1e6)

# download data -----------------------------------------------------------

# basins
download.file(url = "https://data.hydrosheds.org/file/hydrobasins/standard/hybas_sa_lev01-12_v1c.zip",
              destfile = "01_data/04_hidrography/00_raw/hybas_sa_lev01-12_v1c.zip", mode = "wb")

unzip(zipfile = "01_data/04_hidrography/00_raw/hybas_sa_lev01-12_v1c.zip",
      exdir = "01_data/04_hidrography/00_raw")

unlink(x = dir(path = "01_data/04_hidrography/00_raw/",
               pattern = c(".cbf|.sbn|.sbx|.xml"),
               full.names = TRUE))

# lakes
download.file(url = "https://data.hydrosheds.org/file/hydrolakes/HydroLAKES_polys_v10_shp.zip",
              destfile = "01_data/04_hidrography/00_raw/HydroLAKES_polys_v10_shp.zip", mode = "wb")

unzip(zipfile = "01_data/04_hidrography/00_raw/HydroLAKES_polys_v10_shp.zip", exdir = "01_data/04_hidrography/00_raw")

# masses of water
download.file(url = "https://dnsg.ign.gob.ar/apps/api/v1/capas-sig/Hidrograf%C3%ADa+y+oceanograf%C3%ADa/Aguas+continentales/areas_de_aguas_continentales_BH140/shp",
              destfile = "01_data/04_hidrography/00_raw/areas_de_aguas_continentales_BH140.zip", mode = "wb")

download.file(url = "https://dnsg.ign.gob.ar/apps/api/v1/capas-sig/Hidrograf%C3%ADa+y+oceanograf%C3%ADa/Aguas+continentales/areas_de_aguas_continentales_BH130/shp",
              destfile = "01_data/04_hidrography/00_raw/areas_de_aguas_continentales_BH130.zip", mode = "wb")

download.file(url = "https://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bc250/versao2021/geopackage/bc250_2021_11_18.zip",
              destfile = "01_data/01_limits/00_raw/2021_bc_250.zip", mode = "wb")

unzip(zipfile = "01_data/04_hidrography/00_raw/HydroLAKES_polys_v10_shp.zip", exdir = "01_data/04_hidrography/00_raw")
unzip(zipfile = "01_data/04_hidrography/00_raw/areas_de_aguas_continentales_BH140.zip", exdir = "01_data/04_hidrography/00_raw")
unzip(zipfile = "01_data/04_hidrography/00_raw/areas_de_aguas_continentales_BH140.zip", exdir = "01_data/04_hidrography/00_raw")

# end ---------------------------------------------------------------------
