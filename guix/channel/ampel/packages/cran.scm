(define-module (ampel packages cran)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system r)
  #:use-module (gnu packages)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cran)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages statistics))

(define-public r-broom-helpers
  (package
    (name "r-broom-helpers")
    (version "1.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "broom.helpers" version))
        (sha256
          (base32
            "1xc12l3dy4mh0q0pxv74rixmbqwh2nag9ywdwwqa215gfg58fw1b"))))
    (properties `((upstream-name . "broom.helpers")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-broom
            r-cli
            r-dplyr
            r-labelled
            r-lifecycle
            r-purrr
            r-rlang
            r-stringr
            r-tibble
            r-tidyr))
    (native-inputs (list r-knitr))
    (home-page
      "https://larmarange.github.io/broom.helpers/")
    (synopsis
      "Helpers for Model Coefficients Tibbles")
    (description
      "This package provides suite of functions to work with regression model 'broom::tidy()' tibbles.  The suite includes functions to group regression model terms by variable, insert reference and header rows for categorical variables, add variable labels, and more.")
    (license gpl3)))

(define-public r-consort
  (package
    (name "r-consort")
    (version "1.0.1")
    (source (origin
              (method url-fetch)
              (uri (cran-uri "consort" version))
              (sha256
               (base32
                "16i7hd433f3lfs6saa20m2jk9926r9jaln74333dmx5ld0294q99"))))
    (properties `((upstream-name . "consort")))
    (build-system r-build-system)
    (native-inputs (list r-knitr))
    (home-page "https://github.com/adayim/consort/")
    (synopsis "Create Consort Diagram")
    (description
     "To make it easy to create CONSORT diagrams for the transparent reporting of
participant allocation in randomized, controlled clinical trials.  This is done
by creating a standardized disposition data, and using this data as the source
for the creation a standard CONSORT diagram.  Human effort by supplying text
labels on the node can also be achieved.")
    (license expat)))

(define-public r-dictionar6
  (package
    (name "r-dictionar6")
    (version "0.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "dictionar6" version))
        (sha256
          (base32 "1rg958py4pqghkid3830hla7vibvwsjhk75x55lxry5d8dp04m9f"))))
    (properties `((upstream-name . "dictionar6")))
    (build-system r-build-system)
    (propagated-inputs (list r-ooplah r-r6))
    (home-page "https://xoopR.github.io/dictionar6/")
    (synopsis "R6 Dictionary Interface")
    (description
      "Efficient object-oriented R6 dictionary capable of holding objects of any class, including R6.  Typed and untyped dictionaries are provided as well as the 'usual' dictionary methods that are available in other OOP languages, for example listing keys, items, values, and methods to get/set these.")
    (license expat)))

(define-public r-distr6
  (package
    (name "r-distr6")
    (version "1.6.9")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "distr6" version))
        (sha256
          (base32
            "1vl8xg0r0g169xdx6prnfpfr1jnn8mc4daayrzpws4my2dc59dqh"))))
    (properties `((upstream-name . "distr6")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-checkmate
            r-data-table
            r-param6
            r-r6
            r-rcpp
            r-set6))
    (native-inputs (list r-knitr))
    (home-page
      "https://alan-turing-institute.github.io/distr6/")
    (synopsis
      "The Complete R6 Probability Distributions Interface")
    (description
      "An R6 object oriented distributions package.  Unified interface for 42 probability distributions and 11 kernels including functionality for multiple scientific types.  Additionally functionality for composite distributions and numerical imputation.  Design patterns including wrappers and decorators are described in Gamma et al. (1994, ISBN:0-201-63361-2).  For quick reference of probability distributions including d/p/q/r functions and results we refer to McLaughlin, M.  P. (2001).  Additionally Devroye (1986, ISBN:0-387-96305-7) for sampling the Dirichlet distribution, Gentle (2009) <doi:10.1007/978-0-387-98144-4> for sampling the Multivariate Normal distribution and Michael et al. (1976) <doi:10.2307/2683801> for sampling the Wald distribution.")
    (license expat)))

