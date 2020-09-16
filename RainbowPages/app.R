library(shiny)
library(DT)
library(magrittr)
library(leaflet)
library(here)

source("sheet.R")
source("data_manip.R")
curated <- curated


ui <- navbarPage("Rainbow Pages Cape Town",
                 tabPanel("Welcome!"),
                 tabPanel("Businesses", DT::dataTableOutput("busi")),
                 tabPanel("Organisations", DT::dataTableOutput("orgs")),
                 tabPanel("Individuals", DT::dataTableOutput("indiv")), 
                 tabPanel("Map", 
                          tags$head(
                            tags$style(HTML("
                              #controls {
                                background-color: white;
                                padding: 0 20px 20px 20px;
                                opacity: 0.5};")
                            )),
                          
                          leafletOutput("map", height = 800),
                          
                          absolutePanel(id = "controls", fixed = TRUE,
                                        draggable = TRUE, top = 100, left = "auto", right = 40, bottom = "auto",
                                        width = 230, height = "auto",
                                        style = "opacity: 0.8",
                                        
                                        checkboxGroupInput("category", 
                                                           h3("Layers"), 
                                                           choiceNames = list("Arts & Entertainment", 
                                                                              "Health", 
                                                                              "Fashion & Beauty",
                                                                              "Information Technology"),
                                                           choiceValues = list("Arts & Entertainment", 
                                                                               "Health", 
                                                                               "Fashion & Beauty",
                                                                               "Information Technology"),
                                                           selected = "Arts & Entertainment")
                          )), 
                 tabPanel("Network"), 
                 tabPanel("Resources"),
                 tabPanel("Support"),
                 tabPanel("Suggestions"),
                 fluid=T
)
    
  


server <- function(input, output) {
    output$busi <- DT::renderDataTable({
        datatable(busi, 
                  options=list(columnDefs = list(list(visible=FALSE, targets=c(6,10))), pageLength = 1000)
                  ) %>%
        formatStyle('colours',
                    target = 'row',
                    backgroundColor = styleEqual(c(1:8), hex)) 
        })
    output$orgs <- DT::renderDataTable({
         datatable(orgs, 
                   options=list(columnDefs = list(list(visible=FALSE, targets=c(6,10))), pageLength = 1000)) %>%
            formatStyle('colours',
                        target = 'row',
                        backgroundColor = styleEqual(c(1:8), hex)) 
        })
    output$indiv <- DT::renderDataTable({
        datatable(indiv, 
                  options=list(columnDefs = list(list(visible=FALSE, targets=c(6,9))), pageLength = 1000)) %>%
            formatStyle('colours',
                        target = 'row',
                        backgroundColor = styleEqual(c(1:8), hex)) 
        })
    
    map_filtered <- reactive({
      
      map <- leaflet() %>% 
        addTiles() %>%
        #addProviderTiles(providers$Stamen.Watercolor) %>% 
        setView(lng = 18.5, lat = -33.9, zoom = 10)
      
      marker_data <- markers %>%
        filter(layer %in% input$category)
      
      rainbow_icons <- icons(
        iconUrl = case_when(
          marker_data$layer == "Arts & Entertainment" ~ here("icons/nightlife.png"),
          marker_data$layer == "Community" ~ here("icons/community.png"),
          marker_data$layer == "Information Technology" ~ here("icons/computers.png"),
          marker_data$layer == "Food" ~ here("icons/food.png"),
          marker_data$layer == "Health" ~ here("icons/health-medical.png"),
          marker_data$layer == "Fashion & Beauty" ~ here("icons/fashion.png"),
          marker_data$layer == "Financial Services" ~ here("icons/finance.png")
        ),
        iconWidth = 26.4, iconHeight = 35.2,
        iconAnchorX = 13.2, iconAnchorY = 35
      )
      
      map <- map %>%
        addMarkers(
          data = marker_data,
          lng = ~lon,
          lat = ~lat,
          icon = rainbow_icons,
          popup = ~as.character(label),
          clusterOptions = markerClusterOptions()
        )
    })
    
    output$map <- renderLeaflet({map_filtered()})
    
}

# Run the application 
shinyApp(ui = ui, server = server)
