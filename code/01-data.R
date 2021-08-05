.add_meld_columns <- function(x) {
    x$ScoreMeld <- meld(
        creatinine = as_metric(x$CRE_S, "creatinine"),
        bilirubin = as_metric(x$BILI_S, "bilirubin"),
        inr = x$INR_C,
        dialysis = x$Dialysis,
        cause = ifelse(x$Ethyltoxic == 1, "ethyltoxisch", "other")
    )
    x$ScoreMeldUnos <- meld(
        creatinine = as_metric(x$CRE_S, "creatinine"),
        bilirubin = as_metric(x$BILI_S, "bilirubin"),
        inr = x$INR_C,
        dialysis = x$Dialysis,
        cause = "unos"
    )
    x$ScoreMeldNa <- meld_na(
        creatinine = as_metric(x$CRE_S, "creatinine"),
        bilirubin = as_metric(x$BILI_S, "bilirubin"),
        inr = x$INR_C,
        sodium = x$NA_S,
        dialysis = x$Dialysis,
        cause = ifelse(x$Ethyltoxic == 1, "ethyltoxisch", "other")
    )
    x$ScoreMeldNaUnos <- meld_na(
        creatinine = as_metric(x$CRE_S, "creatinine"),
        bilirubin = as_metric(x$BILI_S, "bilirubin"),
        inr = x$INR_C,
        sodium = x$NA_S,
        dialysis = x$Dialysis,
        type = "unos"
    )
    x$ProbMeldPlus7 <- meld_plus7(
        creatinine = as_metric(x$CRE_S, "creatinine"),
        bilirubin = as_metric(x$BILI_S, "bilirubin"),
        inr = x$INR_C,
        sodium = x$NA_S,
        albumin = x$ALB_S / 10,
        wbc = x$B_WBC_E,
        age = x$Age
    )
    x$MeldCategory <- cut(
        x$ScoreMeldUnos,
        breaks = c(-Inf, seq(10, 40, by=10), Inf),
        labels = c(
            paste0(
                "[", floor(min(x$ScoreMeldUnos, na.rm = TRUE)), ",9]"
            ),
            "[10,20)", "[20,30)", "[30,40)",
            paste0(
                "[40,", ceiling(max(x$ScoreMeldUnos, na.rm = TRUE)), ")"
            )
        ),
        right = FALSE
    )
    x
}

tg_data <- list(
    tar_target(raw_data, {
            data(eldd, package = "ameld")
            eldd
        },
        packages = "ameld",
        deployment = "main"
    ),
    tar_target(ref_data, {
            ## prepare reference data for zlog normalisation
            data(eldr, package = "ameld")
            r <- eldr[c("Code", "AgeDays", "Sex", "LowerLimit", "UpperLimit")]
            names(r) <- c("param", "age", "sex", "lower", "upper")
            r$age <- r$age / 365.25

            ## set missing lower limits to 0.15 of the upper according to
            ## Haeckel et al. 2015
            set_missing_limits(r)
        },
        packages = "zlog",
        deployment = "main"
    ),
    tar_target(imp_data, {
            imp <- withCallingHandlers(
                impute_df(raw_data, ref_data, method = "logmean"),
                warning = function(w) {
                    if(w$message != paste0(
                        "No reference for column(s): DaysAtRisk, Deceased, ",
                        "LTx, Cirrhosis, ALF, Ethyltoxic, HBV, HCV, AIH, PBC, ",
                        "PSC, NASH, Cryptogenic, Dialysis, GIB, HCC, SBP"))
                           stop(w$message)
                    else
                        invokeRestart("muffleWarning")
                }
            )
            ## assume no dialysis for missing values
            imp$Dialysis[is.na(imp$Dialysis)] <- 0L
            ## same for SBP and Cirrhosis
            imp$SBP[is.na(imp$SBP)] <- 0L
            imp$Cirrhosis[is.na(imp$Cirrhosis)] <- 0L
            ## exclude Age below 20
            imp <- imp[imp$Age >= 20,]
            imp
        },
        packages = "zlog",
        deployment = "main"
    ),
    tar_target(
        labelled_meld_data, {
            x <- .add_meld_columns(raw_data)
            ## apply some basic labels to the laboratory columns
            cn_labs <- grep("_[CEQS]$", colnames(x), value = TRUE)
            data(eldr, package = "ameld")
            ref <- eldr[
                match(cn_labs, eldr$Code),
                c("Code", "LongDescription", "ShortDescription", "Unit")
            ]
            abbr <- setNames(character(ncol(x)), colnames(x))

            .lbl <- function(x, unit) {
                if (nchar(unit))
                    paste0(x, " [", unit, "]")
                else
                    x
            }
            .upc <- function(x) {
                substr(x, 1L, 1L) <- toupper(substr(x, 1L, 1L))
                x
            }

            levels(x$Sex) <- .upc(levels(x$Sex))

            x$CLI <- as.integer(
                !x$Cirrhosis & !is.na(x$Cirrhosis) & !x$ALF & !is.na(x$ALF)
            )

            for (cn in cn_labs) {
                r <- ref[ref$Code == cn,]
                if (startsWith(
                        sub("^B_", "", cn),
                        sub("-", "", r$ShortDescription)
                )) {
                    ## common abbreviation like ALAT
                    ## e.g. Code: ALAT_S, ShortDescription: ALAT
                    desc <- r$ShortDescription
                    abbr[cn] <- paste0(desc, ", ", r$LongDescription)
                } else
                    desc <- .upc(r$LongDescription)

                attr(x[[cn]], "label") <- .lbl(desc, r$Unit)
            }

            attr(x$DaysAtRisk, "label") <- "Follow-up time [days]"

            attr(x$ScoreMeld, "label") <-
                attr(x$ScoreMeldUnos, "label") <- "MELD score"
            attr(x$ScoreMeldNa, "label") <-
                attr(x$ScoreMeldNaUnos, "label") <- "MELD-Na score"
            attr(x$ProbMeldPlus7, "label") <- "MELD-Plus7 risk score"

            attr(x$MeldCategory, "label") <- "MELD Category"

            ## labels where the column names are identical to the abbreviation
            .abbr <- c(
                 AIH = "autoimmune hepatitis",
                 ALF = "acute liver failure",
                 CLI = "chronic liver insufficiency",
                 GIB = "gastrointestinal bleeding",
                 HBV = "hepatitis B virus",
                 HCV = "hepatitis C virus",
                 LTx = "liver transplantation",
                 NASH = "non-alcoholic steatohepatitis",
                 PBC = "primary biliary cirrhosis",
                 PSC = "primary sclerosing cholangitis",
                 SBP = "spontaneous bacterial peritonitis"
            )
            for (nm in names(.abbr))
                attr(x[[nm]], "label") <- nm

            abbr[names(.abbr)] <- paste0(names(.abbr), ", ", .abbr)

            attr(x, "abbreviations") <- abbr
            x
        },
        packages = "ameld",
        deployment = "main"
    ),
    tar_target(
        meld_data,
        .add_meld_columns(imp_data),
        packages = "ameld",
        deployment = "main"
    ),
    tar_target(zlog_data, {
            zlog_data <- meld_data
            iconvert <- colnames(zlog_data) %in%
                c("Age", "Sex", grep("_[SECQ]$", colnames(imp_data), value = TRUE))
            zlog_data[iconvert] <- zlog_df(imp_data[iconvert], ref_data)
            zlog_data
        },
        packages = "zlog",
        deployment = "main"
    )
)
