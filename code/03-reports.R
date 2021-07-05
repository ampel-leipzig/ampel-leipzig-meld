reports <- tools::list_files_with_exts(
    rprojroot::find_rstudio_root_file("analysis"), "Rmd"
)
## exclude site parts
reports <- reports[!grepl("pipeline.Rmd|index.Rmd|license.Rmd", reports)]

smbs <- rlang::syms(
    paste("reports", tools::file_path_sans_ext(basename(reports)), sep = "_")
)

tg_reports <- tar_eval(
    values = list(s = smbs, rpt = reports),
    tar_target(
        s,
        command = {
            list(site_conf)
            !!tar_knitr_deps_expr(rpt)
            workflowr::wflow_build(rpt, view = FALSE)
            rpt
        }, format = "file"
    )
)

rm("reports", "smbs")
