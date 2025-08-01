skip_on_cran()
skip_if_offline(url_parse(hb())$domain)


test_that("Async works", {
  expect_s3_class(Async, "R6ClassGenerator")

  aa <- Async$new(urls = c(hb('/get'), 'https://google.com'))

  expect_s3_class(aa, "Async")
  expect_null(aa$handle)
  expect_type(aa$urls, "character")
  expect_equal(length(aa$urls), 2)
  expect_type(aa$.__enclos_env__$private$gen_interface, "closure")

  expect_type(aa$get, "closure")
  expect_type(aa$post, "closure")
  expect_type(aa$put, "closure")
  expect_type(aa$patch, "closure")
  expect_type(aa$delete, "closure")
  expect_type(aa$head, "closure")

  # after calling
  res <- aa$get()
  expect_s3_class(res, "asyncresponses")
  expect_equal(length(res), 2)
  expect_s3_class(res[[1]], "HttpResponse")
  expect_s3_class(res[[1]]$request, "HttpRequest")
  expect_type(res[[1]]$content, "raw")
})

test_that("Async fails well", {
  expect_error(Async$new(), "\"urls\" is missing, with no default")
})

test_that("Async print method", {
  aa <- Async$new(urls = c(hb('/get'), 'https://google.com'))

  expect_s3_class(aa, "Async")
  expect_type(aa$print, "closure")
  expect_output(aa$print(), "crul async connection")
  expect_output(aa$print(), "curl options")
  expect_output(aa$print(), "proxies")
  expect_output(aa$print(), "auth")
  expect_output(aa$print(), "headers")
  expect_output(aa$print(), "urls:")
  expect_output(aa$print(), hb('/get'))
  expect_output(aa$print(), 'https://google.com')

  # > 10 urls
  aa <- Async$new(urls = rep(hb('/get'), 12))

  expect_output(aa$print(), "# ... with")
  expect_output(aa$print(), hb('/get'))
})


test_that("Async curl options work", {
  skip_on_ci() # not sure why, but not working on CI

  aa <- Async$new(
    urls = c(hb('/get'), 'https://google.com'),
    opts = list(timeout_ms = 100)
  )
  expect_output(aa$print(), "curl options")
  expect_output(aa$print(), "timeout_ms: 100")

  expect_equal(vapply(aa$get(), "[[", 1, "status_code"), c(0, 0))
})

test_that("Async headers work", {
  aa <- Async$new(
    urls = c(hb('/get'), 'https://google.com'),
    headers = list(foo = "bar")
  )
  expect_output(aa$print(), "headers")
  expect_output(aa$print(), "foo: bar")

  bb <- aa$get()
  expect_equal(
    vapply(bb, function(x) x$request_headers[[1]], ""),
    c("bar", "bar")
  )
})


test_that("Async - get", {
  aa <- Async$new(urls = c(hb('/get'), 'https://google.com'))
  out <- aa$get()

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_equal(out[[1]]$method, "get")
  expect_equal(out[[2]]$method, "get")
})


test_that("Async - post", {
  aa <- Async$new(urls = c(hb('/post'), hb('/post')))
  out <- aa$post()

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_equal(out[[1]]$method, "post")
})


test_that("Async - put", {
  aa <- Async$new(urls = c(hb('/put'), hb('/put')))
  out <- aa$put()

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_equal(out[[1]]$method, "put")
  expect_equal(out[[2]]$method, "put")
})


test_that("Async - patch", {
  aa <- Async$new(urls = c(hb('/patch'), hb('/patch')))
  out <- aa$patch()

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_equal(out[[1]]$method, "patch")
  expect_equal(out[[2]]$method, "patch")
})


test_that("Async - delete", {
  aa <- Async$new(urls = c(hb('/delete'), hb('/delete')))
  out <- aa$delete()

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_equal(out[[1]]$method, "delete")
  expect_equal(out[[2]]$method, "delete")
})


test_that("Async - head", {
  aa <- Async$new(urls = c('https://google.com', 'https://nytimes.com'))
  out <- aa$head()

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_equal(out[[1]]$method, "head")
  expect_equal(out[[2]]$method, "head")
})


test_that("Async - verb", {
  aa <- Async$new(urls = c('https://google.com', 'https://nytimes.com'))
  out <- aa$verb('get')

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_equal(out[[1]]$method, "get")
  expect_equal(out[[2]]$method, "get")
})


