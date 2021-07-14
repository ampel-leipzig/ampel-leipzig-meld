tg_data <- list(
    tar_target(raw_data, {
            data(eldd, package = "ameld")
            eldd
        },
        packages = "ameld",
        deployment = "main"
    ),
    tar_target(ref_data, {
            ## prepare reference data for zlog normalisation
            data(eldr, package = "ameld")
            r <- eldr[c("Code", "AgeDays", "Sex", "LowerLimit", "UpperLimit")]
            names(r) <- c("param", "age", "sex", "lower", "upper")
            r$age <- r$age / 365.25

            ## set missing lower limits to 0.15 of the upper according to
            ## Haeckel et al. 2015
            set_missing_limits(r)
        },
        packages = "zlog",
        deployment = "main"
    ),
    tar_target(imp_data, {
            imp <- withCallingHandlers(
                impute_df(raw_data, ref_data, method = "logmean"),
                warning = function(w) {
                    if(w$message != paste0(
                        "No reference for column(s): DaysAtRisk, Deceased, ",
                        "LTx, Cirrhosis, ALF, Ethyltoxic, HBV, HCV, AIH, PBC, ",
                        "PSC, NASH, Cryptogenic, Dialysis, GIB, HCC, SBP"))
                           stop(w$message)
                    else
                        invokeRestart("muffleWarning")
                }
            )
            ## assume no dialysis for missing values
            imp$Dialysis[is.na(imp$Dialysis)] <- 0L
            ## same for SBP and Cirrhosis
            imp$SBP[is.na(imp$SBP)] <- 0L
            imp$Cirrhosis[is.na(imp$Cirrhosis)] <- 0L
            ## exclude Age below 20
            imp <- imp[imp$Age >= 20,]
            imp
        },
        packages = "zlog",
        deployment = "main"
    ),
    tar_target(meld_data, {
            m <- imp_data
            m$ScoreMeld <- meld(
                creatinine = as_metric(m$CRE_S, "creatinine"),
                bilirubin = as_metric(m$BILI_S, "bilirubin"),
                inr = m$INR_C,
                dialysis = m$Dialysis,
                cause = ifelse(m$Ethyltoxic == 1, "ethyltoxisch", "other")
            )
            m$ScoreMeldUnos <- meld(
                creatinine = as_metric(m$CRE_S, "creatinine"),
                bilirubin = as_metric(m$BILI_S, "bilirubin"),
                inr = m$INR_C,
                dialysis = m$Dialysis,
                cause = "UNOS"
            )
            m$ScoreMeldNa <- meld_na(
                creatinine = as_metric(m$CRE_S, "creatinine"),
                bilirubin = as_metric(m$BILI_S, "bilirubin"),
                inr = m$INR_C,
                sodium = m$NA_S,
                dialysis = m$Dialysis,
                cause = ifelse(m$Ethyltoxic == 1, "ethyltoxisch", "other")
            )
            m$ScoreMeldNaUnos <- meld_na(
                creatinine = as_metric(m$CRE_S, "creatinine"),
                bilirubin = as_metric(m$BILI_S, "bilirubin"),
                inr = m$INR_C,
                sodium = m$NA_S,
                dialysis = m$Dialysis,
                type = "UNOS"
            )
            m$ProbMeldPlus7 <- meld_plus7(
                creatinine = as_metric(m$CRE_S, "creatinine"),
                bilirubin = as_metric(m$BILI_S, "bilirubin"),
                inr = m$INR_C,
                sodium = m$NA_S,
                albumin = m$ALB_S / 10,
                wbc = m$B_WBC_E,
                age = m$Age
            )
            m$MeldCategory <- cut(
                m$ScoreMeldUnos,
                breaks = c(-Inf, seq(10, 40, by=10), Inf),
                labels = c(
                    paste0(
                        "[", floor(min(m$ScoreMeldUnos, na.rm = TRUE)), ",9]"
                    ),
                    "[10,20)", "[20,30)", "[30,40)",
                    paste0(
                        "[40,", ceiling(max(m$ScoreMeldUnos, na.rm = TRUE)), ")"
                    )
                ),
                right = FALSE
            )
            m
        },
        packages = "ameld",
        deployment = "main"
    ),
    tar_target(zlog_data, {
            zlog_data <- meld_data
            iconvert <- colnames(zlog_data) %in%
                c("Age", "Sex", grep("_[SECQ]$", colnames(imp_data), value = TRUE))
            zlog_data[iconvert] <- zlog_df(imp_data[iconvert], ref_data)
            zlog_data
        },
        packages = "zlog",
        deployment = "main"
    )
)
