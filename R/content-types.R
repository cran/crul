#' Working with content types
#'
#' The [HttpResponse] class holds all the responses elements for an HTTP
#' request. This document details how to work specifically with the
#' content-type of the response headers
#'
#' @name content-types
#' @section Content types:
#' The "Content-Type" header in HTTP responses gives the media type of the
#' response. The media type is both the data format and how the data is
#' intended to be processed by a recipient. (modified from rfc7231)
#'
#' @section Behavior of the parameters HttpResponse raise_for_ct* methods:
#'
#' - type: (only applicable for the `raise_for_ct()` method): instead of
#' using one of the three other content type methods for html, json, or xml,
#' you can specify a mime type to check, any of those in [mime::mimemap]
#' - charset: if you don't give a value to this parameter, we only
#' check that the content type is what you expect; that is, the charset,
#' if given, is ignored.
#' - behavior: by default when you call this method, and the content type
#' does not match what the method expects, then we run `stop()` with a
#' message. Instead of stopping, you can choose `behavior="warning"`
#' and we'll throw a warning instead, allowing any downstream processing
#' to proceed.
#'
#' @references
#' spec for content types:
#' <https://datatracker.ietf.org/doc/html/rfc7231#section-3.1.1.5>
#'
#' spec for media types:
#' <https://datatracker.ietf.org/doc/html/rfc7231#section-3.1.1.1>
#'
#' @seealso [HttpResponse]
#' @examples \dontrun{
#' (x <- HttpClient$new(url = "https://hb.opencpu.org"))
#' (res <- x$get())
#'
#' ## see the content type
#' res$response_headers
#'
#' ## check that the content type is text/html
#' res$raise_for_ct_html()
#'
#' ## it's def. not json
#' # res$raise_for_ct_json()
#'
#' ## give custom content type
#' res$raise_for_ct("text/html")
#' # res$raise_for_ct("application/json")
#' # res$raise_for_ct("foo/bar")
#'
#' ## check charset in addition to the media type
#' res$raise_for_ct_html(charset = "utf-8")
#' # res$raise_for_ct_html(charset = "utf-16")
#'
#' # warn instead of stop
#' res$raise_for_ct_json(behavior = "warning")
#' }
NULL