(define-public r-future-batchtools
  (package
    (name "r-future-batchtools")
    (version "0.10.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "future.batchtools" version))
        (sha256
          (base32
            "1ly98h2g7wpfxp2r8vl1hy7wqqgwgawjagz0m2iczjmcj4ix6avk"))))
    (properties
      `((upstream-name . "future.batchtools")))
    (build-system r-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'set-HOME
           (lambda _ (setenv "HOME" "/tmp"))))))
    (propagated-inputs
      (list r-batchtools r-future))
    (native-inputs (list r-r-rsp)); vignette builder
    (home-page
      "https://github.com/HenrikBengtsson/future.batchtools")
    (synopsis
      "A Future API for Parallel and Distributed Processing using 'batchtools'")
    (description
      "Implementation of the Future API on top of the 'batchtools' package.  This allows you to process futures, as defined by the 'future' package, in parallel out of the box, not only on your local machine or ad-hoc cluster of machines, but also via high-performance compute ('HPC') job schedulers such as 'LSF', 'OpenLava', 'Slurm', 'SGE', and 'TORQUE' / 'PBS', e.g. 'y <- future.apply::future_lapply(files, FUN = process)'.")
    (license lgpl2.1+)))

(define-public r-future-callr
  (package
    (name "r-future-callr")
    (version "0.8.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "future.callr" version))
        (sha256
          (base32
            "1nhkmxaaii647gizrxa8zj1iakivml7zrqi4bvvs5yshc7m9slg9"))))
    (properties `((upstream-name . "future.callr")))
    (build-system r-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'set-HOME
           (lambda _ (setenv "HOME" "/tmp"))))))
    (propagated-inputs (list r-callr r-future))
    (native-inputs (list r-r-rsp)); vignette builder
    (home-page
      "https://future.callr.futureverse.org")
    (synopsis
      "A Future API for Parallel Processing using 'callr'")
    (description
      "Implementation of the Future API on top of the 'callr' package.  This allows you to process futures, as defined by the 'future' package, in parallel out of the box, on your local (Linux, macOS, Windows, ...) machine.  Contrary to backends relying on the 'parallel' package (e.g. 'future::multisession') and socket connections, the 'callr' backend provided here can run more than 125 parallel R processes.")
    (license lgpl2.1+)))

(define-public r-gt
  (package
    (name "r-gt")
    (version "0.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "gt" version))
        (sha256
          (base32
            "1yr6w8nd42gnqrf641hr5a3hs8p92xmybr0lb2fv1m7cvbh894s6"))))
    (properties `((upstream-name . "gt")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-bitops
            r-checkmate
            r-commonmark
            r-dplyr
            r-fs
            r-ggplot2
            r-glue
            r-htmltools
            r-magrittr
            r-rlang
            r-sass
            r-scales
            r-stringr
            r-tibble
            r-tidyselect))
    (home-page "https://gt.rstudio.com/")
    (synopsis
      "Easily Create Presentation-Ready Display Tables")
    (description
      "Build display tables from tabular data with an easy-to-use set of functions.  With its progressive approach, we can construct display tables with a cohesive set of table parts.  Table values can be formatted using any of the included formatting functions.  Footnotes and cell styles can be precisely added through a location targeting system.  The way in which 'gt' handles things for you means that you don't often have to worry about the fine details.")
    (license expat)))

(define-public r-gtsummary
  (package
    (name "r-gtsummary")
    (version "1.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "gtsummary" version))
        (sha256
          (base32
            "0lw70g14sj0nfmcq9kj8lyckydaxngxbm1xgan5bgd7i88n4bzfz"))))
    (properties `((upstream-name . "gtsummary")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-broom
            r-broom-helpers
            r-cli
            r-dplyr
            r-forcats
            r-glue
            r-gt
            r-knitr
            r-lifecycle
            r-purrr
            r-rlang
            r-stringr
            r-survival
            r-tibble
            r-tidyr))
    (native-inputs (list r-knitr))
    (home-page
      "https://github.com/ddsjoberg/gtsummary")
    (synopsis
      "Presentation-Ready Data Summary and Analytic Result Tables")
    (description
      "Creates presentation-ready tables summarizing data sets, regression models, and more.  The code to create the tables is concise and highly customizable.  Data frames can be summarized with any function, e.g.  mean(), median(), even user-written functions.  Regression models are summarized and include the reference rows for categorical variables.  Common regression models, such as logistic regression and Cox proportional hazards regression, are automatically identified and the tables are pre-filled with appropriate column headers.")
    (license expat)))

