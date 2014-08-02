## =============================================================================
## [RUGS Visualisation]: Step 1 - Data Preparation
## =============================================================================

## Author: Jo-fai Chow

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Import Raw Data
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rugs <- read.csv("./data/rugs_ww_june_11_14.csv", stringsAsFactors=FALSE)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Create a new dataframe and update lat/lon information
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df_rugs <- data.frame(matrix(NA, nrow = nrow(rugs), ncol = (ncol(rugs) + 2)))
colnames(df_rugs) <- c(colnames(rugs), "lat", "lon")
df_rugs[, 1:5] <- rugs[,]


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Load cities databases from 'maps' package
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(maps)
data(world.cities)
data(us.cities)
data(canada.cities)
df_cities <- rbind(world.cities, us.cities, canada.cities)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Update Information (also using this step to cross check the original rugs table)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for (n_row in 1:nrow(df_rugs)) {
  row_match <- which(df_cities$name == df_rugs[n_row,]$City)
  if (length(row_match) > 0) df_rugs[n_row, 6:7] <- df_cities[row_match, 4:5]
}

## Filter out the records that may need correct
print(df_rugs[which(is.na(df_rugs[,7])),])

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Manually Update Records (some cities have different spellings) ...
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Chang Mai -> Chiang Mai
df_rugs[2, ]$City <- 'Chiang Mai'
df_rugs[2, ]$Name <- 'Chiang Mai R User Group'

## Channai -> Chennai
df_rugs[4, ]$City <- 'Chennai'

## Budapwst -> Budapest
df_rugs[30, ]$City <- 'Budapest'

# Group Name: Grupo de Interés Local de Madrid
df_rugs[49, ]$Name <- "Grupo de Interés Local de Madrid"

# Albany, United states -> United States
df_rugs[139, ]$Country <- "United States"

## Charlotte, United States -> Charlotte
df_rugs[140, ]$City <- "Charlotte"
df_rugs[140, ]$Country <- "United States"

## Kansas CIty -> Kansas City
df_rugs[89, ]$City <- "Kansas City"

## Remove the extra Kansas City record
df_rugs <- df_rugs[-90, ]


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Update the missing lat/lon information as well as cross-checking
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(ggmap)

for (n_rugs in 1:nrow(df_rugs)) {

  ## Create temp city name
  tmp_city <- paste0(df_rugs[n_rugs,]$City, ", ", df_rugs[n_rugs,]$Country)

  ## Update lat/lon if it is missing
  if (is.na(df_rugs[n_rugs,]$lat)) {

    ## Get geocode from Google
    tmp_geo <- geocode(tmp_city)
    df_rugs[n_rugs,]$lat <- tmp_geo$lat
    df_rugs[n_rugs,]$lon <- tmp_geo$lon

    } else {

      ## Cross-check geocode
      tmp_geo <- geocode(tmp_city)
      diff_lat <- abs(df_rugs[n_rugs, ]$lat - tmp_geo$lat)
      diff_lon <- abs(df_rugs[n_rugs, ]$lon - tmp_geo$lon)
      diff_max <- max(c(diff_lat, diff_lon))

      ## If the difference is huge, use Google's geocode
      if (diff_max > 0.05) {
        df_rugs[n_rugs, ]$lat <- tmp_geo$lat
        df_rugs[n_rugs, ]$lon <- tmp_geo$lon
      }
  }
}

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Adjust the lat/lon of multiple RUGS in the same city
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Find duplicated cities and seperate them
name_dup <- df_rugs[which(duplicated(df_rugs$City)), ]$City
row_dup <- which(df_rugs$City %in% name_dup)
df_rugs_multi <- df_rugs[row_dup, ]
df_rugs_single <- df_rugs[-row_dup, ]

## As the max number of multi groups is 2 in all these cities,
## I use a simple odd/even rule here ... adjust the lon values only
for (n_rugs in 1:nrow(df_rugs_multi)) {
  if ((n_rugs %% 2) == 1) {
    df_rugs_multi[n_rugs, ]$lon <- df_rugs_multi[n_rugs, ]$lon + 0.05
  } else {
    df_rugs_multi[n_rugs, ]$lon <- df_rugs_multi[n_rugs, ]$lon - 0.05
  }
}

## Create the final df_rugs
df_rugs <- rbind(df_rugs_multi, df_rugs_single)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Replace "/" with "or"
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(stringr)
df_rugs$Region <- str_replace(df_rugs$Region, "/", "or")


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Write the final table to CSV
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df_rugs[, 6] <- round(df_rugs[, 6], 5)
df_rugs[, 7] <- round(df_rugs[, 7], 5)
write.csv(df_rugs, file ="./data/rugs_updated.csv", row.names=F)

## =============================================================================
## End of Script
## =============================================================================
