% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{calc_forward_speed}
\alias{calc_forward_speed}
\title{Calculate storm's forward speed}
\usage{
calc_forward_speed(tclat_1, tclon_1, time_1, tclat_2, tclon_2, time_2)
}
\arguments{
\item{tclat_1}{A numeric vector giving latitude of the first location
(degrees)}

\item{tclon_1}{A numeric vector giving longitude of the first location
(degrees). This value should be expressed as a positive value for Western
hemisphere longitudes.}

\item{time_1}{A date-time vector giving the time of the first observation.}

\item{tclat_2}{A numeric vector giving latitude of the second location
(degrees)}

\item{tclon_2}{A numeric vector giving longitude of the second location
(degrees). This value should be expressed as a positive value for Western
hemisphere longitudes.}

\item{time_2}{A date-time vector giving the time of the second observation.}
}
\value{
A numeric vector with the average forward speed of the storm between
   the two observations, in meters per second.
}
\description{
This storm takes two storm locations and their observations times and
calculates the average speed of the storm between the two observations.
}
