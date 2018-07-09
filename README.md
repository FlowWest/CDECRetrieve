![cdec_retrieve_logo](cdecretrieve_logo.png)

![travis_mater_status](https://travis-ci.org/FlowWest/CDECRetrieve.svg?branch=master)    [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/CDECRetrieve)](https://cran.r-project.org/package=CDECRetrieve)

![](https://cranlogs.r-pkg.org/badges/CDECRetrieve)

## Recent Updates

`cdec_query()` now uses memoisation by using the `memoise` package. This allows for 
caching of already run queries. The next iteration will allow caching to happen in a 
filesystem or s3 rather than just memory that way regardless of status of CDEC you can
run memoized queries. 

# What is CDECRetrieve?

CDECRetrieve uses the web services provided by the California Data Exchange Center
[here](http://cdec.water.ca.gov/) as a backend to allow users to download 
data with a single function call. CDECRetrieve specifically uses the SHEF download
service due to the fact that it is the most robust of the services. You can learn 
more about the SHEF format [here](http://www.nws.noaa.gov/om/water/resources/SHEF_CodeManual_5July2012.pdf).

The design of this package maps different CDEC url endpoints into "services" that 
make sense. For example there is a **datasets** service that allows the user to 
view all datasets available at a given location. There is **query/data** service
that allows the user to bring observations into memory. The goal is to allow a
workflow where a user can pipe reponses from one service into another, and eventually
into the **data** service to get the data, and be able to automate this process.

Please see the *Details* section below for limitations and possible annoyances 
inherited from the CDEC service.

# Installation 

```r 
# stable version 
package.install("CDECRetrieve")

# dev version
devtools::install_github("flowwest/CDECRetrieve")
```

# Basic Usage 

CDECRetrieve exposes several useful functions to query services from CDEC. 
The main function in the package is `cdec_query`, 

```r 
# download data from kwk, sensor 20, duration is event type
kwk_flow <- cdec_query("KWK", "20", "E", "2000-01-01", "2002-01-01")
```

The data returned,

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

Visualize these flows,


```r 
library(dplyr)
library(ggplot2)

kwk_flow %>% 
  filter(parameter_value >= 0) %>% # sentinel values -9998 and -9997 are present
  ggplot(aes(datetime, parameter_value)) + 
  geom_line()
```

![kwk](https://raw.githubusercontent.com/FlowWest/CDECRetrieve/master/images/kwk_flow_ts.png)

*Note that appart from replacing sentinel values with appropriate NA values, 
the package does no QA/QC. This can be seen in the plot above, where suspicoius 
values are apparent.*


# Details 


### Why use shef?

The package uses the shef download service to download the data. It was chosen
for its undocumented ability to download multiple years of data with one call,
something the csv service can not do.


### Why I download to a temp dir

If you read the code you will note that it downloads a temp file to the operating 
system's temp directory, it then parses the resulting file after reading in 
with `read_csv`. The same work can be done with `httr::GET`, where instead the parsing
happens in memory with one of `*apply` functions or `purrr::map`. I chose for the first
method eventhough its got a really ugly side effect. 

Here are some benchmarks for the first and second method:

*Download Method*

| min       |lq     |mean      |median       |uq      |max     |neval|
|----------|---------|--------|-------------|-------|---------|-----------|
| 2.093852 |2.460448| 2.548882| 2.563623| 2.691349| 2.868398|    100|
 

*HTTR Method*

|min       |lq        |mean   |median       |uq     | max     |neval|
|----------|---------|--------|-------------|-------|---------|-----------|
|5.786492| 5.923293| 6.968335 |5.949256 |6.527922 |11.66943 |   100|

the benchmark expression used were:

```r
# for the download method
CDECRetrieve::cdec_query("kwk", "20", "h", "2010-01-01", "2018-01-01")

# for the HTTR method
s <- "http://cdec.water.ca.gov/cgi-progs/querySHEF"

q <- list(
  station_id = "kwk",
  sensor_num = "20",
  dur_code = "h",
  start_date = "2010-01-01",
  end_date = "2018-01-01"
)

resp <- httr::GET(s, query = q)
cont <- httr::content(resp)
in_rows <- unlist(strsplit(cont, "\n"))
data_rows <- in_rows[9:length(in_rows)]

parse_func <- function(line) {
  split_at_sapce <- trimws(unlist(strsplit(line, " ")))
  list(
    location_id = split_at_space[2],
    date = split_at_space[3],
    time = split_at_space[5],
    shef_code = split_at_space[6],
    value = split_at_space[7]
  )
}

purrr::map_df(data_rows, parse_func)
```

