lsm_hidrography <- function(input,
                            output = NULL,
                            threshold = 100,
                            stream_raster = FALSE,
                            stream_vector = FALSE,
                            spring_raster = FALSE,
                            spring_vector = FALSE,
                            memory = 300){
    
    # watershed
    rgrass::execGRASS(cmd = "r.watershed",
                      flags = c("m", c("overwrite", "quiet")),
                      elevation = input,
                      threshold = threshold,
                      accumulation = paste0(input, output, "_accumulation"),
                      memory = memory)
    
    # stream
    rgrass::execGRASS(cmd = "r.stream.extract",
                      flags = c("overwrite", "quiet"),
                      elevation = input,
                      accumulation = paste0(input, output, "_accumulation"),
                      stream_raster = paste0(input, output, "_stream"),
                      stream_vector = paste0(input, output, "_stream_spring"),
                      threshold = threshold)
    
    # extract stream and spring
    if(stream_vector == TRUE){
        rgrass::execGRASS(cmd = "v.extract",
                          flags = c("overwrite", "quiet"),
                          input = paste0(input, output, "_stream_spring"),
                          type = "line",
                          output = paste0(input, output, "_stream"))
    }
    
    if(spring_vector == TRUE){
        rgrass::execGRASS(cmd = "v.extract",
                          flags = c("overwrite", "quiet"),
                          input = paste0(input, output, "_stream_spring"),
                          type = "point",
                          where = "(type_code = '0')",
                          output = paste0(input, output, "_spring"))
    }
    
    # rasterize stream and spring
    if(stream_vector == TRUE & stream_raster == TRUE){
        rgrass::execGRASS(cmd = "v.to.rast",
                          flags = c("overwrite", "quiet"),
                          input = paste0(input, output, "_stream"),
                          output = paste0(input, output, "_stream_null"),
                          use = "val")
        rgrass::execGRASS(cmd = "r.mapcalc", flags = "overwrite", expression = paste0(input, output, "_stream_binary=if(isnull(", input, output, "_stream_null), 0, 1)"))
    }
    
    if(spring_vector == TRUE & spring_raster == TRUE){
        rgrass::execGRASS(cmd = "v.to.rast",
                          flags = c("overwrite", "quiet"),
                          input = paste0(input, output, "_spring"),
                          output = paste0(input, output, "_spring_null"),
                          use = "val")
        rgrass::execGRASS(cmd = "r.mapcalc", flags = "overwrite", expression = paste0(input, output, "_spring_binary=if(isnull(", input, output, "_spring_null), 0, 1)"))
    }
    
    # clean
    rgrass::execGRASS(cmd = "g.remove", flags = c("f", "quiet"), type = "raster", name = paste0(input, output, "_accumulation"))
    rgrass::execGRASS(cmd = "g.remove", flags = c("f", "quiet"), type = "raster", name = paste0(input, output, "_stream"))
    rgrass::execGRASS(cmd = "g.remove", flags = c("f", "quiet"), type = "vector", name = paste0(input, output, "_stream_spring"))
    
}
