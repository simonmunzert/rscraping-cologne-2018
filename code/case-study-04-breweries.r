### -----------------------------
### simon munzert
### intro to web scraping with R
### -----------------------------

## preparations -----------------------
source("packages.r")


## case study: mapping breweries in Germany -------

##  goal
# get list of breweries in Germany
# import list in R
# geolocate breweries
# put them on a map

# set temporary working directory
tempwd <- ("../data/breweriesGermany")
dir.create(tempwd)
setwd(tempwd)

## step 1: fetch list of cities with breweries
url <- "http://www.biermap24.de/brauereiliste.php"
content <- read_html(url)
anchors <- html_nodes(content, xpath = "//tr/td[2]")
cities <- html_text(anchors)
cities
cities <- str_trim(cities)
cities <- cities[str_detect(cities, "^[[:upper:]]+.")]
cities <- cities[6:length(cities)]
length(cities)
length(unique(cities))
sort(table(cities))


## step 2: geocode cities

# geocoding takes a while -> save results in local cache file
# 2500 requests allowed per day
if ( !file.exists("breweries_geo.RData")){
  pos <- geocode(cities)
  geocodeQueryCheck()
  save(pos, file="breweries_geo.RData")
} else {
  load("breweries_geo.RData")
}
head(pos)

## step 3: plot breweries of Germany
brewery_map <- get_map(location=c(lon = mean(c(min(pos$lon), max(pos$lon))), lat = mean(c(min(pos$lat), max(pos$lat)))), zoom=6, maptype="terrain", source = "stamen")
get_openstreetmap()
p <- ggmap(brewery_map) + geom_point(data=pos, aes(x=lon, y=lat), col="red", size=.8)
p


# Alternative package based on OpenStreetMap data to geolocate observations
devtools::install_github("hrbrmstr/nominatim")
library(nominatim)
# get fre API key at browseURL("https://developer.mapquest.com/")
load("/Users/simonmunzert/rkeys.RDa")
b1 <- osm_geocode("Germany", key = openstreetmap)
b1[c("lat", "lon")]

# add background raster graphic
library(OpenStreetMap)
library(rgdal)
map <- openmap(upperLeft = c(55.5, 5), lowerRight = c(46, 16), type = "osm")

pos_mercator <- projectMercator(pos$lat, pos$lon) %>% as.data.frame
autoplot(map) + geom_point(aes(x, y), data=pos_mercator, size = .5, color = "red")



## return to base working drive
setwd("../../code")

