ipyexec <- function(code,
                    options=list(kernel=getOption("kernel.default", "create"), results="asis"),
                    message=FALSE,
                    debug=FALSE,
                    latex=FALSE)
{
  if(missing(code) && ("rstudioapi" %in% installed.packages()[,1]))
  {
    doc <- rstudioapi::getActiveDocumentContext()
    code = doc$selection[[1]]$text
    if(!length(code))
    {
      message("Please select some python code first")
      return(invisible())
    }
  }

  if(!exists(".ipython_store"))
    .ipython_store <<- list()

  kernel_name <- kernel <- options$kernel
  if(is.null(kernel_name))
    kernel_name <- "create"
  if(kernel_name=="create")
    kernel <- NULL

  if(!kernel_name %in% names(.ipython_store))
    .ipython_store[kernel_name] <<- list(ipython(kernel=kernel, message=message, debug=debug))

  .ipython_store[[kernel_name]]$exec(code, options, message=message, debug=debug, latex=latex)
}
