# CDECRetrieve

![travis_mater_status](https://travis-ci.org/FlowWest/CDECRetrieve.svg?branch=master)


# What is CDECRetrieve?

CDECRetrieve uses the web services provided by the California Data Exchange Center
[here](http://cdec.water.ca.gov/) as a backend to allow users to download 
data with a single function call. CDECRetrieve specifically uses the SHEF download
service due to the fact that it is the most robust of the services. You can learn 
more about the SHEF format [here](http://www.nws.noaa.gov/om/water/resources/SHEF_CodeManual_5July2012.pdf).
CDECRetrieve came to be after trying to download large amounts of data from CDEC 
for multiple stations. 

# Installation 

Install using `devtools::install_github` 

```r 
devtools::install_github("flowwest/CDECRetrieve")
```

# Usage 

## Basic Usage 

CDECRetrieve exposes several useful functions to query services from CDEC. 
The main function in the package is `cdec_query`, 

```r 
# download data from kwk, sensor 20, duration is event type
kwk_flow <- cdec_query("KWK", "20", "E", "2000-01-01", "2002-01-01")
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


# Details 

The CDEC web services are a mess! Queries do not always respond and the service 
that fulfills a query is not always the same. The most reliable queries are those
from the SHEF download service. The approach taken here is one with an ugly side effect, 
namely a SHEF file is downloaded temporarily to the working environment, this however 
is a huge boost in robustness. Having interacted with other services from CDEC 
none come close the reliability showcased by the SHEF download service. Currently one 
can pull up to 7 years of data with consistent responses. 

In order to go from SHEF --> Tidy, there exist a mapping from SHEF parameter codes 
to those provided through CDEC. At the moment the list of mappings is one that 
satisfies the work we do internally, however these are exposed as a simple list in 
`consts.R` and can be updated to one's needs. Ideally and if needed this can be a 
a static file that gets parsed and brought in to the environment for use. 