(define-public r-mets
  (package
    (name "r-mets")
    (version "1.2.9")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "mets" version))
        (sha256
          (base32 "1daah4wkn428gdlah5f96jyjs3z9c3sz8h7g9lil8p3i9q3crb2z"))))
    (properties `((upstream-name . "mets")))
    (build-system r-build-system)
    (arguments
     `(#:tests? #f)) ; one vignette overwrite another, disable checks, hopefully CRAN checks it
    (propagated-inputs
      (list r-lava
            r-mvtnorm
            r-numderiv
            r-rcpp
            r-rcpparmadillo
            r-survival
            r-timereg))
    (native-inputs (list gfortran-toolchain r-knitr))
    (home-page "https://kkholst.github.io/mets/")
    (synopsis "Analysis of Multivariate Event Times")
    (description
      "Implementation of various statistical models for multivariate event history data
      <doi:10.1007/s10985-013-9244-x>.  Including multivariate cumulative incidence
      models <doi:10.1002/sim.6016>, and  bivariate random effects probit models
      (Liability models) <doi:10.1016/j.csda.2015.01.014>.  Also contains two-stage
      binomial modelling that can do pairwise odds-ratio dependence modelling based
      marginal logistic regression models.  This is an alternative to the alternating
      logistic regression approach (ALR).")
    (license gpl2+)))

(define-public r-mlr3benchmark
  (package
    (name "r-mlr3benchmark")
    (version "0.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "mlr3benchmark" version))
        (sha256
          (base32
            "0j56l8yi1c0sa3fsychrvv42rpip2d300yccps0bj636c5r7na64"))))
    (properties `((upstream-name . "mlr3benchmark")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-checkmate
            r-data-table
            r-ggplot2
            r-mlr3misc
            r-r6))
    (home-page "https://mlr3benchmark.mlr-org.com")
    (synopsis
      "Analysis and Visualisation of Benchmark Experiments")
    (description
      "Implements methods for post-hoc analysis and visualisation of benchmark experiments, for 'mlr3' and beyond.")
    (license lgpl3)))

(define-public r-mlr3extralearners
  (let ((commit
          "6a0da263ae31fe0163f10f5ea1a94feef2ddf852")
        (revision "1"))
    (package
      (name "r-mlr3extralearners")
      (version (git-version "0.5.37" revision commit))
      (source
        (origin
          (method git-fetch)
          (uri (git-reference
                 (url "https://github.com/mlr-org/mlr3extralearners")
                 (commit commit)))
          (file-name (git-file-name name version))
          (sha256
            (base32
              "15vzh1ary9kn8iy92mkv7mby4s7gw766j9z0qdpvh1cvh7hxf6fz"))))
      (properties
        `((upstream-name . "mlr3extralearners")))
      (build-system r-build-system)
      (propagated-inputs
        (list r-checkmate
              r-data-table
              r-mlr3
              r-mlr3misc
              r-paradox
              r-r6))
      (home-page
        "https://github.com/mlr-org/mlr3extralearners")
      (synopsis "Extra Learners For mlr3")
      (description "Extra learners for use in mlr3.")
      (license lgpl3))))

