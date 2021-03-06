% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/curl_options.R
\name{curl_verbose}
\alias{curl_verbose}
\title{curl verbose method}
\usage{
curl_verbose(data_out = TRUE, data_in = FALSE, info = FALSE, ssl = FALSE)
}
\arguments{
\item{data_out}{Show data sent to the server}

\item{data_in}{Show data recieved from the server}

\item{info}{Show informational text from curl. This is mainly useful for
debugging https and auth problems, so is disabled by default}

\item{ssl}{Show even data sent/recieved over SSL connections?}
}
\description{
curl verbose method
}
\details{
line prefixes:
\itemize{
\item \code{*} informative curl messages
\item \verb{=>} headers sent (out)
\item \code{>} data sent (out)
\item \verb{*>} ssl data sent (out)
\item \code{<=} headers received (in)
\item \code{<} data received (in)
\item \verb{<*} ssl data received (in)
}
}
\note{
adapted from \code{httr::verbose}
}
