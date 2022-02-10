suppressPackageStartupMessages(library("mlr3"))
suppressPackageStartupMessages(library("mlr3extralearners"))
suppressPackageStartupMessages(library("mlr3learners"))
suppressPackageStartupMessages(library("mlr3pipelines"))
suppressPackageStartupMessages(library("mlr3proba"))
suppressPackageStartupMessages(library("mlr3tuning"))
suppressPackageStartupMessages(library("paradox"))

tg_lrns <- list(
    ## while these are small targets that don't need any processing time
    ## we want to rerun the benchmarking when anything changes
    tar_target(crossval,
        list(
            inner = rsmp("cv", folds = 2L),
            outer = rsmp("repeated_cv", folds = 2L, repeats = 1L)
        ),
        deployment = "main"
    ),
    tar_target(learners, {
        l <- list(
            cox = list(
                lrn = lrn("surv.coxph", id = "cox")
            ),
            lasso = list(
                lrn = lrn(
                    "surv.cv_glmnet", id = "lasso", alpha = 1L,
                    standardize = FALSE # use pipeline/zlog
                ),
                ps = ps(s = p_dbl(lower = 0, upper = 1))
            ),
            ridge = list(
                lrn = lrn(
                    "surv.cv_glmnet", id = "ridge", alpha = 0L,
                    standardize = FALSE # use pipeline/zlog
                ),
                ps = ps(s = p_dbl(lower = 0, upper = 1))
            ),
            elasticnet = list(
                lrn = lrn(
                    "surv.cv_glmnet", id = "elasticnet",
                    standardize = FALSE # use pipeline/zlog
                ),
                ps = ps(
                    alpha = p_dbl(lower = 0, upper = 1),
                    s = p_dbl(lower = 0, upper = 1)
                )
            ),
            penlasso = list(
                lrn = lrn(
                    "surv.penalized", id = "penlasso", lambda2 = 0,
                    trace = FALSE,
                    standardize = FALSE # use pipeline/zlog
                ),
                ps = ps(
                    lambda1 = p_dbl(lower = 1, upper = 100)
                )
            ),
            penridge = list(
                lrn = lrn(
                    "surv.penalized", id = "penridge", lambda1 = 0,
                    trace = FALSE,
                    standardize = FALSE # use pipeline/zlog
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
                    splitrule = p_fct(c("logrank", "logrankscore"))
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
                    "surv.svm", id = "svmregression", type = "regression",
                    gamma.mu = 0 # would be trained later, is required by ctor
                ),
                ps = {
                    p <- ps(
                        gamma.mu = p_dbl(lower = -3, upper = 3, default = 0),
                        kernel.pars = p_dbl(lower = -3, upper = 3, default = 0)
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
                    "surv.svm", id = "svmvanbelle1", type = "vanbelle1",
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
            ),
            coxtime = list(
                lrn = lrn(
                    "surv.deepsurv", id = "coxtime",
                    activation = "leakyrelu",
                    #frac = 0.3, # we run our own nested cv
                    early_stopping = TRUE,
                    epochs = 100, optimizer = "adam"
                ),
                ps = {
                    p <- ps(
                        dropout = p_dbl(lower = 0, upper = 1),
                        weight_decay = p_dbl(lower = 0, upper = 0.5),
                        learning_rate = p_dbl(lower = 0, upper = 1),
                        nodes = p_int(lower = 1, upper = 32),
                        k = p_int(lower = 1, upper = 4)
                    )
                    p$trafo <- function(x, param_set) {
                        x$num_nodes <- rep(x$nodes, x$k)
                        x$nodes <- x$k <- NULL
                        x
                    }
                    p
                }
            ),
            deepsurv = list(
                lrn = lrn(
                    "surv.deepsurv", id = "deepsurv",
                    activation = "leakyrelu",
                    frac = 0.3, early_stopping = TRUE,
                    epochs = 100, optimizer = "adam"
                ),
                ps = {
                    p <- ps(
                        dropout =
                            p_dbl(lower = 0, upper = 0.7, default = 0.5),
                        ## 0.004, 0.002, 0.001, 0.0005, 0.0002, 0.0001, 0
                        weight_decay =
                            p_int(lower = 0, upper = 6, default = 2),
                        learning_rate =
                            p_dbl(lower = 0, upper = 0.2, default = 0.1),
                        ## nodes in a layer (2, 4, 8, 16, 32, 64, 128)
                        nodes = p_int(lower = 0L, upper = 7L, default = 5L),
                        ## number of hidden layers
                        k = p_int(lower = 0L, upper = 4L, default = 2L)
                    )
                    p$trafo <- function(x, param_set) {
                        x$weight_decay <-
                            trunc(40L / 2L^(x$weight_decay)) / 10000
                        x$num_nodes = rep(2L^x$nodes, x$k)
                        x$nodes <- x$k <- NULL
                        x
                    }
                    p
                }
            )
        )
        ## tuner
        tuner <-
            tnr("grid_search", resolution = 4L, batch_size = 4L)
            #tnr("random_search", batch_size = 5L)

        ## terminator
        terminator <- trm("combo", list(
                trm("evals", n_evals = 50L),
                trm("run_time", secs = 90L),
                trm("stagnation", iters = 3L, threshold = 1e-3),
                trm("stagnation_batch", n = 1L, threshold = 1e-3)
            ),
            any = TRUE
        )

        ## autotuner
        l <- lapply(l, function(ll) {
            if (is.null(ll$ps))
                ll$lrn
            else
                AutoTuner$new(
                    learner = ll$lrn,
                    search_space = ll$ps,
                    resampling = crossval$inner,
                    measure = msr("surv.cindex"),
                    tuner = tuner,
                    terminator = terminator
                )
        })

        ### preprocessing (is part of the crossval now)
        l <- c(
            l,
            lapply(
                l,
                function(ll)as_learner(po("scale") %>>% po("learner", ll))
            )
        )
        l
    },
    iteration = "list",
    deployment = "main"
    )
)
