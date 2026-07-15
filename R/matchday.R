#' Parse matchday data
#'
#' Parse or scrape the meta data of a matchday from a matchday overview page.
#'
#' @include utils.R
#' @param url page url
#' @return data.frame
#' @export
#' @examples
#' \donttest{
#' parse_matchday("https://www.deutsche-turnliga.de/archiv.html")
#' }
parse_matchday <- function(url) {
  html <- rvest::read_html(url)

  selection <- parse_selected(as.character(html))

  l <- html |>
    rvest::html_element(".table-striped") |>
    rvest::html_element("tbody") |>
    rvest::html_elements("td")

  wettkampf <- l[seq(1, length(l), by = 3)]
  score <- l[seq(2, length(l), by = 3)] |> rvest::html_text2()
  gp <- l[seq(3, length(l), by = 3)] |> rvest::html_text2()

  df <- selection |>
    lapply(rep, times = length(wettkampf)) |>
    as.data.frame()

  df[["datetime"]] <- wettkampf |>
    rvest::html_text2() |>
    strsplit(" Uhr ") |>
    vapply(\(x) x[[1]], FUN.VALUE = character(1)) |>
    as.POSIXct(format = "%d.%m.%Y %H:%M", tz = "Europe/Berlin")

  df[["location"]] <- wettkampf |>
    as.character() |>
    strsplit(" Uhr ") |>
    vapply(\(x) x[[2]], FUN.VALUE = character(1)) |>
    strsplit("<br>") |>
    vapply(\(x) x[[1]], FUN.VALUE = character(1))

  df[["title"]] <- wettkampf |>
    rvest::html_element("a") |>
    rvest::html_text2()

  teams <- strsplit(df[["title"]], " - ", fixed = TRUE)
  df[["home_team"]] <- teams |>
    sapply(`[`, 1)
  df[["guest_team"]] <- teams |>
    sapply(`[`, 2)

  df[["competition_url"]] <- wettkampf |>
    rvest::html_element("a") |>
    rvest::html_attr("href") |>
    pad_urls() # nolint

  df[["score"]] <- score
  df[["gp"]] <- gp
  df[["matchday_url"]] <- url
  df
}

parse_selected <- function(html) {
  xml <- rvest::read_html(html) |>
    rvest::html_elements("select") |>
    lapply(rvest::html_elements, "option[selected]")
  type <- c("type", "season", "league", "matchday")
  type_id <- paste(type, "id", sep = "_")
  l <- list()
  for (i in 1:4) {
    l[[type_id[[i]]]] <- xml[[i]] |>
      rvest::html_attr("value")
    l[[type[[i]]]] <- xml[[i]] |>
      rvest::html_text2()
  }
  l
}
