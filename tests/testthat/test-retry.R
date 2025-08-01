skip_on_cran()
skip_if_offline(url_parse(hb())$domain)


test_that("retry has basic error checking", {
  cli <- HttpClient$new(url = hb())

  expect_error(cli$retry())
  expect_error(cli$retry(TRUE))
  expect_error(cli$retry(times = 10))
  expect_error(cli$retry("", times = 10))
  expect_error(cli$retry("FOO", times = 10))
})


test_that("retry wrapping get request works", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("GET", path = "get")

  expect_s3_class(aa, "HttpResponse")
  expect_s3_class(aa$handle, 'curl_handle')
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "get")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse(), "character")
  expect_true(aa$success())
})

test_that("retry wrapping get request - query parameters", {
  cli <- HttpClient$new(url = hb())
  querya <- list(a = "Asdfadsf", hello = "world")
  aa <- cli$retry("GET", path = "get", query = querya)

  expect_s3_class(aa, "HttpResponse")
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "get")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse(), "character")
  expect_true(aa$success())

  library(urltools)
  params <- unlist(
    lapply(
      strsplit(urltools::url_parse(aa$request$url$url)$parameter, "&")[[1]],
      function(x) {
        tmp <- strsplit(x, "=")[[1]]
        as.list(stats::setNames(tmp[2], tmp[1]))
      }
    ),
    FALSE
  )
  expect_equal(params, querya)
})


test_that("retry wrapping post request works", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("POST", path = "post")

  expect_s3_class(aa, "HttpResponse")
  expect_s3_class(aa$handle, 'curl_handle')
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "post")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse(), "character")
  expect_true(aa$success())

  expect_null(aa$request$fields)
})

test_that("retry wrapping post request with body", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("POST", path = "post", body = list(hello = "world"))

  expect_s3_class(aa, "HttpResponse")
  expect_s3_class(aa$handle, 'curl_handle')
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "post")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse(), "character")
  expect_true(aa$success())

  expect_named(aa$request$fields, "hello")
  expect_equal(aa$request$fields[[1]], "world")
})


test_that("retry wrapping post request with file upload", {
  # txt file
  ## as file
  file <- upload(system.file("CITATION"))
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("POST", path = "post", body = list(a = file))

  expect_s3_class(aa, "HttpResponse")
  expect_type(aa$content, "raw")
  expect_null(aa$request$options$readfunction)
  out <- jsonlite::fromJSON(aa$parse("UTF-8"))
  expect_named(out$files, "a")
  expect_match(out$files$a, "bibentry")

  ## as data
  aa2 <- cli$retry("POST", path = "post", body = file)
  expect_s3_class(aa2, "HttpResponse")
  expect_type(aa2$content, "raw")
  expect_type(aa2$request$options$readfunction, "closure")
  out <- jsonlite::fromJSON(aa2$parse("UTF-8"))
  expect_equal(length(out$files), 0)
  expect_type(out$data, "character")
  expect_match(out$data, "bibentry")

  # binary file: jpeg
  file <- upload(file.path(Sys.getenv("R_DOC_DIR"), "html/logo.jpg"))
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("POST", path = "post", body = list(a = file))

  expect_s3_class(aa, "HttpResponse")
  expect_type(aa$content, "raw")
  expect_named(aa$request$fields, "a")
  out <- jsonlite::fromJSON(aa$parse("UTF-8"))
  expect_named(out$files, "a")
  expect_match(out$files$a, "data:image/jpeg")
})


test_that("retry wrapping put request works", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("PUT", path = "put")

  expect_s3_class(aa, "HttpResponse")
  expect_s3_class(aa$handle, 'curl_handle')
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "put")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse(), "character")
  expect_true(aa$success())

  expect_null(aa$request$fields)
})

test_that("retry wrapping put request with body", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("PUT", path = "put", body = list(hello = "world"))

  expect_s3_class(aa, "HttpResponse")
  expect_s3_class(aa$handle, 'curl_handle')
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "put")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse("UTF-8"), "character")
  expect_true(aa$success())

  expect_named(aa$request$fields, "hello")
  expect_equal(aa$request$fields[[1]], "world")
})


test_that("retry wrapping delete request works", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("DELETE", path = "delete")

  expect_s3_class(aa, "HttpResponse")
  expect_s3_class(aa$handle, 'curl_handle')
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "delete")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse(), "character")
  expect_true(aa$success())

  expect_null(aa$request$fields)
})

test_that("retry wrapping delete request with body", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$retry("DELETE", path = "delete", body = list(hello = "world"))

  expect_s3_class(aa, "HttpResponse")
  expect_s3_class(aa$handle, 'curl_handle')
  expect_type(aa$content, "raw")
  expect_type(aa$method, "character")
  expect_equal(aa$method, "delete")
  expect_type(aa$parse, "closure")
  expect_type(aa$parse("UTF-8"), "character")
  expect_true(aa$success())

  expect_named(aa$request$fields, "hello")
  expect_equal(aa$request$fields[[1]], "world")
})


