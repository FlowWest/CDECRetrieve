# CDECRetrieve

CDECRetrieve uses the web services provided by the California Data Exchange Center
as a backend to allow users to download data with a single function call. 

# Installation 

Install using `devtools::install_github` 

```r 
devtools::install_github("CDECRetrieve", username="flowwest")
```

*Note* This package currently lives in a private repository an auth token is required
to download and install. Email erodriguez@flowwest.com for key. 

# Usage 

## Basic Usage 

CDECRetrieve exposes several useful functions to query services from CDEC. 
The main function in the package is `retrieve_station_data`, 

```r 
# download data from kwk, sensor 20, duration is event type
kwk_flow <- retrieve_station_data("KWK", "20", "E", "2000-01-01", "2002-01-01")
```

The returned data complies with both tidy data and the structure on the open 
water database 

```r
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

The function does one thing, obtain data from a given station. There are powerful 
tools in R to retrieve multiple stations. Here we use the `purrr` package to map 
across a set of desired CDEC stations. (Adding these as base package functions is
under consideration).

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

This can be placed in a function as follows: 

```r 
query_from_station_list <- function(station_list, sensor_num, dur_code, 
                                    start_date, end_date) {
  resp <- map(station_list, safely(function(x) {
    retrieve_station_data(x, sensor_num, dur_code, start_date, end_date)
  }))
  
  transpose(resp)$result %>% bind_rows()
}
```

## Advanced Usage 

There is no "advanced" way to use CDECRetrieve, rather combining it with `purrr`
allows for great felixbilty. 

**Retrieve Desired Codes** 

Suppose you are interested in water quality attributes for a given station. Much like
we mapped through the station_list we can map through desired codes. 

```r
# water qual codes 
water_qual_codes <- c("04", "14", "25", "27", "61")

kwk_wq <- map(water_qual_codes, safely(function(x) {
  retrieve_station_data("kwk", x, "H", "2000-01-01")
}))

kwk_wq <- transpose(kwk_wq)$result %>% bind_rows()
```

**Retrieve a combination of stations and codes**

Once again we will take advantage of the purrr package to accomplish this.
Like we did before we create vectors of both the stations and sensor numbers
we wish to obtain data for.

```r
# stations codes
station_codes <- c("FRE", "KWK", "BND")

# sensor numbers
wq_codes <- c("25", "66", "61")
```

There is a built in function called `get_locations_list` that can retrieve
such a vector from a file

```r
station_codes <- get_locations_list("data/station_list.txt")
```

We now create a dataframe that expands the above two into rows of all
possible combinations

```r
inputs_to_retrieve <- expand.grid(stations_codes, wq_codes)
```

Lastly we map this dataframe with `retrieve_station_data` function.

```r
resp <- map(inputs_to_retrieve, safely(function(x) {
     retrieve_station_data(x[1,1], x[1,2], "H", "2016-01-01")
}))

# get returned queries
# note this needs a lot improvement since the actual data is burried
results <- transpose(resp$.out)$result
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

# TODO 

* Better error handling, currently relies on `safely` but error outputs should be 
much more informative 