(define-public r-mlr3proba
  (let ((commit "fdfd269"))
  (package
    (name "r-mlr3proba")
    ;(version "0.4.9")
    (version (string-append "0.4.11-" commit))
    (source
      (origin
        ;(method url-fetch)
        ;(uri (cran-uri "mlr3proba" version))
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/mlr-org/mlr3proba")
               (commit commit)))
        (file-name (string-append name version))
        (sha256
          (base32
            "0jri3m2f9apxvhl8snbm2fs5kpcq7f0axzcdfc1w0jmrmidajlkb"))))
    (properties `((upstream-name . "mlr3proba")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-checkmate
            r-data-table
            r-distr6
            r-mlr3
            r-mlr3misc
            r-paradox
            r-r6
            r-rcpp
            r-survival
            r-survivalmodels))
    (home-page "https://mlr3proba.mlr-org.com")
    (synopsis
      "Probabilistic Supervised Learning for 'mlr3'")
    (description
      "This package provides extensions for probabilistic supervised learning for 'mlr3'.  This includes extending the regression task to probabilistic and interval regression, adding a survival task, and other specialized models, predictions, and measures.  mlr3extralearners is available from <https://github.com/mlr-org/mlr3extralearners>.")
    (license lgpl3))))

(define-public r-mlr3viz
  (package
    (name "r-mlr3viz")
    (version "0.5.9")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "mlr3viz" version))
        (sha256
          (base32
            "07hhhasd43iwcm77kic7wfz4gm0q6lryp2lh3cmjrjin1ma7vxig"))))
    (properties `((upstream-name . "mlr3viz")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-checkmate
            r-data-table
            r-ggplot2
            r-mlr3misc
            r-scales
            r-viridis))
    (home-page "https://mlr3viz.mlr-org.com")
    (synopsis "Visualizations for 'mlr3'")
    (description
      "This package provides visualizations for 'mlr3' objects such as tasks, predictions, resample results or benchmark results via the autoplot() generic of 'ggplot2'.  The returned 'ggplot' objects are intended to provide sensible defaults, yet can easily be customized to create camera-ready figures.  Visualizations include barplots, boxplots, histograms, ROC curves, and Precision-Recall curves.")
    (license lgpl3)))

(define-public r-ooplah
  (package
    (name "r-ooplah")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "ooplah" version))
        (sha256
          (base32 "1p74jh9g62yicrw0lhpbn0diqi2myl24z28kpd2b3mglyffadr0b"))))
    (properties `((upstream-name . "ooplah")))
    (build-system r-build-system)
    (propagated-inputs (list r-r6))
    (home-page "https://xoopR.github.io/ooplah/")
    (synopsis "Helper Functions for Class Object-Oriented Programming")
    (description
      "Helper functions for coding object-oriented programming with a focus on R6.  Includes functions for assertions and testing, looping, and re-usable design patterns including Abstract and Decorator classes.")
    (license expat)))

(define-public r-param6
  (package
    (name "r-param6")
    (version "0.2.4")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "param6" version))
        (sha256
          (base32
            "0h4r2l670zvsbq0cakbm7f5yc0ghaf40kby80q3ql8lwgfnay1jd"))))
    (properties `((upstream-name . "param6")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-checkmate
            r-data-table
            r-dictionar6
            r-r6
            r-set6))
    (home-page "https://xoopR.github.io/param6/")
    (synopsis "A Fast and Lightweight R6 Parameter Interface")
    (description
      "By making use of 'set6', alongside the S3 and R6 paradigms, this package provides a fast and lightweight R6 interface for parameters and parameter sets.")
    (license expat)))

