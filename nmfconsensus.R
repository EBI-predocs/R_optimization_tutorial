#!/usr/bin/env Rscript

nmfconsensus <- function(input.ds, k.init, k.final, num.clusterings, maxniter, 
                         error.function, rseed=123456789, stopconvergence = 40, 
                         stopfrequency = 10, doc.string="result", directory="") {
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
    n.iter<-as.integer(maxniter)
    if (!is.na(rseed)) {
         seed <- as.integer(rseed)
    }
    stopfreq <- as.integer(stopfrequency)
    stopconv <- as.integer(stopconvergence)

    D <- read.gct(input.ds)
    A <- data.matrix(D)

    # Threshold negative values to small quantity 
    eps <- .Machine$double.eps
    A[A < 0] <- eps

    cols <- length(A[1,])
    rows <- length(A[,1])
    col.names <- names(D)

    num.k <- k.final - k.init + 1
    rho <- vector(mode = "numeric", length = num.k)
    k.vector <- vector(mode = "numeric", length = num.k)

    k.index <- 1
    connect.matrix.ordered <- array(0, c(num.k, cols, cols))

    for (k in k.init:k.final) {
        nf <- layout(matrix(c(1,2,3,4,5,6,7,8), 4, 2, byrow=T), 
                     c(1, 1, 1, 1), c(1, 1), TRUE)
        assign <- matrix(0, nrow = num.clusterings, ncol = cols)

        for (i in 1:num.clusterings) {
            NMF.out <- NMF(V = A, k = k, maxniter = n.iter, seed = seed + i, 
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

    k.linkage = 2
    k.index.linkage = which(c(k.init:k.final)==k.linkage)
    sub.string <- paste(doc.string, " k=", k.linkage, sep="")
    plot(HC, xlab="samples", cex = 0.75, labels = col.names, sub = sub.string, col = 
        "blue", main = paste("Ordered Linkage Tree. Coph=", rho[k.index.linkage]))

    dev.off()

    xx <- cbind(k.vector, rho)
#    write(xx, file= paste(directory, doc.string, ".", "cophenetic.txt", sep=""))
    return(xx)
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
matrix.abs.plot <- function(V, axes = F, log = F, norm = T, transpose = T, 
                            matrix.order = T, max.v = 1, min.v = 0, main = " ", 
                            sub = " ", xlab = " ", ylab = "  ") {
    rows <- length(V[,1])
    cols <- length(V[1,])
    if (log == T) {
        V <- log(V)
    }

    B <- matrix(0, nrow=rows, ncol=cols)

    for (i in 1:rows) {
        for (j in 1:cols) {
            if (matrix.order == T) {
                k <- rows - i + 1
            } else {
                k <- i
            }
            if (norm == T) {
                if ((max.v == 1) && (min.v == 0)) {
                    max.val <- max(V)
                    min.val <- min(V)
                } else {
                    max.val = max.v
                    min.val = min.v
                }
            }
            B[k, j] <-  max.val - V[i, j] + min.val
        }
    }

    if (transpose == T) {
        B <- t(B)
    }

    if (norm == T) {
        image(z = B, zlim = c(min.val, max.val), axes = axes, 
              col = rainbow(100, s = 1.0, v = 0.75, start = 0.0, end = 0.75), 
              main = main, sub = sub, xlab = xlab, ylab = ylab) 
    } else {
        image(z = B, axes = axes, col = rainbow(100, s = 1, v = 0.6, start = 0.1, 
              end = 0.9), main = main, sub = sub, xlab = xlab, ylab = ylab) 
    }

    return(list(B, max.val, min.val))
}

#
# Plot membership "genes"
#
metagene.plot <- function(H, main = " ", sub = " ", xlab = "samples ", ylab = "amplitude") {
    k <- length(H[,1])
    S <- length(H[1,])
    index <- 1:S
    maxval <- max(H)
    minval <- min(H)

    plot(index, H[1,], xlim=c(1, S), ylim=c(minval, maxval), main = main, 
         sub = sub, ylab = ylab, xlab = xlab, type="n")

    for (i in 1:k) {
        lines(index, H[i,], type="l", col = i, lwd=2)
    }
}

#
# Plots a heatmap plot of a consensus matrix
#
ConsPlot <- function(V, col.labels, col.names, main = " ", sub = " ", xlab=" ", ylab=" ") {
    cols <- length(V[1,])
    B <- matrix(0, nrow=cols, ncol=cols)
    max.val <- max(V)
    min.val <- min(V)
    for (i in 1:cols) {
        for (j in 1:cols) {
            k <- cols - i + 1
            B[k, j] <-  max.val - V[i, j] + min.val
        }
    }

    col.names2 <- rev(col.names)
    col.labels2 <- rev(col.labels)
    D <- matrix(0, nrow=(cols + 1), ncol=(cols + 1))

    col.tag <- vector(length=cols, mode="numeric")
    current.tag <- 0
    col.tag[1] <- current.tag
    for (i in 2:cols) {
        if (col.labels[i] != col.labels[i - 1]) {
            current.tag <- 1 - current.tag
        }
        col.tag[i] <- current.tag
    }
    col.tag2 <- rev(col.tag)
    D[(cols + 1), 2:(cols + 1)] <- ifelse(col.tag %% 2 == 0, 1.02, 1.01)
    D[1:cols, 1] <- ifelse(col.tag2 %% 2 == 0, 1.02, 1.01)
    D[(cols + 1), 1] <- 1.03
    D[1:cols, 2:(cols + 1)] <- B[1:cols, 1:cols]

    col.map <- c(rainbow(100, s = 1.0, v = 0.75, start = 0.0, end = 0.75), 
                  "#BBBBBB", "#333333", "#FFFFFF")
    image(1:(cols + 1), 1:(cols + 1), t(D), col = col.map, axes=FALSE, 
           main=main, sub=sub, xlab= xlab, ylab=ylab)

    for (i in 1:cols) {
        col.names[i]  <- paste("      ", substr(col.names[i], 1, 12), sep="")
        col.names2[i] <- paste(substr(col.names2[i], 1, 12), "     ", sep="")
    }

    axis(2, at=1:cols, labels=col.names2, adj= 0.5, tick=FALSE, las = 1, 
         cex.axis=0.50, font.axis=1, line=-1)
    axis(2, at=1:cols, labels=col.labels2, adj= 0.5, tick=FALSE, las = 1, 
         cex.axis=0.65, font.axis=1, line=-1)
    axis(3, at=2:(cols + 1), labels=col.names, adj= 1, tick=FALSE, las = 3, 
         cex.axis=0.50, font.axis=1, line=-1)
    axis(3, at=2:(cols + 1), labels=as.character(col.labels), adj = 1, tick=FALSE, 
         las = 1, cex.axis=0.65, font.axis=1, line=-1)
}

#
# Reads a gene expression dataset in GCT format and converts it into an R data frame
#
read.gct <- function(filename = "NULL") { 
    ds <- read.delim(filename, header=T, sep="\t", quote="", skip=2, row.names=1, 
                     blank.lines.skip=T, comment.char="", as.is=T)
    ds <- ds[-1]
    return(ds)
}

