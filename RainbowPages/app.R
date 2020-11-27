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
source("app_text.R")
curated_data <- read.csv(text=getURL("https://raw.githubusercontent.com/astridite/rainbow_pages/dev/RainbowPages/curated_data.csv")) 


ui <-  fluidPage(theme=shinytheme("simplex"),
                 setBackgroundColor("#FFF7FA"),
                 # title is not a string, so set windowTitle explicitly
                 navbarPage(windowTitle="Rainbow Pages Cape Town",
                            title=img(src="full_logo.png", height=28),
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
                                           style=HTML("background-color:  rgba(0, 0, 0, 0);", 
                                                      "border-color:  rgba(0, 0, 0, 0);",
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
                                           checkboxGroupInput('layer', 
                                                              label=tags$h4("Filter by Activity"),
                                                              selected=levels(factor(curated_data$layer)),
                                                              choices =levels(factor(curated_data$layer)),
                                                              inline = F,
                                                              width = '100%'),
                                           width=2),
                                         mainPanel(
                                           (DT::dataTableOutput(outputId = "browse")))
                                         ))),
                            tabPanel("Map", icon=icon("map-marked-alt"),
                                     fluidPage(
                                       fluidRow(
                                       tags$br(),
                                       #column(tags$h3(map_text1), width=12),
                                       tags$head(
                                       tags$style(HTML("
                                       #controls {
                                       background-color: white;
                                       padding: 0 20px 20px 20px;
                                                       opacity: 0.5};"))),
                                       column(absolutePanel(id = "controls", fixed = TRUE,
                                                            draggable = TRUE, top = 100, left = "auto", right = "auto", bottom = "auto",
                                                            width = 230, height = "auto",
                                                            style = "opacity: 0.8",
                                                            checkboxGroupInput("category",
                                                                               h4("Explore LGBTQIA+ Activities in Cape Town:"), 
                                                                               choiceNames = levels(factor(curated_data$layer)),
                                                                               choiceValues = levels(factor(curated_data$layer)),
                                                                               selected = levels(factor(curated_data$layer)))), width=4),
                                       column(leafletOutput("map", height = 480, width=800), width=9, offset=3)
                                       ))),
                            tabPanel("Sign-Up", icon=icon("user-plus"),
                                     fluidPage(column(
                                       tags$h3(signup_text1),
                                       tags$h5(signup_text2),
                                       tags$br(),
                                       tags$iframe(src="https://docs.google.com/forms/d/e/1FAIpQLSfp7dzCI7Pjh5H8RMEWvfh4_ba2ZbNoFSLfyuJlU6v4W4-nxg/viewform?usp=sf_link", width=700, height=400),
                                       width=9, offset=2))
                                     ),
                            # tabPanel("Support", icon=icon("hand-holding-usd"),
                            #          fluidPage(
                            #            fluidRow(column(tags$h3(work_in_progress), width=12)))),
                            tabPanel("Suggestions", icon=icon("envelope-open-text"),
                                     fluidPage(column(
                                       tags$h3(suggestion_text1),
                                       tags$h5(suggestion_text2),
                                       tags$br(),
                                       tags$iframe(src=" https://docs.google.com/forms/d/e/1FAIpQLScNatTIO3l8PZNQK5QdrNlWuxHhCjfP7etHYt3HEo9rn97ztw/viewform?usp=sf_link", width=700, height=400),
                                       width=9, offset=2))
                                     ),
                            tabPanel("About", icon=icon("info-circle"),
                                     fluidPage(
                                       fluidRow(column(tags$h3(about_text1,
                                                               tags$a(href="https://www.sahistory.org.za/archive/life-orientation-classroom-sexuality-and-gender-pack?fbclid=IwAR3Thjx83Q4y4ntDa-78zPp-SFHuXKf_4uoMY55c1cLTRrwgp5DfYq36jUs",
                                                                      "Check out this comprehensive Gender and Sexuality Pack.")), width=8, offset=1),
                                                column(tags$h3(about_text2,
                                                               tags$a(href="https://github.com/astridite/rainbow_pages",
                                                                      "Check out our Github Repo."), align='right'), width=8, offset=4),
                                                column(tags$h3(about_text3, tags$a(href="mailto:rainbowpagesct@gmail.com","get in touch!")), width=8, offset=1),
                                                column(tags$br(),tags$br(), tags$br(), width=12)),
                                       fluidRow(column(img(src="lettermark.png", height=200), width=3, offset=1), 
                                                column(tags$h3(about_text4, tags$a(href="https://twitter.com/dataccino", "Astrid Radermacher"), ",", 
                                                               tags$a(href="https://twitter.com/Axiematic", "Emma Collier"), "and",
                                                               tags$a(href="https://twitter.com/mattdenni", "Matt Dennis"), align='right'), 
                                                       tags$h3(about_text5, tags$a(href="https://www.behance.net/liamlr95", "Liam Le Roux"), align='right'),
                                                       width=6, offset=2))))
                            ),
                 setBackgroundImage(src="rp_background.png"),
                 tags$style(HTML("a {color: #eb34c0}")),
                 tags$style(type = 'text/css', '.navbar-default { background-color: rgba(0, 0, 0, 0);
                            color: rgba(0, 0, 0, 0);}'),
                 tags$style(type = 'text/css',"navbar navbar-default navbar-static-top {color: rgba(0, 0, 0, 0);}")
                 )


