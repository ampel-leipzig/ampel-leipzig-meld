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
    }, packages = "zlog"),
    tar_target(imp_data, {
        withCallingHandlers(
            impute_df(raw_data, ref_data, method = "logmean"),
            warning = function(w) {
                if(w$message != paste0(
                    "No reference for column(s): DaysAtRisk, Deceased, LTx, ",
                    "Cirrhosis, ALF, Ethyltoxic, HBV, HCV, AIH, PBC, PSC, ",
                    "NASH, Cryptogenic, Dialysis, GIB, HCC, SBP"))
                       stop(w$message)
                else
                    invokeRestart("muffleWarning")
            }
        )
    }),
    tar_target(zlog_data, {
        zlog_data <- imp_data
        iconvert <- colnames(zlog_data) %in%
            c("Age", "Sex", grep("_[SECQ]$", colnames(imp_data), value = TRUE))
        zlog_data[iconvert] <- zlog_df(imp_data[iconvert], ref_data)
        zlog_data
    }, packages = "zlog")
)
