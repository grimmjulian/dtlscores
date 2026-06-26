test_that("a data.frame gets parsed", {
  url <- testthat::test_path("matchdays", "M-16-2N-3.html")
  df <- parse_matchday(url)
  expect_true(is.data.frame(df))
})

test_that("score and gp get parsed correctly", {
  url <- testthat::test_path("matchdays", "M-16-2N-3.html")
  df <- parse_matchday(url)
  expect_equal(df[["score"]][[3]], "21:53")
  expect_equal(df[["gp"]][[2]], "7:5")
})

test_that("datetime gets parsed correctly", {
  url <- testthat::test_path("matchdays", "M-16-2N-3.html")
  df <- parse_matchday(url)
  expect_equal(
    df[["datetime"]][[3]],
    as.POSIXct("2016-10-15 16:00", tz = "Europe/Berlin")
  )
})

test_that("location gets parsed correctly", {
  url <- testthat::test_path("matchdays", "M-16-2N-3.html")
  df <- parse_matchday(url)
  expect_equal(
    df[["location"]][[4]],
    "Neue Turnhalle, Asselheimer Str. 19, 67269 Grünstadt"
  )
})

test_that("location gets parsed correctly", {
  url <- testthat::test_path("matchdays", "M-16-2N-3.html")
  df <- parse_matchday(url)
  expect_equal(
    df[["title"]][[3]],
    "KTG Heidelberg - KTT Heilbronn"
  )
})

test_that("competition_url gets parsed correctly", {
  url <- testthat::test_path("matchdays", "M-16-2N-3.html")
  df <- parse_matchday(url)
  expect_equal(
    df[["competition_url"]][[2]],
    "https://www.deutsche-turnliga.de/dtl/historie/archiv/detailsm0.html?ID=1385"
  )
})

test_that("parsing selection works", {
  url <- testthat::test_path("matchdays", "M-16-2N-3.html")
  l <- parse_selected(url)
  expect_snapshot(l)
})

test_that("parsing works for matchdays with 3 competitions", {
  url <- testthat::test_path("matchdays", "M-25-3S-1.html")
  df <- parse_matchday(url)
  expect_snapshot(df)
})
