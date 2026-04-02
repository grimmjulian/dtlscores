pad_urls <- function(url) {
  rvest::url_absolute(url, "https://deutsche-turnliga.de/")
}

scrape_matchday_urls <- function() {
  url_stem <- "https://www.deutsche-turnliga.de/archiv.html"

  url <- paste0(url_stem, "?Typ=Mann")

  saison <- parse_options(url, "SaisonID")
  # Right now: only saison after 2011
  saison[["text"]] <- as.numeric(saison[["text"]])
  saison <- saison[saison[["text"]] >= 2011, ]
  url <- paste0(url, "&SaisonID=", saison[["value"]])
  df <- data.frame(type = "M\u00e4nner", season = saison[["text"]], url = url)
  l_df <- split(df, seq_len(nrow(df)))
  i <- 1
  for (d in l_df) {
    liga <- parse_options(d[["url"]], "LigaID")
    colnames(liga) <- c("league", "url")
    # Right now only Bundesliga results
    liga <- liga[grepl("Bundesliga", liga[["league"]]), ]
    liga[["type"]] <- d[["type"]]
    liga[["season"]] <- d[["season"]]
    liga[["url"]] <- paste0(d[["url"]], "&LigaID=", liga[["url"]])
    l_df[[i]] <- liga
    i <- i + 1
  }
  df <- do.call(rbind, l_df)

  t_df <- split(df, seq_len(nrow(df)))
  i <- 1
  for (d in t_df) {
    tag <- parse_options(d[["url"]], "TagesID")
    colnames(tag) <- c("matchday", "url")
    tag[["matchday"]] <- sub("^([0-9]+).*", "\\1", tag[["matchday"]]) |>
      as.numeric()
    tag[["type"]] <- d[["type"]]
    tag[["season"]] <- d[["season"]]
    tag[["league"]] <- d[["league"]]
    tag[["url"]] <- paste0(d[["url"]], "&TagesID=", tag[["url"]])
    t_df[[i]] <- tag
    i <- i + 1
  }
  df <- do.call(rbind, t_df)
  df <- df[, c("type", "season", "league", "matchday", "url")]
  df
}


parse_options <- function(url, name) {
  # Read the HTML from the URL
  page <- rvest::read_html(url)
  select_element <- page |>
    rvest::html_element(paste0("select[name='", name, "']"))

  if (is.na(select_element)) {
    stop("Select element with name '", name, "' not found on page")
  }

  options <- select_element |>
    rvest::html_elements("option")

  text <- rvest::html_text2(options)
  value <- rvest::html_attr(options, "value")
  data.frame(
    text = text,
    value = value
  )
}
