tg_variable_importance <- list(
    tar_target(rngr, {
        ranger(
            x = amelddata$x, y = amelddata$y,
            importance = "impurity",
            num.trees = 1000,
        )
    },
    packages = c("ranger", "survival"),
    deployment = "main"
    )
)
