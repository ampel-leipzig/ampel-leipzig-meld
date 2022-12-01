tg_tables <- list(
    tar_target(tbl1, {
        tbGeneral <- labelled_meld_data |>
            select(
                Sex,
                DaysAtRisk, Age, LTx
            ) |>
            tbl_summary(
                by = Sex,
                missing_text = "(Missing)"
            ) |>
            add_overall()

        tbLabs <- labelled_meld_data |>
            select(
                Sex,
                BILI_S, CYSC_S, CRE_S, INR_C, NA_S,
                B_WBC_E, CRE_S, IL6_S,
                ALB_S, PROT_S, CHOLG_S,
                ALAT_S, ASAT_S
            ) |>
            tbl_summary(
                by = Sex,
                missing_text = "(Missing)"
            ) |>
            add_overall()

        tbMeld <- labelled_meld_data |>
            select(
               Sex,
               ScoreMeldUnos,
               ScoreMeldNaUnos,
               MeldCategory,
               ScoreMeld3,
            ) |>
            tbl_summary(
                by = Sex,
                missing_text = "(Missing)"
            ) |>
            add_overall()

        tbEntities <- labelled_meld_data |>
            select(
               Sex,
               Cirrhosis, ALF, CLI
            ) |>
            tbl_summary(
                by = Sex,
                missing_text = "(Missing)"
            ) |>
            add_overall()

        tbEtiology <- labelled_meld_data |>
            select(
               Sex,
               Ethyltoxic, HBV, HCV, AIH, PBC, PSC, NASH, Cryptogenic
            ) |>
            tbl_summary(
                by = Sex,
                missing_text = "(Missing)"
            ) |>
            add_overall()

        tbComplications <- labelled_meld_data |>
            select(
               Sex,
               Dialysis, GIB, HCC, SBP
            ) |>
            tbl_summary(
                by = Sex,
                missing_text = "(Missing)"
            ) |>
            add_overall()

        ## generate mortality table stub
        ## (tbl_survfit doesn't support (cumulative) events) and t()
        tbMortality <- labelled_meld_data |>
            select(
               Sex,
               Age
            ) |>
            tbl_summary(
                by = Sex,
                missing_text = "(Missing)"
            ) |>
            add_overall()

        ## generate mortality table content
        times <- c(7, 30, 90, 365)
        srv <- Surv(
            labelled_meld_data$DaysAtRisk,
            labelled_meld_data$Deceased
        )
        m_overall <- observed_mortality(srv, times = times)
        n_overall <- observed_events(
            srv, times = times, cumulative = TRUE
        )
        m_sex <- observed_mortality(
            srv, f = labelled_meld_data$Sex, times = times
        )
        n_sex <- observed_events(
            srv,
            f = labelled_meld_data$Sex,
            times = times,
            cumulative = TRUE
        )
        content <- tibble::tibble(
            variable = paste0("M", times),
            var_type = "mortality",
            var_label = "Mortality",
            row_type = "label",
            label = paste0("Within ", times, " days"),
            stat_label = "n (%)",
            stat_0 = paste0(
                n_overall, " (", style_percent(m_overall, symbol = TRUE), ")"
            ),
            stat_1 = paste0(
                n_sex[, "Female"],
                " (", style_percent(m_sex[, "Female"], symbol = TRUE), ")"
            ),
            stat_2 = paste0(
                n_sex[, "Male"],
                " (", style_percent(m_sex[, "Male"], symbol = TRUE), ")"
            )
        )

        ## replace stub with content
        tbMortality$table_body <- content
        tbMortality <- modify_table_styling(
            tbMortality, column = "label", text_format = "indent"
        )

        tbl1 <- tbl_stack(
            list(
                tbGeneral,
                tbLabs,
                tbMeld,
                tbEntities,
                tbEtiology,
                tbComplications,
                tbMortality
            ),
            group_header = c(
                "General",
                "Laboratory measurements",
                "MELD",
                "Entities",
                "Etiology (more than 1 per patient possible)",
                "Complications (more than 1 per patient possible)",
                "Mortality"
            )
        ) |>
        ## remove all footnotes
        modify_footnote(update = everything() ~ NA) |>
        ## reorder: Overall column (stat_0) to the right
        modify_table_body( ~ .x |> dplyr::relocate(stat_0, .after = stat_2)) |>
        ## indent variable names and missing
        modify_table_styling(column = "label", text_format = "indent") |>
        modify_table_styling(
            rows = row_type %in% c("missing", "level"),
            column = "label",
            text_format = "indent2"
        )

        ## set caption
        tbl1 |>
        modify_caption(
            paste0(
                "Baseline characteristics.<br />",
                "Values are given as ",
                "median (lower quartile, upper quartile) or n (percent).<br />",
                paste0(
                    Filter(
                        nchar,
                        attr(labelled_meld_data, "abbreviations")[
                            unique(sort(
                                gsub("^B_", "", tbl1$table_body$variable)
                            ))
                        ]
                    ),
                    collapse = "; "
                )
            )
        )
    },
    packages = c("ameld", "gtsummary", "survival"),
    deployment = "main"
    ),
    tar_target(tbl_observed_vs_expected_mortality, {
        ## MELD mortality values are taken from @vanderwerken2021
        vanderwerken <- data.frame(
            MELD = 6:40,
            mortality = 1 -
            c(0.9700, 0.9720, 0.9715, 0.9744, 0.9802, 0.9759, 0.9747, 0.9791,
              0.9752, 0.9651, 0.9606, 0.9514, 0.9380, 0.9309, 0.9128, 0.9048,
              0.8721, 0.8509, 0.8098, 0.7869, 0.7406, 0.6787, 0.6619, 0.5791,
              0.5244, 0.4906, 0.4831, 0.4069, 0.3860, 0.3629, 0.2944, 0.2429,
              0.2469, 0.1003, 0.1562)
        )
        vanderwerken$MeldCategory <- cut(
            vanderwerken$MELD,
            breaks = c(-Inf, seq(10, 40, by=10), Inf),
            labels = c("[6,9]", "[10,20)", "[20,30)", "[30,40)", "[40,52)"),
            right = FALSE
        )
        expected <- tapply(
            vanderwerken$mortality, vanderwerken$MeldCategory, mean
        )

        observed_vs_expected_mortality(
            Surv(labelled_meld_data$DaysAtRisk, labelled_meld_data$Deceased),
            f = labelled_meld_data$MeldCategory,
            time = 90, expected
        )
    },
    packages = "ameld",
    deployment = "main"
    )
)
