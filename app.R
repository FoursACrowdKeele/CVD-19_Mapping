# --------
# Install packages if necessary
# 
# install.packages("shiny") 
# install.packages("maps")
# install.packages("sf")
# install.packages("ggplot2")
# --------

library(shiny)
library(maps)
library(sf)
library(ggplot2)

ltla <- readRDS(file = "ltla21_boundaries.rds")

# Define UI ----
ui <- fluidPage(
  titlePanel("title"),
  
  sidebarLayout(
    sidebarPanel("sb panel"),
    mainPanel(
      "LTLA boundary map",
      plotOutput("map"))
  )
)

# Define server logic ----
server <- function(input, output) {
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
  
  output$map <- renderPlot(
    ggplot() + geom_sf(data = ltla, size=.1)
    )
}

# Run the app ----
shinyApp(ui = ui, server = server)