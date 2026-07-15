to_routines <- function(pairings) {
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

  routines <- rbind(home_routines, guest_routines)
  routines[
    !grepl(
      pattern = "^kein Turner$",
      routines$gymnast,
      ignore.case = TRUE
    ),
  ]
}
