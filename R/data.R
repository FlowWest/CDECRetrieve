#' Water Year Index and Type 1906-2017
#'
#' @description
#' \strong{Department of Water Resources}
#'
#' \url{http://cdec.water.ca.gov/cgi-progs/iodir/WSIHIST}
#'
#' California Cooperative Snow Surveys / Chronological Reconstructed Sacramento and San Joaquin Valley
#'
#' Water Year Hydrologic Classification Indices based on measured unimpaired runoff (in million acre-feet), subject to revision.
#'
#' \strong{Abbreviations:}
#' \itemize{
#' \item WY - Water year (Oct 1 - Sep 30)
#' \item W - Wet year type
#' \item AN - Above normal year type
#' \item BN - Below normal year type
#' \item D - Dry year type
#' \item C - Critical year type
#' }

#' Notes:
#'
#' Unimpaired runoff represents the natural water production of a river basin,
#' unaltered by upstream diversions, storage, export of water to or import of
#' water from other basins.
#'
#' Sacramento River Runoff is the sum (in maf) of Sacramento River at Bend Bridge,
#' Feather River inflow to Lake Oroville, Yuba River at Smartville, and
#' American River inflow to Folsom Lake.  The WY sum is also known as the
#' Sacramento River Index, and was previously referred to as the "4 River Index" or
#' "4 Basin Index".  It was previously used to determine year type classifications
#' under State Water Resources Control Board (SWRCB) Decision 1485.
#'
#' Sacramento Valley Water Year Index = 0.4 * Current Apr-Jul Runoff Forecast (in maf)
#' + 0.3 * Current Oct-Mar Runoff in (maf) + 0.3 * Previous Water Year's Index
#'    (if the Previous Water Year's Index exceeds 10.0, then 10.0 is used).
#' This index, originally specified in the 1995 SWRCB Water Quality Control Plan,
#' is used to determine the Sacramento Valley water year type as implemented in
#' SWRCB D-1641.  Year types are set by first of month forecasts beginning in
#' February.  Final determination is based on the May 1 50% exceedence forecast.
#'
#'  \strong{Sacramento Valley Water Year Hydrologic Classification:}
#'  \itemize{
#'  \item Wet - Equal to or greater than 9.2
#'  \item Above Normal - Greater than 7.8, and less than 9.2
#'  \item Below Normal - Greater than 6.5, and equal to or less than 7.8
#'  \item Dry - Greater than 5.4, and equal to or less than 6.5
#'  \item Critical - Equal to or less than 5.4
#'  }
#'
#' San Joaquin River Runoff is the sum of Stanislaus River inflow to New Melones
#' Lake, Tuolumne River inflow to New Don Pedro Reservoir, Merced River inflow
#' to Lake McClure, and San Joaquin River inflow to Millerton Lake (in maf).
#' San Joaquin Valley Water Year Index = 0.6 * Current Apr-Jul Runoff Forecast (in maf)
#' + 0.2 * Current Oct-Mar Runoff in (maf) + 0.2 * Previous Water Year's Index
#'    (if the Previous Water Year's Index exceeds 4.5, then 4.5 is used).
#'
#' This index, originally specified in the 1995 SWRCB Water Quality Control Plan,
#' is used to determine the San Joaquin Valley water year type as implemented in
#' SWRCB D-1641.  Year types are set by first of month forecasts beginning in
#' February.  Final determination for San Joaquin River flow objectives is based
#' on the May 1 75% exceedence forecast.
#'
#' \strong{San Joaquin Valley Water Year Hydrologic Classification:}
#' \itemize{
#' \item Wet - Equal to or greater than 3.8
#' \item Above Normal - Greater than 3.1, and less than 3.8
#' \item Below Normal - Greater than 2.5, and equal to or less than 3.1
#' \item Dry - Greater than 2.1, and equal to or less than 2.5
#' \item Critical - Equal to or less than 2.1
#' }
#'
#' Eight River Index = Sacramento River Runoff + San Joaquin River Runoff
#' This Index is used from December through May to set flow objectives
#' as implemented in SWRCB Decision 1641.
#'
#'
#' @format A data frame with 227 rows and 7 variables:
#' \describe{
#' \item{wy}{October-September}
#' \item{oct_mar}{Runoff (maf)}
#' \item{apr_jul}{Runoff (maf)}
#' \item{wy_sum}{Year Total Runoff (maf)}
#' \item{index}{Water Year Type Index Score}
#' \item{yr_type}{Water Year Type}
#' \item{location}{Sacramento Valley or San Joaquin Valley}
#' }
#'
#' @examples
#' head(water_year_indices)
#'
#' @source California Department of Water Resources, California Data Exchange Center (CDEC)
'water_year_indices'
