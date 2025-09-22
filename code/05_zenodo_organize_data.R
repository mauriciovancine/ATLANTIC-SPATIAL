#' ----
#' aim: zenodo confer data
#' author: mauricio vancine
#' date: 07/01/2025
#' ----

# prepare r ---------------------------------------------------------------

# packages
library(tidyverse)
library(atlanticr)
library(rvest)

# import data -------------------------------------------------------------

## atlantic spatial ----
atlantic_spatial

## list doi from zenodo ----
atlantic_spatial_zenodo_repository <- atlantic_spatial %>% 
    dplyr::distinct(zenodo_repository, zenodo_doi)
atlantic_spatial_zenodo_repository

## list zenodo doi ----
atlantic_spatial_zenodo_doi <- atlantic_spatial_zenodo_repository %>% 
    dplyr::mutate(zenodo_id = stringr::str_replace(zenodo_doi, "https://doi.org/10.5281/zenodo.", ""))
atlantic_spatial_zenodo_doi$zenodo_id

# test --------------------------------------------------------------------

## habitat ----
zen_rep <- "ATLANTIC SPATIAL - Habitat"
zenodo_files_habitat <- rvest::read_html(paste0(
    "html_zenodo/", 
    dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
    ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_habitat

atlantic_spatial_files_habitat_limit <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::slice(1) %>% 
    dplyr::pull(file_name) %>% 
    paste0(., ".gpkg")
atlantic_spatial_files_habitat_limit

atlantic_spatial_files_habitat <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::slice(-1) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    c(atlantic_spatial_files_habitat_limit, .) %>% 
    sort()
atlantic_spatial_files_habitat

all(zenodo_files_habitat %in% atlantic_spatial_files_habitat)
all(atlantic_spatial_files_habitat %in% zenodo_files_habitat)

## fragment ----
zen_rep <- "ATLANTIC SPATIAL - Fragment"
zenodo_files_fragment <- rvest::read_html(paste0(
    "html_zenodo/", 
    dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id,
    ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_fragment

atlantic_spatial_files_fragment <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_fragment

all(zenodo_files_fragment %in% atlantic_spatial_files_fragment)
all(atlantic_spatial_files_fragment %in% zenodo_files_fragment)

## Core 30|60|90m Forest ----
zen_rep <- "ATLANTIC SPATIAL - Core 30|60|90m Forest"
zenodo_files_core_30_60_90m_forest <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_core_30_60_90m_forest

atlantic_spatial_files_core_30_60_90m_forest <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_core_30_60_90m_forest

all(zenodo_files_core_30_60_90m_forest %in% atlantic_spatial_files_core_30_60_90m_forest)
all(atlantic_spatial_files_core_30_60_90m_forest %in% zenodo_files_core_30_60_90m_forest)

## Core 120|240m Forest ----
zen_rep <- "ATLANTIC SPATIAL - Core 120|240m Forest"
zenodo_files_core_120_240m_forest <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_core_120_240m_forest

atlantic_spatial_files_core_120_240m_forest <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_core_120_240m_forest

all(zenodo_files_core_120_240m_forest %in% atlantic_spatial_files_core_120_240m_forest)
all(atlantic_spatial_files_core_120_240m_forest %in% zenodo_files_core_120_240m_forest)

## Edge 30|60|90m Forest ----
zen_rep <- "ATLANTIC SPATIAL - Edge 30|60|90m Forest"
zenodo_files_edge_30_60_90m_forest <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_edge_30_60_90m_forest

atlantic_spatial_files_edge_30_60_90m_forest <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_edge_30_60_90m_forest

all(zenodo_files_edge_30_60_90m_forest %in% atlantic_spatial_files_edge_30_60_90m_forest)
all(atlantic_spatial_files_edge_30_60_90m_forest %in% zenodo_files_edge_30_60_90m_forest)

## Edge 120|240m Forest ----
zen_rep <- "ATLANTIC SPATIAL - Edge 120|240m Forest"
zenodo_files_edge_120_240m_forest <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_edge_120_240m_forest

atlantic_spatial_files_edge_120_240m_forest <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_edge_120_240m_forest

all(zenodo_files_edge_120_240m_forest %in% atlantic_spatial_files_edge_120_240m_forest)
all(atlantic_spatial_files_edge_120_240m_forest %in% zenodo_files_edge_120_240m_forest)

## Core 30|60|90m natural ----
zen_rep <- "ATLANTIC SPATIAL - Core 30|60|90m Natural"
zenodo_files_core_30_60_90m_natural <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_core_30_60_90m_natural

atlantic_spatial_files_core_30_60_90m_natural <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_core_30_60_90m_natural

all(zenodo_files_core_30_60_90m_natural %in% atlantic_spatial_files_core_30_60_90m_natural)
all(atlantic_spatial_files_core_30_60_90m_natural %in% zenodo_files_core_30_60_90m_natural)

## Core 120|240m natural ----
zen_rep <- "ATLANTIC SPATIAL - Core 120|240m Natural"
zenodo_files_core_120_240m_natural <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_core_120_240m_natural

atlantic_spatial_files_core_120_240m_natural <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_core_120_240m_natural

all(zenodo_files_core_120_240m_natural %in% atlantic_spatial_files_core_120_240m_natural)
all(atlantic_spatial_files_core_120_240m_natural %in% zenodo_files_core_120_240m_natural)

## Edge 30|60|90m natural ----
zen_rep <- "ATLANTIC SPATIAL - Edge 30|60|90m Natural"
zenodo_files_edge_30_60_90m_natural <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_edge_30_60_90m_natural

atlantic_spatial_files_edge_30_60_90m_natural <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_edge_30_60_90m_natural

all(zenodo_files_edge_30_60_90m_natural %in% atlantic_spatial_files_edge_30_60_90m_natural)
all(zenodo_files_edge_30_60_90m_natural %in% atlantic_spatial_files_edge_30_60_90m_natural)

## Edge 120|240m natural ----
zen_rep <- "ATLANTIC SPATIAL - Edge 120|240m Natural"
zenodo_files_edge_120_240m_natural <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_edge_120_240m_natural

atlantic_spatial_files_edge_120_240m_natural <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_edge_120_240m_natural

all(zenodo_files_edge_120_240m_natural %in% atlantic_spatial_files_edge_120_240m_natural)
all(atlantic_spatial_files_edge_120_240m_natural %in% zenodo_files_edge_120_240m_natural)

## Connectivity ----
zen_rep <- "ATLANTIC SPATIAL - Connectivity"
zenodo_files_connectivity <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_connectivity

atlantic_spatial_files_connectivity <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_connectivity

all(zenodo_files_connectivity %in% atlantic_spatial_files_connectivity)
all(atlantic_spatial_files_connectivity %in% zenodo_files_connectivity)

## Diversity Shannon ----
zen_rep <- "ATLANTIC SPATIAL - Diversity Shannon"
zenodo_files_diversity_shannon <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_diversity_shannon

atlantic_spatial_files_diversity_shannon <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_diversity_shannon

all(zenodo_files_diversity_shannon %in% atlantic_spatial_files_diversity_shannon)
all(atlantic_spatial_files_diversity_shannon %in% zenodo_files_diversity_shannon)

## Diversity Simpson ----
zen_rep <- "ATLANTIC SPATIAL - Diversity Simpson"
zenodo_files_diversity_simpson <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_diversity_simpson

atlantic_spatial_files_diversity_simpson <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_diversity_simpson

zenodo_files_diversity_simpson[1]
atlantic_spatial_files_diversity_simpson[1]

all(zenodo_files_diversity_simpson %in% atlantic_spatial_files_diversity_simpson)
all(atlantic_spatial_files_diversity_simpson %in% zenodo_files_diversity_simpson)

## Topographic ----
zen_rep <- "ATLANTIC SPATIAL - Topographic"
zenodo_files_topographic <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_topographic

atlantic_spatial_files_topographic <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_topographic

all(zenodo_files_topographic %in% atlantic_spatial_files_topographic)
all(atlantic_spatial_files_topographic %in% zenodo_files_topographic)

## Hydrological ----
zen_rep <- "ATLANTIC SPATIAL - Hydrological"
zenodo_files_hydrological <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_hydrological

atlantic_spatial_files_hydrological <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_hydrological

all(zenodo_files_hydrological %in% atlantic_spatial_files_hydrological)
all(atlantic_spatial_files_hydrological %in% zenodo_files_hydrological)

## Anthropogenic ----
zen_rep <- "ATLANTIC SPATIAL - Anthropogenic"
zenodo_files_anthropogenic <- rvest::read_html(
    paste0("html_zenodo/", 
           dplyr::filter(atlantic_spatial_zenodo_doi, zenodo_repository == zen_rep)$zenodo_id, 
           ".html")) %>% 
    html_elements("link[rel='alternate']") %>%
    html_attr("href") %>% 
    basename() %>% 
    sort()
zenodo_files_anthropogenic

atlantic_spatial_files_anthropogenic <- atlantic_spatial %>% 
    dplyr::filter(zenodo_repository == zen_rep) %>% 
    dplyr::pull(file_name) %>% 
    expand.grid(., c(".tfw", ".tif")) %>% 
    apply(., 1, paste, collapse = "") %>% 
    sort()
atlantic_spatial_files_anthropogenic

all(zenodo_files_anthropogenic %in% atlantic_spatial_files_anthropogenic)
all(atlantic_spatial_files_anthropogenic %in% zenodo_files_anthropogenic)

# end ---------------------------------------------------------------------