#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

pacman::p_load(shiny, sf, tmap, bslib, tidyverse)

hunan <- st_read(dsn = "data",
                 layer = "Hunan")
data <- read_csv("data/Hunan_2012.csv")

# hunan_data <- left_join(hunan, data,
#                         by = c('County' = 'COUNTY'))

hunan_profile <- left_join(hunan, data) %>%
  select(1:4, 7, 15)

# print(hunan_profile)

ui <- fluidPage(
    titlePanel("Choropleth Mapping"),
    sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "variable",
          label = "Mapping variable",
          choices = list("Gross Domestic Product, GDP" = "GDP",
                          "Gross Domestic Product Per Capita" = "GDPPC",
                          "Gross Industry Output" = "GIO", 
                          "Output Value of Agriculture" = "OVA",
                          "Output Value of Service" = "OVS"),
          selected = "GDPPC"), 
          sliderInput(inputId = "classes",
                      label= "Number of classes",
                      min = 5,
                      max = 10, 
                      value = c(6))
        ),
        mainPanel(
          tmapOutput("mapPlot",
                      width = "100%",
                      height = 580)
          )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$mapPlot <- renderTmap ({
      tmap_options(check.and.fix = TRUE) +
           tm_shape(hunan_profile) +
           tm_fill(input$variable,
                   n = input$classes,
                   style = "quantile",
                   palette = blues9) +
           tm_borders(lwd = 0.1, alpha = 1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
