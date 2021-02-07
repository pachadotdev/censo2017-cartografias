source("00-paquetes.r")

finp <- list.files("cartografias-originales", recursive = T, full.names = T, pattern = "PROVINCIA.*shp$")

# 15 regiones ----

finp_15r <- grep("/r08/|/r16/", finp, value = T, invert = T)

# como solo el archivo r08 15r trae la region, la tomo del nombre del archivo

provincias_15r <- map_df(
  finp_15r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0")
      )
  }
)

# 16 regiones ----

finp_16r <- grep("/r08-15r/", finp, value = T, invert = T)

provincias_16r <- map_df(
  finp_16r,
  function(f) {
    d <- read_sf(f, as_tibble = T) %>% 
      clean_names() %>% 
      mutate(
        region = str_pad(region, 2, "left", "0"),
        provincia  = str_pad(provincia , 3, "left", "0")
      )
  }
)

# arreglos ----

# el archivo r08 r15 trae algunos campos adicionales, busco los equivalentes en los demas archivos

colnames(provincias_15r)[!colnames(provincias_15r) %in% colnames(provincias_16r)]

unique(provincias_15r$nom_reg)
unique(provincias_15r$nom_prov)

d <- provincias_15r %>% 
  filter(!is.na(nom_reg))

unique(d$region)

provincias_15r <- provincias_15r %>% 
  mutate(
    nom_region = ifelse(is.na(nom_region), nom_reg, nom_region),
    nom_provin = ifelse(is.na(nom_provin), nom_prov, nom_provin)
  ) %>% 
  select(-c(nom_reg, nom_prov))

# exportar ----

# las opciones evitan el warning
# GDAL Message 1: One or several characters couldn't be converted correctly from UTF-8 to ISO-8859-1.  This warning will not be emitted anymore.
write_sf(provincias_15r, "cartografias-fusionadas/provincias_15r.shp", layer_options = "ENCODING=UTF-8")
write_sf(provincias_16r, "cartografias-fusionadas/provincias_16r.shp", layer_options = "ENCODING=UTF-8")
