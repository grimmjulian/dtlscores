library(rix)

rix(
  date = "2026-03-11",
  r_pkgs = c("rvest", "devtools", "targets"),
	system_pkgs = c("html-tidy", "gnumake", "pandoc"),
	tex_pkgs = c("collection-fontsextra"),
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
