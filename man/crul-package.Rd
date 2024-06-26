% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crul-package.r
\docType{package}
\name{crul-package}
\alias{crul}
\alias{crul-package}
\title{crul: HTTP Client}
\description{
\if{html}{\figure{logo.png}{options: style='float: right' alt='logo' width='120'}}

A simple HTTP client, with tools for making HTTP requests, and mocking HTTP requests. The package is built on R6, and takes inspiration from Ruby's 'faraday' gem (\url{https://rubygems.org/gems/faraday}). The package name is a play on curl, the widely used command line tool for HTTP, and this package is built on top of the R package 'curl', an interface to 'libcurl' (\url{https://curl.se/libcurl/}).
}
\section{Package API}{

\itemize{
\item \code{\link[=HttpClient]{HttpClient()}} - create a connection client, set all
your http options, make http requests
\item \code{\link[=HttpResponse]{HttpResponse()}} - mostly for internal use, handles
http responses
\item \code{\link[=Paginator]{Paginator()}} - auto-paginate through requests
\item \code{\link[=Async]{Async()}} - asynchronous requests
\item \code{\link[=AsyncVaried]{AsyncVaried()}} - varied asynchronous requests
\item \code{\link[=HttpRequest]{HttpRequest()}} - generate an HTTP request, mostly for
use in building requests to be used in \code{Async} or \code{AsyncVaried}
\item \code{\link[=mock]{mock()}} - Turn on/off mocking, via \code{webmockr}
\item \code{\link[=auth]{auth()}} - Simple authentication helper
\item \code{\link[=proxy]{proxy()}} - Proxy helper
\item \code{\link[=upload]{upload()}} - File upload helper
\item set curl options globally: \code{\link[=set_auth]{set_auth()}}, \code{\link[=set_headers]{set_headers()}},
\code{\link[=set_opts]{set_opts()}}, \code{\link[=set_proxy]{set_proxy()}}, and \code{\link[=crul_settings]{crul_settings()}}
}
}

\section{HTTP verbs (or HTTP request methods)}{


See \link{verb-GET}, \link{verb-POST}, \link{verb-PUT}, \link{verb-PATCH}, \link{verb-DELETE},
\link{verb-HEAD} for details.
\itemize{
\item \link{HttpClient} is the main interface for making HTTP requests,
and includes methods for each HTTP verb
\item \link{HttpRequest} allows you to prepare a HTTP payload for use with
\link{AsyncVaried}, which provides asynchronous requests for varied
HTTP methods
\item \link{Async} provides asynchronous requests for a single HTTP method
at a time
\item the \code{verb()} method can be used on all the above to request
a specific HTTP verb
}
}

\section{Checking HTTP responses}{


\code{\link[=HttpResponse]{HttpResponse()}} has helpers for checking and raising warnings/errors.
\itemize{
\item \link{content-types} details the various options for checking content
types and throwing a warning or error if the response content
type doesn't match what you expect. Mis-matched content-types are
typically a good sign of a bad response. There's methods built
in for json, xml and html, with the ability to set any
custom content type
\item \code{raise_for_status()} is a method on \code{\link[=HttpResponse]{HttpResponse()}} that checks
the HTTP status code, and errors with the appropriate message for
the HTTP status code, optionally using the package \code{fauxpas}
if it's installed.
}
}

\section{HTTP conditions}{

We use \code{fauxpas} if you have it installed for handling HTTP
conditions but if it's not installed we use \pkg{httpcode}
}

\section{Mocking}{

Mocking HTTP requests is supported via the \pkg{webmockr}
package. See \link{mock} for guidance, and
\url{https://books.ropensci.org/http-testing/}
}

\section{Caching}{

Caching HTTP requests is supported via the \pkg{vcr}
package. See \url{https://books.ropensci.org/http-testing/}
}

\section{Links}{


Source code: \url{https://github.com/ropensci/crul}

Bug reports/feature requests: \url{https://github.com/ropensci/crul/issues}
}

\seealso{
Useful links:
\itemize{
  \item \url{https://docs.ropensci.org/crul/}
  \item \url{https://github.com/ropensci/crul}
  \item \url{https://books.ropensci.org/http-testing/}
  \item Report bugs at \url{https://github.com/ropensci/crul/issues}
}

}
\author{
\strong{Maintainer}: Scott Chamberlain \email{myrmecocystus@gmail.com} (\href{https://orcid.org/0000-0003-1444-9135}{ORCID})

}
\keyword{internal}
