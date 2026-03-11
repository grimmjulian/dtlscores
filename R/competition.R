fill <- function(vec) {
	l <- seq_along(vec)
	for (i in l[-1]) {
		if (is.na(vec[[i]])) {
			vec[[i]] <- vec[[i - 1]]
		}
	}
	vec
}

parse_competition <- function(html) {
	html <- rvest::read_html(html)
	df <- html |>
		rvest::html_element(".Einzelnachweis") |>
		rvest::html_table()

	df <- df |>
		dplyr::mutate(
			home_team = df[[1]][[1]],
			guest_team = df[[6]][[1]],
			event = fill(X10),
			event = dplyr::recode_values(
				event,
				"Boden" ~ "floor",
				"Pferd" ~ "pommel_horse",
				"Ringe" ~ "still_rings",
				"Sprung" ~ "vault",
				"Barren" ~ "parallel_bars",
				"Reck" ~ "high_bar"
			),
			event = factor(event, levels = unique(event)),
			home_gymnast = X1,
			home_d_value = X2,
			home_end_value = X3,
			home_score_value = X4,
			guest_gymnast = X6,
			guest_d_value = X7,
			guest_end_value = X8,
			guest_score_value = X9
		)
	event_start_row <- which(df[[1]] == "Turner") + 1
	event_end_row <- which(df[[1]] == "Summe") - 1
	event_rows <- Map(seq, event_start_row, event_end_row) |>
		unlist()

	df <- df[event_rows, ]
	df <- cbind(df, parse_competition_tags(as.character(html)))

	df |>
		dplyr::group_by(event) |>
		dplyr::mutate(pairing_order = seq_len(dplyr::n())) |>
		dplyr::ungroup() |>
		dplyr::mutate(
			dplyr::across(
				dplyr::ends_with("value"),
				\(x) as.numeric(gsub(",", ".", x))
			)
		) |>
		dplyr::relocate(home_gymnast_url, .after = home_gymnast) |>
		dplyr::relocate(home_starts, .after = home_gymnast_url) |>
		dplyr::relocate(guest_gymnast_url, .after = guest_gymnast) |>
		dplyr::select(-dplyr::starts_with("X"))
}

parse_competition_tags <- function(html) {
	tags <- rvest::read_html(html) |>
		rvest::html_element(".Einzelnachweis") |>
		rvest::html_elements("a")

	urls <- tags |>
		rvest::html_attr("href")

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
