test_that(
  'Simple commands work',
  {
    if(Sys.which("jupyter")=="")
      skip('jupyter is not available')

    p = ipython(debug=T, message=F)

    r = p$exec("a=17")
    expect_null(r)

    r = p$exec("a+17")
    expect_equal(r, c("```", "34", "```"))

    r = p$exec("a+17", options = list(results="asis"))
    expect_equal(r, "34")
  })

test_that(
  'matplotlib plots are saved',
  {
    if(Sys.which("jupyter")=="")
      skip('jupyter is not available')

    r = p$exec("import matplotlib.pyplot")
    if(!is.null(attr(r, "status")))
      skip('matplotlib is not available')

    p$exec("import matplotlib.pyplot as plt")
    r = p$exec("plt.plot([1,2])", options=list(fig.path="fig_path/", label="fig_label"))

    expect_null(attr(r, "status"))
    expect_equal(length(r),1)
    expect_true(grepl("^\\!\\[.*\\]\\(fig_path/fig_label_1.png\\)$", r))
    expect_true(file.exists("fig_path/fig_label_1.png"))
    unlink("fig_path", recursive = TRUE)
  })

test_that(
  'incorrect code throws an error',
  {
    options = list(code = "not correct", eval=TRUE, error=FALSE, results = "asis", echo=FALSE)
    expect_error(r = ipython_engine(options),
                 "NameError: name 'correct' is not defined")
  })

test_that(
  'python tests pass',
  {
    if(Sys.which("py.test")=="")
      skip('py.test is not available')

    out <- system2("py.test", system.file("python", "test_ipython_exec.py", package="ipython"), stdout = TRUE)
    if(!is.null(attr(out, "status")))
      warning(paste(out, collapse="\n"))
    expect_null(attr(out, "status"))
  })
