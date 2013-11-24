R optimization tutorial
=======================

We are here to solve scientific problems, not write nice code
-------------------------------------------------------------

 * not about how the code looks, but ensuring correctness
 * testing code
 * debugging can help (and is better than print statements everywhere)
 * describe debugger in Rstudio/R


Computing time is cheap, so why bother making it fast?
------------------------------------------------------

 * computing time is cheap, programmer time expensive, so why bother?
 * large datasets: runtime increases mostly not linearly with sample size/number
 * might easily hit wall time of cluster
 * small modifications can easily yield 10x speed increase 


But you can't do High Performance Computing in R. Or can you?
-------------------------------------------------------------

 * packages often have compiled C/Fortran code in background
 * links LAPACK/BLAS -> matrix ops are about as fast as it gets (if compiled with)
 * sanitizing input/output easier in R
 * parallisation easier here (parallel, BatchJobs; low-level threading is a pain)


The role of the infamous for loops
----------------------------------

 * usually, only few steps are critical
 * things that are notoriously slow: for loops
 * spending time in R vs C code: eg. for vs apply
 * have a couple examples: bad code, good code
   * for vs apply
   * calculating something repeatedly in inner loop
   * '+'(and other) reducing stuff
   * special cases: expand.grid, outer


Finding bottlenecks with the profiler
-------------------------------------

 * records how much time spent in different functions
 * example syntax+output
 * have one example from nmfconsensus already, to point out where it is and how to find it

