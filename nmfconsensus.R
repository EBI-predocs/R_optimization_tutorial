#!/usr/bin/env Rscript

nmfconsensus <- function(A, k.init=2, k.final=5, num.clusterings=3,
                         maxniter=1000, error.function='euclidean', rseed=123456789, 
                         stopconvergence = 40, stopfrequency = 10, doc.string="result", 
                         directory="") {
#
#  GenePattern Methodology for:
#
#  Metagenes and Molecular Pattern Discovery using Matrix Factorization
#  Jean-Philippe Brunet, Pablo Tamayo, Todd. R. Golub, and Jill P. Mesirov
# 
#  Author:  Pablo Tamayo (tamayo@genome.wi.mit.edu)
#
#  Based on the original matlab version written by Jean-Philippe Brunet (brunet@broad.mit.edu) and
#  with additional contributions from: Ted Liefeld (liefeld@broad.mit.edu)   
#  Date:  November 27, 2003
#
#  Last change March 3, 2005: modifications to make the output more readable.
#
#  Execute from an R console window with this command:
#  source("<this file>", echo = TRUE)
#  E.g. someoutput <- mynmf2(input.ds="c:\\nmf\\all_aml.res",k.init=2,k.final=5,num.clusterings=20, maxniter=500) 
#
#  For details on the method see:
#
#  Proc. Natl. Acad. Sci. USA 2004 101: 4164-4169
#  http://www.broad.mit.edu/cgi-bin/cancer/publications/pub_paper.cgi?mode=view&paper_id=89
#
#  Modifications for EBI Bioinformatics Workshop 2013: Michael Schubert <schubert@ebi.ac.uk>
#

    k.init<-as.integer(k.init)
    k.final<-as.integer(k.final)
    num.clusterings<-as.integer(num.clusterings)
    maxniter<-as.integer(maxniter)
    if (!is.na(rseed)) {
        seed <- as.integer(rseed)
        set.seed(seed)
    }
    stopfreq <- as.integer(stopfrequency)
    stopconv <- as.integer(stopconvergence)

    # Threshold negative values to small quantity 
    eps <- .Machine$double.eps
    A[A < 0] <- eps

    cols <- length(A[1,])
    rows <- length(A[,1])
    col.names <- names(D)

    num.k <- k.final - k.init + 1
    rho <- vector(mode = "numeric", length = num.k)
    k.vector <- vector(mode = "numeric", length = num.k)

    k.index <- "1"
    connect.matrix.ordered <- array(0, c(num.k, cols, cols))

    for (k in k.init:k.final) {
        assign <- matrix(0, nrow = num.clusterings, ncol = cols)

        for (i in 1:num.clusterings) {
            NMF.out <- NMF(V = A, k = k, maxniter = maxniter, seed = seed + i, 
                           stopconv = stopconv, stopfreq = stopfreq)

            for (j in 1:cols) { # Find membership
                class <- order(NMF.out$H[,j], decreasing=T)
                assign[i, j] <- class[1]
            }
        }

        connect.matrix <- matrix(0, nrow = cols, ncol = cols)

        for (i in 1:num.clusterings) {
            for (j in 1:cols) {
                for (p in 1:cols) {
                    if (j != p) {
                        if (assign[i, j] == assign[i, p]) {
                            connect.matrix[j, p] <- connect.matrix[j, p] + 1
                        } 
                    } else {
                        connect.matrix[j, p] <- connect.matrix[j, p] + 1
                    }
                }
            }
        }

        connect.matrix = connect.matrix / num.clusterings
        dist.matrix = as.dist(1 - connect.matrix)
        HC = hclust(dist.matrix, method="average")
        dist.coph = cophenetic(HC)

        k.vector[k.index] <- k
        rho[k.index] <- cor(dist.matrix, dist.coph)
        rho[k.index] <- signif(rho[k.index], digits = 4)

        for (i in 1:cols)
            for (j in 1:cols)
                connect.matrix.ordered[k.index, i, j] <- connect.matrix[HC$order[i], HC$order[j]]

        # compute consensus clustering membership
        membership <- cutree(HC, k = k)
        max.k <- max(membership)
        items.names.ordered <- col.names[HC$order]
        membership.ordered <- membership[HC$order]
        results <- data.frame(cbind(membership.ordered, items.names.ordered))

        if (k > k.init) {
            all.membership <- cbind(all.membership, membership)
        }
        else {
            all.membership <- cbind(membership)
        }

        resultsGct <- data.frame(membership.ordered)
        row.names(resultsGct) <- items.names.ordered
        filename <- paste(directory, doc.string, ".", "consensus.k.",k, ".gct", sep="", collapse="")

        k.index <- k.index + 1
    } # end of loop over k

    # Save consensus matrices in one file
    filename <- paste(directory, doc.string, ".", "consensus.all.k.plot.pdf", sep="")
    pdf(file=filename, width = 8.5, height = 11)

    nf <- layout(matrix(c(1,2,3,4,5,6,7,8), 4, 2, byrow=T), c(1,1,1,1), c(1,1,1,1), TRUE)

    for (k in 1:num.k) { 
        matrix.abs.plot(connect.matrix.ordered[k,,], log = F, main = paste("k=", k.vector[k]), 
            sub = paste("Cophenetic coef.=", rho[k]), ylab = "samples", xlab ="samples")
    }

    y.range <- c(1 - 2*(1 - min(rho)), 1)
    plot(k.vector, rho, main ="Cophenetic Coefficient", xlim=c(k.init, k.final), 
         ylim=y.range, xlab = "k", ylab="Cophenetic correlation", type = "n")
    lines(k.vector, rho, type = "l", col = "black")
    points(k.vector, rho, pch=22, type = "p", cex = 1.25, bg = "black", col = "black")

    my.exprs = t(A)
    my.svd = svd(cov(my.exprs))
    my.iloads = solve(t(my.svd$v))
    my.weights = my.svd$d
    my.scores = my.exprs %*% my.iloads
    my.title = paste("PCA of samples capturing\n",
        round(100*sum(my.weights[1:2])/sum(my.weights), digits=1), "% of variance")
    my.pc1 = paste("PC1 (", round(100*my.weights[1]/sum(my.weights), 1), "%)")
    my.pc2 = paste("PC2 (", round(100*my.weights[2]/sum(my.weights), 1), "%)")
    plot(my.scores[,1], my.scores[,2], main=my.title, xlab=my.pc1, ylab=my.pc2)

    dev.off()

    xx <- cbind(k.vector, rho)
    write(connect.matrix.ordered, file=".cophenetic")
}

