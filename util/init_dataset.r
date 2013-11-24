#!/usr/bin/env Rscript

writeDataset = function(num.genes=50, num.samples=100, filename="100+100x50.gct") {
    library(OCplus)
    A = MAsim.smyth(ng=num.genes, n=num.samples, p0=0.2)
    A = (A - min(A) + runif(1,0,1))/10
    rownames(A) = c(1:dim(A)[1])
    colnames(A) = c(1:dim(A)[2])
    write.gct(A, filename)
    return(A)
}

set.seed(1234)
source("nmfconsensus.R")
A = writeDataset()

cat("Running baseline benchmark... this will take a minute or two\n")
runtime = system.time(nmfconsensus('100+100x50.gct', 2, 5, 3, 500, 'euclidean'))
cat(as.double(runtime)[1], "\n", file=file.path("util", ".basetime"))

cat("\ndone in", as.double(runtime)[1], "seconds\n\n")

