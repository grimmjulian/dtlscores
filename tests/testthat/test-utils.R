test_that("url padding works", {
  urls <- c(
    "dtl/historie/archiv/detailsm0.html?ID=2764",
    "vereine/turner.html?ID=21382"
  )
  expected <- c(
    "https://deutsche-turnliga.de/dtl/historie/archiv/detailsm0.html?ID=2764",
    "https://deutsche-turnliga.de/vereine/turner.html?ID=21382"
  )
  expect_equal(pad_urls(urls), expected)
})
