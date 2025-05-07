#' Impute hurricane tracks to finer time scale
#'
#' Inputs data on a hurricane's track and imputes to a finer time resolution.
#' For example, if the hurricane tracks are recorded at 6-hour intervals, this
#' could be used to impute locations and windspeeds at 15-minute intervals.
#' This function also does some reformatting necessary for later functions in
#' the \code{stormwindmodel} package.
#'
#' @details The function uses natural cubic splines for interpolation for location
#' and linear splines for interpolation for wind speed.
#'
#' @param hurr_track Dataframe with hurricane track data for a single
#'    storm. The dataframe must include columns for date-time (year, month, day,
#'    hour, minute; e.g., "198808051800" for August 5, 1988, 18:00 UTC),
#'    latitude, longitude (in degrees East), and wind speed (in knots). The column
#'    names for each of these must be \code{date}, \code{latitude},
#'    \code{longitude}, and \code{wind}. See the example \code{\link{floyd_tracks}}
#'    dataset for an example of the required format.
#' @param tint Interval (in hours) to which to interpolate the tracks. The
#'    default is 0.25 (i.e., 15 minutes).
#'
#' @return A version of the storm's track data with
#'    latitude, longitude, and wind speed interpolated between
#'    observed values. Also, wind speed is converted in this function to m / s
#'    and the absolute value of the latitude is taken (necessary for further
#'    wind speed calculations). Finally, the names of some columns are
#'    changed (\code{tclat} for latitude, \code{tclon} for longitude, and
#'    \code{vmax} for wind speed.)
#'
#' @note This function imputes between each original data point, and it starts
#'    by determining the difference in time between each pair of data points.
#'    Because of this, the function can handle data that includes a point
#'    that is not at one of the four daily synoptic times (00:00, 06:00, 12:00,
#'    and 18:00). Typically, the only time hurricane observations are given
#'    outside of synoptic times for best tracks data is at landfall.
#'
#' @note After imputing the tracks, longitude is expressed as a positive number.
#'    This is so the output will work correctly in later functions to fit the
#'    wind model. However, be aware that you should use the negative value of
#'    longitude for mapping tracks from the output from this function.
#'
#' @examples
#' data("floyd_tracks")
#' full_track <- create_full_track(hurr_track = floyd_tracks)
#'
#' # Interpolate to every half hour (instead of default 15 minutes)
#' full_track <- create_full_track(hurr_track = floyd_tracks, tint = 0.5)
#'
#' @export
create_full_track <- function(hurr_track = stormwindmodel::floyd_tracks,
                              tint = 0.25){
  hurr_track <- hurr_track[c("date", "latitude", "longitude", "wind")]
  colnames(hurr_track) <- c("date", "tclat", "tclon", "vmax")
  hurr_track$date <- as.POSIXct(hurr_track$date, format = "%Y%m%d%H%M")
  hurr_track$tclat <- as.numeric(hurr_track$tclat)
  hurr_track$tclon <- as.numeric(hurr_track$tclon)
  hurr_track$vmax <- units::set_units(hurr_track$vmax, "knots") |>
    units::set_units("m/s") |>
    as.numeric() |>
    round(3)
    
  hurr_track$track_time_simple = as.numeric(
    difftime(hurr_track$date, hurr_track$date[1], units = "hour")
  )
    
    
  # Identify cases where a storm goes over the international date line, and
  # longitudes change from about 180 to about -180, or vice versa. Correct this
  # before interpolating (then later we get everything back within the 180 to -180
  # range).
  if (diff(range(hurr_track$tclon)) > 300) {
    hurr_track$tclon <- ifelse(hurr_track$tclon > 0, hurr_track$tclon, hurr_track$tclon + 360)
  }

  interp_time <- seq(
    from = hurr_track$track_time_simple[[1]], 
    to = hurr_track$track_time_simple[[nrow(hurr_track)]], 
    by = tint
  )
  tclat <- sapply(interp_time, function(time_to_interp) {
    interpolate_spline(
      x = hurr_track$track_time_simple,
      y = hurr_track$tclat,
      new_x = time_to_interp
    )
  })
  tclon <- sapply(interp_time, function(time_to_interp) {
    interpolate_spline(
      x = hurr_track$track_time_simple,
      y = hurr_track$tclon,
      new_x = time_to_interp
    )
  })
  tclon <- ((tclon + 180) %% 360) - 180
  vmax <- sapply(interp_time, function(time_to_interp) {
    interpolate_line(
      x = hurr_track$track_time_simple,
      y = hurr_track$vmax,
      new_x = time_to_interp
    )
  })
  date <- hurr_track$date[1] + (3600 * interp_time)

  full_track <- data.frame(date, tclat, tclon, vmax)

  return(full_track)
}
