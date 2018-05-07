ipython = setRefClass("ipython",
                      fields = list(kernel = "character", ipyexec = "character", message="logical", debug="logical", kill.on.exit="logical"))

ipython$methods(
  initialize = function(kernel=NULL, message=TRUE, debug=FALSE,
                        kill.on.exit=is.null(kernel)) {
    .self$message = message
    .self$debug = debug
    .self$kill.on.exit = kill.on.exit

    python <- Sys.which("python")
    if(python == "")
      stop("'python' not found. Please make sure python is available, and update the PATH environment variable if necessary")

    jupyter <- Sys.which("jupyter")
    if(jupyter == "")
      stop("'jupyter' not found. Please install a recent version of python that provides jupyter, and update the PATH environment variable if necessary")

    pd <- dirname(python)
    jd <- dirname(jupyter)
    if(substr(jd, 0, nchar(pd))!=pd)
      warning("Please check your python installation consistency: 'python' maps to ", python, " while 'jupyter' maps to ", jupyter)
    else if(debug)
    {
      message("'python' is ", python)
      message("'jupyter' is ", jupyter)
    }

    if(!is.null(kernel))
      .self$kernel = kernel
    else
    {
      kernel_file <- tempfile("ipython_kernel_info")
      start_kernel_cmd = system.file("python", "ipython_start_kernel.py", package="ipython")
      if(debug)
        message('running: python ', start_kernel_cmd, ' ', kernel_file)
      system2("python", c(start_kernel_cmd, kernel_file), wait=FALSE)

      i <- 50
      while(!file.exists(kernel_file) ||
            !length(k <- readLines(kernel_file, 1)))
      {
        i <- i-1
        if(i<0)
          stop("Could not start an ipython kernel. Start one yourself with 'jupyter console' and set knitr options kernel='existing'")
        Sys.sleep(.1)
      }

      .self$kernel <- k
    }

    .self$ipyexec <- system.file("python", "ipython_exec.py", package = "ipython")
  })

ipython$methods(
  finalize = function()
    if(kill.on.exit)
    {
      exec("quit")

      # Forked process may complain if R exits right now
      Sys.sleep(0.1)
    }
)

ipython$methods(
  exec = function(code,
                  options=list(),
                  message=.self$message,
                  debug=.self$debug,
                  latex = FALSE)
  {
    valid_path <- function (prefix, label)
    {
      if (length(prefix) == 0L || is.na(prefix) || prefix == "NA")
        prefix = ""
      paste0(prefix, label)
    }

    cmd = c(shQuote(paste(code, collapse = '\n')),
            "--kernel", .self$kernel,
            "--to", if(identical(options$results, "asis")) "asis" else if(latex) "latex" else "markdown",
            if(!is.null(options$results))
              c("--results", options$results),
            if(!is.null(options$message))
              c("--message", (if(options$message) "True" else "False")),
            if(!is.null(options$fig.path) && !is.null(options$label))
              c("--prefix", paste(valid_path(options$fig.path, options$label), sep = '_')),
            if(!is.null(options$fig.show))
              c("--figshow", options$fig.show),
            if(!is.null(options$dev))
              c("--imageformat", options$dev),
            if(!is.null(options$fig.width))
              c("--width", options$fig.width),
            if(!is.null(options$fig.height))
              c("--height", options$fig.height),
            if(!is.null(options$dpi))
              c("--dpi", options$dpi),
            if(!is.null(options$out.width))
              c("--outwidth", shQuote(options$out.width))
    )

    if(debug)
      message('running: ', ipyexec, ' ', paste(cmd, collapse=" "))
    r <- tryCatch(
      system2("python", c(ipyexec, cmd),
              stdout = TRUE, stderr = TRUE, env = options$engine.env),
      error = function(e) {
        if (is.null(options$error) || !options$error)
          stop(e)
        paste('Error in running command', cmd)
      }
    )

    if(!is.null(attr(r, 'status')))
    {
      msg <- paste('Error in running command', paste(cmd, collapse=" "))
      msg <- paste(c(msg, r), collapse='\n')
      if (is.null(options$error) || !options$error)
        stop(msg)
      else
        warning(msg, immediate. = TRUE, call. = FALSE)
    }

    if(message)
    {
      if(length(r))
        message(paste(r, collapse="\n"))
      return(invisible(r))
    }
    else if(length(r))
      return(r)
    else
      return(invisible())
  }
)
