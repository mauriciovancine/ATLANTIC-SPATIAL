#' ----
#' title: atlantic spatial - download - limits
#' author: mauricio vancine
#' date: 2023-10-12
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r ---------------------------------------------------------------

# packages
library(tidyverse)
library(rnaturalearth)
library(sf)
library(geobr)
library(tmap)

# options
sf::sf_use_s2(FALSE)
options(timeout = 1e5)

# download data -----------------------------------------------------------

# folder structure to download data
folder <- "01_data"; if(!dir.exists(folder)) dir.create(folder)
folder <- "01_data/01_limits"; if(!dir.exists(folder)) dir.create(folder)
folder <- "01_data/01_limits/00_raw"; if(!dir.exists(folder)) dir.create(folder)

# atlantic forest limits
download.file(url = "https://github.com/LEEClab/ATLANTIC-limits/blob/master/data/limites_integradores_wgs84_v1_2_0.zip",
              destfile = "01_data/01_limits/00_raw/limites_integradores_wgs84_v1_2_0.zip", mode = "wb")

system("unrar e 01_data/01_limits/00_raw/limites_integradores_wgs84_v1_1_0.rar 01_data/01_limits/00_raw")

geobr::read_biomes(year = 2004) %>%
  dplyr::filter(name_biome == "Mata Atlântica") %>%
  sf::st_transform(4326) %>%
  sf::st_write("01_data/01_limits/00_raw/limit_af_ibge_2004_wgs84_geo.shp")

geobr::read_biomes(year = 2019) %>%
  dplyr::filter(name_biome == "Mata Atlântica") %>%
  sf::st_transform(4326) %>%
  sf::st_write("01_data/01_limits/00_raw/limit_af_ibge_2019_wgs84_geo.shp")

download.file(url = "https://storage.googleapis.com/teow2016/Ecoregions2017.zip",
              destfile = "01_data/01_limits/00_raw/ecoregions2017.zip", mode = "wb")

unzip(zipfile = "01_data/01_limits/00_raw/ecoregions2017.zip", exdir = "01_data/01_limits/00_raw/")

sf::st_read("01_data/01_limits/00_raw/Ecoregions2017.shp") %>%
  dplyr::filter(BIOME_NAME %in% c("Tropical & Subtropical Moist Broadleaf Forests",
                                  "Mangroves",
                                  "Tropical & Subtropical Dry Broadleaf Forests"),
                REALM == "Neotropic",
                ECO_NAME %in% c("Alto Paraná Atlantic forests",
                                "Araucaria moist forests",
                                "Bahia coastal forests",
                                "Bahia interior forests",
                                "Serra do Mar coastal forests",
                                "Southern Atlantic Brazilian mangroves",
                                "Atlantic Coast restingas",
                                "Brazilian Atlantic dry forests",
                                "Pernambuco interior forests",
                                "Pernambuco coastal forests",
                                "Caatinga Enclaves moist forests")) %>%
  sf::st_write("01_data/01_limits/00_raw/limit_af_wwf_terr_ecos_biorregions_2017_gcs_wgs84.shp")

download.file(url = "http://antigo.mma.gov.br/estruturas/202/_arquivos/shape_mata_atlantica_ibge_5milhoes_policonica_sirgas2000shp_202.zip",
              destfile = "01_data/01_limits/00_raw/shape_mata_atlantica_ibge_5milhoes_policonica_sirgas2000shp_202.zip", mode = "wb")

unzip(zipfile = "01_data/01_limits/00_raw/shape_mata_atlantica_ibge_5milhoes_policonica_sirgas2000shp_202.zip",
      exdir = "01_data/01_limits/00_raw/")

sf::st_read("01_data/01_limits/00_raw/shape_mata_atlantica_IBGE_5milhoes_policonica_sirgas2000.shp") %>%
  sf::st_transform(4326) %>%
  sf::st_write("01_data/01_limits/00_raw/limit_af_lawaf2006_gcs_wgs84.shp")

# brazil ibge 1:250,000
download.file(url = "https://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bc250/versao2021/geopackage/bc250_2021_11_18.zip",
              destfile = "01_data/01_limits/00_raw/2021_bc_250.zip", mode = "wb")

unzip(zipfile = "01_data/01_limits/00_raw/2021_bc_250.zip", exdir = "01_data/01_limits")

# countries
countries_sa <- rnaturalearth::ne_countries(scale = 10, continent = "South America", returnclass = "sf") %>%
  sf::st_union(rnaturalearth::ne_countries(scale = 10, country = "France", returnclass = "sf")) %>%
  sf::st_crop(rnaturalearth::ne_countries(continent = "South America", returnclass = "sf")) %>%
  sf::st_as_sf()
countries_sa
sf::st_write(countries_sa, "01_data/01_limits/countries_sa_natural_earth_wgs84_geodesic.gpkg", delete_dsn = TRUE)

# end ---------------------------------------------------------------------
