## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  warning = FALSE,
  message = FALSE
)

## ------------------------------------------------------------------------
library("crul")

## ------------------------------------------------------------------------
make_request <- function(url) {
  # create a HttpClient object, defining the url
  cli <- crul::HttpClient$new(url = url)
  # do a GET request
  res <- cli$get()
  # check to see if request failed or succeeded
  # - if succeeds this will return nothing and proceeds to next step
  res$raise_for_status()
  # parse response to plain text (JSON in this case) - most likely you'll 
  # want UTF-8 encoding
  txt <- res$parse("UTF-8")
  # parse the JSON to an R list
  jsonlite::fromJSON(txt)
}

## ------------------------------------------------------------------------
make_request("https://httpbin.org/get")

## ------------------------------------------------------------------------
make_request2 <- function(url, ...) {
  # create a HttpClient object, defining the url
  cli <- crul::HttpClient$new(url = url)
  # do a GET request, allow curl options to be passed in
  res <- cli$get(...)
  # check to see if request failed or succeeded
  # - a custom approach this time combining status code, 
  #   explanation of the code, and message from the server
  if (res$status_code > 201) {
    mssg <- jsonlite::fromJSON(res$parse("UTF-8"))$message$message
    x <- res$status_http()
    stop(
      sprintf("HTTP (%s) - %s\n  %s", x$status_code, x$explanation, mssg),
      call. = FALSE
    )
  }
  # parse response
  txt <- res$parse("UTF-8")
  # parse the JSON to an R list
  jsonlite::fromJSON(txt)
}

## ------------------------------------------------------------------------
make_request2("http://api.crossref.org/works?rows=0")

## ----eval=FALSE----------------------------------------------------------
#  make_request2("http://api.crossref.org/works?rows=0", verbose = TRUE)
#  make_request2("http://api.crossref.org/works?rows=0", timeout_ms = 1)

## ------------------------------------------------------------------------
make_request2("http://api.crossref.org/works", query = list(rows = 0))

## ----eval=FALSE----------------------------------------------------------
#  make_request2("http://api.crossref.org/works?rows=asdf")
#  #> Error: HTTP (400) - Bad request syntax or unsupported method
#  #>   Integer specified as asdf but must be a positive integer less than or equal to 1000.

