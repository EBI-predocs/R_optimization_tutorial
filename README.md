R optimization tutorial
=======================

This tutorial will show you how to debug and vectorize R code. The concepts are 
applicable to other languages, such as Matlab or Python.

Two libraries are required to run the examples: `OCplus` and `RCurl`. You can install
them by typing the following commands:

```r
install.packages('RCurl')
source("http://bioconductor.org/biocLite.R")
biocLite("OCplus")
```

Your toy problem: NMF clustering
--------------------------------

We will consider a measurement of two populations, with 100 samples and 50 data
points each. They divide into two distinct clusters when applying e.g. [PCA][pca] to
the dataset. Our sample matrix `V` can then be approximated by matrices `W*H` that are
strictly non-negative (i.e., [Non-negative matrix factorization][nmf]), which eases 
interpretation of results.

 * **V.** Our data matrix with the data points in rows (`k`) and samples in columns (`n`)
 * **H.** A `k*n` matrix. Each column can be interpreted as a sample and each row as
    weights of it belonging to either cluster.
 * **W.** A `m*k` matrix. Each column can be interpreted as a metasignature of a cluster.

[![W*H approximates V][nmfimg]][nmf]

Suppose we didn't know there were two clusters and we'd want a fully automatic
way to identify the number of clusters and assign membership of each sample to
a given cluster. We can run NMF with different values of `k` and evaluate the 
cophenetic coefficient for each of them. It it expected to decline with more
clusters added (with k increased), but it will show local maxima with a cluster
number that fits the data well.

Ensuring code correctness and debugging
---------------------------------------

Try to run your NMF clustering script, either by typing

```r
source("nmfconsensus.R")
runNMF()
```

from within R or by calling it from the command line

```bash
./nmfconsensus.R
```

You will realize that it throws an error. Try to spot and correct it.

**Using the debugger**

If there is an error you can not spot right away, it makes sense to run your code 
through the debugger. You can debug a function by calling `debug()` on it. In our
case, you will want to call `debug(nmfconsensus)` It will show the chunk of code 
that is about to be executed. You can type in the following commands:

 * **&lt;Enter&gt; or n:** execute the next single statement
 * **c:** execute the next block
 * **Q:** quit the debugger

During debugging, you can inspect variables and modify them as if you were in a 
standard R session If you no longer want to use the debugger you can either call
`undebug()` on your function or just `source()` your script file again.

**Correcting errors is fine, but why should I optimize my code when it works?**

An argument that is often used is that "science is about new findings, not writing 
nice code" and "if my script produces the right output, this is good enough". People 
who say that are missing the point, really. Writing segmented and testable code is 
*not* about how it looks but about ensuring correctness. After all, how do you know
your code is [doing the right thing][natreproc] as opposed to giving you the output 
*you want*.

 * Don't worry too much when doing exploratory analyses. Those are there to give
     you ideas what your data *might* contain. But *do* test your code when you 
     confirm a hypothesis.
 * Writing testable code is about splitting your functionality into segments that
     are simple enough so you know the right output for a given input. All that's
     left to do is write a separate test script that makes sure that makes sure 
     of that. Also, `stopifnot()` statements are useful to make sure assumptions 
     you make about your variables are correct.

Optimising execution time
-------------------------

When running your `runNMF()` function again, you will see that it now runs and produces
the output PDF. However, it runs for quite a while. Try to improve the execution time.

**Using the profiler to find bottlenecks**

In case you do not know which functions are causing most of the execution time, you
can run a profiler to figure that out. Use the commands below and the run your script again.

 * `Rprof()` activates the profiler, `Rprof(NULL)` deactivates it. Output is stored
     in the file `Rprof.out`.
 * You can view the output with `summaryRprof()`, but you might need to `library(tools)` 
     first.

If we, for instance, activate the profiler and then run `runNMF()`, the output is similar
to the following:

```r
> summaryRprof()
$by.self
                     self.time self.pct total.time total.pct
"max"                    26.18    43.36      26.18     43.36
"min"                    24.24    40.15      24.24     40.15
"nmfconsensus"            2.42     4.01      60.28     99.83
"%*%"                     1.74     2.88       1.74      2.88
...

$by.total
                     total.time total.pct self.time self.pct
"runNMF"                  60.36     99.97      0.00     0.00
"system.time"             60.32     99.90      0.00     0.00
"nmfconsensus"            60.28     99.83      2.42     4.01
...
```

Where `$by.self` and `$by.total` are ordered by a function taking the maximum time by
itself (`self.time`, former) or including all functions that were called from it 
(`total.time`, latter). With this information you can figure out which part of your 
code is the bottleneck by means of execution time.

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
language such as R. Ideally, it should be a combination of both? Turns out it already is,
with many packages implementing their core machinery in a compiled language that is
then called by R.

 * R can be [compiled][rcompile] with [LAPACK][lapack] and [BLAS][blas] support. Those
     are linear algebra libraries that implement optimized operations such as matrix
     multiplications, among others. Compiling with support for those can dramatically
     speed up operations such as `%*%`, as well as allow for implicit 
     [parallelization][openblas].
 * Performance-critical code chunks can also be compiled into a dynamically linked
     [C, Fortran][dynload] or [C++][rcpp] library and then called from R. By moving those
     chunks to a compiled language (which means, in the easiest case, using `apply` instead
     of `for`) most of the execution time can be spent in compiled code.

Follow ups
----------

Advanced R programming: http://adv-r.had.co.nz/

[pca]: http://en.wikipedia.org/wiki/Principal_component_analysis
[nmf]: http://en.wikipedia.org/wiki/Non-negative_matrix_factorization
[nmfimg]: http://upload.wikimedia.org/wikipedia/commons/f/f9/NMF.png
[natreproc]: http://www.nature.com/nature/journal/v470/n7334/full/470305b.html
[bigo]: http://en.wikipedia.org/wiki/Big_O_notation
[rcompile]: https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/r
[lapack]: http://en.wikipedia.org/wiki/LAPACK
[blas]: http://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms
[openblas]: http://www.openblas.net/
[dynload]: http://users.stat.umn.edu/~geyer/rc/
[rcpp]: http://dirk.eddelbuettel.com/code/rcpp.html