(define-public r-pec
  (package
    (name "r-pec")
    (version "2022.05.04")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "pec" version))
        (sha256
          (base32
            "0s0lfr8747gfnn9hrwacbh160mn593p28qvima5dz9aabndhg8a7"))))
    (properties `((upstream-name . "pec")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-foreach
            r-lava
            r-prodlim
            r-riskregression
            r-rms
            r-survival
            r-timereg))
    (home-page "https://cran.r-project.org/package=pec")
    (synopsis
      "Prediction Error Curves for Risk Prediction Models in Survival Analysis")
    (description
      "Validation of risk predictions obtained from survival models and
      competing risk models based on censored data using inverse weighting and
      cross-validation.
      Most of the 'pec' functionality has been moved to 'riskRegression'.")
    (license gpl2+)))

(define-public r-publish
  (package
    (name "r-publish")
    (version "2020.12.23")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "Publish" version))
        (sha256
          (base32 "1qpv5hj9agmc4hrpskqk0lns8bh8w3j27d4ckh5y7gh1532qzad7"))))
    (properties `((upstream-name . "Publish")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-data-table r-lava r-multcomp r-prodlim r-survival))
    (home-page "https://cran.r-project.org/package=Publish")
    (synopsis
      "Format Output of Various Routines in a Suitable Way for Reports and Publication")
    (description
      "This package provides a bunch of convenience functions that transform the
      results of some basic statistical analyses into table format nearly ready for
      publication.  This includes descriptive tables, tables of logistic regression
      and Cox regression results as well as forest plots.")
    (license gpl2+)))

(define-public r-riskregression
  (package
    (name "r-riskregression")
    (version "2022.03.22")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "riskRegression" version))
        (sha256
          (base32
            "0ix0h91a9zsw3cl4pg14mmkzq71f2g9r4wakpixy0fp7bfj6c6jf"))))
    (properties `((upstream-name . "riskRegression")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-cmprsk
            r-data-table
            r-doparallel
            r-foreach
            r-ggplot2
            r-lattice
            r-lava
            r-mets
            r-mvtnorm
            r-plotrix
            r-prodlim
            r-publish
            r-ranger
            r-rcpp
            r-rcpparmadillo
            r-rms
            r-survival
            r-timereg))
    (home-page "https://github.com/tagteam/riskRegression")
    (synopsis
      "Risk Regression Models and Prediction Scores for Survival Analysis with Competing Risks")
    (description
      "Implementation of the following methods for event history analysis.  Risk
      regression models for survival endpoints also in the presence of competing risks
      are fitted using binomial regression based on a time sequence of binary event
      status variables.  A formula interface for the Fine-Gray regression model and an
      interface for the combination of cause-specific Cox regression models.  A
      toolbox for assessing and comparing performance of risk predictions (risk
      markers and risk prediction models).  Prediction performance is measured by the
      Brier score and the area under the ROC curve for binary possibly time-dependent
      outcome.  Inverse probability of censoring weighting and pseudo values are used
      to deal with right censored data.  Lists of risk markers and lists of risk
      models are assessed simultaneously.  Cross-validation repeatedly splits the
      data, trains the risk prediction models on one part of each split and then
      summarizes and compares the performance across splits.")
    (license gpl2+)))

(define-public r-set6
  (package
    (name "r-set6")
    (version "0.2.4")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "set6" version))
        (sha256
          (base32
            "06swz60p73a7m7rvsv1545hsr2chkk2w2hmnfwkwfz4hrbdxm709"))))
    (properties `((upstream-name . "set6")))
    (build-system r-build-system)
    (propagated-inputs (list r-checkmate r-ooplah r-r6 r-rcpp))
    (native-inputs (list r-knitr))
    (home-page "https://xoopR.github.io/set6/")
    (synopsis "R6 Mathematical Sets Interface")
    (description
      "An object-oriented package for mathematical sets, upgrading the current gold-standard {sets}.  Many forms of mathematical sets are implemented, including (countably finite) sets, tuples, intervals (countably infinite or uncountable), and fuzzy variants.  Wrappers extend functionality by allowing symbolic representations of complex operations on sets, including unions, (cartesian) products, exponentiation, and differences (asymmetric and symmetric).")
    (license expat)))

