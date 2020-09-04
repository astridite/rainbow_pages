library(shiny)
library(DT)
library(magrittr)
library(leaflet)

source("sheet.R")
source("data_manip.R")
curated <- curated


ui <- navbarPage("Rainbow Pages Cape Town",
                 tabPanel("Welcome!"),
                 tabPanel("Businesses", DT::dataTableOutput("busi")),
                 tabPanel("Organisations", DT::dataTableOutput("orgs")),
                 tabPanel("Individuals", DT::dataTableOutput("indiv")), 
                 tabPanel("Map", 
                          tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                          leafletOutput("map")), 
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
    output$map <- renderLeaflet({
        leaflet(data = markers) %>%
        addTiles() %>%
        setView(lng = 18.495678, lat = -33.939157, zoom = 12) %>%
        addMarkers(lng = ~lon, lat = ~lat, popup = ~as.character(label), clusterOptions = markerClusterOptions())
        })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
