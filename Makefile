README.md: README.Rmd
	Rscript -e "devtools::build_readme()"

docs: README.md
	Rscript -e "roxygen2::roxygenize('.')"

check:
	rm -f *.tar.gz
	R CMD build --compact-vignettes="gs+qpdf" .
	R CMD check *.tar.gz

cran: 
	rm -f *.tar.gz
	R CMD build --compact-vignettes="gs+qpdf" .
	R CMD check --as-cran *.tar.gz

test: 
	Rscript -e "testthat::test_local()"

clean: 
	rm README.html
	rm *.tar.gz

