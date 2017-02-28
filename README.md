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

# Details 

The CDEC web services are a mess! Queries do not always respond and the service 
that fulfills a query is not always the same. The most reliable queries are those
from the SHEF download service. This returns a SHEF file, for which the `fehs` 
package is used to convert into a tidy dataframe. 

# Upcoming features

* A shiny interface 
* Dates can be left empty, package knows what to query 
* and more....







