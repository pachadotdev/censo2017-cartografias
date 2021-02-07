source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "MANZANA_SIN_INF.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

# como solo el archivo r08 15r trae la region, la tomo del nombre del archivo

manzanas_sin_informacion_15r <- map_df(
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

manzanas_sin_informacion_16r <- map_df(
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

# el archivo r08 r15 trae algunos campos adicionales, busco los equivalentes en los demas archivos

colnames(manzanas_sin_informacion_15r)[!colnames(manzanas_sin_informacion_15r) %in% colnames(manzanas_sin_informacion_16r)]

unique(manzanas_sin_informacion_15r$localidad)
unique(manzanas_sin_informacion_15r$entidad_ma)

d <- manzanas_sin_informacion_15r %>% 
  filter(!is.na(localidad))

unique(d$region)

manzanas_sin_informacion_15r <- manzanas_sin_informacion_15r %>% 
  mutate(
    loc_zon = ifelse(is.na(loc_zon), localidad, loc_zon),
    ent_man = ifelse(is.na(ent_man), entidad_ma, ent_man)
  ) %>% 
  select(-c(localidad, entidad_ma))

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(manzanas_sin_informacion_15r, "cartografias-fusionadas/manzanas_sin_informacion_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(manzanas_sin_informacion_16r, "cartografias-fusionadas/manzanas_sin_informacion_16r.shp", layer_options = "ENCODING=UTF-8")
