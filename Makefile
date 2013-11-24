run: init util/run_nmfconsensus.r
	Rscript util/run_nmfconsensus.r

.PHONY: run init clean

init: util/init_dataset.r 100+100x50.gct util/.basetime

clean:
	rm -f Rprof.out 100+100x50.gct PCA_samples.png util/*time result.* util/.cophenetic

100+100x50.gct util/.basetime:
	Rscript util/init_dataset.r