#####################################################################################
#
# Compute NMF
#
#####################################################################################

#
# Does the actual Non-negative Matrix Factorization
#
NMF <- function(V, k, maxniter = 2000, seed = 123456, stopconv = 40, stopfreq = 10) {
    N <- length(V[,1])
    M <- length(V[1,])
    set.seed(seed)
    W <- matrix(runif(N*k), nrow = N, ncol = k)  # Initialize W and H with random numbers
    H <- matrix(runif(k*M), nrow = k, ncol = M)

    VP <- matrix(nrow = N, ncol = M)

    error.v <- vector(mode = "numeric", length = maxniter)
    new.membership <- vector(mode = "numeric", length = M)
    old.membership <- vector(mode = "numeric", length = M)
    eps <- .Machine$double.eps

    for (t in 1:maxniter) {
        VP = W %*% H

        H <- H * (crossprod(W, V)/crossprod(W, VP)) + eps
        VP = W %*% H
        H.t <- t(H)
        W <- W * (V %*% H.t)/(VP %*% H.t) + eps
        error.v[t] <- sqrt(sum((V - VP)^2))/(N * M)
        if (t %% stopfreq == 0) {
            for (j in 1:M) {
                class <- order(H[,j], decreasing=T)
                new.membership[j] <- class[1]
            }
            if (sum(new.membership == old.membership) == M) {
                no.change.count <- no.change.count + 1
            } else {
                no.change.count <- 0
            }
            if (no.change.count == stopconv) break
            old.membership <- new.membership
        }
    }

    return(list(W = W, H = H, t = t, error.v = error.v))
}

#####################################################################################
#
# Plotting routines
#
#####################################################################################

