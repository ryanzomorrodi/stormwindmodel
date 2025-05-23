test_that("Wind speed estimates are reasonable for Hurricane Katrina", {
  orleans_and_miami <- county_points[county_points$gridid %in% c("22071", "12086"), ]

  katrina_wind <- calc_grid_winds(grid_df = orleans_and_miami,
                                   hurr_track = stormwindmodel::katrina_tracks)

  orleans_max <- max(katrina_wind[["vmax_sust"]][, "22071"], na.rm = TRUE)
  miami_max <- max(katrina_wind[["vmax_sust"]][, "12086"], na.rm = TRUE)

  # Expectation based on https://www.nhc.noaa.gov/data/tcr/AL122005_Katrina.pdf
  # "The strongest sustained wind in New Orleans is subject to speculation since
  # observations are sparse, due in part to the power failures that disabled ASOS
  # stations in the area before peak wind conditions occurred. A few instrumented
  # towers placed in various locations in the metropolitan area by the Florida Coastal
  # Monitoring Program (FCMP) and by Texas Tech University measured sustained winds in
  # the range of 61-68 kt." 61 knots = 31.4 m/s, 68 knots = 35.0 m/s
  expect_true(30 <= orleans_max & orleans_max <= 40)

  # Expectation based on https://www.nhc.noaa.gov/data/tcr/AL122005_Katrina.pdf
  # "While the eye moved west-southwestward over northern Miami-Dade, it passed over the
  # NWS Miami Forecast Office / National Hurricane Center facility near Sweetwater, Florida
  # (Fig. 4), where a pressure of 983 mb was measured at 0105 UTC 26 August. The eastern
  # eyewall moved over the facility a few minutes later and sustained winds of 60 kt with a
  # gust to 76 kt were measured near 0115 UTC. The strongest sustained wind measured by a
  # land-based anemometer was 63 kt on Virginia Key" 60 knots = 30.9 m/s, 63 knots = 32.4 m/s
  expect_true(25 <= miami_max & miami_max <= 35)

})

test_that("Wind speed estimates are reasonable for Hurricane Michael", {
  michael_track <- hurricaneexposuredata::hurr_tracks[
    hurricaneexposuredata::hurr_tracks$storm_id == "Michael-2018", 
  ]

  bay_county_location <- county_points[county_points$gridid == "12005", ]

  bay_michael_wind <- calc_grid_winds(grid_df = bay_county_location,
                                       hurr_track = michael_track)
  bay_county_max <- max(bay_michael_wind[["vmax_sust"]][, "12005"], na.rm = TRUE)

  # Expect sustained winds in Bay County, FL (county of Michael's landfall)
  # to be higher than Category 3 (The storm was Category 5 at landfall, but
  # the county center is not right at the landfall.)
  expect_true(bay_county_max >= 49.6)

  # County FIPS with winds over 64 knots (32.9 m/s) based on Best Tracks wind radii
  highest_wind_locs <- hurricaneexposuredata::ext_tracks_wind[
    hurricaneexposuredata::ext_tracks_wind$storm_id == "Michael-2018" &
      hurricaneexposuredata::ext_tracks_wind$vmax_sust == 32.9216,
  ]$fips

  michael_high_winds <- calc_grid_winds(
    hurr_track = michael_track,
    grid_df = county_points[county_points$gridid %in% highest_wind_locs, ]
  )
  michael_high_winds_vmax <- as.vector(apply(
    michael_high_winds[["vmax_sust"]],
    MARGIN = 2, 
    FUN = max, 
    na.rm = TRUE
  ))

  # Leave about 5 m/s variation room around the 32.9216 threshold from the wind radii
  expect_true(all(michael_high_winds_vmax > 28))
  expect_true(mean(michael_high_winds_vmax) > 32.9216)

  # County FIPS with winds between 50 knots (25.72 m/s) and 64 knots (32.9 m/s) based on
  # Best Tracks wind radii
  mid_wind_locs <- hurricaneexposuredata::ext_tracks_wind[
    hurricaneexposuredata::ext_tracks_wind$storm_id == "Michael-2018" & 
      hurricaneexposuredata::ext_tracks_wind$vmax_sust == 25.7200,
  ]$fips

  michael_mid_winds <- calc_grid_winds(
    hurr_track = michael_track,
    grid_df = county_points[county_points$gridid %in% mid_wind_locs, ]
  )
  michael_mid_winds_vmax <- as.vector(apply(
    michael_mid_winds[["vmax_sust"]],
    MARGIN = 2, 
    FUN = max, 
    na.rm = TRUE
  ))

  # Allow some variation room around the 25.72 and 32.9216 thresholds
  # from the wind radii
  expect_true(all(15 <= michael_mid_winds_vmax &
                    michael_mid_winds_vmax <= 45))
  expect_true(25.72 <= mean(michael_mid_winds_vmax) &
                mean(michael_mid_winds_vmax) <= 32.9216)

  # County FIPS with winds between 34 knots (17.4896 m/s) and 50 knots (25.72 m/s) based on
  # Best Tracks wind radii
  low_wind_locs <- hurricaneexposuredata::ext_tracks_wind[
    hurricaneexposuredata::ext_tracks_wind$storm_id == "Michael-2018" &
      hurricaneexposuredata::ext_tracks_wind$vmax_sust == 17.4896,
  ]$fips
  michael_low_winds <- calc_grid_winds(
    hurr_track = michael_track,
    grid_df = county_points[county_points$gridid %in% low_wind_locs, ]
  )
  michael_low_winds_vmax <- as.vector(apply(
    michael_low_winds[["vmax_sust"]],
    MARGIN = 2, 
    FUN = max, 
    na.rm = TRUE
  ))

  # Allow some variation room around the 25.72 upper threshold
  # from the wind radii
  expect_true(all(michael_low_winds_vmax <= 36))
  expect_true(mean(michael_low_winds_vmax) <= 25.72)

})

test_that("Wind estimates agree with hand calculations", {
  ex_counties <- county_points[
    county_points$gridid %in% c("22071", "22075", "22087", "22051", "28045", "28047", "28059"), 
  ]

  ex_winds <- calc_grid_winds(hurr_track = stormwindmodel::katrina_tracks,
                               grid_df = ex_counties)
  ex_winds <- ex_winds[["vmax_sust"]]
  ex_max_winds <- as.data.frame(ex_winds)
  ex_max_winds$date <- rownames(ex_max_winds)
  rownames(ex_max_winds) <- NULL

  ex_max_winds <- ex_max_winds[
    as.character(ex_max_winds$date) == "2005-08-29 11:15:00",
  ]

  expect_equal(round(ex_max_winds[["22075"]]), 37)
  expect_equal(round(ex_max_winds[["22087"]]), 32)
  expect_equal(round(ex_max_winds[["22051"]]), 29)
  expect_equal(round(ex_max_winds[["28045"]]), 26)
  expect_equal(round(ex_max_winds[["28047"]]), 24)
  expect_equal(round(ex_max_winds[["28059"]]), 22)
})

