library(shiny)
library(DT)
library(magrittr)
library(leaflet)

source("sheet.R")
curated <- curated


ui <- navbarPage("Rainbow Pages Cape Town",
                 tabPanel("Welcome!"),
                 tabPanel("Businesses", DT::dataTableOutput("busi")),
                 tabPanel("Organisations", DT::dataTableOutput("orgs")),
                 tabPanel("Individuals", DT::dataTableOutput("indiv")), 
                 tabPanel("Map", leafletOutput("map")), 
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
        leaflet()
        })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
