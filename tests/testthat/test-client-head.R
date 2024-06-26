skip_on_cran()
skip_if_offline(url_parse(hb())$domain)
context("HttpClient: head")

test_that("head request works", {
  cli <- HttpClient$new(url = "https://www.google.com")
  aa <- cli$head()

  expect_is(aa, "HttpResponse")
  expect_is(aa$handle, 'curl_handle')
  expect_is(aa$content, "raw")
  expect_is(aa$method, "character")
  expect_equal(aa$method, "head")
  expect_is(aa$parse, "function")
  expect_is(aa$parse(), "character")
  expect_true(aa$success())

  # content is empty
  expect_equal(aa$content, raw(0))
})


test_that("head - query passed to head doesn't fail", {
  cli <- HttpClient$new(url = "https://www.google.com")
  aa <- cli$head(query = list(foo = "bar"))

  expect_is(aa, "HttpResponse")
  expect_is(aa$handle, 'curl_handle')
  expect_is(aa$content, "raw")
  expect_is(aa$method, "character")
  expect_equal(aa$method, "head")
  expect_is(aa$parse, "function")
  expect_true(aa$success())
  expect_match(aa$request$url$url, "foo")
  expect_match(aa$request$url$url, "bar")

  # content is empty
  expect_equal(aa$content, raw(0))
})


test_that("with auth works", {
  cli <- HttpClient$new(url = hb(), auth = auth("foo", "bar"))
  aa <- cli$head("/basic-auth/foo/bar")

  expect_is(aa, "HttpResponse")
  expect_equal(aa$method, "head")
  expect_true(aa$success())
  expect_equal(aa$status_code, 200)
  expect_equal(aa$request$options$userpwd, "foo:bar")
})
