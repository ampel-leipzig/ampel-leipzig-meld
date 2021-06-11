## adopted from
## https://github.com/jdblischak/workflowr/issues/238#issuecomment-782024069
tg_site <- list(
    tar_file(site_conf, file.path("analysis", "_site.yml")),
    tar_target(
        site_about,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "about.Rmd"))
            # Build
            workflowr::wflow_build(
                file.path("analysis", "about.Rmd"),
                message = "docs: rebuild about.html",
                view = FALSE
            )
            # Return file name
            file.path("analysis", "about.Rmd")
        },
        format = "file"
    ),
    tar_target(
        site_index,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(file.path("analysis", "index.Rmd"))
            workflowr::wflow_build(
                file.path("analysis", "index.Rmd"),
                message = "docs: rebuild index.html",
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
                message = "docs: rebuild license.html",
                view = FALSE
            )

            file.path("analysis", "license.Rmd")
        },
        format = "file"
    )
)
