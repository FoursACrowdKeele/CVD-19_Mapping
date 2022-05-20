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
ltlaC19 <- read_csv("covid_ltla_2022-05-16.csv") #may need to convert date but this file seems to work natively on my local machine
#What level of detail are these? Are they generalised/clipped? If not it might be worth it - I've found mapping to take quite some time so far
#Wondering if topoJSON or some other simplified form is also worth looking into

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
  # Data fiddling - should this go in Server section? ---- 

  mapdata <- subset(testdata, date=="2022-01-23") #Placeholder test date - want to pass from calendar/slider in UI
  map_and_data <- merge(ltla,mapdata,by.x="ltla21_code", by.y="areaCode",all.x=TRUE)
  
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
  
  output$map <- renderPlot(
    ggplot(map_and_data) +  
    geom_sf(aes(fill = newCasesBySpecimenDate),lwd = 0.1) + #Pass in other measures to fill from UI - will need to put them in src file
    theme_void() + 
    scale_fill_gradient2(low = "#a50026", high = "#005abb", na.value = "#808080")

    )
}

# Run the app ----
shinyApp(ui = ui, server = server)