test_that("Async - retry", {
  aa <- Async$new(
    urls = c(
      "https://nghttp2.org/httpbin/status/404",
      "https://nghttp2.org/httpbin/status/429"
    )
  )
  out <- aa$retry(verb = 'get')

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_equal(out[[1]]$method, "get")
  expect_equal(out[[2]]$method, "get")
  expect_gt(length(out[[1]]$response_headers_all), 3)
  expect_gt(length(out[[2]]$response_headers_all), 3)
})


test_that("Async - order", {
  aa <- Async$new(urls = c(hb('/get?a=5'), hb('/get?b=6'), hb('/get?c=7')))
  out <- aa$get()

  expect_s3_class(out, "asyncresponses")
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_s3_class(out[[3]], "HttpResponse")

  expect_match(out[[1]]$url, "a=5")
  expect_match(out[[2]]$url, "b=6")
  expect_match(out[[3]]$url, "c=7")
})


test_that("Async - writing to disk works", {
  cc <- Async$new(
    urls = c(
      hb('/get?a=5'),
      hb('/get?foo=bar'),
      hb('/get?b=4'),
      hb('/get?stuff=things'),
      hb('/get?b=4&g=7&u=9&z=1')
    )
  )
  files <- replicate(5, tempfile())
  res <- cc$get(disk = files)
  out <- lapply(files, readLines)

  # cleanup
  closeAllConnections()

  expect_s3_class(res, "asyncresponses")
  expect_s3_class(res[[1]], "HttpResponse")
  expect_type(out, "list")
  expect_type(out[[1]], "character")
})


test_that("Async - writing to disk works", {
  post_url <- hb('/post')
  cc <- Async$new(urls = rep(post_url, 5))
  files <- replicate(5, tempfile())
  res <- cc$post(disk = files, body = list(a = 6))
  out <- lapply(files, readLines)

  # cleanup
  closeAllConnections()

  expect_s3_class(res, "asyncresponses")
  expect_s3_class(res[[1]], "HttpResponse")
  expect_type(out, "list")
  expect_type(out[[1]], "character")
  expect_named(jsonlite::fromJSON(out[[1]])$form, "a")
})


test_that("Async - writing to disk works", {
  put_url <- hb('/put')
  cc <- Async$new(urls = rep(put_url, 5))
  files <- replicate(5, tempfile())
  res <- cc$put(disk = files, body = list(a = 6))
  out <- lapply(files, readLines)

  # cleanup
  closeAllConnections()

  expect_s3_class(res, "asyncresponses")
  expect_s3_class(res[[1]], "HttpResponse")
  expect_type(out, "list")
  expect_type(out[[1]], "character")
  expect_named(jsonlite::fromJSON(out[[1]])$form, "a")
})


test_that("Async - writing to disk works", {
  patch_url <- hb('/patch')
  cc <- Async$new(urls = rep(patch_url, 5))
  files <- replicate(5, tempfile())
  res <- cc$patch(disk = files, body = list(a = 6))
  out <- lapply(files, readLines)

  # cleanup
  closeAllConnections()

  expect_s3_class(res, "asyncresponses")
  expect_s3_class(res[[1]], "HttpResponse")
  expect_type(out, "list")
  expect_type(out[[1]], "character")
  expect_named(jsonlite::fromJSON(out[[1]])$form, "a")
})


test_that("Async - writing to disk works", {
  delete_url <- hb('/delete')
  cc <- Async$new(urls = rep(delete_url, 5))
  files <- replicate(5, tempfile())
  res <- cc$delete(disk = files, body = list(a = 6))
  out <- lapply(files, readLines)

  # cleanup
  closeAllConnections()

  expect_s3_class(res, "asyncresponses")
  expect_s3_class(res[[1]], "HttpResponse")
  expect_type(out, "list")
  expect_type(out[[1]], "character")
  expect_named(jsonlite::fromJSON(out[[1]])$form, "a")
})


test_that("Async - streaming to disk works", {
  bb <- Async$new(urls = c(hb('/get?a=5'), hb('/get?b=6'), hb('/get?c=7')))
  lst <- c()
  fun <- function(x) lst <<- append(lst, list(x))
  out <- bb$get(stream = fun)

  expect_s3_class(bb, "Async")

  expect_s3_class(out[[1]], "HttpResponse")

  expect_identical(out[[1]]$content, raw(0))
  expect_identical(out[[2]]$content, raw(0))
  expect_identical(out[[3]]$content, raw(0))

  expect_type(lst, "list")
  expect_type(rawToChar(lst[[1]]$content), "character")
  expect_type(rawToChar(lst[[2]]$content), "character")
  expect_type(rawToChar(lst[[3]]$content), "character")
})


