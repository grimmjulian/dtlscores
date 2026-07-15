#' @include utils.R

fill <- function(vec) {
  l <- seq_along(vec)
  for (i in l[-1]) {
    if (is.na(vec[[i]])) {
      vec[[i]] <- vec[[i - 1]]
    }
  }
  vec
}

recode_events <- function(vec) {
  fac <- factor(vec, levels = unique(vec))
  levels(fac) <- c(
    "floor",
    "pommel_horse",
    "still_rings",
    "vault",
    "parallel_bars",
    "high_bar"
  )
  fac
}

relocate <- function(df, col, after) {
  other_cols <- colnames(df)[which(!colnames(df) == col)]
  pos <- match(after, other_cols)
  cols <- append(other_cols, col, pos)
  df[, cols]
}

#' Parse competition results
#'
#' Parse or scrape results from the competition site
#'
#' @param url page url
#' @return data.frame
#' @export
#' @examples
#' \donttest{
#' parse_competition("https://www.deutsche-turnliga.de/dtl/historie/archiv/detailsm0.html?ID=2787")
#' }
parse_competition <- function(url) {
  l <- url
  url <- rvest::read_html(url)
  df <- url |>
    rvest::html_element(".Einzelnachweis") |>
    rvest::html_table()

  df[["home_team"]] <- df[[1]][[1]]
  df[["guest_team"]] <- df[[6]][[1]]
  if (is.null(df[["X10"]])) {
    df[["event"]] <- NA
  } else {
    df[["event"]] <- df[["X10"]] |>
      fill() |>
      recode_events()
  }
  df[["home_gymnast"]] <- df[["X1"]]
  df[["home_d_value"]] <- df[["X2"]]
  df[["home_end_value"]] <- df[["X3"]]
  df[["home_score_value"]] <- df[["X4"]]
  df[["guest_gymnast"]] <- df[["X6"]]
  df[["guest_d_value"]] <- df[["X7"]]
  df[["guest_end_value"]] <- df[["X8"]]
  df[["guest_score_value"]] <- df[["X9"]]

  event_start_row <- which(df[[1]] == "Turner") + 1
  event_end_row <- which(df[[1]] == "Summe") - 1
  event_rows <- Map(seq, event_start_row, event_end_row) |>
    unlist()

  df <- df[event_rows, ]
  df <- cbind(df, parse_competition_tags(as.character(url)))

  df[["pairing_order"]] <- numeric(nrow(df))

  for (e in levels(df[["event"]])) {
    i <- df[["event"]] == e
    df[i, "pairing_order"] <- seq_len(sum(i))
  }

  value_cols <- endsWith(colnames(df), "value")

  for (v in which(value_cols)) {
    df[[v]] <-
      as.numeric(gsub(",", ".", df[[v]]))
  }

  df <- relocate(df, "home_gymnast_url", after = "home_gymnast")
  df <- relocate(df, "home_starts", after = "home_gymnast_url")
  df <- relocate(df, "guest_gymnast_url", after = "guest_gymnast")
  df <- relocate(df, "pairing_order", after = "event")
  if (nrow(df) > 0) {
    df[["competition_url"]] <- l
  } else {
    df[["competition_url"]] <- character()
  }

  x_cols <- startsWith(colnames(df), "X")
  df[, !x_cols]
}

parse_competition_tags <- function(html) {
  tags <- rvest::read_html(html) |>
    rvest::html_element(".Einzelnachweis") |>
    rvest::html_elements("a")

  urls <- tags |>
    rvest::html_attr("href") |>
    pad_urls() # nolint

  if (length(urls) == 0) {
    return(
      data.frame(
        home_gymnast_url = character(),
        guest_gymnast_url = character(),
        home_starts = logical()
      )
    )
  }

  is_starting <- tags |>
    lapply(rvest::html_element, "span") |>
    vapply(Negate(is.na), logical(1))

  home_index <- seq(1, length(urls), by = 2)

  data.frame(
    home_gymnast_url = urls[home_index],
    guest_gymnast_url = urls[home_index + 1],
    home_starts = is_starting[home_index]
  )
}
