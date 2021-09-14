suppressPackageStartupMessages(library("mlr3"))
suppressPackageStartupMessages(library("mlr3proba"))

.create_tsk <- function(d, id) {
    ## exclude precalculated scores
    d <- d[!grepl("Meld", colnames(d))]
    d$Sex <- as.integer(d$Sex == "male") # female: 0, male: 1

    TaskSurv$new(
        id = id,
        backend = d,
        time = "DaysAtRisk",
        event = "Deceased"
    )
}

tg_tasks <- list(
    tar_target(
        tasks,
        mapply(
            FUN = .create_tsk,
            d = list(zlog_data, ln_data),
            id = paste(c("zlog", "ln"), "eldd", sep = "_")
        ),
        packages = c("mlr3", "mlr3proba")
    )
)
