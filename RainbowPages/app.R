library(shiny)
library(shinythemes)
library(shinyWidgets)
library(DT)
library(dplyr)
library(magrittr)
library(leaflet)
library(RCurl)
library(stringr)
library(here)
source("data_manip.R")

curated_data <- read.csv(text=getURL("https://raw.githubusercontent.com/astridite/rainbow_pages/dev/RainbowPages/curated_data.csv")) 
markers <- read.csv(here("markers.csv"))

ui <-  fluidPage(theme=shinytheme("yeti"),
  navbarPage("Rainbow Pages Cape Town",
             tabPanel("Browse",
                          icon=icon("heart"),
                          fluidPage(
                            fluidRow(column(
                              tags$h2(welcome_text), 
                              tags$br(),
                              tags$h4(welcome_para1, align="justify"),
                              tags$br(),
                              width = 11)
                              ),
                            sidebarLayout(
                              sidebarPanel(
                                tags$br(),
                                style=HTML("background-color: #ffffff;", 
                                           "border-color: #ffffff;",
                                           "box-shadow: none;"),
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
             tabPanel("Map", icon=icon("map-marked-alt"),
                      fluidRow(
                        #column(tags$img(src='banner.jpg'), width=12),
                               column(tags$h3(map_text1), width=12),
                               tags$head(
                               tags$style(HTML("
                               #controls {
                               background-color: white;
                               padding: 0 20px 20px 20px;
                                               opacity: 0.5};"))),
                               leafletOutput("map", height = 800)),
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
                                                       selected = list("Arts & Entertainment",
                                                                       "Health", 
                                                                       "Fashion & Beauty",
                                                                       "Information Technology")))),
             tabPanel("Sign-Up", icon=icon("user-plus"),
                      fluidPage(column(
                        tags$h3(signup_text1),
                        tags$h5(signup_text2),
                        tags$br(),
                        tags$iframe(src="https://docs.google.com/forms/d/e/1FAIpQLSfp7dzCI7Pjh5H8RMEWvfh4_ba2ZbNoFSLfyuJlU6v4W4-nxg/viewform?usp=sf_link", width=1000, height=500),
                        width=10, offset=1))
                      ), 
             
             tabPanel("Resources", icon=icon("info-circle"), 
                          fluidPage(
                            fluidRow(column(tags$h3(resources_text1,
                                                    tags$a(href="https://www.sahistory.org.za/archive/life-orientation-classroom-sexuality-and-gender-pack?fbclid=IwAR3Thjx83Q4y4ntDa-78zPp-SFHuXKf_4uoMY55c1cLTRrwgp5DfYq36jUs",
                                                           "Check out this comprehensive Gender and Sexuality Pack.")), width=8),
                                    column(tags$h3(resources_text2,
                                                    tags$a(href="https://github.com/astridite/rainbow_pages",
                                                           "Check out our Github Repo."), align='right'), width=8, offset=4)))),
                 # tabPanel("Support", icon=icon("hand-holding-usd"),
                 #          fluidPage(
                 #            fluidRow(column(tags$h3(work_in_progress), width=12)))),
                 tabPanel("Suggestions", icon=icon("envelope-open-text"),
                          fluidPage(column(
                            tags$h3(suggestion_text1),
                            tags$br(),
                            tags$iframe(src=" https://docs.google.com/forms/d/e/1FAIpQLScNatTIO3l8PZNQK5QdrNlWuxHhCjfP7etHYt3HEo9rn97ztw/viewform?usp=sf_link", width=1000, height=500),
                            width=10, offset=1))
                 )),
  
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
