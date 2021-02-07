source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "LOCALIDAD.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

localidades_15r <- map_df(
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

# 16 regiones ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

localidades_16r <- map_df(
  finp_16r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0"),
        comuna  = str_pad(comuna , 5, "left", "0"),
        geocodigo = str_pad(geocodigo, 11, "left", "0")
      )
  }
)

# arreglos ----

# el archivo r08 15r tiene el campo localidad en lugar de loc_zon

d <- localidades_15r %>% 
  filter(is.na(loc_zon))

d %>% filter(region == "08")

localidades_15r <- localidades_15r %>% 
  mutate(loc_zon = ifelse(is.na(loc_zon), localidad, loc_zon)) %>% 
  select(-localidad)

localidades_15r %>% 
  filter(is.na(nom_locali))

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(localidades_15r, "cartografias-fusionadas/localidades_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(localidades_16r, "cartografias-fusionadas/localidades_16r.shp", layer_options = "ENCODING=UTF-8")
