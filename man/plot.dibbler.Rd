% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.dibbler.R
\name{plot.dibbler}
\alias{plot.dibbler}
\title{Plot input data for dibbler}
\usage{
\method{plot}{dibbler}(x, y = NULL, col_pal = dibbler_pal2, ...)
}
\arguments{
\item{x}{A \code{dibbler} object.}

\item{y}{An optional variable from the linelist defining groups used to color
the network.}

\item{col_pal}{A color palette to be used for the groups; defaults to
\code{dibbler_pal2}.}

\item{...}{Further arguments passed to the \code{plot.epicontacts} method.}
}
\description{
This function plots dibbler's input data as a network, using different
symbols and colors for different types of nodes. It uses the package
\code{network}.
}
\examples{

\dontrun{
if (require(outbreaks)) {

  v_data <- s_enteritidis_pt59$graph
  n_data <- data.frame(id = names(s_enteritidis_pt59$cluster),
                       cluster = s_enteritidis_pt59$cluster)

  x <- make_dibbler(v_data, n_data)
  x

  plot(x)
  plot(x, "cluster")
}
}
}
\author{
Thibaut Jombart \email{thibautjombart@gmail.com}
}
