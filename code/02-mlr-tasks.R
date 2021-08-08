suppressPackageStartupMessages(library("mlr3"))
suppressPackageStartupMessages(library("mlr3proba"))

tg_tasks <- list(
    tar_target(
        zlog_task, {
            ## exclude precalculated scores
            zd <- zlog_data[!grepl("Meld", colnames(zlog_data))]
            zd$Sex <- as.integer(zd$Sex == "male") # female: 0, male: 1

            TaskSurv$new(
                id = "eldd",
                backend = zd,
                time = "DaysAtRisk",
                event = "Deceased"
            )
        },
        packages = c("mlr3", "mlr3proba")
    )
)
