source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "LIM_DPA.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

# como solo el archivo r08 15r trae la region, la tomo del nombre del archivo

limites_dpa_15r <- map_df(
  finp_15r,
  function(f) {
    r <- gsub("cartografias-originales/r", "", f)
    r <- gsub("/.*|-15r", "", r)
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(region = r)
  }
)

limites_dpa_15r <- limites_dpa_15r %>% 
  select(-nom_region) %>% 
  select(region, everything())

# 16 regiones ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

limites_dpa_16r <- map_df(
  finp_16r,
  function(f) {
    r <- gsub("cartografias-originales/r", "", f)
    r <- gsub("/.*|-15r", "", r)
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(region = r) %>% 
      select(region, everything())
  }
)

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(limites_dpa_15r, "cartografias-fusionadas/limites_divisiones_politicas_y_administrativas_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(limites_dpa_16r, "cartografias-fusionadas/limites_divisiones_politicas_y_administrativas_16r.shp", layer_options = "ENCODING=UTF-8")
