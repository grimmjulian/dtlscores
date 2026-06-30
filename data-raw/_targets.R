library(targets)
# Set target options:
tar_option_set(
  packages = c("tibble") # Packages that your targets need for their tasks.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  tar_target(
    name = competition,
    command = {
      url <- "https://www.deutsche-turnliga.de/dtl/historie/archiv/detailsm0.html?ID=2764"
      parse_competition(url)
    }
  ),
  tar_target(
    name = matchday,
    command = {
      url <- "https://www.deutsche-turnliga.de/archiv.html?Typ=Mann&SaisonID=20&LigaID=760&TagesID=666"
      parse_matchday(url)
    }
  ),
  tar_target(
    name = matchday_urls,
    command = scrape_matchday_urls()
  ),
  tar_target(
    name = save_data,
    command = {
      usethis::use_data(competition, overwrite = TRUE)
      usethis::use_data(matchday, overwrite = TRUE)
      usethis::use_data(matchday_urls, overwrite = TRUE)
    }
  ),
  tar_target(
    name = competitions,
    command = {
      u <- matchday_urls$url
      lapply(u, parse_matchday) |>
        do.call(what = rbind)
    }
  ),
  tar_target(
    name = pairings,
    command = {
      u <- competitions$competition_url
      lapply(u, parse_competition) |>
        do.call(what = rbind)
    }
  ),
  tar_target(
    name = routines,
    command = {
      a <- pairings
      a[["guest_starts"]] <- !a[["home_starts"]]
      home_routines <- a[, grep(
        pattern = "^guest_",
        colnames(a),
        invert = TRUE
      )]
      colnames(home_routines) <- sub("^home_", "", colnames(home_routines))
      home_routines[["is_home"]] <- TRUE

      guest_routines <- a[, grep(
        pattern = "^home_",
        colnames(a),
        invert = TRUE
      )]
      colnames(guest_routines) <- sub("^guest_", "", colnames(guest_routines))
      guest_routines[["is_home"]] <- FALSE

      rbind(home_routines, guest_routines)
    }
  )
)
