tg_ameld <- list(
    tar_target(ameldcfg, list(
        alpha = seq(0, 1, len = 11)^3,
        nboot = 200L,
        nrepcv = 100L,
        nfolds = 3L,
        m = 50,
        times = 90,
        standardize = FALSE
    ),
    deployment = "main"
    ),
    tar_target(amelddata, {
        d <- zlog_data
        ## exclude precalculated scores
        d <- d[!grepl("Meld", colnames(d))]
        srv <- Surv(d$DaysAtRisk, d$Deceased)
        d$DaysAtRisk <- d$Deceased <- NULL
        d <- data.matrix(d)
        list(x = d, y = srv)
    },
    packages = c("survival"),
    deployment = "main"
    ),
    tar_target(amelddatacc, {
        d <- zlog_data_complete_cases
        ## exclude precalculated scores
        d <- d[!grepl("Meld", colnames(d))]
        srv <- Surv(d$DaysAtRisk, d$Deceased)
        d$DaysAtRisk <- d$Deceased <- NULL
        d <- data.matrix(d)
        list(x = d, y = srv)
    },
    packages = c("survival"),
    deployment = "main"
    ),
    tar_target(arcvob, {
        arcv.glmnet(
            x = amelddata$x, y = amelddata$y,
            family = "cox",
            alpha = ameldcfg$alpha,
            nrepcv = ameldcfg$nrepcv,
            nfolds = ameldcfg$nfolds,
            balanced = TRUE,
            standardize = ameldcfg$standardize,
            trace.it = FALSE
        )
    },
    packages = c("ameld", "survival"),
    deployment = "worker"
    ),
    tar_target(bootrcv, {
        bootrcv <- bootstrap(
            x = amelddata$x, y = amelddata$y,
            fun = rcv.glmnet,
            nboot = ameldcfg$nboot,
            nrepcv = ameldcfg$nrepcv,
            nfolds = ameldcfg$nfolds,
            family = "cox",
            standardize = ameldcfg$standardize,
            m = ameldcfg$m,
            times = ameldcfg$times
        )
        bootrcv
    },
    packages = c(
        "ameld", "future", "future.batchtools", "glmnet", "survival"
    ),
    deployment = "worker"
    ),
    tar_target(bootrcvcc, {
        bootrcv <- bootstrap(
            x = amelddatacc$x, y = amelddatacc$y,
            fun = rcv.glmnet,
            nboot = ameldcfg$nboot,
            nrepcv = ameldcfg$nrepcv,
            nfolds = ameldcfg$nfolds,
            family = "cox",
            standardize = ameldcfg$standardize,
            m = ameldcfg$m,
            times = ameldcfg$times
        )
        bootrcv
    },
    packages = c(
        "ameld", "future", "future.batchtools", "glmnet", "survival"
    ),
    deployment = "worker"
    ),
    tar_target(bootrcv.woIC, {
        x <- amelddata$x[,
            !colnames(amelddata$x) %in% c("IL6_S", "CYSC_S")
        ]
        bootrcv <- bootstrap(
            x = x, y = amelddata$y,
            fun = rcv.glmnet,
            family = "cox",
            nboot = ameldcfg$nboot,
            nfolds = ameldcfg$nfolds,
            nrepcv = ameldcfg$nrepcv,
            standardize = ameldcfg$standardize,
            m = ameldcfg$m,
            times = ameldcfg$times
        )
        bootrcv
    },
    packages = c(
        "ameld", "future", "future.batchtools", "glmnet", "survival"
    ),
    deployment = "worker"
    ),
    tar_target(psurvbootrcv, {
        predict(
            bootrcv$fit, x = amelddata$x, y = amelddata$y, newx = amelddata$x,
            type = "survival", times = ameldcfg$times, s = "lambda.1se"
        )[1,]
    }),
    tar_target(psurvbootrcvcc, {
        predict(
            bootrcvcc$fit, x = amelddatacc$x, y = amelddatacc$y,
            newx = amelddatacc$x, type = "survival",
            times = ameldcfg$times, s = "lambda.1se"
        )[1,]
    }),
    tar_target(bootarcv, {
        selarcv <- function(...) {
            a <- arcv.glmnet(...)
            a$models[[which.min.error(a, s = "lambda.1se", maxnnzero = Inf)]]
        }

        bootarcv <- bootstrap(
            x = amelddata$x, y = amelddata$y,
            fun = selarcv,
            family = "cox",
            alpha = ameldcfg$alpha,
            nboot = ameldcfg$nboot,
            nfolds = ameldcfg$nfolds,
            nrepcv = ameldcfg$nrepcv,
            standardize = ameldcfg$standardize,
            m = ameldcfg$m,
            times = ameldcfg$times
        )
        bootarcv
    },
    packages = c(
        "ameld", "future", "future.batchtools", "glmnet", "survival"
    ),
    deployment = "worker"
    ),
    tar_target(psurvbootarcv, {
        predict(
            bootarcv$fit, x = amelddata$x, y = amelddata$y, newx = amelddata$x,
            type = "survival", times = ameldcfg$times, s = "lambda.1se"
        )[1,]
    })
)
