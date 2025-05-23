% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{county_points}
\alias{county_points}
\title{Eastern U.S. county latitude and longitudes}
\format{
A dataframe with 2,396 rows and 3 variables:
\describe{
   \item{fips}{A character vector giving the county's five-digit Federal
               Information Processing Standard (FIPS) code}
   \item{glat}{A numeric vector giving the latitude of the population mean
                   center of each county}
   \item{glon}{A numeric vector giving the longitude of the population mean
                    center of each county}
   \item{glandsea}{A logical vector specifying whether each grid point is over
                    land (TRUE) or over water (FALSE).}
}
}
\source{
\url{http://www2.census.gov/geo/docs/reference/cenpop2010/county/CenPop2010_Mean_CO.txt}
}
\usage{
county_points
}
\description{
A dataframe containing locations of population mean centers for counties in
the eastern United States. Each county is identified by its 5-digit Federal
Information Processing Standard (FIPS) code. This dataframe can be used to
model storm winds at each county center. This dataset was put together using
a dataframe from the U.S. Census Bureau, which was pulled from the website
listed in "Source".
}
\keyword{datasets}
