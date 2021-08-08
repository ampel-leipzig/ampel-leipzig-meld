suppressPackageStartupMessages(library("mlr3"))
suppressPackageStartupMessages(library("mlr3tuning"))

tg_benchmarks <- tar_target(
    bmrks,
    benchmark(
        benchmark_grid(
            task = zlog_task,
            learner = learners,
            resampling = crossval$outer
        ),
        store_models = FALSE,
        store_backends = FALSE
    ),
    pattern = map(learners),
    iteration = "list",
    packages = c(
        "mlr3", "mlr3tuning", "mlr3misc", "mlr3proba", "mlr3learners",
        "ranger"
    ),
    deployment = "worker"
)

tg_benchmark_results <- tar_combine(
    bmrk_results,
    tg_benchmarks,
    command = c(!!!.x),
    packages = "mlr3",
    deployment = "worker"
)