server <- function(input, output) {
  data <- reactive(
    curated_data %>% 
      dplyr::filter(class %in% input$type) %>% 
      dplyr::filter(location %in% input$location) %>% 
      dplyr::filter(layer %in% input$layer) %>% 
      select(id, detail, op_icons, location, sector, colours)
  )
          
  output$browse <- DT::renderDataTable({
    datatable(data(),
              escape=F,
              rownames = F,
              colnames=c("Name", "Detail", "Email", "Location", "Sector", "colours"),
              options=list(
              columnDefs = list(list(visible=FALSE, targets=c(5#colours
                                                              ))),
              paging=F)) %>% 
      formatStyle('colours', 
                  target = 'row', 
                  backgroundColor = styleEqual(c(1:8), rgb_cols))
  })
  
  mapFiltered <- reactive({
    
    filtered_markers <- curated_data %>%
      filter(!is.na(lon),
             layer %in% input$category)
    
    filtered_icons <- icons(
      iconUrl = case_when(
        filtered_markers$layer == "Activism" ~ here("icons/community.png"),
        filtered_markers$layer == "Arts & Entertainment" ~ here("icons/nightlife.png"),
        filtered_markers$layer == "Commerce" ~ here("icons/financial-services.png"),
        filtered_markers$layer == "Entrepeneurship" ~ here("icons/professional.png"),
        filtered_markers$layer == "Fashion & Beauty" ~ here("icons/fashion.png"),
        filtered_markers$layer == "Film, Media & Photography" ~ here("icons/photography.png"),
        filtered_markers$layer == "Hospitality & Tourism" ~ here("icons/restaurants.png"),
        filtered_markers$layer == "Marketing & Social Media" ~ here("icons/mobile-phones.png"),
        filtered_markers$layer == "Medical & Counselling" ~ here("icons/health-medical.png"),
        filtered_markers$layer == "Networking" ~ here("icons/meetups.png"),
        filtered_markers$layer == "Science & Technology" ~ here("icons/computers.png")
      ),
      iconWidth = 26.4, iconHeight = 35.2,
      iconAnchorX = 13.2, iconAnchorY = 35
    )
    
    filtered_elements <- list(filtered_markers, filtered_icons)
    
    return(filtered_elements)
    
  })
  
  output$map <- renderLeaflet({
    leaflet(data = curated_data[!is.na(curated_data$lon),]) %>% 
      addTiles() %>%
      fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat)) %>%
      addMarkers(
        lng = ~lon,
        lat = ~lat,
        icon = mapFiltered()[[2]],
        popup = ~as.character(label),
        clusterOptions = markerClusterOptions()
      )
  })
  
  observe({
        leafletProxy("map", data = mapFiltered()[[1]]) %>%
          clearMarkers() %>%
          clearMarkerClusters() %>%
          addMarkers(
            lng = ~lon,
            lat = ~lat,
            icon = mapFiltered()[[2]],
            popup = ~as.character(label),
            clusterOptions = markerClusterOptions()
      )
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

