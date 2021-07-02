## adopted from
## https://github.com/jdblischak/workflowr/issues/238#issuecomment-782024069
tg_site <- list(
    tar_file(site_conf, file.path("analysis", "_site.yml")),
    tar_target(
        site_index,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "index.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "index.Rmd"),
                view = FALSE
            )
            file.path("analysis", "index.Rmd")
        },
        format = "file"
    ),
    tar_target(
        site_license,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "license.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "license.Rmd"),
                view = FALSE
            )

            file.path("analysis", "license.Rmd")
        },
        format = "file"
    )
)
