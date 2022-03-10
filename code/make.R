targets::tar_make_future(
        reporter = "timestamp"
)
workflowr::wflow_build(
        rprojroot::find_rstudio_root_file("analysis", "pipeline.Rmd"),
        view = FALSE
)
