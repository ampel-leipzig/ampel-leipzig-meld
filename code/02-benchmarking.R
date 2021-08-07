suppressPackageStartupMessages(library("mlr3"))
suppressPackageStartupMessages(library("mlr3extralearners"))
suppressPackageStartupMessages(library("mlr3learners"))
suppressPackageStartupMessages(library("mlr3proba"))
suppressPackageStartupMessages(library("mlr3tuning"))
suppressPackageStartupMessages(library("paradox"))

## learners
lrn_cox <- lrn("surv.coxph", id = "cox")

lrn_lasso <- lrn("surv.cv_glmnet", id = "lasso", alpha = 1L)

lrn_ridge <- lrn("surv.cv_glmnet", id = "ridge", alpha = 0L)

lrn_elasticnet <- lrn("surv.cv_glmnet", id = "elasticnet")

lrn_penlasso <- lrn("surv.penalized", id = "penlasso",
    lambda2 = 0, standardize = TRUE, trace = FALSE
)

lrn_penridge <- lrn("surv.penalized", id = "penridge",
    lambda1 = 0, standardize = TRUE, trace = FALSE
)

lrn_ranger <- lrn("surv.ranger", id = "ranger",
    # ?ranger, 3 for survival
    min.node.size = 3L
)

lrn_rfsrc <- lrn("surv.rfsrc",
    # ?randomForestSRC, nsplit = 0, randomized splitting
    nsplit = 0
)

lrn_xgboost <- lrn("surv.xgboost", max_depth = 6)

lrn_svmregression <- lrn("surv.svm", id = "svm-regression",
    type = "regression",
    gamma.mu = 0 # would be trained later, is required by ctor
)

lrn_svmvanbelle1 <- lrn("surv.svm", id = "svm-vanbelle1",
    type = "vanbelle1",
    diff.meth = "makediff3",
    kernel = "rbf_kernel",
    opt.meth = "quadprog",
    gamma.mu = 0 # would be trained later, is required by ctor
)

## params
ps_lasso <- ParamSet$new(
    params = list(
        ParamDbl$new("s", lower = 0L, upper = 1L)
    )
)

ps_ridge <- ParamSet$new(
    params = list(
        ParamDbl$new("s", lower = 0L, upper = 1L)
    )
)

ps_elasticnet <- ParamSet$new(
    params = list(
        ParamDbl$new("alpha", lower = 0L, upper = 1L),
        ParamDbl$new("s", lower = 0L, upper = 1L)
    )
)

ps_penlasso <- ParamSet$new(
    params = list(
        ParamDbl$new("lambda1", lower = 0L, upper = 100)
    )
)

ps_penridge <- ParamSet$new(
    params = list(
        ParamDbl$new("lambda2", lower = 0L, upper = 100)
    )
)

ps_ranger <- ParamSet$new(
    params = list(
        ParamInt$new("num.trees", lower = 200L, upper = 2000L),
        # ?ranger floor(sqrt(length(variables))) = 6 in our case
        ParamInt$new("mtry", lower = 4L, upper = 8L),
        ParamFct$new("splitrule", c("logrank", "C"))
    )
)

ps_rfsrc <- ParamSet$new(
    params = list(
        ParamInt$new("ntree", lower = 200L, upper = 2000L),
            # ?randomForestSRC 15 for survival
            ParamInt$new("nodesize", lower = 5L, upper = 50L),
            # ?randomForestSRC ceiling(sqrt(length(variables))) = 7
            # in our case
            ParamInt$new("mtry", lower = 4L, upper = 8L),
            ParamFct$new("splitrule", c("logrank", "logrankscore"))
    )
)

ps_xgboost <- ParamSet$new(
    params = list(
        ParamDbl$new(
            "eta",
            lower = 0L, upper = 1L, default = 0.3
        ),
        ParamInt$new(
            "max_depth",
            lower = 3L, upper = 10L, default = 6L
        ),
        ParamDbl$new(
            "min_child_weight",
            lower = 0L, upper = 10L, default = 1L
        ),
        ParamDbl$new(
            "gamma",
            lower = -10, upper = 1, default = 0L
        ),
        ParamDbl$new(
            "colsample_bytree",
            lower = 0.6, upper = 1, default = 1
        ),
        ParamDbl$new(
            "subsample",
            lower = 0.6, upper = 1, default = 1
        ),
        ParamDbl$new(
            "alpha",
            lower = -10L, upper = 2, default = 0
        )
    )
)
ps_xgboost$trafo <- function(x, param_set) {
    x$gamma <- 2^x$gamma
    x$alpha <- 2^x$alpha
    x
}

ps_svmregression <- ParamSet$new(
    params = list(
        ParamDbl$new(
            "gamma.mu",
            lower = -5L, upper = 5L, default = 0L
        ),
        ParamDbl$new(
            "kernel.pars",
            lower = -5L, upper = 5L, default = 0L
        )
    )
)

ps_svmregression$trafo <- function(x, param_set) {
    x$gamma.mu <- 2^x$gamma.mu
    x$kernel.pars <- 2^x$kernel.pars
    x
}

## resampling
#inner_cv <- rsmp("cv", folds = 5L)
#outer_cv <- rsmp("repeated_cv", folds = 3L, repeats = 10L)
inner_cv <- rsmp("cv", folds = 3L)
outer_cv <- rsmp("repeated_cv", folds = 3L, repeats = 1L)

## tuning
autoTuner <- function(lrn, prms, rsmp = inner_cv)AutoTuner$new(
    learner = lrn,
    search_space = prms,
    resampling = rsmp,
    measure = msr("surv.cindex"),
    tuner = tnr("random_search", batch_size = 2L),
    terminator = trm("evals", n_evals = 20)
)

at_lasso <- autoTuner(lrn_lasso, ps_lasso)
at_ridge <- autoTuner(lrn_ridge, ps_ridge)
at_elasticnet <- autoTuner(lrn_elasticnet, ps_elasticnet)
at_penlasso <- autoTuner(lrn_penlasso, ps_penlasso)
at_penridge <- autoTuner(lrn_penridge, ps_penridge)
at_ranger <- autoTuner(lrn_ranger, ps_ranger)
at_rfsrc <- autoTuner(lrn_rfsrc, ps_rfsrc)
at_xgboost <- autoTuner(lrn_xgboost, ps_xgboost)
at_svmregression <- autoTuner(lrn_svmregression, ps_svmregression)
at_svmvanbelle1 <- autoTuner(lrn_svmvanbelle1, ps_svmregression)

lrns <- c(
    "lrn_cox",
    "at_lasso", "at_ridge", "at_elasticnet",
    "at_penlasso",
    "at_ranger", "at_rfsrc",
    "at_xgboost",
    "at_svmregression", "at_svmvanbelle1"
)

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
        packages = "mlr3proba"
    )
)

tg_benchmarks <- tar_eval(
    values = list(
        l = rlang::syms(lrns),
        s = rlang::syms(paste0("bmrk_", lrns))
    ),
    tar_target(
        s,
        benchmark(
            benchmark_grid(
                task = zlog_task,
                learner = l,
                resampling = outer_cv
            ),
            store_models = FALSE,
            store_backends = TRUE
        ),
        packages = c(
            "mlr3", "mlr3tuning", "mlr3misc", "mlr3proba", "mlr3learners",
            "ranger"
        ),
        deployment = "worker"
    )
)

tg_benchmark_results <- tar_combine(
    bmrk_results,
    tg_benchmarks,
    command = c(!!!.x),
    packages = "mlr3",
    deployment = "worker"
)

rm("lrns")