(define-public r-skimr
  (package
    (name "r-skimr")
    (version "2.1.4")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "skimr" version))
        (sha256
          (base32
            "1xfma7h488sjhqz3mj1zz5xlm075arzp85rny24rckvn7nj6avkg"))))
    (properties `((upstream-name . "skimr")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-cli
            r-dplyr
            r-knitr
            r-magrittr
            r-pillar
            r-purrr
            r-repr
            r-rlang
            r-stringr
            r-tibble
            r-tidyr
            r-tidyselect
            r-vctrs))
    (native-inputs (list r-knitr))
    (home-page "https://docs.ropensci.org/skimr/")
    (synopsis
      "Compact and Flexible Summaries of Data")
    (description
      "This package provides a simple to use summary function that can be used with pipes and displays nicely in the console.  The default summary statistics may be modified by the user as can the default formatting.  Support for data frames and vectors is included, and users can implement their own skim methods for specific object types as described in a vignette.  Default summaries include support for inline spark graphs.  Instructions for managing these on specific operating systems are given in the \"Using skimr\" vignette and the README.")
    (license gpl3)))

(define-public r-survivalmodels
  (package
    (name "r-survivalmodels")
    (version "0.1.13")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "survivalmodels" version))
        (sha256
          (base32
            "0d5bfmvfwf3i1iim5cjrqq5vlja92znpzv1csrk488rb582zaza7"))))
    (properties
      `((upstream-name . "survivalmodels")))
    (build-system r-build-system)
    (propagated-inputs (list r-rcpp))
    (home-page
      "https://github.com/RaphaelS1/survivalmodels/")
    (synopsis "Models for Survival Analysis")
    (description
      "Implementations of classical and machine learning models for survival analysis, including deep neural networks via 'keras' and 'tensorflow'.  Each model includes a separated fit and predict interface with consistent prediction types for predicting risk, survival probabilities, or survival distributions with 'distr6' <https://CRAN.R-project.org/package=distr6>.  Models are either implemented from 'Python' via 'reticulate' <https://CRAN.R-project.org/package=reticulate>, from code in GitHub packages, or novel implementations using 'Rcpp' <https://CRAN.R-project.org/package=Rcpp>.  Novel machine learning survival models wil be included in the package in near-future updates.  Neural networks are implemented from the 'Python' package 'pycox' <https://github.com/havakv/pycox> and are detailed by Kvamme et al. (2019) <https://jmlr.org/papers/v20/18-424.html>.  The 'Akritas' estimator is defined in Akritas (1994) <doi:10.1214/aos/1176325630>. 'DNNSurv' is defined in Zhao and Feng (2020) <arXiv:1908.02337>.")
    (license expat)))

(define-public r-survivalsvm
  (package
    (name "r-survivalsvm")
    (version "0.0.5")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "survivalsvm" version))
        (sha256
          (base32
            "1b4hrdrqq1z0kfn8vpdwg54388m25df2s6w9i574x3mkxkmkjkga"))))
    (properties `((upstream-name . "survivalsvm")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-hmisc r-kernlab r-matrix r-pracma r-quadprog r-survival))
    (home-page
      "https://github.com/imbs-hl/survivalsvm")
    (synopsis "Survival Support Vector Analysis")
    (description
      "Performs support vectors analysis for data sets with survival outcome.  Three approaches are available in the package: The regression approach takes censoring into account when formulating the inequality constraints of the support vector problem.  In the ranking approach, the inequality constraints set the objective to maximize the concordance index for comparable pairs of observations.  The hybrid approach combines the regression and ranking constraints in the same model.")
    (license (list gpl2+ gpl3+))))

(define-public r-tarchetypes
  (package
    (name "r-tarchetypes")
    (version "0.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "tarchetypes" version))
        (sha256
          (base32
            "1knzzbfxka8n1vvz7ikplckqzrdw62fqy5wkh46fvgcb13dmx99a"))))
    (properties `((upstream-name . "tarchetypes")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-digest
            r-dplyr
            r-fs
            r-rlang
            r-targets
            r-tibble
            r-tidyselect
            r-vctrs
            r-withr))
    (home-page
      "https://docs.ropensci.org/tarchetypes/")
    (synopsis "Archetypes for Targets")
    (description
      "Function-oriented Make-like declarative workflows for Statistics and data science are supported in the 'targets' R package.  As an extension to 'targets', the 'tarchetypes' package provides convenient user-side functions to make 'targets' easier to use.  By establishing reusable archetypes for common kinds of targets and pipelines, these functions help express complicated reproducible workflows concisely and compactly.  The methods in this package were influenced by the 'drake' R package by Will Landau (2018) <doi:10.21105/joss.00550>.")
    (license expat)))

