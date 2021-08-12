.PHONY: gitInstall RandRStudioInstall windowsInstall 

all: gitInstall RandRStudioInstall windowsInstall windowsAndLinux

clean:
	rm -rf *.md *.html 

%.html: %.Rmd
	echo $(<)
	Rscript -e "rmarkdown::render('$(<)')"

accessingUnixCommandLine.html: accessingUnixCommandLine.md
	echo $(<)
	pandoc -s -o accessingUnixCommandLine.html accessingUnixCommandLine.md
