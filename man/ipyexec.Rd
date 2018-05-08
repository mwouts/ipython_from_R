\name{ipyexec}
\alias{ipyexec}
\title{
Execute the desired code in a jupyter kernel.
}
\description{
Send the desired code to a jupyter kernel and retrieve the result of execution.
}
\usage{
ipyexec(code,
        options = list(kernel = getOption("kernel.default", "create"), results = "asis"),
        message = FALSE,
        debug = FALSE,
        latex = FALSE)
}
\arguments{
  \item{code}{
  (Python, or R, or Julia) code to be executed.
}
  \item{options}{
  List of options for execution. \code{kernel} points to the kernel where the code should be executed. Other options allow to format the result as desired.
}
  \item{message}{
  Logical: display the result of execution on the console
}
  \item{debug}{
  Logical: display debug information
}
  \item{latex}{
  Logical: format output as LaTeX
}
}

\seealso{
See \link{ipython_engine} for the knitr engine.
}
\examples{
ipyexec('a=17')
ipyexec('a+17')
}
