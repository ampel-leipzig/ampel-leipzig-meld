tg_tables <- list(
    tar_target(tbl1, {
        theme_gtsummary_journal(journal = "jama")
        theme_gtsummary_compact()
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
               MeldCategory,
               ScoreMeldNaUnos, ProbMeldPlus7,
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
        ## (tbl_survfit doesn't support (cumulative) events)
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
                n_overall, " (", style_percent(m_overall), ")"
            ),
            stat_1 = paste0(
                n_sex[, "Female"],
                " (", style_percent(m_sex[, "Female"]), ")"
            ),
            stat_2 = paste0(
                n_sex[, "Male"],
                " (", style_percent(m_sex[, "Male"]), ")"
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
            rows = row_type == "missing",
            column = "label",
            text_format = "indent2"
        )

        ## set caption
        tbl1 |>
        modify_caption(
            paste0(
                "Baseline characteristics.\n",
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
    tar_target(tbl_observed_vs_expected_mortality,
        observed_vs_expected_mortality(
            Surv(labelled_meld_data$DaysAtRisk, labelled_meld_data$Deceased),
            f = labelled_meld_data$MeldCategory,
            time = 90,
            ## MELD mortality values are taken from @wiesner2003.
            c(0.019, 0.06, 0.196, 0.526, 0.713)
        ),
    packages = "ameld",
    deployment = "main"
    )
)
