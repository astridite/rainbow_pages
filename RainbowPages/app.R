library(shiny)
library(shinythemes)
library(DT)
library(magrittr)
library(leaflet)
source("sheet.R")
source("data_manip.R")

ui <-  fluidPage(theme=shinytheme("yeti"),
  navbarPage("Rainbow Pages Cape Town",
                 tabPanel("Welcome!", icon=icon("heart"),
                          fluidPage(
                            fluidRow(column(
                              tags$h2(welcome_text), width = 12)),
                            fluidRow(column(
                              tags$br(),
                              tags$br(),
                              tags$p(welcome_para1, align="justify"),
                              tags$p(welcome_para2, align="justify"),
                              width=6, offset=6)))), 
                 tabPanel("Businesses", icon=icon("briefcase"), 
                          fluidPage(
                            fluidRow(column(tags$img(src='www/banner.jpg'), width=12),
                                     column(tags$p(sample_text), width=12),
                                     column(DT::dataTableOutput(outputId = "busi"), width=12)))),
                 tabPanel("Organisations", icon=icon("hands-helping"), DT::dataTableOutput("orgs")),
                 tabPanel("Individuals",  icon=icon("address-book"), DT::dataTableOutput("indiv")), 
                 tabPanel("Map", icon=icon("map-marked-alt"), 
                          tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                          leafletOutput("map")), 
                 tabPanel("Network", icon=icon("draw-polygon")),
                 tabPanel("Resources", icon=icon("info-circle")),
                 tabPanel("Support", icon=icon("hand-holding-usd")),
                 tabPanel("Suggestions", icon=icon("envelope-open-text")))
    
  
)

server <- function(input, output) {
    output$busi <- DT::renderDataTable({
      datatable(busi,
                filter="top",
                options=list(
                  sDom  = '<"top">flrt<"bottom">ip',
                  columnDefs = list(list(visible=FALSE, targets=c(2,6,10))),
                  pageLength = 1000,
                  scrollX=T, 
                  headerCallback = DT::JS(
                    "function(thead) {",
                    "  $(thead).css('font-size', '1em');",
                    "}") ))%>% 
        formatStyle('colours', target = 'row', backgroundColor = styleEqual(c(1:8), hex),
                    fontSize = '90%')})
    output$orgs <- DT::renderDataTable({
         datatable(orgs, 
                   filter="top",
                   options=list(
                     columnDefs = list(list(visible=FALSE, targets=c(2,6,10))),
                     pageLength = 1000,
                     scrollX=T, 
                     headerCallback = DT::JS(
                       "function(thead) {",
                       "  $(thead).css('font-size', '1em');",
                       "}") ))%>% 
        formatStyle('colours', target = 'row', backgroundColor = styleEqual(c(1:8), hex),
                    fontSize = '90%') 
        })
    output$indiv <- DT::renderDataTable({
        datatable(indiv, 
                  filter="top",
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
