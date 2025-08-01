skip_on_cran()
skip_if_offline(url_parse(hb())$domain)


cli <- HttpClient$new(url = "http://api.crossref.org")
aa <- Paginator$new(
  client = cli,
  by = "limit_offset",
  limit_param = "rows",
  offset_param = "offset",
  limit = 50,
  chunk = 10
)

test_that("Paginator print method", {
  expect_type(aa$print, "closure")
  expect_output(aa$print(), "api.crossref.org")
  expect_output(aa$print(), "limit_offset")
  expect_output(aa$print(), "chunk: 10")
  expect_output(aa$print(), "limit_param: rows")
  expect_output(aa$print(), "offset_param: offset")
  expect_output(aa$print(), "limit: 50")
  expect_output(aa$print(), "status: not run yet")
})

test_that("Paginator works", {
  expect_s3_class(cli, "HttpClient")
  expect_s3_class(Paginator, "R6ClassGenerator")

  expect_s3_class(aa, "Paginator")
  expect_type(aa$.__enclos_env__$private$page, "closure")
  expect_type(aa$parse, "closure")
  expect_type(aa$content, "closure")
  expect_type(aa$responses, "closure")

  # before requests
  expect_equal(length(aa$content()), 0)
  expect_equal(length(aa$status()), 0)
  expect_equal(length(aa$status_code()), 0)
  expect_equal(length(aa$times()), 0)

  # after requests
  invisible(aa$get("works"))
  expect_equal(length(aa$content()), 5)
  expect_equal(length(aa$status()), 5)
  expect_equal(length(aa$status_code()), 5)
  expect_equal(length(aa$times()), 5)
})


test_that("Paginator works with many different limit and chunk combinations", {
  limit_param = "rows"
  offset_param = "start"

  aa <- Paginator$new(
    client = cli,
    by = "limit_offset",
    limit_param = limit_param,
    offset_param = offset_param,
    limit = 27,
    chunk = 10
  )
  expect_equal(aa$.__enclos_env__$private$offset_iters, c(0, 10, 20))
  expect_equal(aa$.__enclos_env__$private$limit_chunks, c(10, 10, 7))

  bb <- Paginator$new(
    client = cli,
    by = "limit_offset",
    limit_param = limit_param,
    offset_param = offset_param,
    limit = 50,
    chunk = 10
  )
  expect_equal(bb$.__enclos_env__$private$offset_iters, c(0, 10, 20, 30, 40))
  expect_equal(bb$.__enclos_env__$private$limit_chunks, c(10, 10, 10, 10, 10))

  cc <- Paginator$new(
    client = cli,
    by = "limit_offset",
    limit_param = limit_param,
    offset_param = offset_param,
    limit = 1050,
    chunk = 20
  )
  expect_equal(cc$.__enclos_env__$private$offset_iters, seq(0, 1040, by = 20))
  expect_equal(
    cc$.__enclos_env__$private$limit_chunks,
    c(rep(20, floor(1050 / 20)), 10)
  )

  dd <- Paginator$new(
    client = cli,
    by = "limit_offset",
    limit_param = limit_param,
    offset_param = offset_param,
    limit = 1049,
    chunk = 20
  )
  expect_equal(dd$.__enclos_env__$private$offset_iters, seq(0, 1040, by = 20))
  expect_equal(
    dd$.__enclos_env__$private$limit_chunks,
    c(rep(20, floor(1049 / 20)), 9)
  )

  ee <- Paginator$new(
    client = cli,
    by = "limit_offset",
    limit_param = limit_param,
    offset_param = offset_param,
    limit = 1051,
    chunk = 20
  )
  expect_equal(ee$.__enclos_env__$private$offset_iters, seq(0, 1040, by = 20))
  expect_equal(
    ee$.__enclos_env__$private$limit_chunks,
    c(rep(20, floor(1051 / 20)), 11)
  )

  ff <- Paginator$new(
    client = cli,
    by = "limit_offset",
    limit_param = limit_param,
    offset_param = offset_param,
    limit = 1051,
    chunk = 5
  )
  expect_equal(ff$.__enclos_env__$private$offset_iters, seq(0, 1050, by = 5))
  expect_equal(
    ff$.__enclos_env__$private$limit_chunks,
    c(rep(5, floor(1051 / 5)), 1)
  )
})


test_that("Paginator fails well", {
  expect_error(Paginator$new(), "argument \"client\" is missing")
  # expect_error(Paginator$new(cli), "argument \"chunk\" is missing")
  expect_error(Paginator$new(cli, 5), "'by' must be one of")
  expect_error(
    Paginator$new(5, "limit_offset"),
    "'client' has to be an object of class 'HttpClient'"
  )

  limit_param = "rows"
  offset_param = "start"

  # chunk = 0 or not an integer
  expect_error(
    Paginator$new(
      client = cli,
      by = "limit_offset",
      limit_param = limit_param,
      offset_param = offset_param,
      limit = 51,
      chunk = 0
    ),
    "'chunk' must be an integer and > 0"
  )
  expect_error(
    Paginator$new(
      client = cli,
      by = "limit_offset",
      limit_param = limit_param,
      offset_param = offset_param,
      limit = 51,
      chunk = 1.5
    ),
    "'chunk' must be an integer and > 0"
  )

  # limit not an integer
  expect_error(
    Paginator$new(
      client = cli,
      by = "limit_offset",
      limit_param = limit_param,
      offset_param = offset_param,
      limit = "stuff",
      chunk = 10
    ),
    "limit must be of class numeric, integer"
  )

  # limit_param must be character
  expect_error(
    Paginator$new(
      client = cli,
      by = "limit_offset",
      limit_param = 5,
      offset_param = offset_param,
      limit = 51,
      chunk = 10
    ),
    "limit_param must be of class character"
  )

  # offset_param must be character
  expect_error(
    Paginator$new(
      client = cli,
      by = "limit_offset",
      limit_param = limit_param,
      offset_param = 5,
      limit = 51,
      chunk = 10
    ),
    "offset_param must be of class character"
  )

  # page_param must be character
  expect_error(
    Paginator$new(
      client = cli,
      by = "page_perpage",
      page_param = 5,
      per_page_param = 'a'
    ),
    "page_param must be of class character"
  )

  # per_page_param must be character
  expect_error(
    Paginator$new(
      client = cli,
      by = "page_perpage",
      page_param = 'b',
      per_page_param = 45
    ),
    "per_page_param must be of class character"
  )
})

test_that("Paginator progress option", {
  cli <- HttpClient$new(url = "https://api.crossref.org")
  cc <- Paginator$new(
    client = cli,
    limit_param = "rows",
    offset_param = "offset",
    limit = 20,
    chunk = 10,
    progress = TRUE
  )
  expect_output(cc$get('works'), "====")
})

test_that("by throws warning when query_params used", {
  expect_warning(
    Paginator$new(
      client = cli,
      by = "query_params",
      limit_param = "rows",
      offset_param = "offset",
      limit = 50,
      chunk = 10
    )
  )
})
