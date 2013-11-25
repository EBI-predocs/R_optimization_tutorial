R optimization tutorial
=======================

Your toy problem: NMF clustering
--------------------------------

We will consider a measurement of two populations, with 100 samples and 50 data
points each. They divide into two distinct clusters when applying e.g. [PCA][pca] to
the dataset. Our sample matrix `V` can then be approximated by matrices `W*H` that are
strictly non-negative (i.e., [Non-negative matrix factorizatiion][nmf]), which eases 
interpretation of results.

 * **V.** Our data matrix with the data points in rows (`k`) and samples in columns (`n`)
 * **H.** A `k*n` matrix. Each column can be interpreted as a sample and each row as
    weights of it belonging to either cluster.
 * **W.** A `m*k` matrix. Each column can be interpreted as a metasignature of a cluster.

->[![W*H approximates V][nmfimg]][nmf]<-

Suppose we didn't know there were two clusters and we'd want a fully automatic
way to identify the number of clusters and assign membership of each sample to
a given cluster. We can run NMF with different values of `k` and evaluate the 
cophenetic coefficient for each of them. It it expected to decline with more
clusters added (with k increased), but it will show local maxima with a cluster
number that fits the data well.

Ensuring code correctness and debugging
---------------------------------------

**We are here to solve scientific problems, not write nice code**



 * not about how the code looks, but ensuring correctness
 * link some reproducibility issues
 * testing code


**Using the debugger**
 * debugging can help (and is better than print statements everywhere)
 * describe debugger in Rstudio/R
 * this should be what to type


Optimising execution time
-------------------------

**Computing time is cheap, so why bother making code run fast?**

Another point that is frequently raised is that as computing time is becoming a 
commodity with modern hardware, it makes less and less sense to optimize code
execution time. While this is generally true, there is also another force counteracting
it: measurements get cheaper as well, and thus datasets get larger. R is for sure not
a very performant language, but some constructs are exceptionally slow (e.g. the
infamous `for` loops).

 * When performing operations on large data sets, runtime does 
     [often not linearly increase][bigo] with the size of the dataset and might easily
     hit the wall time of a computing cluster.
 * On the bright side, in most cases not all bits and pieces of code need to be 
     optimized. It is often enough to identify critical inner loops and realize that
     a 10x speedup in just that inner loop might well translate to almost the same
     speedup for the whole program.

One could also take the opposite point of view and argue that all high performance
code should be written in a low-level language, such as C or Fortran. But then again,
sanitizing IO, parallelizing execution, etc. are much easier done in a high level
language such as R. Ideally, it should be a combination of both? Turns out it is already,
with many packages implementing their core machinery in a compiled language that is
then called by R.

 * links LAPACK/BLAS -> matrix ops are about as fast as it gets (if compiled with)
 * critical elements could be written in C
 * spending time in R vs C code: eg. for vs apply

**Using the profiler to find bottlenecks**

 * records how much time spent in different functions
 * example syntax+output
 * have one example from nmfconsensus already, to point out where it is and how to find it
 * this should explain what to type

[pca]: http://en.wikipedia.org/wiki/Principal_component_analysis
[nmf]: http://en.wikipedia.org/wiki/Non-negative_matrix_factorization
[nmfimg]: http://upload.wikimedia.org/wikipedia/commons/f/f9/NMF.png
[bigo]: http://en.wikipedia.org/wiki/Big_O_notation

