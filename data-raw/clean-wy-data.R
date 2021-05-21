# copied text without headers starting at 1906 from
# http://cdec.water.ca.gov/cgi-progs/iodir/WSIHIST and saved file as wy.text
# 6/14/2017, updated 02/13/19
library(readr)
library(dplyr)
wy <- readr::read_table('data-raw/wy.txt', col_names = FALSE)

sac <- dplyr::mutate(wy[ , 1:6], location = 'Sacramento Valley')
san_joaquin <- dplyr::mutate(wy[ , c(1, 7:11)], location = 'San Joaquin Valley')

names(sac) <- c('WY', 'Oct_Mar', 'Apr_Jul', 'WYsum', 'Index', 'Yr_type', 'location')
names(san_joaquin) <- c('WY', 'Oct_Mar', 'Apr_Jul', 'WYsum', 'Index', 'Yr_type', 'location')

water_year_indices <- dplyr::bind_rows(sac, san_joaquin) %>%
  dplyr::mutate(Yr_type = factor(Yr_type, levels = c('C', 'D', 'BN', 'AN', 'W'),
                                 labels = c('Critical', 'Dry', 'Below Normal', 'Above Normal', 'Wet')))

devtools::use_data(water_year_indices, overwrite = TRUE)
