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
  )
)