#
# Plots a clustered matrix vor membership visualization
#
matrix.abs.plot <- function(V, axes = F, log = F, transpose = T,  main = " ", sub = " ", xlab = " ", ylab = "  ", plot = T) {
    max.v = 1
    min.v = 0

    rows <- length(V[,1])
    cols <- length(V[1,])
    if (log == T) {
        V <- log(V)
    }

    B <- matrix(0, nrow=rows, ncol=cols)

    for (i in 1:rows) {
        for (j in 1:cols) {
            k <- rows - i + 1
            max.val <- max(V)
            min.val <- min(V)
            B[k, j] <-  max.val - V[i, j] + min.val
        }
    }

    if (transpose == T) {
        B <- t(B)
    }

    if (plot == T) {
        image(z = B, zlim = c(min.val, max.val), axes = axes, 
              col = rainbow(100, s = 1.0, v = 0.75, start = 0.0, end = 0.75), 
              main = main, sub = sub, xlab = xlab, ylab = ylab) 
    }

    return(list(B, max.val, min.val))
}

#
# Reads a gene expression dataset in GCT format and converts it into an R data frame
#
read.gct <- function(filename = "NULL") { 
    ds <- read.delim(filename, header=T, sep="\t", quote="", skip=2, row.names=1, 
                     blank.lines.skip=T, comment.char="", as.is=T)
    ds <- ds[-1]
    return(ds[,colSums(is.na(ds)) != nrow(ds)]) # why do I need this all of a sudden?
}

#
# Write a data matrix to GCT format
#
write.gct <- function (gct, filename)
{
    f <- file(filename, "w")
    cat("#1.2", "\n", file = f, append = TRUE, sep = "")
    cat(dim(gct)[1], "\t", dim(gct)[2], "\n", file = f, append = TRUE, sep = "")

    cat("Name", "\t", file = f, append = TRUE, sep = "")
    cat("Description", "\t", file = f, append = TRUE, sep = "")
    cat(c(1:(dim(gct)[2]-1)), file = f, append = TRUE, sep = "\t")

    names <- names(gct)
    for (j in 1:length(names)) {
        cat("\t", names[j], file = f, append = TRUE, sep = "")
    }
    cat("\n", file = f, append = TRUE, sep = "")
    oldWarn <- options(warn = -1)

    m <- matrix(nrow = dim(gct)[1], ncol = dim(gct)[2] +  2)
    m[, 1] <- row.names(gct)
    m[, 2] <- row.names(gct)
    index <- 3
    for (i in 1:dim(gct)[2]) {
        m[, index] <- gct[, i]
        index <- index + 1
    }
    write.table(m, file = f, append = TRUE, quote = FALSE, sep = "\t", eol = "\n", col.names = FALSE, row.names = FALSE)
    close(f)
    options(warn = 0)
    return(gct)
}

#####################################################################################
#
# Benchmarking code, ***DO NOT CHANGE THIS***
#
#####################################################################################
runNMF = function() {
    if (! file.exists(".name")) {
        if (! interactive())
            stop("need to run in interactive mode first time")
        name = readline("enter your name: ")
        cat(name, "\n", file=".name")
    }
    else {
        name = as.character(read.delim(".name", header=F)$V1)
    }

    num.genes=50
    num.samples=100

    library(OCplus)
    set.seed(4621)
    A = MAsim.smyth(ng=num.genes, n=num.samples, p0=0.2)
    A = (A - min(A) + runif(1,0,1))/10
    rownames(A) = c(1:dim(A)[1])
    colnames(A) = c(1:dim(A)[2])

    library(tools)
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
    runtime = system.time(nmfconsensus(A, 2, 5, 3, 500, 'euclidean'))

    if (md5sum('.cophenetic') != "78fbfc339cd56f709459d2c2bfc25b95")
        stop("You introduced an error somewhere, the result doesn't match the reference")

    runtime = as.double(runtime)[1]
    cat("Finished in ", runtime , "s\n")

    library(RCurl) # post results
    invisible(postForm("http://www.ebi.ac.uk/~schubert/ropt/index.php", name=name, 
                       score=as.character(runtime)))
}

if (! interactive()) {
    runNMF()
}

