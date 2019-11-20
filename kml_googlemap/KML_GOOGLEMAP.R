#=================================================================
#                                             Rafael Tieppo
#                                             tiepporc@unemat.br
#                                             09-07-2015
# Function to read/convert  KML files to Data Frame
#=================================================================

library(ggplot2)
library(gridExtra)
library(maptools)
library(maps)
library(spdep)
library(ggthemes)
library(rgdal)
library(XML)
library(sp)
library(ggmap)

# Obter o KML file do google maps
# acessar https://www.google.com/maps/d/u/0/

# Para trabalhar com KML:
# http://max2.ese.u-psud.fr/epc/conservation/Girondot/Publications/Blog_r/Entrees/2013/5/18_Read_z_coordinates_of_kml_file_for_lines.html

#============================================================
#Funcao para montar data frame do arquivo KML
#============================================================

KML_GOOGLEMAP <- function (KML_file, DAY)
    {
#lendo KML
XML_LIST <- xmlToList(KML_file)
#XML_LIST <- xmlToList(xmlParse("ZURI_RAPPERS.kml"))

head(XML_LIST)
COORDS <- (XML_LIST[1]$Document$Placemark$LineString$coordinates)

#elimina todas as quebras(\n) e tabs(\t)
COORDS <- gsub("[\n\t]", "", COORDS)
#inserir quebras
COORDS <- gsub(" ", "\n", COORDS)

COORDS <- read.delim(text=COORDS, sep=",", header=FALSE, col.names =
                      c('LONG', 'LAT', 'ALT'))

COORDS_GEOG <- SpatialPoints(COORDS, proj4string=CRS("+proj=longlat +datum=WGS84"))
COORDS_UTM <- (spTransform(COORDS_GEOG,CRS("+proj=utm +zone=32")))
COORDS_GEOG <- data.frame(x = COORDS$LONG, y = COORDS_GEOG$LAT, id = rep(DAY, length(COORDS_GEOG$LONG)))
COORDS_UTM <- data.frame(x = COORDS_UTM$LONG, y = COORDS_UTM$LAT, id = rep(DAY, length(COORDS_UTM$LONG)))


DIST <- matrix(sapply(seq(1:(nrow(COORDS_UTM)-1)), function(M)
       sqrt((COORDS_UTM[M + 1, 1] - COORDS_UTM[M, 1])^2 +
        (COORDS_UTM[M + 1, 2] - COORDS_UTM[M, 2])^2)
       ))

DIST_ACUM <- matrix(sapply(seq(1:(nrow(DIST))), function(M)
       sum(DIST[c(1:M),1])))

COORDS_UTM_frame <- data.frame(COORDS_UTM,
                               DIST = c(0, DIST),
                               DIST_ACUM = c(0, DIST_ACUM))

COORDS_GEOG_frame <- data.frame(COORDS_GEOG,
                               DIST = c(0, DIST),
                               DIST_ACUM = c(0, DIST_ACUM))

return(COORDS_GEOG_frame)
   }


## How to buid the map

DAY2_FRAME <- KML_GOOGLEMAP("RAPPER_SARG.kml", 2)

LOCATION_D2 <- get_map(location = c(lon = median(DAY2_FRAME$x),
                                    lat = median(DAY2_FRAME$y)),
                     source = 'google', zoom = 11, maptype = 'roadmap')
D2_MAP <- ggmap(LOCATION_D2, extent = 'device')
plot(D2_MAP)

ggsave("DAY2.jpg", 
       D2_MAP +
   geom_path(data = DAY2_FRAME, aes(x = x, y = y, colour = as.factor(id)),
              size = 1.3) +
    scale_colour_manual(breaks = c("1"), values = c('blue'), labels = c('Dia 1')) +
    guides(colour = guide_legend(title = NULL))  ,
       width = 14, height = 11, units = 'cm', dpi = 300)

