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

# load boundry data from files and rename
ltla_bounds <- readRDS(file = "boundaries_ltla19.rds")
ltla_bounds = ltla_bounds %>%
  rename(areaName="ltla19_name",areaCode="ltla19_code")
# load covid data
ltlaC19 <- read_csv("covid_ltla_2022-05-16.csv")
# load IMD data
#load datasets and merge
load("boundaries_lsoa11.rda")
IMDRanks <- read_csv("Eng + Wales IMD 2019.csv")
IMDmapdata <-  merge(boundaries_lsoa11,IMDRanks,by.x="lsoa11_code", by.y="LSOA code",all.x=TRUE)

#subset into separate dataframes for wales and england (temporary until I can figure out mapping both on one)
IMDmapdataWALES <- subset(IMDmapdata, Country == "Wales")
IMDmapdataENGLAND <- subset(IMDmapdata, Country == "England")


# convert dates to week commencing date. e.g. each date is converted to the...
# week it belongs to (week starts monday)
ltlaC19$date = cut(as.Date(ltlaC19$date), "week")
# group by week and sum covid cases per day for each ltla
ltlaC19 <- aggregate(newCasesBySpecimenDate~
                       areaCode+areaName+areaType+date,ltlaC19,sum)
ltlaC19$date <- as.Date(ltlaC19$date)

min_date = min(ltlaC19$date)
max_date = max(ltlaC19$date)

# get all combinations of dates and areas so the full map is rendered
cart_prod_df = crossing(data.frame(date=ltlaC19$date),
                        data.frame(areaCode=ltla_bounds$areaCode))
# join back to boundry data to collect geometry column
cart_prod_df = merge(ltla_bounds,cart_prod_df,x.by=areaCode,
                     y.by=areaCode)

# join tables, keep all date and area combinations (left join)
map_and_data <- merge(cart_prod_df,select(ltlaC19, c("areaCode",
                                                     "date",
                                                     "newCasesBySpecimenDate")),
                      by=c("areaCode","date"), all.x = TRUE)

# replace NA counts with 0
# map_and_data[is.na(map_and_data)] <- 0

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
                             "Week Commencing Date",
                             min = min_date,
                             max = max_date,
                             value = min_date,
                             step=7,
                             animate=animationOptions(interval=1500))#,
                 #animationOptions(interval=2500)#,
                 #textOutput("SliderText")
                 ),
    mainPanel(
      fluidRow(
         column(6,
               "LTLA boundary map",
               plotOutput("map")
                ),
          column(6,
                 "LSOA IMD",
                 plotOutput("map2")
                )
               )
              )
  )
)

# Define server logic ----
server <- function(input, output) {
  # Data fiddling - should this go in Server section? ---- 
  
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
  
  output$map <- renderPlot(
    ggplot(subset(map_and_data, date==input$date)) +  
      geom_sf(aes(fill = newCasesBySpecimenDate),lwd = 0.1) + #Pass in other measures to fill from UI - will need to put them in src file
      theme_void() + 
      scale_fill_gradient2(low = "#a50026", high = "#005abb", na.value = "#808080")
    )
    
    #Mapping english imd ranks
    output$map2 <- renderPlot(
      ggplot(IMDmapdataENGLAND) +  
      geom_sf(aes(fill = Rank,geometry=geometry),lwd = 0) + #Pass in other measures to fill from UI - will need to put them in src file
      #  scale_fill_gradient2(low = "#550000", high = "#ff0000", na.value = "#808080")
      scale_fill_gradient()
    )
}

# Run the app ----
shinyApp(ui = ui, server = server)