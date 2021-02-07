source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "ZONA.*shp$")

# 15 zonas ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

# como solo el archivo r08 15r trae la region, la tomo del nombre del archivo

zonas_15r <- map_df(
  finp_15r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        geocodigo = as.character(geocodigo),
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0"),
        comuna  = str_pad(comuna , 5, "left", "0"),
        geocodigo = str_pad(geocodigo, 11, "left", "0")
      )
  }
)

# 16 zonas ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

zonas_16r <- map_df(
  finp_16r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        geocodigo = as.character(geocodigo),
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0"),
        comuna  = str_pad(comuna , 5, "left", "0"),
        geocodigo = str_pad(geocodigo, 11, "left", "0")
      )
  }
)

# arreglos ----

# el archivo r08 15r tiene el campo zona en lugar de loc_zon

d <- zonas_15r %>% 
  filter(!is.na(zona))

unique(d$region)

zonas_15r <- zonas_15r %>% 
  mutate(loc_zon = ifelse(is.na(loc_zon), zona, loc_zon)) %>% 
  select(-zona)

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(zonas_15r, "cartografias-fusionadas/zonas_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(zonas_16r, "cartografias-fusionadas/zonas_16r.shp", layer_options = "ENCODING=UTF-8")
