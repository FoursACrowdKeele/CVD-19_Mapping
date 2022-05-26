#Contains misc code sections to be added to the app in future


#This section contains code for mapping English IMD ranks ----------------------------------------------------------------------------------------
#mapping welsh ranks on the same map is a work in progress (scottish data so far unavailable)
#may also be worth investigating https://research.mysociety.org/sites/imd2019/about/ to try to map based on MSOA instead of LSOA

#load datasets and merge
load("boundaries_lsoa11.rda")
IMDRanks <- read_csv("Eng + Wales IMD 2019.csv")
IMDmapdata <-  merge(boundaries_lsoa11,IMDRanks,by.x="lsoa11_code", by.y="LSOA code",all.x=TRUE)

#subset into separate dataframes for wales and england (temporary until I can figure out mapping both on one)
IMDmapdataWALES <- subset(IMDmapdata, Country == "Wales")
IMDmapdataENGLAND <- subset(IMDmapdata, Country == "England")

#Mapping english imd ranks
ggplot(IMDmapdataENGLAND) +  
  geom_sf(aes(fill = Rank,geometry=geometry),lwd = 0) + #Pass in other measures to fill from UI - will need to put them in src file
  #  scale_fill_gradient2(low = "#550000", high = "#ff0000", na.value = "#808080")
  scale_fill_gradient(low='blue', high='white')

#Can map welsh IMD ranks separately here
ggplot(IMDmapdataWALES) +  
  geom_sf(aes(fill = Rank,geometry=geometry),lwd = 0) + #Pass in other measures to fill from UI - will need to put them in src file
#  scale_fill_gradient2(low = "#550000", high = "#ff0000", na.value = "#808080")
  scale_fill_gradient(low='red', high='white')
  
  
#end of section ------------------------------------------------------------------------------------------------------------------------------------
  


#Population mapping section ------------------------------------------------------------------------------------------------------------------------
