# CVD-19_Mapping

Creation of a R Shiny web dashboard to show Covid-19 cases by divided by LTLAs over time. LTLAs (Lower-tier local authorities) is a sub-geogrphy of the UK.

#### App
https://keeletestoneltd.shinyapps.io/cvd-19_mapping/

#### Data sources
Open Covid data obtained from https://coronavirus.data.gov.uk/details/download 

Population data obtained from https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland

IMD data obtained from https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019 

UK boundaries data obtained from https://github.com/humaniverse/geographr


#### Roadmap

- [x] Minimum requirements
  - [x] Display on a map covid case rates in different regions of the UK 
  - [x] Be accessible online from multiple devices 
  - [x] Be able to interactively change the date (with a slider or with a calendar? Or both?) 
- [ ] Tier 1
  - [ ] Be able to change between different geographies (eg Local Authorities or MSOAs – perhaps with a drop-down box) 
  - [ ] Case rate “rate of change” 
  - [ ] Deaths/Hospital Admissions? (might be limited to certain geographies) 
  - [ ] Colourblind compatible colourscheme
- [ ] Tier 2
  - [ ] Weekly data update jobs? 
  - [ ] Vaccination take-up 
  - [ ] Pop density 
- [ ] Tier 3
  - [ ] Add IMD levels for each geography (england only? Available at LSOA level natively, MSOA level through https://research.mysociety.org/sites/imd2019/about/) 
  - [ ] Household size? 
  - [ ] Death rates from other causes 