test_that("Async - with basic auth works", {
  dd <- Async$new(
    urls = rep(hb('/basic-auth/user/passwd'), 3),
    auth = auth(user = "user", pwd = "passwd")
  )
  out <- dd$get()

  expect_s3_class(dd, "Async")

  expect_equal(length(out), 3)
  expect_s3_class(out[[1]], "HttpResponse")
  expect_s3_class(out[[2]], "HttpResponse")
  expect_s3_class(out[[3]], "HttpResponse")

  expect_s3_class(out[[1]]$request$auth, "auth")
  expect_equal(out[[1]]$request$auth$userpwd, "user:passwd")
  expect_equal(out[[1]]$request$auth$httpauth, 1)
})


test_that("Async - failure behavior", {
  urls <- c(
    "http://stuffthings.gvb",
    "https://foo.zasdes",
    "https://scottchamberlain.info"
  )
  conn <- Async$new(urls = urls)
  res <- conn$get()

  expect_s3_class(res, "asyncresponses")

  expect_s3_class(res[[1]], "HttpResponse")
  expect_s3_class(res[[2]], "HttpResponse")
  expect_s3_class(res[[3]], "HttpResponse")

  expect_equal(res[[1]]$status_code, 0)
  expect_equal(res[[2]]$status_code, 0)
  expect_equal(res[[3]]$status_code, 200)

  expect_false(res[[1]]$success())
  expect_false(res[[2]]$success())
  expect_true(res[[3]]$success())

  expect_match(res[[1]]$parse("UTF-8"), "resolve host")
})


test_that("Async - failure behavior", {
  files <- replicate(3, tempfile())
  urls <- c(
    "http://stuffthings.gvb",
    "https://foo.zasdes",
    "https://scottchamberlain.info"
  )
  conn <- Async$new(urls = urls)
  res <- conn$get(disk = files)

  expect_s3_class(res, "asyncresponses")

  expect_s3_class(res[[1]], "HttpResponse")
  expect_s3_class(res[[2]], "HttpResponse")
  expect_s3_class(res[[3]], "HttpResponse")

  expect_equal(res[[1]]$status_code, 0)
  expect_equal(res[[2]]$status_code, 0)
  expect_equal(res[[3]]$status_code, 200)

  expect_false(res[[1]]$success())
  expect_false(res[[2]]$success())
  expect_true(res[[3]]$success())

  expect_match(res[[1]]$parse("UTF-8"), "resolve host")
  expect_type(res[[2]]$parse("UTF-8"), "character")
  expect_match(res[[3]]$parse("UTF-8"), "doctype")

  expect_equal(length(readLines(files[1])), 0)
  expect_equal(length(readLines(files[2])), 0)
  expect_gt(length(readLines(files[3])), 10)

  closeAllConnections()
})


test_that("Async - failure behavior", {
  mylist <- c()
  fun <- function(x) mylist <<- append(mylist, list(x))

  urls <- c(
    "http://stuffthings.gvb",
    "https://foo.zasdes",
    "https://scottchamberlain.info"
  )
  conn <- Async$new(urls = urls)
  res <- conn$get(stream = fun)

  expect_s3_class(res, "asyncresponses")

  expect_s3_class(res[[1]], "HttpResponse")
  expect_s3_class(res[[2]], "HttpResponse")
  expect_s3_class(res[[3]], "HttpResponse")

  # this doesn't mean anything really since we give a templated repsonse with
  # status_code of 0
  expect_equal(res[[1]]$status_code, 0)
  expect_equal(res[[2]]$status_code, 0)
  expect_equal(res[[3]]$status_code, 0)

  # this doesn't mean anything really since we give a templated repsonse with
  # status_code of 0
  expect_false(res[[1]]$success())
  expect_false(res[[2]]$success())
  expect_false(res[[3]]$success())

  # when fails on async, has the error message
  expect_match(res[[1]]$parse("UTF-8"), "resolve host")
  # when not a fail, has nothing
  expect_identical(res[[3]]$parse("UTF-8"), "")

  closeAllConnections()
})
