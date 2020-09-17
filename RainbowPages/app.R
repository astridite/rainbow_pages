library(shiny)
library(shinythemes)
library(shinyWidgets)
library(DT)
library(dplyr)
library(magrittr)
library(leaflet)
library(RCurl)
library(stringr)
source("data_manip.R")

curated_data <- read.csv(text=getURL("https://raw.githubusercontent.com/astridite/rainbow_pages/dev/RainbowPages/curated_data.csv"))

ui <-  fluidPage(theme=shinytheme("yeti"),
  navbarPage("Rainbow Pages Cape Town",
                 # tabPanel("Welcome!", icon=icon("heart"),
                 #          fluidPage(
                 #            fluidRow(column(
                 #              tags$h2(welcome_text), width = 12)),
                 #            fluidRow(column(
                 #              tags$br(),
                 #              tags$br(),
                 #              tags$h4(welcome_para1, align="justify"),
                 #              tags$p("If you would like to see yourself or your business/organisation listed here, please fill out ",
                 #                tags$a(href="https://docs.google.com/forms/d/1Ot4rNE-hQilKH7DTdWoMvTYTh5BX1__uoBhdpm91ZwU/edit", "this form.")),
                 #              tags$p(welcome_para2, align="justify"),
                 #              width=6)))),
                 tabPanel("Browse",
                          fluidPage(
                            fluidRow(column(
                              tags$h2(welcome_text),
                              tags$br(),
                              tags$br(),
                              width = 12)
                              ),
                            sidebarLayout(
                              sidebarPanel(
                                tags$br(),
                                style=HTML("background-color: #ffffff;",
                                           "border-color: #ffffff;"),
                                checkboxGroupInput('type',
                                                   label=tags$h4("Filter by Type"),
                                                   selected=levels(factor(curated_data$class)),
                                                   choices =levels(factor(curated_data$class)),
                                                   inline = F),
                                checkboxGroupInput('location',
                                            label=tags$h4("Filter by Location"),
                                            selected=levels(factor(curated_data$location)),
                                            choices =levels(factor(curated_data$location)),
                                            inline = F,
                                            width = '100%'),
                                width=2),
                            mainPanel(
                              (DT::dataTableOutput(outputId = "browse")))
                          ))),

                 # tabPanel("Map", icon=icon("map-marked-alt"),
                 #          fluidPage(
                 #            fluidRow(column(tags$img(src='www/banner.jpg'), width=12),
                 #                     column(tags$h3(map_text1), width=12),
                 #                     column(tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                 #                            leafletOutput("map"), width=12)))),
                 # tabPanel("Network", icon=icon("draw-polygon"),
                 #          fluidPage(
                 #            fluidRow(column(tags$h3(work_in_progress), width=12)))),
                 tabPanel("Resources", icon=icon("info-circle"),
                          fluidPage(
                            fluidRow(column(tags$h3(resources_text1,
                                                    tags$a(href="https://www.sahistory.org.za/archive/life-orientation-classroom-sexuality-and-gender-pack?fbclid=IwAR3Thjx83Q4y4ntDa-78zPp-SFHuXKf_4uoMY55c1cLTRrwgp5DfYq36jUs",
                                                           "Check out this comprehensive Gender and Sexuality Pack.")), width=8),
                                    column(tags$h3(resources_text2,
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
  data <- reactive(
    curated_data %>%
      dplyr::filter(class %in% input$type) %>%
      dplyr::filter(location %in% input$location)
  )

  output$browse <- renderDataTable({
    datatable(data(),
              rownames = F,
              options=list(
              columnDefs = list(list(visible=FALSE, targets=c(1,5,6,8,9,11))),
              paging=F)) %>%
      formatStyle('colours',
                  target = 'row',
                  backgroundColor = styleEqual(c(1:8), hex))
  })
    # output$map <- renderLeaflet({
    #     leaflet(data = markers) %>%
    #     addTiles() %>%
    #     setView(lng = 18.495678, lat = -33.939157, zoom = 12) %>%
    #     addMarkers(lng = ~lon, lat = ~lat, popup = ~as.character(label), clusterOptions = markerClusterOptions())
    #     })

}

# Run the application
shinyApp(ui = ui, server = server)
