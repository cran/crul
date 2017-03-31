## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  warning = FALSE,
  message = FALSE
)

## ------------------------------------------------------------------------
library("crul")

## ----echo=FALSE, eval=FALSE----------------------------------------------
#  (cc <- Async$new(
#    urls = c(
#      'https://www.heroku.com/',
#      'http://docs.python-tablib.org/en/latest/',
#      'https://httpbin.org'
#    )
#  ))

## ------------------------------------------------------------------------
(cc <- Async$new(
  urls = c(
    'https://httpbin.org/get?a=5',
    'https://httpbin.org/get?a=5&b=6',
    'https://httpbin.org/ip'
  )
))

## ------------------------------------------------------------------------
(res <- cc$get())

## ------------------------------------------------------------------------
res[[1]]$url
res[[1]]$success()
res[[1]]$parse("UTF-8")

## ------------------------------------------------------------------------
lapply(res, function(z) z$parse("UTF-8"))

## ------------------------------------------------------------------------
req1 <- HttpRequest$new(
  url = "https://httpbin.org/get?a=5",
  opts = list(
    verbose = TRUE
  )
)
req1$get()

req2 <- HttpRequest$new(
  url = "https://httpbin.org/post?a=5&b=6"
)
req2$post(body = list(a = 5))

(res <- AsyncVaried$new(req1, req2))

## ------------------------------------------------------------------------
res$request()

## ------------------------------------------------------------------------
res$parse()

## ------------------------------------------------------------------------
lapply(res$parse(), jsonlite::prettify)

## ------------------------------------------------------------------------
res$status_code()

