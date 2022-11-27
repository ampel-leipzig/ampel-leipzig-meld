cols <- c("SurvProbMeldUnos", "SurvProbMeldNaUnos", "SurvProbMeldPlus7", "SurvProbMeld3")
nms <- c("MELD", "MELDNa", "MELDPlus7", "MELD3")

smbs <- rlang::syms(paste0("timeROC_", nms))

tg_timeroc <- tar_eval(
    values = list(s = smbs, col = cols),
    tar_target(
        s,
        command = {
            tr <- timeROC::timeROC(
                T = zlog_data$DaysAtRisk,
                delta = zlog_data$Deceased,
                marker = 1 - zlog_data[[col]],
                cause = 1,
                times = c(2, 7, 30, 90, 180, 365),
                iid = TRUE
            )
            tr$confint <- confint(object = tr, level = 0.95, n.sim = 3000)
            tr
        },
        packages = c("survival", "timeROC"),
        deployment = "main"
    )
)

tg_timeroc_psurv <- list(
    tar_target(timeROC_RCV, {
        tr <- timeROC::timeROC(
            T = zlog_data$DaysAtRisk,
            delta = zlog_data$Deceased,
            marker = 1 - psurvbootrcv,
            cause = 1,
            times = c(2, 7, 30, 90, 180, 365),
            iid = TRUE
        )
        tr$confint <- confint(object = tr, level = 0.95, n.sim = 3000)
        tr
    },
    packages = c("survival", "timeROC"),
    deployment = "main"
    ),
    tar_target(timeROC_RCVcc, {
        tr <- timeROC::timeROC(
            T = zlog_data_complete_cases$DaysAtRisk,
            delta = zlog_data_complete_cases$Deceased,
            marker = 1 - psurvbootrcvcc,
            cause = 1,
            times = c(2, 7, 30, 90, 180, 365),
            iid = TRUE
        )
        tr$confint <- confint(object = tr, level = 0.95, n.sim = 3000)
        tr
    },
    packages = c("survival", "timeROC"),
    deployment = "main"
    ),
    tar_target(timeROC_MELDNacc, {
        tr <- timeROC::timeROC(
            T = zlog_data_complete_cases$DaysAtRisk,
            delta = zlog_data_complete_cases$Deceased,
            marker = 1 - zlog_data_complete_cases$SurvProbMeldNaUnos,
            cause = 1,
            times = c(2, 7, 30, 90, 180, 365),
            iid = TRUE
        )
        tr$confint <- confint(object = tr, level = 0.95, n.sim = 3000)
        tr
    },
    packages = c("survival", "timeROC"),
    deployment = "main"
    ),
    tar_target(timeROC_ARCV, {
        tr <- timeROC::timeROC(
            T = zlog_data$DaysAtRisk,
            delta = zlog_data$Deceased,
            marker = 1 - psurvbootarcv,
            cause = 1,
            times = c(2, 7, 30, 90, 180, 365),
            iid = TRUE
        )
        tr$confint <- confint(object = tr, level = 0.95, n.sim = 3000)
        tr
    },
    packages = c("survival", "timeROC"),
    deployment = "main"
    )
)

rm("cols", "nms", "smbs")
