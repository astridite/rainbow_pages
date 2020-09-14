library(shiny)
library(shinythemes)
library(shinyWidgets)
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
                              tags$h4(welcome_para1, align="justify"),
                              tags$p("If you would like to see yourself or your business/organisation listed here, please fill out ",
                                tags$a(href="https://docs.google.com/forms/d/1Ot4rNE-hQilKH7DTdWoMvTYTh5BX1__uoBhdpm91ZwU/edit", "this form.")),
                              tags$p(welcome_para2, align="justify"),
                              width=6)))), 
                 tabPanel("Businesses", icon=icon("briefcase"), 
                          fluidPage(
                            fluidRow(column(tags$img(src='www/banner.jpg'), width=12),
                                     column(tags$h3(business_text1), width=12),
                                     column(tags$br(), width=12),
                                     column(DT::dataTableOutput(outputId = "busi"), width=12)))),
                 tabPanel("Organisations", icon=icon("hands-helping"), 
                          fluidPage(
                            fluidRow(column(tags$img(src='www/banner.jpg'), width=12),
                                     column(tags$h3(organisation_text1), width=12),
                                     column(tags$br(), width=12),
                                     column(DT::dataTableOutput("orgs"), width=12)))),
                 tabPanel("Individuals",  icon=icon("address-book"), 
                          fluidPage(
                            fluidRow(column(tags$img(src='www/banner.jpg'), width=12),
                                     column(tags$h3(individual_text1), width=12),
                                     column(tags$br(), width=12),
                                     column(DT::dataTableOutput("indiv"), width=12)))), 
                 tabPanel("Map", icon=icon("map-marked-alt"), 
                          fluidPage(
                            fluidRow(column(tags$img(src='www/banner.jpg'), width=12),
                                     column(tags$h3(map_text1), width=12), 
                                     column(tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                                            leafletOutput("map"), width=12)))), 
                 tabPanel("Network", icon=icon("draw-polygon"),
                          fluidPage(
                            fluidRow(column(tags$h3(work_in_progress), width=12)))),
                 tabPanel("Resources", icon=icon("info-circle"), 
                          fluidPage(
                            fluidRow(column(tags$h3(resources_text1,
                                                    tags$a(href="https://www.sahistory.org.za/archive/life-orientation-classroom-sexuality-and-gender-pack?fbclid=IwAR3Thjx83Q4y4ntDa-78zPp-SFHuXKf_4uoMY55c1cLTRrwgp5DfYq36jUs",
                                                           "Check out this comprehensive Gender and Sexuality Pack.")), width=8),
                                     column(tags$h3(resources_text1,
                                                    tags$a(href="https://github.com/astridite/rainbow_pages",
                                                           "Check out our Github Repo."), align='right'), width=8, offset=4)))),
                 tabPanel("Support", icon=icon("hand-holding-usd"),
                          fluidPage(
                            fluidRow(column(tags$h3(work_in_progress), width=12)))),
                 tabPanel("Suggestions", icon=icon("envelope-open-text"),
                          fluidPage(
                            fluidRow(column(tags$h3(work_in_progress), width=12))))),
  
  tags$style(HTML("a {color: #eb34c0}"))
    
  
)

server <- function(input, output) {
    output$busi <- DT::renderDataTable({
      datatable(busi,
                filter="top",
                options=list(
                  columnDefs = list(list(visible=FALSE, targets=c(2,6,10))),
                  paging=F))%>% 
        formatStyle('colours', target = 'row', backgroundColor = styleEqual(c(1:8), hex),
                    fontSize = '90%')})
    output$orgs <- DT::renderDataTable({
         datatable(orgs, 
                   filter="top",
                   options=list(
                     columnDefs = list(list(visible=FALSE, targets=c(2,6,10))),
                     paging=F))%>% 
        formatStyle('colours', target = 'row', backgroundColor = styleEqual(c(1:8), hex),
                    fontSize = '90%') 
        })
    output$indiv <- DT::renderDataTable({
        datatable(indiv, 
                  filter="top",
                  options=list(columnDefs = list(list(visible=FALSE, targets=c(2,6,9))), 
                               paging=F)) %>%
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
