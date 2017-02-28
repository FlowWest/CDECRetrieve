# CDECRetrieve

CDECRetrieve uses the web services provded by the California Data Exchange Center
as a backend to allow users to download data with a single function call. 

# Installation 

Install using `devtools::install_github` 

```r 
devtools::install_github("CDECRetrieve", username="flowwest")
```


# Usage 

CDECRetrieve exposes several useful functions to query services from CDEC. 
The main function in the package is `retrieve_station_data`, 

```r 
# download data from kwk, sensor 20, duration is event type
kwk_flow <- retrieve_station_data("KWK", "20", "E", "2000-01-01", "2002-01-01")
```

The returned data complies with both tidy data and the structure on the open 
water database 

```
kwk 

# A tibble: 48,202 × 4
              datetime location_id parameter_cd parameter_value
                <dttm>       <chr>        <chr>           <dbl>
1  2000-08-11 08:00:00         KWK           20           12191
2  2000-08-11 08:15:00         KWK           20           12159
3  2000-08-11 08:30:00         KWK           20           12223
4  2000-08-11 08:45:00         KWK           20           12207
5  2000-08-11 09:00:00         KWK           20           12223
6  2000-08-11 09:15:00         KWK           20           12191
7  2000-08-11 09:30:00         KWK           20           12223
8  2000-08-11 09:45:00         KWK           20           12239
9  2000-08-11 10:00:00         KWK           20           12207
10 2000-08-11 10:15:00         KWK           20           12207
# ... with 48,192 more rows
```

Note that queries beyond the scope of available data does not break the code! It 
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

The function does one thing, obtain data from a given station. There are powerful 
tools in R to retrieve multiple stations. Here we use the `purrr` package to map 
across a set of desired CDEC stations. 

```r
library(purrr)
# define the stations of interest
station_list <- c("BND", "KWK", "FRE", "CCR")

# use map to retrieve all possible data
resp <- map(station_list, safely(function(x) {
  retrieve_station_data(x, "25", "H", "2000-01-01", "2017-02-28")
}))

# transpose and extract succesfull returns 
query_res <- transpose(resp)$results %>% bind_rows()
```

The query returns 

```r
query_res

# A tibble: 165,554 × 4
              datetime location_id parameter_cd parameter_value
                <dttm>       <chr>        <chr>           <dbl>
1  1999-12-31 23:00:00         KWK           25            52.1
2  2000-01-01 00:00:00         KWK           25            52.1
3  2000-01-01 01:00:00         KWK           25            52.0
4  2000-01-01 02:00:00         KWK           25            52.1
5  2000-01-01 03:00:00         KWK           25            52.0
6  2000-01-01 04:00:00         KWK           25            52.0
7  2000-01-01 05:00:00         KWK           25            52.0
8  2000-01-01 06:00:00         KWK           25            52.0
9  2000-01-01 07:00:00         KWK           25            52.0
10 2000-01-01 08:00:00         KWK           25            52.0
# ... with 165,544 more rows
```

# Details 

The CDEC web services are a mess! Queries do not always respond and the service 
that fulfills a query is not always the same. The most reliable queries are those
from the SHEF download service. This returns a SHEF file, for which the `fehs` 
package is used to convert into a tidy dataframe. 

# Upcoming features

* A shiny interface 
* Dates can be left empty, package knows what to query 
* and more....







