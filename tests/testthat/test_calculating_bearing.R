## Checked against values in https://planetcalc.com/7042/
## Those give in cardinal coordinates (0 is North, 90 is East, etc.), while we
## calculate in polar coordinates (0 is East, 90 is North, etc.). Converted using
## calc_polar <- function (x) (90 - x) %% 360

## Estimates of storm direction are also available through IBTrACS, although they
## use a coordinate system where north is 0, east is 90, etc.

test_that("Bearing calculation correct for North Atlantic basin storm", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Laura", "North Atlantic", lubridate::ymd_hms("2020-08-27 03:00:00"), 29.10, -93.15,
    "Laura", "North Atlantic", lubridate::ymd_hms("2020-08-27 06:00:00"), 29.80, -93.30
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 101 + 1)
  expect_gt(bear, 101 - 1)
})

test_that("Bearing calculation correct for Eastern Pacific basin storm", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Douglas", "Eastern Pacific", lubridate::ymd_hms("2020-07-24 00:00:00"), 14.60, -138.00,
    "Douglas", "Eastern Pacific", lubridate::ymd_hms("2020-07-24 03:00:00"), 14.95, -138.74
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 154 + 1)
  expect_gt(bear, 154 - 1)
})

test_that("Bearing calculation correct for Western Pacific basin storm", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Haishen", "Western Pacific", lubridate::ymd_hms("2020-09-06 21:00:00"), 34.31, 128.97,
    "Haishen", "Western Pacific", lubridate::ymd_hms("2020-09-07 00:00:00"), 35.50, 128.90
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 93 + 1)
  expect_gt(bear, 93 - 1)
})

test_that("Bearing calculation correct for Northern Indian basin storm", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Amphan", "Northern Indian", lubridate::ymd_hms("2020-05-20 00:00:00"), 19.20, 87.40,
    "Amphan", "Northern Indian", lubridate::ymd_hms("2020-05-20 03:00:00"), 19.79, 87.66
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 67 + 1)
  expect_gt(bear, 67 - 1)
})

test_that("Bearing calculation correct for Southern Indian basin storm", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Belna", "Southern Indian", lubridate::ymd_hms("2019-12-09 12:00:00"), -12.40, 46.50,
    "Belna", "Southern Indian", lubridate::ymd_hms("2019-12-09 15:00:00"), -12.63, 46.41
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 249 + 1)
  expect_gt(bear, 249 - 1)
})

test_that("Bearing calculation correct for Southern Pacific basin storm", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Harold", "Southern Pacific", lubridate::ymd_hms("2020-04-03 12:00:00"), -12.70, 163.00,
    "Harold", "Southern Pacific", lubridate::ymd_hms("2020-04-03 15:00:00"), -13.71, 163.41
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 292 + 1)
  expect_gt(bear, 292 - 1)
})

test_that("Bearing calculation correct for Southern Atlantic basin storm", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Not Named", "Southern Atlantic", lubridate::ymd_hms("2004-03-28 06:00:00"), -29.00, -49.60,
    "Not Named", "Southern Atlantic", lubridate::ymd_hms("2004-03-28 09:00:00"), -28.77, -49.93
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 142 + 1)
  expect_gt(bear, 142 - 1)
})

test_that("Bearing calculation correct for crossing prime meridian", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Ophelia", "crossed prime meridian", lubridate::ymd_hms("2005-09-22 12:00:00"), 65.60, -1.00,
    "Ophelia", "crossed prime meridian", lubridate::ymd_hms("2005-09-22 18:00:00"), 66.60, 1.90
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 42 + 1)
  expect_gt(bear, 42 - 1)
})

test_that("Bearing calculation correct for crossing international date line", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Harold", "crossed international date line", lubridate::ymd_hms("2020-04-08 06:00:00"), -20.11, 179.70,
    "Harold", "crossed international date line", lubridate::ymd_hms("2020-04-08 12:00:00"), -20.60, -178.1
  )
  
  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 346 + 1)
  expect_gt(bear, 346 - 1)
})

test_that("Bearing calculation correct for crossing international date line, IBTrACS conventions", {
  storm <- tibble::tribble(
    ~ storm_name, ~ basin, ~ time, ~ lat, ~ lon,
    "Harold", "crossed international date line IBTrACS", lubridate::ymd_hms("2020-04-08 06:00:00"), -20.11, 179.70,
    "Harold", "crossed international date line IBTrACS", lubridate::ymd_hms("2020-04-08 12:00:00"), -20.60, 181.90
  )

  bear <- calc_bearing(tclat_1 = storm$lat[1],
                       tclon_1 = storm$lon[1],
                       tclat_2 = storm$lat[2],
                       tclon_2 = storm$lon[2]
  )
  expect_lt(bear, 346 + 1)
  expect_gt(bear, 346 - 1)
})