(define-public r-targets
  (package
    (name "r-targets")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "targets" version))
        (sha256
          (base32
            "02g1l0mnq9p03n68pmv65af0z8il5dm5yyw470pdrg7zpx2lvg3p"))))
    (properties `((upstream-name . "targets")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-base64url
            r-callr
            r-cli
            r-codetools
            r-data-table
            r-digest
            r-knitr
            r-igraph
            r-r6
            r-rlang
            r-tibble
            r-tidyselect
            r-vctrs
            r-withr
            r-yaml))
    (home-page "https://docs.ropensci.org/targets/")
    (synopsis
      "Dynamic Function-Oriented 'Make'-Like Declarative Workflows")
    (description
      "As a pipeline toolkit for Statistics and data science in R, the 'targets'
      package brings together function-oriented programming and 'Make'-like
      declarative workflows.  It analyzes the dependency relationships among the
      tasks of a workflow, skips steps that are already up to date, runs the
      necessary computation with optional parallel workers, abstracts files as
      R objects, and provides tangible evidence that the results match the
      underlying code and data.  The methodology in this package borrows from
      GNU 'Make' (2015, ISBN:978-9881443519) and 'drake'
      (2018, <doi:10.21105/joss.00550>).")
    (license expat)))

(define-public r-timereg
  (package
    (name "r-timereg")
    (version "2.0.2")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "timereg" version))
        (sha256
          (base32
            "0n9mvdki50j0nbmbs1r91slf7j9nz4cwglscn71kckadsgjjpxmi"))))
    (properties `((upstream-name . "timereg")))
    (build-system r-build-system)
    (propagated-inputs (list r-lava r-numderiv r-survival))
    (home-page "https://github.com/scheike/timereg")
    (synopsis "Flexible Regression Models for Survival Data")
    (description
      "Programs for Martinussen and Scheike (2006), `Dynamic Regression Models
      for Survival Data', Springer Verlag.  Plus more recent developments.
      Additive survival model, semiparametric proportional odds model,
      fast cumulative residuals, excess risk models and more.
      Flexible competing risks regression including GOF-tests.
      Two-stage frailty modelling.  PLS for the additive risk model.
      Lasso in the 'ahaz' package.")
    (license gpl2+)))

(define-public r-timeroc
  (package
    (name "r-timeroc")
    (version "0.4")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "timeROC" version))
        (sha256
          (base32 "1qxijg7hazc8bifwj2254ig2p3cbrp9p0bsyhhh3aikf1rg113v1"))))
    (properties `((upstream-name . "timeROC")))
    (build-system r-build-system)
    (propagated-inputs (list r-mvtnorm r-pec))
    (home-page "https://cran.r-project.org/package=timeROC")
    (synopsis "Time-Dependent ROC Curve and AUC for Censored Survival Data")
    (description
      "Estimation of time-dependent ROC curve and area under time dependent ROC
      curve (AUC) in the presence of censored data, with or without competing
      risks. Confidence intervals of AUCs and tests for comparing AUCs of two
      rival markers measured on the same subjects can be computed, using the
      iid-representation of the AUC estimator.  Plot functions for
      time-dependent ROC curves and AUC curves are provided.
      Time-dependent Positive Predictive Values (PPV) and
      Negative Predictive Values (NPV) can also be computed.
      See Blanche et al. (2013) <doi:10.1002/sim.5958> and references
      therein for the details of the methods implemented in the package.")
    (license gpl2+)))

(define-public r-visnetwork
  (package
    (name "r-visnetwork")
    (version "2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "visNetwork" version))
        (sha256
          (base32
            "0bqmy5m6b5hda4vzlwnpgabsbg60v68wicm556cqml6rpdzixfd2"))))
    (properties `((upstream-name . "visNetwork")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-htmltools
            r-htmlwidgets
            r-jsonlite
            r-magrittr))
    (native-inputs (list r-knitr))
    (home-page
      "http://datastorm-open.github.io/visNetwork/")
    (synopsis
      "Network Visualization using 'vis.js' Library")
    (description
      "This package provides an R interface to the 'vis.js' JavaScript
      charting library.  It allows an interactive visualization of networks.")
    (license expat)))

