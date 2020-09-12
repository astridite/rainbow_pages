library(shiny)
library(shinydashboard)
library(shinythemes)
library(DT)
library(magrittr)
library(leaflet)

source("RainbowPages0.1.0/sheet.R")
source("RainbowPages0.1.0/data_manip.R")
curated <- curated


ui = dashboardPage(
    dashboardHeader( title=tags$img(src='www/logo.jpg',height='50',width='200')),
    dashboardSidebar(sidebarMenu(
        menuItem("Welcome!", tabName = "welcome", icon=icon("heart")),
        menuItem("Businesses", tabName = "businesses", icon=icon("briefcase")),
        menuItem("Individuals", tabName = "individuals", icon=icon("address-book")),
        menuItem("Organisations", tabName = "organisations", icon=icon("hands-helping")),
        menuItem("Map", tabName = "map", icon=icon("map-marked-alt")),
        menuItem("Network", tabName = "network", icon=icon("draw-polygon"), badgeLabel = "WIP", badgeColor = "yellow"),
        menuItem("Resources", tabName = "resources", icon=icon("info-circle"), badgeLabel = "WIP", badgeColor = "yellow"),
        menuItem("Support", tabName = "support", icon=icon("hand-holding-usd"), badgeLabel = "WIP", badgeColor = "yellow"),
        menuItem("Suggestions", tabName = "suggestions", icon=icon("envelope-open-text"), badgeLabel = "WIP", badgeColor = "yellow")
    )),
    dashboardBody(tabItems(
        tabItem(tabName = "welcome", tags$p("some text")),
        tabItem(tabName = "businesses", 
                fluidRow(column(tags$img(src='www/banner.jpg'), width=12),
                         box(title="Business Listings", DT::dataTableOutput(outputId = "busi"), width=12)))
    ))
)




server <- function(input, output) {
    output$busi <- DT::renderDataTable({
        datatable(busi, options=list(columnDefs = list(list(visible=FALSE, targets=c(2,6,10))),
                                     pageLength = 1000,
                                     scrollX=T, 
                                     headerCallback = DT::JS(
                                             "function(thead) {",
                                             "  $(thead).css('font-size', '1em');",
                                             "}"
                                         ) ))%>% 
            formatStyle('colours', target = 'row', backgroundColor = styleEqual(c(1:8), hex),
                        fontSize = '90%')
    })
}

    

# Run the application 
shinyApp(ui = ui, server = server)
