tg_reports <- list(
    tar_target(
        report_histograms,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "histograms.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "histograms.Rmd"),
                message = "docs: rebuild histograms.html",
                view = FALSE
           )
           file.path("analysis", "histograms.Rmd")
        },
        format = "file"
    )
)
