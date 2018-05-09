## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE----------------------------------------------------------
#  # for stable version
#  install.packages("CDECRetrieve")
#  
#  # for development version
#  devtools::install_github("flowwest/CDECRetrieve")

## ------------------------------------------------------------------------
library(CDECRetrieve)

cdec_stations(station_id = "kwk") # return metadata for KWK

# show all locations near san francisco, this returns a set of 
# CDEC station that are near San Francisco
cdec_stations(nearby_city = "san francisco")

# show all location in the sf bay river basin
cdec_stations(river_basin = "sf bay")

# show all station in Tehama county
cdec_stations(county = "tehama")


## ------------------------------------------------------------------------
library(magrittr)
library(leaflet)

cdec_stations(county = "tehama") %>% 
  map_stations()

