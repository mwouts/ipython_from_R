# Introduction

This is an R package that offers
- interactive execution of commands in jupyter kernels
- and a knitr engine for executing python code

# How to use it

Install the package with
```r
devtools::install_github('mwouts/ipython_from_R')
```

Then load the package and execute a first python command:
```r
library(ipython)
ipyexec('1+1')
```

If you prefer to connect to an already existing kernel (for instance, if you have started a notebook server), identify the kernel in jupyter with
```python
%connect_info
## ... kernel-aaaaaaa-ffff-4444-8888-777777755555.json
```

and use this information to connect to the same session:
```r
options(kernel.default='kernel-aaaaaaa-ffff-4444-8888-777777755555.json')
ipyexec('1+1')
## "2"
```

# Using the ipython engine for knitr

Insert an initialization chunk in your R notebook that contains

```r
library(ipython)
knitr::knit_engines$set(python = ipython_engine) # define the ipython engine
# knitr::opts_chunk$set(kernel='existing') # use this if you start the kernel yourself
# knitr::opts_chunk$set(kernel='kernel-aaaaaaa-ffff-4444-8888-777777755555.json') # from %connect_info
```

Then, python chunks will use the ipython engine.

A more detailed example is given [here](https://github.com/mwouts/ipython_from_R/blob/master/inst/examples/knitr-ipython.Rmd)

# Why not reticulate?

Reticulate is an excellent package for executing python code from R, and is developped by the rstudio team. My contribution here does not intend to compete with reticulate. It was developed before I [became aware](https://github.com/yihui/knitr/pull/1424) of reticulate. As much as possible, I am now switching to reticulate. Some of the experience gained here may be useful for reticulate as well.

Major differences with reticulate are
- reticulate starts python as a sub-process, while ipython for R uses the jupyter messaging protocol to communicate with python processes
- reticulate is able to capture matplotlib plots - this implementation is able to capture any rich output
