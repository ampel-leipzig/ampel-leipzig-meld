tg_reports <- list(
    tar_target(
        report_histograms,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "histograms.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "histograms.Rmd"),
                view = FALSE
           )
           file.path("analysis", "histograms.Rmd")
        },
        format = "file"
    ),
    tar_target(
        report_boxplots,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "boxplots.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "boxplots.Rmd"),
                view = FALSE
           )
           file.path("analysis", "boxplots.Rmd")
        },
        format = "file"
    ),
    tar_target(
        report_missing,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "missing.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "missing.Rmd"),
                view = FALSE
           )
           file.path("analysis", "missing.Rmd")
        },
        format = "file"
    ),
    tar_target(
        report_corrplot,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "corrplot.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "corrplot.Rmd"),
                view = FALSE
           )
           file.path("analysis", "corrplot.Rmd")
        },
        format = "file"
    )
)
