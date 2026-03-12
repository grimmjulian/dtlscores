#' Example dataset of competition
#'
#' A dataset containing the result of the competition between
#' Eintracht Frankfurt and TuS Vinnhorst from the 12.04.2025.
#' The competition took place in the 2025 season
#' of the 1. Bundesliga on the first matchday.
#'
#' @format A data frame with 15 columns and 24 rows:
#' \describe{
#'   \item{home_team}{Name of the home team}
#'   \item{guest_team}{Name of the guest team}
#'   \item{event}{Event of the pairing}
#'   \item{pairing_order}{Order of pairings per event}
#'   \item{home_gymnast}{Name of gymnast of home team}
#'   \item{home_gymnast_url}{URL to profile of gymnast of home team}
#'   \item{home_starts}{Logical value if the home team started the pairing}
#'   \item{home_d_value}{D-value of the home gymnast}
#'   \item{home_end_value}{End value of the home gymnast}
#'   \item{home_score_value}{Scraped score result of the home gymnast}
#'   \item{guest_gymnast}{Name of gymnast of guest team}
#'   \item{guest_gymnast_url}{URL to profile of gymnast of guest team}
#'   \item{guest_d_value}{D-value of the guest gymnast}
#'   \item{guest_end_value}{End value of the guest gymnast}
#'   \item{guest_score_value}{Scraped score result of the guest gymnast}
#' }
#'
#' @source https://www.deutsche-turnliga.de/dtl/historie/archiv/detailsm0.html?ID=2764
"competition"

#' Example dataset of a matchday
#'
#' A dataset containing the data of the first matchday
#' of the 2025 season of the 1. Bundesliga.
#'
#' @format A data frame with 3 columns and 4 rows:
#' \describe{
#'   \item{type_id}{type_id of the matchday}
#'   \item{type}{type of the matchday}
#'   \item{season_id}{season_id of the matchday}
#'   \item{season}{season of the matchday}
#'   \item{league_id}{league_id of the matchday}
#'   \item{league}{league of the matchday}
#'   \item{matchday_id}{matchday_id of the matchday}
#'   \item{matchday}{matchday label of the matchday}
#'   \item{datetime}{Date and time of the competition as POSIXct}
#'   \item{location}{Address of competition stadium}
#'   \item{title}{Title of competition; generally the two teams}
#'   \item{competition_url}{URL to competition page}
#'   \item{score}{Official final score result of competition}
#'   \item{gp}{Official final gp result of competition}
#' }
#'
#' @source https://www.deutsche-turnliga.de/archiv.html?Typ=Mann&SaisonID=20&LigaID=760&TagesID=666
"matchday"
