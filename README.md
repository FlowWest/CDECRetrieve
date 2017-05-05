# CDECRetrieve

**Version 0.1.0**

CDECRetrieve uses the web services provided by the California Data Exchange Center

[here](http://cdec.water.ca.gov/) as a backend to allow users to download 
data with a single function call. CDECRetrieve specifically uses the SHEF download
service due to the fact that it is the most robust of the services. You can learn 
more about the SHEF format [here](http://www.nws.noaa.gov/om/water/resources/SHEF_CodeManual_5July2012.pdf).

# Installation 

Install using `devtools::install_github` 

```r 
devtools::install_github("CDECRetrieve", username="flowwest")
```

*Note* This package currently lives in a private repository an auth token is required
to download and install. Email erodriguez@flowwest.com for more information. 

# Usage 

## Basic Usage 

CDECRetrieve exposes several useful functions to query services from CDEC. 
The main function in the package is `retrieve_station_data`, 

```r 
# download data from kwk, sensor 20, duration is event type
kwk_flow <- retrieve_station_data("KWK", "20", "E", "2000-01-01", "2002-01-01")
```

The returned data complies with both tidy data and third normal form, to 
facilitate both statistical analysia and visualization.

```
# A tibble: 17,544 × 5
   agency_cd            datetime location_id parameter_cd parameter_value
       <chr>              <dttm>       <chr>        <chr>           <chr>
1       CDEC 2000-01-01 00:00:00         KWK          20H            5401
2       CDEC 2000-01-01 01:00:00         KWK          20H            4937
3       CDEC 2000-01-01 02:00:00         KWK          20H            5234
4       CDEC 2000-01-01 03:00:00         KWK          20H            5234
5       CDEC 2000-01-01 04:00:00         KWK          20H            5273
6       CDEC 2000-01-01 05:00:00         KWK          20H            5282
7       CDEC 2000-01-01 06:00:00         KWK          20H            5090
8       CDEC 2000-01-01 07:00:00         KWK          20H            5023
9       CDEC 2000-01-01 08:00:00         KWK          20H            5014
10      CDEC 2000-01-01 09:00:00         KWK          20H            5023
# ... with 17,534 more rows
```

Note that queries beyond the scope of available data do not break the code! It 
simply returns the subset of available data. 

Tidy means we can do it all! 

```r 
library(dplyr)
library(ggplot2)

kwk_flow %>% 
  filter(parameter_value >= 0) %>% 
  ggplot(aes(datetime, parameter_value)) + 
  geom_line()
```

![kwk](images/kwk_flow_ts.png)

## Using with purrr

CDECRetrieve does one thing, obtain data from a given station. We strongly believe 
there are tools in R that can extend its functionality beyond this.
Here we use the `purrr` package to map across a set of desired CDEC stations, and 
this retrieving multiple station query.

```r
library(purrr)
# define the stations of interest
station_list <- c("BND", "KWK", "FRE", "CCR")

# use map to retrieve all possible data
resp <- map(station_list, safely(function(x) {
  retrieve_station_data(x, "25", "H", "2015-01-01", "2017-02-28")
}))

# transpose and extract succesfull returns 
resp <- transpose(resp)$results %>% bind_rows()
```

The query returns 

```
resp

# A tibble: 56,808 × 5
   agency_cd            datetime location_id parameter_cd parameter_value
       <chr>              <dttm>       <chr>        <chr>           <dbl>
1       CDEC 2015-01-01 00:00:00         BND          25H            45.3
2       CDEC 2015-01-01 01:00:00         BND          25H            45.4
3       CDEC 2015-01-01 02:00:00         BND          25H            45.4
4       CDEC 2015-01-01 03:00:00         BND          25H            45.3
5       CDEC 2015-01-01 04:00:00         BND          25H            45.3
6       CDEC 2015-01-01 05:00:00         BND          25H            45.2
7       CDEC 2015-01-01 06:00:00         BND          25H            45.1
8       CDEC 2015-01-01 07:00:00         BND          25H            45.0
9       CDEC 2015-01-01 08:00:00         BND          25H            45.0
10      CDEC 2015-01-01 09:00:00         BND          25H            45.1
# ... with 56,798 more rows
```

We can see all of the locations that had a result 

```r
table(resp$location_id)

  BND   CCR   KWK 
18936 18936 18936 
```

If this is useful enough we can place it in a function for reuse: 

```r 
multiple_station_query <- function(station_list, sensor_num, dur_code, 
                                    start_date, end_date) {
  resp <- map(station_list, safely(function(x) {
    retrieve_station_data(x, sensor_num, dur_code, start_date, end_date)
  }))
  
  transpose(resp)$result %>% bind_rows()
}
```

and we call it as follow: 

```r
multiple_station_query(station_list, ....)

# purrr (and functional programming) is great! We can further 
# extend the use of the function 
# Suppose we want to fix everything but the station, filling the remaining 
# values over and over again is annoying so we can partially apply these values 
multiple_station_temp_query <- purrr::partial(
  multiple_station_query, 
  sensor_num = "20", 
  dur_code = "H",
  start_date = "2015-01-01", 
  end_date = "2017-01-01"
)

# now we can call this function ONLY with stations we are interested in 
multiple_station_temp_query("KWK")
multiple_station_temp_query("CCR")
multiple_station_temp_query("BND")
```

# Alternatives 

Apart from going straight to CDEC for data, there is another R package called
`sharpshootR` that allows for data retrieval in a similar way that `CDECRetrieve` 
does.

# Details 

The CDEC web services are a mess! Queries do not always respond and the service 
that fulfills a query is not always the same. The most reliable queries are those
from the SHEF download service. The approach taken here is one with an ugly side effect, 
namely a SHEF file is downloaded temporarily to the working environment, this however 
is a huge boost in robustness. Having interacted with other services from CDEC 
none come close the reliability showcased by the SHEF download service. 

# Upcoming features

* A shiny interface 
* Dates can be left empty, package knows what to query 
* and more....

# TODO 

* Better error handling, currently relies on `safely` but error outputs should be 
much more informative 









