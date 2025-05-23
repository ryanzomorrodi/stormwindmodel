% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{add_inflow}
\alias{add_inflow}
\title{Add inflow to direction of surface winds}
\usage{
add_inflow(gwd, cdist, Rmax, tclat, glandsea)
}
\arguments{
\item{gwd}{A numeric value with the gradient wind direction in polar degrees
(e.g., due east is 0 degrees, due north is 90 degrees)}

\item{cdist}{The distance from the center of the storm to the location at
which the wind is being modeled (in kilometers)}

\item{Rmax}{A numeric value with the radius at which maximum winds occur in kilometers}

\item{tclat}{A numeric value with latitude in radians}

\item{glandsea}{A logical value that specifies whether the location at which
the wind is being modeled is over land (TRUE) or over water (FALSE)}
}
\value{
swd A numeric value with the surface wind direction in polar degrees
  (e.g., due east is 0, due north is 90)
}
\description{
This function adds an inflow angle to the angle of the wind direction.
It calculates an inflow angle as a function of the distance from the
storm center to a location (Phadke et al. 2003). If the locations is over
land, it then adds 20 degrees to this inflow angle to account for the location
being over land rather than over water.
}
\details{
This function uses equations 11a-c from Phadke et al. (2003).
}
\references{
Phadke AC, Martino CD, Cheung KF, and Houston SH. 2003. Modeling of
   tropical cyclone winds and waves for emergency management. Ocean
   Engineering 30(4):553-578.
}
