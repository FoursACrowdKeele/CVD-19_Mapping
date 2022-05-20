# CVD-19_Mapping

Creation of a R Shiny web dashboard to show Covid-19 cases by divided by LTLAs over time. LTLAs (Lower-tier local authorities) is a sub-geogrphy of the UK.

#### App
https://keeletestoneltd.shinyapps.io/cvd-19_mapping/

#### Data sources
Open Covid data obtained from coronavirus.data.gov.uk.

#### Roadmap

- [ ] Minimum requirements
  - [ ] Display on a map covid case rates in different regions of the UK 
  - [x] Be accessible online from multiple devices 
  - [ ] Be able to interactively change the date (with a slider or with a calendar? Or both?) 
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

