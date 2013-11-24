library(OCplus)
A = MAsim.smyth(ng=1000, n=20, p0=0.2)
#ng = 1000
#n = 20
#A = MAsim.var(ng=ng, n1=n, n2=n*2, p0=0.8)
#A[n*2:n*3] = A[n*2:n*3] * rep(runif(ng,0.75,1.25), n,1)
A = (A - min(A) + runif(1,0,1))/10

#rownames(A) = c(1:dim(A)[1])
#colnames(A) = c(1:dim(A)[2])
#write.gct(A, "50+50x5000.gct")

plotPCA = function(gct.matrix, my.title="PCA plot", my.classes=NULL) {
    my.exprs = t(gct.matrix)
    my.svd = svd(cov(my.exprs))
    my.iloads = solve(t(my.svd$v))
    my.weights = my.svd$d
    my.scores = my.exprs %*% my.iloads

    my.title = paste("PCA of samples capturing\n", 
        round(100*sum(my.weights[1:2])/sum(my.weights), digits=1), "% of variance")
    my.pc1 = paste("PC1 (", round(100*my.weights[1]/sum(my.weights), 1), "%)")
    my.pc2 = paste("PC2 (", round(100*my.weights[2]/sum(my.weights), 1), "%)")

    plot(my.scores[,1], my.scores[,2], main=my.title, xlab=my.pc1, ylab=my.pc2)
}

#source("nmf.r")
#runNMFinJobs(A, k=c(2:5), num.clusterings=5, maxniter=10000, seed=123, njobs=1)

#system.time(nmfconsensus("50+50x5000.gct", k.init=2, k.final=5, num.clusterings=5, maxniter=10000, error.function="euclidean"))
