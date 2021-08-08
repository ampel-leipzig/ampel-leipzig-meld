suppressPackageStartupMessages(library("mlr3"))
suppressPackageStartupMessages(library("mlr3extralearners"))
suppressPackageStartupMessages(library("mlr3learners"))
suppressPackageStartupMessages(library("mlr3proba"))
suppressPackageStartupMessages(library("mlr3tuning"))
suppressPackageStartupMessages(library("paradox"))

tg_lrns <- list(
    ## while these are small targets that don't need any processing time
    ## we want to rerun the benchmarking when anything changes
    tar_target(crossval,
        list(
            inner = rsmp("cv", folds = 3L),
            outer = rsmp("repeated_cv", folds = 3L, repeats = 1L)
        )
    ),
    tar_target(learners, {
        l <- list(
            cox = list(
                lrn = lrn("surv.coxph", id = "cox")
            ),
            lasso = list(
                lrn = lrn("surv.cv_glmnet", id = "lasso", alpha = 1L),
                ps = ps(s = p_dbl(lower = 0, upper = 1))
            ),
            ridge = list(
                lrn = lrn("surv.cv_glmnet", id = "ridge", alpha = 0L),
                ps = ps(s = p_dbl(lower = 0, upper = 1))
            ),
            elasticnet = list(
                lrn = lrn("surv.cv_glmnet", id = "elasticnet"),
                ps = ps(
                    alpha = p_dbl(lower = 0, upper = 1),
                    s = p_dbl(lower = 0, upper = 1)
                )
            ),
            penlasso = list(
                lrn = lrn(
                    "surv.penalized", id = "penlasso",
                    lambda2 = 0, standardize = TRUE, trace = FALSE
                ),
                ps = ps(
                    lambda1 = p_dbl(lower = 1, upper = 100)
                )
            ),
            penridge = list(
                lrn = lrn(
                    "surv.penalized", id = "penridge",
                    lambda1 = 0, standardize = TRUE, trace = FALSE
                ),
                ps = ps(
                    lambda2 = p_dbl(lower = 1, upper = 100)
                )
            ),
            ranger = list(
                lrn = lrn(
                    "surv.ranger", id = "ranger",
                    # ?ranger, 3 for survival
                    min.node.size = 3L
                ),
                ps = ps(
                    num.trees = p_int(lower = 200L, upper = 2000L),
                    # ?ranger floor(sqrt(length(variables))) = 6 in our case
                    mtry = p_int(lower = 4L, upper = 8L),
                    splitrule = p_fct(c("logrank", "C"))
                )
            ),
            rfsrc = list(
                lrn = lrn(
                    "surv.rfsrc",
                    # ?randomForestSRC, nsplit = 0, randomized splitting
                    nsplit = 0
                ),
                ps = ps(
                    ntree = p_int(lower = 200L, upper = 2000L),
                    # ?randomForestSRC 15 for survival
                    nodesize = p_int(lower = 5L, upper = 50L),
                    # ?randomForestSRC ceiling(sqrt(length(variables))) = 7
                    # in our case
                    mtry = p_int(lower = 4L, upper = 8L),
                    splitrule = p_fct(c("logrank", "C"))
                )
            ),
            xgboost = list(
                lrn = lrn("surv.xgboost", max_depth = 6L),
                ps = {
                    p <- ps(
                        eta = p_dbl(lower = 0, upper = 1, default = 0.3),
                        max_depth =
                            p_int(lower = 3L, upper = 10L, default = 6L),
                        min_child_weight =
                            p_int(lower = 0L, upper = 10L, default = 1L),
                        gamma = p_dbl(lower = -10, upper = 1, default = 0),
                        colsample_bytree =
                            p_dbl(lower = 0.6, upper = 1, default = 1),
                        subsample = p_dbl(lower = 0.6, upper = 1, default = 1),
                        alpha = p_dbl(lower = -10, upper = 2, default = 0)
                    )
                    p$trafo <- function(x, param_set) {
                        x$gamma <- 2^x$gamma
                        x$alpha <- 2^x$alpha
                        x
                    }
                    p
                }
            ),
            svmregression = list(
                lrn = lrn(
                    "surv.svm", id = "svm-regression", type = "regression",
                    gamma.mu = 0 # would be trained later, is required by ctor
                ),
                ps = {
                    p <- ps(
                        gamma.mu = p_dbl(lower = -5, upper = 5, default = 0),
                        kernel.pars = p_dbl(lower = -5, upper = 5, default = 0)
                    )
                    p$trafo <- function(x, param_set) {
                        x$gamma.mu <- 2^x$gamma.mu
                        x$kernel.pars <- 2^x$kernel.pars
                        x
                    }
                    p
                }
            ),
            svmvanbelle1 = list(
                lrn = lrn(
                    "surv.svm", id = "svm-vanbelle1", type = "vanbelle1",
                    diff.meth = "makediff3", kernel = "rbf_kernel",
                    opt.meth = "quadprog",
                    gamma.mu = 0 # would be trained later, is required by ctor
                ),
                ps = {
                    p <- ps(
                        gamma.mu = p_dbl(lower = -5, upper = 5, default = 0),
                        kernel.pars = p_dbl(lower = -5, upper = 5, default = 0)
                    )
                    p$trafo <- function(x, param_set) {
                        x$gamma.mu <- 2^x$gamma.mu
                        x$kernel.pars <- 2^x$kernel.pars
                        x
                    }
                    p
                }
            )
        )
        lapply(l, function(ll) {
            if (is.null(ll$ps))
                ll
            else
                AutoTuner$new(
                    learner = ll$lrn,
                    search_space = ll$ps,
                    resampling = crossval$inner,
                    measure = msr("surv.cindex"),
                    tuner = tnr("random_search", batch_size = 2L),
                    terminator = trm("evals", n_evals = 4L)
                )
        })
    }, iteration = "list")
)