test_that("retry actually retries on error", {
  cli <- HttpClient$new(url = hb())
  ## baseline time for comparison
  tt <- system.time(cli$retry("GET", path = "status/200", times = 2))
  ## try again if this took longer than expected
  if (tt["elapsed"] > 1) {
    tt <- system.time(cli$retry("GET", path = "status/200", times = 2))
  }

  tt1 <- system.time(cli$retry("GET", path = "status/400", times = 2))
  expect_gt(tt1["elapsed"] - tt["elapsed"], 2)
})

test_that("retry recognizes retry headers", {
  skip("Redo these tests, not doing what the title states")
  skip_if_not_installed("webmockr")

  withr::local_package("webmockr")
  withr::defer(unloadNamespace(asNamespace("webmockr")))
  webmockr::enable()
  cli <- HttpClient$new(url = hb())

  stub <- webmockr::stub_request("get", hb("/get"))
  stub <- webmockr::to_return(
    stub,
    status = 503,
    headers = list("retry-after" = 1)
  )
  tt0 <- system.time(cli$retry("GET", path = "get", times = 0))
  expect_lt(tt0["elapsed"], 0.5)

  tt1 <- system.time(cli$retry(
    "GET",
    path = "get",
    pause_base = 0,
    pause_min = 0,
    times = 2
  ))
  expect_gt(tt1["elapsed"], 2)
  webmockr::stub_registry_clear()

  stub <- webmockr::stub_request("get", hb("/get"))
  stub <- webmockr::to_return(
    stub,
    status = 429,
    headers = list("x-ratelimit-remaining" = "0", "retry-after" = "1")
  )
  tt1 <- system.time(cli$retry(
    "GET",
    path = "get",
    pause_base = 0,
    pause_min = 0,
    times = 2
  ))
  expect_gt(tt1["elapsed"], 2)
  webmockr::stub_registry_clear()

  stub <- webmockr::stub_request("get", hb("/get"))
  stub <- webmockr::to_return(
    stub,
    status = 429,
    headers = list(
      "x-ratelimit-remaining" = "0",
      "x-ratelimit-reset" = ceiling(as.numeric(Sys.time())) + 3
    )
  )
  tt1 <- system.time(cli$retry(
    "GET",
    path = "get",
    pause_base = 0,
    pause_min = 0,
    times = 1
  ))
  expect_gt(tt1["elapsed"], 2.0)
  webmockr::stub_registry_clear()

  webmockr::disable()
})

test_that("retry doesn't retry on error unless triggered", {
  cli <- HttpClient$new(url = hb())
  ## baseline time
  tt <- system.time(cli$retry("GET", path = "status/200", times = 2))
  ## try again if this took longer than expected
  if (tt["elapsed"] > 1) {
    tt <- system.time(cli$retry("GET", path = "status/200", times = 2))
  }

  tt1 <- system.time(cli$retry("GET", path = "status/400", times = 0))
  expect_lt(tt1["elapsed"], 2)
  expect_lt(abs(tt1["elapsed"] - tt["elapsed"]), 1)

  tt1 <- system.time(cli$retry("GET", path = "status/400", pause_cap = 0))
  expect_lt(tt1["elapsed"], 2)
  expect_lt(abs(tt1["elapsed"] - tt["elapsed"]), 1)

  tt1 <- system.time(cli$retry(
    "GET",
    path = "status/400",
    terminate_on = c(400)
  ))
  expect_lt(tt1["elapsed"], 2)
  expect_lt(abs(tt1["elapsed"] - tt["elapsed"]), 1)

  tt1 <- system.time(cli$retry(
    "GET",
    path = "status/404",
    terminate_on = c(400, 404)
  ))
  expect_lt(tt1["elapsed"], 2)
  expect_lt(abs(tt1["elapsed"] - tt["elapsed"]), 1)

  tt1 <- system.time(cli$retry(
    "GET",
    path = "status/404",
    retry_only_on = c(400)
  ))
  expect_lt(tt1["elapsed"], 2)
  expect_lt(abs(tt1["elapsed"] - tt["elapsed"]), 1)
})


test_that("retry invokes callback function if provided", {
  cli <- HttpClient$new(url = hb())
  codes <- c()
  waittimes <- c()
  tt <- system.time(cli$retry(
    "GET",
    path = "status/400",
    times = 2,
    onwait = function(resp, secs) {
      codes <<- c(codes, resp$status_code)
      waittimes <<- c(waittimes, secs)
    }
  ))
  expect_length(codes, 2)
  expect_length(waittimes, 2)
  expect_identical(codes, c(400, 400))
  expect_true(waittimes[1] >= 1 && waittimes[1] <= 2)
  expect_true(waittimes[2] >= 1 && waittimes[2] <= 4)
})
