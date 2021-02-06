# packages ----

library(DBI)
library(RSQLite)
library(dplyr)
library(sf)

# connections ----

con <- dbConnect(SQLite(), "data-raw/censo2017.sqlite")
tablas <- dbListTables(con)
tablas_mapas <- grep("mapa", tablas, value = T, invert = F)
dbDisconnect(con)

# export SHP ----

for (t in tablas_mapas) {
  message(t)
  
  con <- dbConnect(SQLite(), "data-raw/censo2017.sqlite")
  d <- st_read(con, t)
  dbDisconnect(con)
  
  st_write(d, paste0("data-raw/files-for-user-db/", t, ".shp"))
  gc()
  rm(d)
}

# test ----

for (t in tablas_mapas) {
  message(t)
  
  con <- dbConnect(SQLite(), "data-raw/censo2017.sqlite")
  d <- st_read(con, t)
  d <- c(nrow(d), ncol(d))
  dbDisconnect(con)
  
  d2 <- st_read(paste0("data-raw/", t, ".shp"))
  d2 <- c(nrow(d2), ncol(d2))
  
  stopifnot(d[1] == d2[1])
  stopifnot(d[2] == d2[2])
  
  message(paste(paste0("r", d[1], " c", d[2]), "vs", paste0("r", d2[1], " c", d2[2])))
}
