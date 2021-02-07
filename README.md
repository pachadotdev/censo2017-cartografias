# Cartografías CENSO 2017

## Descripción

Este repositorio contiene la totalidad de las cartografías del CENSO 2017 (INE) de Chile. Estas cartografías se generaron con el paquete sf en R, pero *se pueden usar con QGIS o cualquier software compatible con el formato shp.*

Estas cartografías no se han simplicado, a diferencia del paquete R [chilemapas](https://github.com/pachamaltese/chilemapas) y se pueden descargar en un único enlace en la pestaña *Releases* en el [repositorio](https://github.com/pachamaltese/cartografias-censo2017) o en [este enlace](https://github.com/pachamaltese/cartografias-censo2017/releases/download/v0.4/cartografias-censo2017.zip).

Cartografías incluídas (15 y 16 regiones):

- [x] Calles
- [x] Comunas
- [x] Distritos
- [x] Entidades
- [x] Límites Divisiones Políticas y Administrativas
- [x] Límites Urbanos
- [x] Localidades
- [x] Manzanas Aldeas
- [x] Manzanas Indeterminadas
- [x] Manzanas Sin Información
- [x] Provincias
- [x] Regiones

Cambios a los archivos originales:

- En todas las cartografías que contienen region/provincia/comuna se agregaron ceros al comienzo para esto campos tengan el mismo ancho (e.g. regiones "01", ..., "16" y no 1, ..., 16)
- En las siguientes cartografías se armonizaron los nombres de las columnas en el archivo de 15 regiones debido a diferencias entre los archivos con 16 regiones y el archivo de la Octava Región que incluye la provincia de Ñuble:
  - Distrito
  - Límites DPA
  - Límites Urbanos
  - Localidades
  - Manzanas Aldeas
  - Manzanas Indeterminadas
  - Manzanas Sin Información
  - Provincias
  - Zonas
  
Todo el código para efectuar los cambios está en este repositorio.

## Condiciones de uso

Estos mapas no tienen precisión geodésica, por lo que aplica DFL-83 de 1979 de la República de Chile y se consideran referenciales sin validez legal. No se incluyen los territorios antárticos y bajo ningún evento estos mapas significan que exista una cesión u ocupación de territorios soberanos en contra del Derecho Internacional por parte de Chile.

**Los archivos se han liberado con licencia Creative Commons CC0 1.0 Universal.**
