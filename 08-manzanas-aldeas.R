source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "MANZANA_ALDEA.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

# como solo el archivo r08 15r trae la region, la tomo del nombre del archivo

manzanas_aldeas_15r <- map_df(
  finp_15r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0"),
        comuna  = str_pad(comuna , 5, "left", "0")
      )
  }
)

# 16 regiones ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

manzanas_aldeas_16r <- map_df(
  finp_16r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0"),
        comuna  = str_pad(comuna , 5, "left", "0")
      )
  }
)

# arreglos ----

# el archivo r08 15r tiene el campo nombre_ald en lugar de nom_aldea

manzanas_aldeas_15r <- manzanas_aldeas_15r %>% 
  mutate(nom_aldea  = ifelse(is.na(nom_aldea), nombre_ald, nom_aldea)) %>% 
  select(-nombre_ald)

manzanas_aldeas_15r %>% 
  filter(is.na(nom_aldea))

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(manzanas_aldeas_15r, "cartografias-fusionadas/manzanas_aldeas_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(manzanas_aldeas_16r, "cartografias-fusionadas/manzanas_aldeas_16r.shp", layer_options = "ENCODING=UTF-8")
