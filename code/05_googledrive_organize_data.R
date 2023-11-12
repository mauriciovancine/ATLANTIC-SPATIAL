# library
library(googledrive)

# authorization ----
googledrive::drive_auth()

# atlantic spatial description ----
atlantic_spatial_description <- readr::read_csv("data/atlantic_spatial_description.csv") %>% 
    dplyr::select(id:file_name)
atlantic_spatial_description

# list files ----
atlantic_spatial_files <- googledrive::drive_ls(path = "atlantic_spatial") %>% 
    dplyr::arrange(name)
atlantic_spatial_files

# drive id ----
atlantic_spatial_files_join <- atlantic_spatial_files %>% 
    dplyr::arrange(name) %>% 
    dplyr::mutate(file_name = stringr::str_sub(name, end = -5),
                  extension = stringr::str_sub(name, start = -3)) %>% 
    tidyr::pivot_wider(names_from = extension, values_from = id) %>% 
    dplyr::select(file_name, tif, tfw) %>%
    dplyr::mutate(tif = ifelse(is.na(tif), "", tif),
                  tfw = ifelse(is.na(tfw), "", tfw)) %>% 
    dplyr::group_by(file_name) %>% 
    dplyr::summarise(tif = paste0(tif, collapse = ""),
                     tfw = paste0(tfw, collapse = "")) %>% 
    dplyr::mutate(link_drive_tif = paste0("https://drive.google.com/file/d/", tif), .after = tif) %>% 
    dplyr::mutate(link_drive_tfw = paste0("https://drive.google.com/file/d/", tfw), .after = tfw) %>% 
    dplyr::rename(file_id_drive_tif = tif,
                  file_id_drive_tfw = tfw)
atlantic_spatial_files_join

atlantic_spatial_description <- dplyr::left_join(atlantic_spatial_description, atlantic_spatial_files_join, by = "file_name")
atlantic_spatial_description

atlantic_spatial_description %>% 
    readr::write_csv("~/Downloads/atlantic_spatial_description.csv")


# data to rename ----
atlantic_spatial_description_rename <- atlantic_spatial_description %>% 
    dplyr::mutate(id = stringr::str_sub(file_name, end = 3)) %>% 
    dplyr::mutate(name = stringr::str_remove(file_name, ".tif")) %>% 
    dplyr::mutate(name = substring(name, 5)) %>% 
    dplyr::select(id, name) %>% 
    dplyr::mutate(file_rename = paste0(id, "_", name)) %>% 
    dplyr::select(-id)
atlantic_spatial_description_rename

atlantic_spatial_files_name <- atlantic_spatial_files %>% 
    dplyr::select(name) %>% 
    dplyr::mutate(name = stringr::str_remove_all(name, ".tif")) %>%
    dplyr::mutate(name = stringr::str_remove_all(name, ".tfw")) %>%
    dplyr::distinct()
atlantic_spatial_files_name

rename <- dplyr::left_join(atlantic_spatial_files_name, atlantic_spatial_description_rename, by = "name") %>% 
    tidyr::drop_na() %>% 
    dplyr::arrange(file_rename)
rename

for(i in 1:nrow(rename)){
    
    googledrive::drive_rename(file = paste0(rename[i, ]$name, ".tif"), 
                              name = paste0(rename[i, ]$file_rename, ".tif"))
    
    googledrive::drive_rename(file = paste0(rename[i, ]$name, ".tfw"), 
                              name = paste0(rename[i, ]$file_rename, ".tfw"))

}

# pattern ----
atlantic_spatial_files <- googledrive::drive_ls(path = "atlantic_spatial") %>% 
    dplyr::arrange(name)
atlantic_spatial_files

atlantic_spatial_files_name <- atlantic_spatial_files %>% 
    dplyr::select(name) %>% 
    dplyr::mutate(name = stringr::str_remove_all(name, ".tif")) %>%
    dplyr::mutate(name = stringr::str_remove_all(name, ".tfw")) %>%
    dplyr::distinct()
atlantic_spatial_files_name

atlantic_spatial_files_name_pattern <- atlantic_spatial_files_name %>% 
    dplyr::filter(stringr::str_detect(name, "buffer_2000")) %>% 
    dplyr::mutate(file_rename = stringr::str_replace_all(name, "buffer_2000", "buffer2000")) %>% 
    dplyr::slice(1)
atlantic_spatial_files_name_pattern

rename <- atlantic_spatial_files_name_pattern
rename

for(i in 1:nrow(rename)){
    
    googledrive::drive_rename(file = paste0(rename[i, ]$name, ".tif"), 
                              name = paste0(rename[i, ]$file_rename, ".tif"))
    
    googledrive::drive_rename(file = paste0(rename[i, ]$name, ".tfw"), 
                              name = paste0(rename[i, ]$file_rename, ".tfw"))
    
}

