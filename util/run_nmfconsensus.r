#!/usr/bin/env Rscript

library(tools)
source("nmfconsensus.R")

unlink(file.path("util", ".time"))

set.seed(7531)
V = matrix(rexp(16, rate=.1), ncol=4)
Bout = matrix.abs.plot(V, plot=F, transpose=F)
Bref = max(V) - V + min(V)
Bref = apply(Bref, 2, rev)
if (! all(Bout[[1]] == Bref)) {
    stop("matrix.abs.plot() produces a different result than it should")
}

set.seed(6531)
res = NMF(V,3,50)
if (abs(sum(sample(c(res$W,res$H), 3) - c(0.5211503,5.6024402,17.9820890))) > 1e-4)
    stop("NMF() produces a different result than it should")

cat("\nRunning benchmark... this will take a minute or two\n")
runtime = system.time(nmfconsensus('100+100x50.gct', 2, 5, 3, 500, 'euclidean'))
md5 = md5sum(file.path('util','.cophenetic'))
if (! md5 %in% c("e439926293bb11c40ea6cc44669b09aa"))
    stop("You introduced some error somewhere, the result doesn't match the reference")

basetime = read.delim(file.path("util", ".basetime"), header=F)
runtime = as.double(runtime)[1]
cat(runtime, "\n", file=file.path("util", ".runtime"))
cat("Finished in ", runtime , "(", as.double(basetime)/runtime,"x speedup)\n")

