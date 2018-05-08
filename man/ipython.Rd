\name{ipython}
\alias{ipython}
\title{
Internal IPython class
}
\description{
Internal IPython class for communicating with jupyter kernels. Don't use it directly, instead use \link{ipyexec} for single command execution, and \code{ipython_engine} for use within knitr.
}
\usage{
ipython(...)
}
\arguments{
  \item{...}{
  kernel: Either NULL (create), 'existing' (latest jupyter kernel) or the json name of a jupyter kernel, obtained from the magic command '\%connect_info'

  message: Logical: display the result of command execution on the console
  debug: Logical: display debug information
  kill.on.exit: Logical: terminate the distant kernel when the object is deleted.
}
}
