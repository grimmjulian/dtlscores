README.md: README.Rmd
	Rscript -e "devtools::build_readme()"

docs: README.md
	Rscript -e "roxygen2::roxygenize('.')"

targets:
	Rscript -e "targets::tar_make(script = 'data-raw/_targets.R')"

build: docs targets
	rm -f *.tar.gz
	R CMD build --compact-vignettes="gs+qpdf" .

check: build
	R CMD check *.tar.gz

cran: build
	rm -f *.tar.gz
	R CMD build --compact-vignettes="gs+qpdf" .
	R CMD check --as-cran *.tar.gz

test: 
	Rscript -e "testthat::test_local()"

clean: 
	rm -f README.html
	rm -f *.tar.gz
	rm -rf dtlscores.Rcheck

default.nix: gen-env.R
	nix-shell -p R rPackages.rix --run "Rscript gen-env.R"
