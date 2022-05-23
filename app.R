# --------
# Install packages if necessary
# 
# install.packages("shiny") 
# install.packages("maps")
# install.packages("sf")
# install.packages("ggplot2")
# install.packages("readr")
# install.packages("tidyverse")
# install.packages("lubridate")
# install.packages("dplyr")
# --------

library(shiny)
library(maps)
library(sf)
library(ggplot2)
library(readr)
library(tidyverse)
library(lubridate)
library(dplyr)

# load data from files
ltla <- readRDS(file = "ltla21_boundaries.rds")
ltlaC19 <- read_csv("covid_ltla_2022-05-16.csv")
# convert date to date commencing. e.g. each date is converted to the week it belongs to (week starts monday)
ltlaC19$date = cut(as.Date(ltlaC19$date), "week")
# group by week and sum covid cases per day for each ltla
ltlaC19 <- aggregate(newCasesBySpecimenDate~areaCode+areaName+areaType+date,ltlaC19,sum)
ltlaC19$date <- as.Date(ltlaC19$date)

min_date = min(ltlaC19$date)
max_date = max(ltlaC19$date)

map_and_data <- merge(ltla,ltlaC19,by.x="ltla21_code", by.y="areaCode",all.x=TRUE)

#may need to convert date but this file seems to work natively on my local machine
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
    sidebarPanel("Inputs",
                 sliderInput("date",
                             "Date",
                             min = min_date,
                             max = max_date,
                             value = min_date,
                             step=7,
                             animate=TRUE),
                 animationOptions(interval=2500),
                 textOutput("SliderText")),
    mainPanel(
      "LTLA boundary map",
      plotOutput("map"))
  )
)

# Define server logic ----
server <- function(input, output) {
  # Data fiddling - should this go in Server section? ---- 
  
  #mapdata <- subset(ltlaC19, date==input$date) #Placeholder test date - want to pass from calendar/slider in UI
  #map_and_data <- merge(ltla,mapdata,by.x="ltla21_code", by.y="areaCode",all.x=TRUE)
  
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
  
  output$map <- renderPlot(
    ggplot(subset(map_and_data, date==input$date)) +  
      geom_sf(aes(fill = newCasesBySpecimenDate),lwd = 0.1) + #Pass in other measures to fill from UI - will need to put them in src file
      theme_void() + 
      scale_fill_gradient2(low = "#a50026", high = "#005abb", na.value = "#808080")
    
  )
}

# Run the app ----
shinyApp(ui = ui, server = server)