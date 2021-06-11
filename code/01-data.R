tg_data <- list(
    tar_target(raw_data, {
        data(eldd, package = "ameld")
        eldd
    }),
    tar_target(ref_data, {
        ## prepare reference data for zlog normalisation
        data(eldr, package = "ameld")
        r <- eldr[c("Code", "AgeDays", "Sex", "LowerLimit", "UpperLimit")]
        names(r) <- c("param", "age", "sex", "lower", "upper")
        r$age <- r$age / 365.25

        ## set missing lower limits to 0.15 of the upper according to
        ## Haeckel et al. 2015
        set_missing_limits(r)
    }, packages = "zlog")
)
