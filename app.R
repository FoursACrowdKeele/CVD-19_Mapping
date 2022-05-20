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
#not sure if it goes here or in server section, but we need to:
#first load the covid data and boundaries, and make sure date is formatted correctly in covid data
#then filter the covid data based on date - from a calendar/slider in the UI ideally - down to 1 row = 1 geog area code
#then join covid data to boundary files (using merge unless there's a better/more efficient option?)
#then finally the ggplot mapping code
#ideally should be able to also pass in from the UI what measure we're mapping

# Define UI ----
ui <- fluidPage(
  titlePanel("Covid-19 UK cases by LTLA"),
  
  sidebarLayout(
    sidebarPanel("Inputs"),
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
