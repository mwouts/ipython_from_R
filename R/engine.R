ipython_engine <- function(options, message=FALSE, debug=TRUE)
{
  latex = identical(knitr:::out_format(), "latex")
  out = if (options$eval) {
    ipyexec(options$code, options, message=message, debug=debug, latex=latex)
  } else ''

  if (!options$error && !is.null(attr(out, 'status')))
  {
    out <- gsub("\\\\(begin|end)\\{verbatim\\}", "", out)
    out <- gsub("```", "", out)
    out <- out[out!=""]

    warning(paste(out, collapse="\n"))
    stop(tail(out, 1))
  }

  # Input language is python
  options$engine <- "python"

  # Don't escape a second time the output
  if(options$results == "markup")
    options$results <- "asis"
  # But escape it if it was not and something went wrong
  else if(options$results == "asis" && !is.null(attr(out, 'status')))
    options$results <- "markup"

  if(is.null(options$inline) || !options$inline)
    knitr::engine_output(options, options$code, out)
  else
    out
}
