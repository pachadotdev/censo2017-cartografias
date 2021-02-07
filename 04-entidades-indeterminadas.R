source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "ENTIDAD.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

entidades_indeterminadas_15r <- map_df(
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

entidades_indeterminadas_16r <- map_df(
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

# arreglos ----

# el archivo r08 r15 trae algunos campos adicionales, busco los equivalentes en los demas archivos

colnames(entidades_indeterminadas_15r)[!colnames(entidades_indeterminadas_15r) %in% colnames(entidades_indeterminadas_16r)]

entidades_indeterminadas_15r %>% 
  filter(region != "08") %>% 
  select(-c(localidad, nom_locali, entidad, nom_entida))

entidades_indeterminadas_15r %>% 
  filter(region == "08") %>% 
  select(localidad, nom_locali, entidad, nom_entida)

r01_r15 <- read_sf(finp[1], as_tibble = T) %>% clean_names()
r08_r15 <- read_sf(finp[8], as_tibble = T) %>% clean_names()

colnames(r08_r15)[!colnames(r08_r15) %in% colnames(r01_r15)]
colnames(r08_r15)[colnames(r08_r15) %in% colnames(r01_r15)]

entidades_indeterminadas_15r %>% 
  select(region, loc_zon, localidad) %>% 
  filter(!is.na(localidad)) %>% 
  distinct(region)

entidades_indeterminadas_15r <- entidades_indeterminadas_15r %>% 
  mutate(
    loc_zon = ifelse(is.na(loc_zon), localidad, loc_zon),
    ent_man = ifelse(is.na(ent_man), entidad, ent_man)
  ) %>% 
  select(-c(nom_locali, nom_entida, localidad, entidad))

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(entidades_indeterminadas_15r, "cartografias-fusionadas/entidades_indeterminadas_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(entidades_indeterminadas_16r, "cartografias-fusionadas/entidades_indeterminadas_16r.shp", layer_options = "ENCODING=UTF-8")
