suppressPackageStartupMessages(library("mlr3"))
suppressPackageStartupMessages(library("mlr3benchmark"))
suppressPackageStartupMessages(library("mlr3pipelines"))
suppressPackageStartupMessages(library("mlr3proba"))
suppressPackageStartupMessages(library("mlr3tuning"))

tg_benchmarks <- tar_target(
    bmrks,
    benchmark(
        benchmark_grid(
            task = tasks,
            learner = learners,
            resampling = crossval$outer
        ),
        store_models = FALSE,
        store_backends = TRUE
    ),
    pattern = cross(tasks, learners),
    iteration = "list",
    packages = c(
        "mlr3", "mlr3tuning", "mlr3misc", "mlr3pipelines", "mlr3proba",
        "mlr3learners"
    ),
    deployment = "worker"
)

tg_benchmark_results <- list(
    tar_target(
        bmrk_results,
        do.call(c, bmrks),
        packages = "mlr3",
        deployment = "main"
    ),
    tar_target(
        bmrk_aggr,
        as.BenchmarkAggr(
            bmrk_results,
            measures = list(
                msr("surv.cindex", id = "harrell"),
                msr("surv.cindex", id = "uno", weight_meth = "G2")
            )
        ),
        packages = c("mlr3", "mlr3proba", "mlr3benchmark"),
        deployment = "main"
    )
)