(define-public r-workflowr
  (package
    (name "r-workflowr")
    (version "1.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "workflowr" version))
        (sha256
          (base32
            "0j1ahxm7xjla1xa38dc8ykn1j5a4yw1p8ivjk3k3va25kam25cp3"))))
    (properties `((upstream-name . "workflowr")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-callr
            r-fs
            r-getpass
            r-git2r
            r-glue
            r-httpuv
            r-httr
            r-knitr
            r-rmarkdown
            r-rprojroot
            r-rstudioapi
            r-stringr
            r-whisker
            r-xfun
            r-yaml))
    (native-inputs (list r-knitr))
    (home-page
      "https://github.com/jdblischak/workflowr")
    (synopsis
      "A Framework for Reproducible and Collaborative Data Science")
    (description
      "This package provides a workflow for your analysis projects by combining
      literate programming ('knitr' and 'rmarkdown') and version control
      ('Git', via 'git2r') to generate a website containing time-stamped,
      versioned, and documented results.")
    (license expat)))

(define-public r-ameld
  (let ((commit "ac7414b"))
  (package
    (name "r-ameld")
    (version (string-append "0.0.31-" commit))
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ampel-leipzig/ameld")
               (commit commit)))
        (file-name (string-append name version))
        (sha256
          (base32
            "1bh4fp0k9qqml33g664dx22xagdfdb2bcvfvajwyb2s3fs1cgrl0"))))
    (properties `((upstream-name . "ameld")))
    (build-system r-build-system)
    (propagated-inputs
      (list r-survival
            r-glmnet
            r-future
            r-future-apply
            r-dofuture
            r-progressr
            r-viridislite))
    (native-inputs (list r-knitr))
    (home-page "https://ampel-leipzig.github.io/ameld/")
    (synopsis "Data and Model of End-Stage Liver Disease used in the AMPEL Project")
    (description
      "A dataset of patients evaluated for liver transplantation at the
      University Hospital Leipzig from November 2012 to June 2015.
      Additional the model used to predict survival in patients with
      end-stage liver disease in the AMPEL (Analysis and Reporting System for the
      Improvement of Patient Safety through Real-Time Integration of Laboratory
      Findings, <https://ampel.care>) is provided.")
    (license gpl3+))))

(define-public r-zlog
  (let ((commit "4d2f2be"))
  (package
    (name "r-zlog")
    (version (string-append "1.0.1.9000-" commit))
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ampel-leipzig/zlog")
               (commit commit)))
        (file-name (string-append name version))
        (sha256
          (base32
            "0flrrcx5bxibxn52ccisfznf0fn0g2y2rkvqcihgy6jqa461zw6g"))))
    (properties `((upstream-name . "zlog")))
    (build-system r-build-system)
    (native-inputs (list r-knitr))
    (home-page
      "https://cran.r-project.org/package=zlog")
    (synopsis
      "Z(log) Transformation for Laboratory Measurements")
    (description
      "Transformation of laboratory measurements into z or z(log)-value based on
      given or empirical reference limits as proposed in Hoffmann et al.
      2017 <doi:10.1515/labmed-2016-0087>.")
    (license gpl3+))))
