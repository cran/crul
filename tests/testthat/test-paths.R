skip_on_cran()
skip_if_offline(url_parse(hb())$domain)


test_that("paths work", {
  cli <- HttpClient$new(url = hb())
  aa <- cli$get(path = 'get')

  expect_s3_class(aa, "HttpResponse")
  urlsp <- strsplit(aa$url, "/")[[1]]
  expect_equal(urlsp[length(urlsp)], "get")
  expect_equal(aa$status_code, 200)
})

test_that("path - multiple route paths work", {
  cli <- HttpClient$new(url = hb())
  bb <- cli$get('status/200')

  expect_s3_class(bb, "HttpResponse")
  urlsp <- strsplit(bb$url, "/")[[1]]
  expect_equal(urlsp[4:5], c('status', '200'))
  expect_equal(bb$status_code, 200)
})

test_that("path - paths don't work if paths already on URL", {
  cli <- HttpClient$new(url = hb("/get/adsfasdf"))
  bb <- cli$get('stuff')

  expect_s3_class(bb, "HttpResponse")
  expect_equal(bb$status_code, 404)
  expect_true(grepl("stuff", bb$url))
  expect_false(grepl("adsfasdf", bb$url))
})

test_that("path - work with routes that have spaces", {
  skip_on_os("windows")

  cli <- HttpClient$new(url = "http://www.marinespecies.org")
  bb <- cli$get('rest/AphiaRecordsByName/Platanista gangetica')

  expect_s3_class(bb, "HttpResponse")
  urlsp <- strsplit(bb$url, "/")[[1]]
  expect_equal(urlsp[length(urlsp)], 'Platanista%20gangetica')
})
