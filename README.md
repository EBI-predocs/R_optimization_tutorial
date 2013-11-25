R optimization tutorial
=======================

Your toy problem: NMF clustering
--------------------------------

We will consider a measurement of two populations, with 100 samples and 50 data
points each. They divide into two distinct clusters when applying e.g. [PCA][pca] to
the dataset.

 * **V.** Our data matrix with the data points in rows (k) and samples in columns (n)
 * **H.** A k*n matrix
 * **W.** A m*k matrix

<center>![W*H approximates V][nmfimg]</center>

Suppose we didn't know there were two clusters and we'd want a fully automatic
way to identify the number of clusters and assign membership of each sample to
a given cluster. We can run NMF with different values of k and evaluate the 
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

 * large datasets: runtime increases mostly not linearly with sample size/number
 * might easily hit wall time of cluster
 * small modifications can easily yield 10x speed increase 
 * usually, only few steps are critical
 * packages often have compiled C/Fortran code in background
 * links LAPACK/BLAS -> matrix ops are about as fast as it gets (if compiled with)
 * sanitizing input/output easier in R
 * parallisation easier here (parallel, BatchJobs; low-level threading is a pain)
 * spending time in R vs C code: eg. for vs apply
 * have a couple examples: bad code, good code # no, move@solution
   * for vs apply
   * calculating something repeatedly in inner loop
   * '+'(and other) reducing stuff
   * special cases: expand.grid, outer


**Finding bottlenecks with the profiler**

 * records how much time spent in different functions
 * example syntax+output
 * have one example from nmfconsensus already, to point out where it is and how to find it
 * this should explain what to type

[pca]: http://en.wikipedia.org/wiki/Principal_component_analysis
[nmfimg]: http://upload.wikimedia.org/wikipedia/commons/f/f9/NMF.png

