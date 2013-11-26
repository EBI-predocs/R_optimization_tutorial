all:
	echo $(shell whoami) > .name
	Rscript nmfconsensus.R

clean:
	rm -f .name .basetime .runtime .cophenetic result.*

