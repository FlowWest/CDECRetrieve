# Title: Conts.R
# Author: Emanuel Rodriguez
# Date:
# Description: A location to place all global and constant values
# ----------------------

cdec_urls <- list(

  download_shef = "http://cdec.water.ca.gov/cgi-progs/querySHEF?station_id=STATION&sensor_num=SENSOR&dur_code=DURCODE&start_date=STARTDATE&end_date=ENDDATE&data_wish=Download+SHEF+Data+Now",
  wy_forecast = "http://cdec.water.ca.gov/cgi-progs/iodir/wsi",
  station_metadata = "http://cdec.water.ca.gov/cgi-progs/staMeta",
  show_historical = "http://cdec.water.ca.gov/cgi-progs/selectQuery"

)


shef_code_lookup <- list(
  "/HGH" = "01H",
  "/HGE" = "01E",
  "/QRH" = "20H",
  "/QRE" = "20E",
  "/TWH" = "25H",
  "/TWE" = "25E",
  "/WTH" = "27H",
  "/WTE" = "27E",
  "/WPH" = "62H",
  "/WPE" = "62E",
  "/WPD" = "62D",
  "/WOH" = "-99",
  "/QPH" = "70H",
  "/QPE" = "70E",
  "/QPD" = "70E",
  "/WFH" = "114H",
  "/WFD" = "114D",
  "/WFE" = "114E",
  "/TUH" = "146H",
  "/TUE" = "146E",
  "/WSE" = "100E",
  "/WSD" = "100D",
  "/WSH" = "100H",
  "/HLD" = "06D",
  "/HLH" = "06H",
  "/LSD" = "15D",
  "/LSH" = "15H",
  "/QTD" = "23D",
  "/QTH" = "23H",
  "/QID" = "76D",
  "/QIH" = "76H",
  "/LRD" = "94D",
  "/LRH" = "94H"
)
