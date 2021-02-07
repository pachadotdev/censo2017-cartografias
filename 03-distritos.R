source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "DISTRITO.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

distritos_15r <- map_df(
  finp_15r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        comuna = as.character(comuna),
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0"),
        comuna  = str_pad(comuna , 5, "left", "0")
      )
  }
)

# 16 regiones ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

distritos_16r <- map_df(
  finp_16r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        comuna = as.character(comuna),
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0"),
        comuna  = str_pad(comuna , 5, "left", "0")
      )
  }
)

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(distritos_15r, "cartografias-fusionadas/distritos_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(distritos_16r, "cartografias-fusionadas/distritos_16r.shp", layer_options = "ENCODING=UTF-8")
