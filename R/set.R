#' Set curl options, proxy, and basic auth
#'
#' @export
#' @name crul-options
#' @param ... For `set_opts()` any curl option in the set
#' [curl::curl_options()]. For `set_headers()` a named list of headers
#' @param x For `set_proxy()` a `proxy` object made with [proxy()]. For
#' `set_auth()` an `auth` object made with [auth()]
#' @param reset (logical) reset all settings (aka, delete them).
#' Default: `FALSE`
#' @details
#'
#' - `set_opts()`: set curl options; supports any options in
#' [curl::curl_options()]
#' - `set_verbose()`: set custom curl verbose; sets `verbose=TRUE`
#' and `debugfunction` to the callback result from [curl_verbose()]
#' - `set_proxy()`: set proxy settings, accepts [proxy()]
#' - `set_auth()`: set authorization, accepts [auth()]
#' - `set_headers()`: set request headers, a named list
#' - `crul_settings()`: list all settigns set via these functions
#'
#' @note the `mock` option will be seen in output of `crul_settings()`
#' but is set via the function [mock()]
#'
#' @examples
#' if (interactive()) {
#' # get settings
#' crul_settings()
#'
#' # curl options
#' set_opts(timeout_ms = 1000)
#' crul_settings()
#' set_opts(timeout_ms = 4000)
#' crul_settings()
#' set_opts(verbose = TRUE)
#' crul_settings()
#' \dontrun{
#' HttpClient$new('https://hb.opencpu.org')$get('get')
#' }
#' # set_verbose - sets: `verbose=TRUE`, and `debugfunction` to
#' # result of call to `curl_verbose()`, see `?curl_verbose`
#' set_verbose()
#' crul_settings()
#'
#' # basic authentication
#' set_auth(auth(user = "foo", pwd = "bar", auth = "basic"))
#' crul_settings()
#'
#' # proxies
#' set_proxy(proxy("http://97.77.104.22:3128"))
#' crul_settings()
#'
#' # headers
#' crul_settings(TRUE) # reset first
#' set_headers(foo = "bar")
#' crul_settings()
#' set_headers(`User-Agent` = "hello world")
#' crul_settings()
#' \dontrun{
#' set_opts(verbose = TRUE)
#' HttpClient$new('https://hb.opencpu.org')$get('get')
#' }
#'
#' # reset
#' crul_settings(TRUE)
#' crul_settings()
#'
#' # works with async functions
#' ## Async
#' set_opts(verbose = TRUE)
#' cc <- Async$new(urls = c(
#'     'https://hb.opencpu.org/get?a=5',
#'     'https://hb.opencpu.org/get?foo=bar'))
#' (res <- cc$get())
#'
#' ## AsyncVaried
#' set_opts(verbose = TRUE)
#' set_headers(stuff = "things")
#' reqlist <- list(
#'   HttpRequest$new(url = "https://hb.opencpu.org/get")$get(),
#'   HttpRequest$new(url = "https://hb.opencpu.org/post")$post())
#' out <- AsyncVaried$new(.list = reqlist)
#' out$request()
#' }
set_opts <- function(...) {
  crul_opts$opts <-
    utils::modifyList(crul_opts$opts %||% list(), curl_opts_fil(list(...)))
}

#' @export
#' @name crul-options
set_verbose <- function() {
  crul_opts$opts$verbose <- TRUE
  crul_opts$opts$debugfunction <- curl_verbose()
}

#' @export
#' @name crul-options
set_proxy <- function(x) {
  if (!inherits(x, "proxy")) {
    stop("`set_proxy` input must be of class 'proxy'", call. = FALSE)
  }
  crul_opts$proxies <- x
}

#' @export
#' @name crul-options
set_auth <- function(x) {
  if (!inherits(x, "auth")) {
    stop("`set_auth` input must be of class 'auth'", call. = FALSE)
  }
  crul_opts$crul_auth <- x
}

#' @export
#' @name crul-options
set_headers <- function(...) {
  crul_opts$headers <-
    utils::modifyList(crul_opts$headers %||% list(), list(...))
}

#' @export
#' @name crul-options
crul_settings <- function(reset = FALSE) {
  if (reset) {
    rm_env("opts")
    rm_env("proxies")
    rm_env("crul_auth")
    rm_env("headers")
  }
  utils::ls.str(crul_opts)
}

rm_env <- function(x) {
  if (exists(x, envir = crul_opts)) rm(list = x, envir = crul_opts)
}
