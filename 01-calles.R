source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "CALLES.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

calles_15r <- map_df(
  finp_15r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        comuna = as.character(comuna),
        region = str_pad(region, 2, "left", "0"),
        clase_urba = ifelse(clase_urba == "N/A", NA, clase_urba)
      )
  }
)

# aparece la columna shape_le_1 que parte con NA, puede ser por el archivo del mapa de 15 regiones
regiones <- unique(calles_15r$region)

d <- map(
  regiones,
  function(r) {
    d <- calles_15r %>% 
      filter(region == r)
    
    unique(d$shape_le_1)
  }
)

map_dbl(seq_along(d), function(i) length(d[[i]]))

# shape_le_1 tiene contenido para las regiones 10 a 12

# veamos el detalle...
calles_r1012 <- calles_15r %>% 
  filter(region %in% 10:12) %>% 
  mutate(diferencia_len = shape_leng - shape_le_1)

calles_r1012 %>% filter(diferencia_len > 10e-5)

# son iguales, se saca la columna
calles_15r <- calles_15r %>% select(-shape_le_1)

# 16 regiones ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

calles_16r <- map_df(
  finp_16r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        comuna = as.character(comuna),
        region = str_pad(region, 2, "left", "0"),
        clase_urba = ifelse(clase_urba == "N/A", NA, clase_urba)
      )
  }
)

calles_16r <- calles_16r %>% select(-shape_le_1)

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(calles_15r, "cartografias-fusionadas/calles_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(calles_16r, "cartografias-fusionadas/calles_16r.shp", layer_options = "ENCODING=UTF-8")
