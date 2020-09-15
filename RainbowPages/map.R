## TO DO: 
# All marker categories must have at least 2 points on map
# Icons must be a list of lists that can be referenced in the addMarkers() call
# Create function for the add markers call

library(leaflet)
library(here)

# Create icons for markers
arts_icon <- makeIcon(iconUrl = here("icons/nightlife.png"),
                      iconWidth = 26.4, iconHeight = 35.2,
                      iconAnchorX = 13.2, iconAnchorY = 35)

health_icon <- makeIcon(iconUrl = here("icons/health-medical.png"),
                      iconWidth = 26.4, iconHeight = 35.2,
                      iconAnchorX = 13.2, iconAnchorY = 35)

fashion_icon <- makeIcon(iconUrl = here("icons/fashion.png"),
                        iconWidth = 26.4, iconHeight = 35.2,
                        iconAnchorX = 13.2, iconAnchorY = 35)

tech_icon <- makeIcon(iconUrl = here("icons/computers.png"),
                        iconWidth = 26.4, iconHeight = 35.2,
                        iconAnchorX = 13.2, iconAnchorY = 35)

food_icon <- makeIcon(iconUrl = here("icons/food.png"),
                        iconWidth = 26.4, iconHeight = 35.2,
                        iconAnchorX = 13.2, iconAnchorY = 35)

community_icon <- makeIcon(iconUrl = here("icons/community.png"),
                        iconWidth = 26.4, iconHeight = 35.2,
                        iconAnchorX = 13.2, iconAnchorY = 35)

finance_icon <- makeIcon(iconUrl = here("icons/finance.png"),
                        iconWidth = 26.4, iconHeight = 35.2,
                        iconAnchorX = 13.2, iconAnchorY = 35)

# Create map and set initial view
map <- leaflet() %>% 
  addTiles() %>% 
  setView(lng = 18.495678, lat = -33.939157, zoom = 12) 

# Add markers to map
map <- map %>%
  addMarkers(
    data = markers[markers$layer == "Arts & Entertainment", ],
    lng = ~lon,
    lat = ~lat,
    group = "Arts & Entertainment",
    icon = arts_icon,
    popup = ~as.character(label),
    clusterOptions = markerClusterOptions()
  ) %>%
  addMarkers(
    data = markers[markers$layer == "Health", ],
    lng = ~lon,
    lat = ~lat,
    group = "Health",
    icon = health_icon,
    popup = ~as.character(label),
    clusterOptions = markerClusterOptions()
  ) %>%
  addMarkers(
    data = markers[markers$layer == "Fashion & Beauty", ],
    lng = ~lon,
    lat = ~lat,
    group = "Fashion & Beauty",
    icon = fashion_icon,
    popup = ~as.character(label),
    clusterOptions = markerClusterOptions()
  ) %>%
  addMarkers(
    data = markers[markers$layer == "Information Technology", ],
    lng = ~lon,
    lat = ~lat,
    group = "Information Technology",
    icon = tech_icon,
    popup = ~as.character(label),
    clusterOptions = markerClusterOptions()
  ) %>%
  addMarkers(
    data = markers[markers$layer == "Finance", ],
    lng = ~lon,
    lat = ~lat,
    group = "Finance",
    icon = finance_icon,
    popup = ~as.character(label),
    clusterOptions = markerClusterOptions()
  ) %>%
  addMarkers(
    data = markers[markers$layer == "Community", ],
    lng = ~lon,
    lat = ~lat,
    group = "Community",
    icon = community_icon,
    popup = ~as.character(label),
    clusterOptions = markerClusterOptions()
  ) %>%
  addMarkers(
    data = markers[markers$layer == "Food", ],
    lng = ~lon,
    lat = ~lat,
    group = "Food",
    icon = food_icon,
    popup = ~as.character(label),
    clusterOptions = markerClusterOptions()
  ) 

# Add layers control
map <- map %>%
  addLayersControl(
    overlayGroups = markers$layer,
    options = layersControlOptions(collapsed = FALSE)
  ) 

map

# rainbow_icons <- icons(
#   iconUrl = case_when(
#     markers$layer == "Arts & Entertainment" ~ here("icons/nightlife.png"),
#     markers$layer == "Community" ~ here("icons/community.png"),
#     markers$layer == "Information Technology" ~ here("icons/computers.png"),
#     markers$layer == "Food" ~ here("icons/food.png"),
#     markers$layer == "Health" ~ here("icons/health-medical.png"),
#     markers$layer == "Fashion & Beauty" ~ here("icons/fashion.png"),
#     markers$layer == "Financial Services" ~ here("icons/finance.png")
#   ),
#   iconWidth = 26.4, iconHeight = 35.2,
#   iconAnchorX = 13.2, iconAnchorY = 35
# )

# markers.df <- split(markers, markers$layer)
# 
# names(markers.df) %>%
#   purrr::walk( function(df) {
#     map <<- map %>%
#       addMarkers(data = markers.df[[df]],
#                  lng = ~lon,
#                  lat = ~lat,
#                  icon = rainbow_icons,
#                  popup = ~as.character(label),
#                  group = df,
#                  clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F)
#                  )
#   })
