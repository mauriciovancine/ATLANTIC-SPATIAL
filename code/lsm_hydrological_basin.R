lsm_hidrography_basin <- function(input,
                                  output,
                                  basin,
                                  threshold = 100,
                                  stream_vector = TRUE,
                                  stream_raster = TRUE,
                                  spring_vector = TRUE,
                                  spring_raster = TRUE,
                                  delete_vector = TRUE,
                                  delete_raster = TRUE,
                                  nprocs = 10,
                                  memory = 1e4){

  # import basin
  basin_total <- rgrass::read_VECT(vname = basin, flags = "quiet")

  # region
  rgrass::execGRASS(cmd = "g.region", flags = "a", raster = input)

  # for
  for(i in unique(basin_total$cat)){

    # information
    print(paste0(i, " of ", max(unique(basin_total$cat))))

    # selection
    rgrass::execGRASS(cmd = "v.extract",
                      flags = c("overwrite", "quiet"),
                      input = basin,
                      output = paste0(basin, "_sel"),
                      where = paste0("CAT = ", i))

    # buffer
    rgrass::execGRASS(cmd = "v.buffer",
                      flags = c("overwrite", "quiet"),
                      input = paste0(basin, "_sel"),
                      output = paste0(basin, "_buf"),
                      distance = 1000)

    # region and mask
    rgrass::execGRASS(cmd = "g.region", flags = "a", vector = paste0(basin, "_buf"))
    rgrass::execGRASS(cmd = "r.mask", flags = c("overwrite", "quiet"), vector = paste0(basin, "_buf"))

    # lsm_hidrography
    lsm_hidrography(input,
                    output = i,
                    threshold = threshold,
                    stream_vector = stream_vector,
                    stream_raster = stream_raster,
                    spring_vector = spring_vector,
                    spring_raster = spring_raster,
                    memory = memory)

    # region and mask
    res <- as.numeric(gsub(".*?([0-9]+).*", "\\1", grep("nsres", rgrass::stringexecGRASS("g.region -p", intern = TRUE), value = TRUE)))
    rgrass::execGRASS(cmd = "v.buffer",
                      flags = c("overwrite", "quiet"),
                      input = paste0(basin, "_sel"),
                      output = paste0(basin, "_buf_p"),
                      distance = 3*res)

    rgrass::execGRASS(cmd = "v.buffer",
                      flags = c("overwrite", "quiet"),
                      input = paste0(basin, "_sel"),
                      output = paste0(basin, "_buf_i"),
                      distance = -1*res)

    # select
    rgrass::execGRASS(cmd = "g.region", flags = "a", vector = paste0(basin, "_sel"))
    rgrass::execGRASS(cmd = "r.mask", flags = c("overwrite", "quiet"), vector = paste0(basin, "_sel"))

    if(stream_raster){
      rgrass::execGRASS(cmd = "r.mapcalc", flags = c("overwrite", "quiet"), expression = paste0(input, i, "_stream_binary", "=", input, i, "_stream_binary"))
      rgrass::execGRASS(cmd = "r.mapcalc", flags = c("overwrite", "quiet"), expression = paste0(input, i, "_stream_null", "=", input, i, "_stream_null"))
    }
    if(spring_raster){
      rgrass::execGRASS(cmd = "r.mapcalc", flags = c("overwrite", "quiet"), expression = paste0(input, i, "_spring_binary", "=", input, i, "_spring_binary"))
      rgrass::execGRASS(cmd = "r.mapcalc", flags = c("overwrite", "quiet"), expression = paste0(input, i, "_spring_null", "=", input, i, "_spring_null"))
    }

    if(spring_vector){rgrass::execGRASS(cmd = "v.select", flags = c("overwrite", "quiet"), ainput = paste0(input, i, "_spring"), binput = paste0(basin, "_buf_i"), output = paste0(input, i, "_spring_buf_i"))}
    if(stream_vector){rgrass::execGRASS(cmd = "v.select", flags = c("overwrite", "quiet"), ainput = paste0(input, i, "_stream"), binput = paste0(basin, "_buf_i"), output = paste0(input, i, "_stream_buf_i"))}
    file <- rgrass::stringexecGRASS(paste0("g.list type=vector pattern=", input, i, "_stream_buf_i"), intern = TRUE)
    if(stream_vector & length(file) > 0 ){rgrass::execGRASS(cmd = "v.overlay", flags = c("overwrite", "quiet"), ainput = paste0(input, i, "_stream"), binput = paste0(basin, "_buf_p"), output = paste0(input, i, "_stream_buf_p"), atype  = "line", operator = "and")}

  }

  # patch ----
  rgrass::execGRASS(cmd = "g.region", flags = "a", raster = input)
  rgrass::execGRASS(cmd = "r.mask", flags = "r")

  if(stream_vector){
    files_stream <- paste0(input, unique(basin_total$cat), "_stream")
    rgrass::execGRASS(cmd = "v.patch", flags = c("overwrite", "quiet"), input = paste0(files_stream, collapse = ","), output = paste0(input, output, "_stream"))
  }

  if(spring_vector){
    files_spring <- paste0(input, unique(basin_total$cat), "_spring")
    rgrass::execGRASS(cmd = "v.patch", flags = c("overwrite", "quiet"), input = paste0(files_spring, collapse = ","), output = paste0(input, output, "_spring"))
  }

  if(stream_raster){
    files_stream_binary <- paste0(input, unique(basin_total$cat), "_stream_binary")
    rgrass::execGRASS(cmd = "r.patch", flags = c("overwrite", "quiet"), input = paste0(files_stream_binary, collapse = ","), output = paste0(input, output, "_stream_binary"), nprocs = nprocs, memory = memory)
    rgrass::execGRASS(cmd = "r.colors", flags = "quiet", map = paste0(input, output, "_stream_binary"), color = "viridis")
    files_stream_null <- paste0(input, unique(basin_total$cat), "_stream_null")
    rgrass::execGRASS(cmd = "r.patch", flags = c("overwrite", "quiet"), input = paste0(files_stream_null, collapse = ","), output = paste0(input, output, "_stream_null"), nprocs = nprocs, memory = memory)
  }

  if(spring_raster){
    files_spring_binary <- paste0(input, unique(basin_total$cat), "_spring_binary")
    rgrass::execGRASS(cmd = "r.patch", flags = c("overwrite", "quiet"), input = paste0(files_spring_binary, collapse = ","), output = paste0(input, output, "_spring_binary"), nprocs = nprocs, memory = memory)
    files_spring_null <- paste0(input, unique(basin_total$cat), "_spring_null")
    rgrass::execGRASS(cmd = "r.patch", flags = c("overwrite", "quiet"), input = paste0(files_spring_null, collapse = ","), output = paste0(input, output, "_spring_null"), nprocs = nprocs, memory = memory)
  }

  # clean
  if(delete_vector){
    rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = paste0(files_stream, collapse = ","))
    rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = paste0(files_spring, collapse = ","))
  }

  if(delete_raster){
    rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "raster", name = paste0(files_stream_binary, collapse = ","))
    rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "raster", name = paste0(files_stream_null, collapse = ","))
    rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "raster", name = paste0(files_spring_binary, collapse = ","))
    rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "raster", name = paste0(files_spring_null, collapse = ","))
  }

  rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = paste0(input, unique(basin_total$cat), "_spring_buf_i", collapse = ","))
  rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = paste0(input, unique(basin_total$cat), "_stream_buf_i", collapse = ","))
  rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = paste0(input, unique(basin_total$cat), "_stream_buf_p", collapse = ","))

  rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = "hybas_rc_buf")
  rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = "hybas_rc_buf_i")
  rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = "hybas_rc_buf_p")
  rgrass::execGRASS(cmd = "g.remove", flags = c("b", "f", "quiet"), type = "vector", name = "hybas_rc_sel")
}
