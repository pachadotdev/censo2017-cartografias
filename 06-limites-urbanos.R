source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "LIMITE_URBANO.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

limites_urbanos_15r <- map_df(
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

limites_urbanos_16r <- map_df(
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

# el archivo r08 15r tiene el campo categoria en lugar de nom_categ

sort(colnames(limites_urbanos_16r))
sort(colnames(limites_urbanos_15r))

colnames(limites_urbanos_15r)[!colnames(limites_urbanos_15r) %in% colnames(limites_urbanos_16r)]

limites_urbanos_15r <- limites_urbanos_15r %>% 
  select(-codigo_cat)

d <- limites_urbanos_15r %>% 
  filter(!is.na(categoria))

unique(d$region)
unique(d$categoria)
unique(d$nom_categ)

limites_urbanos_15r <- limites_urbanos_15r %>% 
  mutate(nom_categ = ifelse(is.na(nom_categ), categoria, nom_categ)) %>% 
  select(-categoria)

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(limites_urbanos_15r, "cartografias-fusionadas/limites_urbanos_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(limites_urbanos_16r, "cartografias-fusionadas/limites_urbanos_16r.shp", layer_options = "ENCODING=UTF-8")
