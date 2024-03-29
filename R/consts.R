# Constant urls for data retrieval
cdec_urls <- list(
  wy_forecast = "http://cdec.water.ca.gov/cgi-progs/iodir/wsi",
  station_hydro_area = "http://cdec.water.ca.gov/cgi-progs/staMeta?station_id=STATION",
  station_metadata = "http://cdec.water.ca.gov/dynamicapp/staMeta?station_id=STATION",
  wy_index = "http://cdec.water.ca.gov/cgi-progs/iodir/wsi",
  stations = "http://cdec.water.ca.gov/dynamicapp/staMeta?station_id=STATION"
)


# Look up table to go from SHEF Code ---> CDEC Param Code
shef_code_lookup <- list(
  "/HGH" = "1", #stage
  "/HGE" = "1", #stage
  "/QRH" = "20", #flow
  "/QRE" = "20", #flow
  "/TWH" = "25", #water temp
  "/TWE" = "25", #water temp
  "/TWD" = "25",
  "/WTH" = "27",
  "/WTE" = "27",
  "/WPH" = "62",
  "/WPE" = "62",
  "/WPD" = "62",
  "/WOH" = "-99",
  "/QPH" = "70",
  "/QPE" = "70",
  "/QPD" = "70",
  "/WFH" = "114",
  "/WFD" = "114",
  "/WFE" = "114",
  "/TUH" = "146",
  "/TUE" = "146",
  "/WSE" = "100",
  "/WSD" = "100",
  "/WSH" = "100",
  "/HLD" = "6",
  "/HLH" = "6",
  "/LSD" = "15",
  "/LSH" = "15",
  "/QTD" = "23",
  "/QTH" = "23",
  "/QID" = "76",
  "/QIH" = "76",
  "/LRD" = "94",
  "/LRH" = "94",
  "/TAD" = "30",
  "/TAH" = "04",
  "/QMD" = "8",
  "/PPM" = "45"

)
