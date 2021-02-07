source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "REGION.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

# como solo el archivo r08 15r trae la region, la tomo del nombre del archivo

regiones_15r <- map_df(
  finp_15r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        region = str_pad(region, 2, "left", "0")
      )
  }
)

# 16 regiones ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

regiones_16r <- map_df(
  finp_16r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        region = str_pad(region, 2, "left", "0")
      )
  }
)

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(regiones_15r, "cartografias-fusionadas/regiones_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(regiones_16r, "cartografias-fusionadas/regiones_16r.shp", layer_options = "ENCODING=UTF-8")
