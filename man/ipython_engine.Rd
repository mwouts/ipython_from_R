\name{ipython_engine}
\alias{ipython_engine}
\title{
IPython engine for knitr
}
\description{
The IPython engine allows knitr to communicate with jupyter kernels, and to execute chunk of codes in R+markdown (or R+LaTeX documents) in jupyter kernels. Rich outputs (text, html and images) are supported.
}
\usage{
ipython_engine(options, message = FALSE, debug = TRUE)
}
\arguments{
  \item{options}{
   A list of options (to be constructed by knitr)
}
  \item{message}{
  Logical: print the result of execution on the console. Otherwise, return it as a character vector.
}
  \item{debug}{
  Logical: display debug information.
}
}
\examples{
# Define the ipython engine
knitr::knit_engines$set(ipython = ipython_engine)
# Activate the engine for all chuncks by default
knitr::opts_chunk$set(engine='ipython') # alternatively, use chunk option engine='ipython'
# And now, tell ipython which kernel to connect to
# knitr::opts_chunk$set(kernel='create') # create a new kernel for each run (and quit)
# knitr::opts_chunk$set(kernel='existing') # use this to connect to the last kernel you started
# knitr::opts_chunk$set(kernel='kernel-55381.json') # use this if you want to connect to an already existing kernel, that you have identified with the magic command '\%connect_info' in ipython or in jupyter.
}
