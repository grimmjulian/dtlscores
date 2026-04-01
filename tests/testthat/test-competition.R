test_that("relocating columns works", {
  df <- data.frame(a = "a", b = "b", c = "c", d = "d")
  expect_equal(
    relocate(df, "c", "a"),
    data.frame(a = "a", c = "c", b = "b", d = "d")
  )
})

test_that("parsing the competition returns a data frame", {
  url <- testthat::test_path("competitions", "2900.html")
  expect_true(is.data.frame(parse_competition(url)))
})

test_that("the right rows are kept", {
  url <- testthat::test_path("competitions", "2900.html")
  home_gymnast_col <- "home_gymnast"
  df <- parse_competition(url)
  vec <- df[[home_gymnast_col]]
  expect_equal(vec[[1]], "Stanley, Jack")
  expect_equal(vec[[5]], "Wagner, Aaron")
  expect_equal(vec[[24]], "Prohorov, Nikita")
  expect_equal(length(vec), 24)
})

test_that("teams are crawled correctly", {
  url <- testthat::test_path("competitions", "2900.html")
  df <- parse_competition(url)
  expect_equal(df[["home_team"]][[1]], "KTV Koblenz")
  expect_equal(df[["guest_team"]][[1]], "Exquisa Oberbayern")
})

test_that("fill function works", {
  vec <- c(NA, "a", NA, NA, "b", NA)
  expect_equal(fill(vec), c(NA, "a", "a", "a", "b", "b"))
})

test_that("events are parsed correctly", {
  url <- testthat::test_path("competitions", "2900.html")
  df <- parse_competition(url)
  vec <- as.character(df[["event"]])
  expect_equal(vec[[3]], "floor")
  expect_equal(vec[[16]], "vault")
})

test_that("pairing order is parsed correctly", {
  url <- testthat::test_path("competitions", "2900.html")
  df <- parse_competition(url)
  vec <- df[["pairing_order"]]
  expect_equal(vec[1:4], 1:4)
  expect_equal(vec[[5]], 1)
})

test_that("values are parsed correctly", {
  url <- testthat::test_path("competitions", "2900.html")
  df <- parse_competition(url)
  expect_equal(df[["home_d_value"]][[1]], 5)
  expect_equal(df[["home_end_value"]][[2]], 12.8)
  expect_equal(df[["home_score_value"]][[3]], 5)
  expect_equal(df[["guest_d_value"]][[4]], 4.1)
  expect_equal(df[["guest_end_value"]][[5]], 12.05)
  expect_equal(df[["guest_score_value"]][[6]], 0)
  expect_false(any(is.na(df[["home_d_value"]])))
  expect_false(any(is.na(df[["home_end_value"]])))
  expect_false(any(is.na(df[["home_score_value"]])))
  expect_false(any(is.na(df[["guest_d_value"]])))
  expect_false(any(is.na(df[["guest_end_value"]])))
  expect_false(any(is.na(df[["guest_score_value"]])))
})

test_that("starting gymnast is parsed correctly", {
  url <- testthat::test_path("competitions", "2900.html")
  df <- parse_competition_tags(url)
  expect_false(df[["home_starts"]][[1]])
  expect_true(df[["home_starts"]][[3]])
})

test_that("gymnast urls are parsed correctly", {
  url <- testthat::test_path("competitions", "2900.html")
  df <- parse_competition_tags(url)
  expect_equal(
    df[["home_gymnast_url"]][[7]],
    "https://www.deutsche-turnliga.de/vereine/turner.html?ID=22318"
  )
  expect_equal(
    df[["guest_gymnast_url"]][[8]],
    "https://www.deutsche-turnliga.de/vereine/turner.html?ID=21198"
  )
})
