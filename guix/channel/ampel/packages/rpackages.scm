(define-module (ampel packages rpackages)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system r)
  #:use-module (gnu packages)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cran)
  #:use-module (gnu packages statistics))

(define-public r-distr6
  (package
    (name "r-distr6")
    (version "1.5.2")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "distr6" version))
        (sha256
          (base32
            "1w1wrfnqxbr9aiif7hza9bnmbn1vmglcbmij7wkk662hvkg1j6z5"))))
    (properties `((upstream-name . "distr6")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-checkmate" ,r-checkmate)
        ("r-data-table" ,r-data-table)
        ("r-r6" ,r-r6)
        ("r-r62s3" ,r-r62s3)
        ("r-rcpp" ,r-rcpp)
        ("r-set6" ,r-set6)))
    (native-inputs `(("r-knitr" ,r-knitr)))
    (home-page
      "https://alan-turing-institute.github.io/distr6/")
    (synopsis
      "The Complete R6 Probability Distributions Interface")
    (description
      "An R6 object oriented distributions package.  Unified interface for 42 probability distributions and 11 kernels including functionality for multiple scientific types.  Additionally functionality for composite distributions and numerical imputation.  Design patterns including wrappers and decorators are described in Gamma et al. (1994, ISBN:0-201-63361-2).  For quick reference of probability distributions including d/p/q/r functions and results we refer to McLaughlin, M.  P. (2001).  Additionally Devroye (1986, ISBN:0-387-96305-7) for sampling the Dirichlet distribution, Gentle (2009) <doi:10.1007/978-0-387-98144-4> for sampling the Multivariate Normal distribution and Michael et al. (1976) <doi:10.2307/2683801> for sampling the Wald distribution.")
    (license expat)))

(define-public r-mlr3proba
  (package
    (name "r-mlr3proba")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "mlr3proba" version))
        (sha256
          (base32
            "1sgmcbxy8xbsmywsbc8qn6qlr79fr244rfz6hvy6i6ipvb6m7rpf"))))
    (properties `((upstream-name . "mlr3proba")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-checkmate" ,r-checkmate)
        ("r-data-table" ,r-data-table)
        ("r-distr6" ,r-distr6)
        ("r-mlr3" ,r-mlr3)
        ("r-mlr3misc" ,r-mlr3misc)
        ("r-paradox" ,r-paradox)
        ("r-r6" ,r-r6)
        ("r-rcpp" ,r-rcpp)
        ("r-survival" ,r-survival)))
    (home-page "https://mlr3proba.mlr-org.com")
    (synopsis
      "Probabilistic Supervised Learning for 'mlr3'")
    (description
      "This package provides extensions for probabilistic supervised learning for 'mlr3'.  This includes extending the regression task to probabilistic and interval regression, adding a survival task, and other specialized models, predictions, and measures.  mlr3extralearners is available from <https://github.com/mlr-org/mlr3extralearners>.")
    (license lgpl3)))

(define-public r-mlr3viz
  (package
    (name "r-mlr3viz")
    (version "0.5.4")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "mlr3viz" version))
        (sha256
          (base32
            "1qf054jk9yx3v5hm55cp89vzwx5i7vwiz71zrgsgxy74kpi4f7ih"))))
    (properties `((upstream-name . "mlr3viz")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-checkmate" ,r-checkmate)
        ("r-data-table" ,r-data-table)
        ("r-ggplot2" ,r-ggplot2)
        ("r-mlr3misc" ,r-mlr3misc)))
    (home-page "https://mlr3viz.mlr-org.com")
    (synopsis "Visualizations for 'mlr3'")
    (description
      "This package provides visualizations for 'mlr3' objects such as tasks, predictions, resample results or benchmark results via the autoplot() generic of 'ggplot2'.  The returned 'ggplot' objects are intended to provide sensible defaults, yet can easily be customized to create camera-ready figures.  Visualizations include barplots, boxplots, histograms, ROC curves, and Precision-Recall curves.")
    (license lgpl3)))

(define-public r-r62s3
  (package
    (name "r-r62s3")
    (version "1.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "R62S3" version))
        (sha256
          (base32
            "0g01izg77spn79xqwva2gzrvk66i20xlb789wl5rgcz7pz7gpjd2"))))
    (properties `((upstream-name . "R62S3")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-data-table" ,r-data-table)))
    (home-page "https://github.com/RaphaelS1/R62S3/")
    (synopsis "Automatic Method Generation from R6")
    (description
      "After defining an R6 class, R62S3 is used to automatically generate optional S3/S4 generics and methods for dispatch.  Also allows piping for R6 objects.")
    (license expat)))

(define-public r-set6
  (package
    (name "r-set6")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "set6" version))
        (sha256
          (base32
            "05c2s8wj10nv07p9617grdhsf5ijwpv82r0d2f76p0sbcx3d46qm"))))
    (properties `((upstream-name . "set6")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-checkmate" ,r-checkmate)
        ("r-r6" ,r-r6)
        ("r-rcpp" ,r-rcpp)))
    (native-inputs `(("r-knitr" ,r-knitr)))
    (home-page "https://xoopR.github.io/set6/")
    (synopsis "R6 Mathematical Sets Interface")
    (description
      "An object-oriented package for mathematical sets, upgrading the current gold-standard {sets}.  Many forms of mathematical sets are implemented, including (countably finite) sets, tuples, intervals (countably infinite or uncountable), and fuzzy variants.  Wrappers extend functionality by allowing symbolic representations of complex operations on sets, including unions, (cartesian) products, exponentiation, and differences (asymmetric and symmetric).")
    (license expat)))

(define-public r-skimr
  (package
    (name "r-skimr")
    (version "2.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "skimr" version))
        (sha256
          (base32
            "02q5l1l1a9m602dg55gbb1zd3ymh0gxy6r815dj8cp769i8hqla1"))))
    (properties `((upstream-name . "skimr")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-cli" ,r-cli)
        ("r-crayon" ,r-crayon)
        ("r-dplyr" ,r-dplyr)
        ("r-knitr" ,r-knitr)
        ("r-magrittr" ,r-magrittr)
        ("r-purrr" ,r-purrr)
        ("r-repr" ,r-repr)
        ("r-rlang" ,r-rlang)
        ("r-stringr" ,r-stringr)
        ("r-tibble" ,r-tibble)
        ("r-tidyr" ,r-tidyr)
        ("r-tidyselect" ,r-tidyselect)
        ("r-vctrs" ,r-vctrs)
        ("r-withr" ,r-withr)))
    (native-inputs `(("r-knitr" ,r-knitr)))
    (home-page "https://docs.ropensci.org/skimr/")
    (synopsis
      "Compact and Flexible Summaries of Data")
    (description
      "This package provides a simple to use summary function that can be used with pipes and displays nicely in the console.  The default summary statistics may be modified by the user as can the default formatting.  Support for data frames and vectors is included, and users can implement their own skim methods for specific object types as described in a vignette.  Default summaries include support for inline spark graphs.  Instructions for managing these on specific operating systems are given in the \"Using skimr\" vignette and the README.")
    (license gpl3)))

(define-public r-tarchetypes
  (package
    (name "r-tarchetypes")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "tarchetypes" version))
        (sha256
          (base32
            "1i0fpsq1qmz2rkc9pkvkr1px3gwlc4flfxc9j2z0g8v8ws2rlc2y"))))
    (properties `((upstream-name . "tarchetypes")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-digest" ,r-digest)
        ("r-fs" ,r-fs)
        ("r-rlang" ,r-rlang)
        ("r-targets" ,r-targets)
        ("r-tidyselect" ,r-tidyselect)
        ("r-vctrs" ,r-vctrs)
        ("r-withr" ,r-withr)))
    (home-page
      "https://docs.ropensci.org/tarchetypes/")
    (synopsis "Archetypes for Targets")
    (description
      "Function-oriented Make-like declarative workflows for Statistics and data science are supported in the 'targets' R package.  As an extension to 'targets', the 'tarchetypes' package provides convenient user-side functions to make 'targets' easier to use.  By establishing reusable archetypes for common kinds of targets and pipelines, these functions help express complicated reproducible workflows concisely and compactly.  The methods in this package were influenced by the 'drake' R package by Will Landau (2018) <doi:10.21105/joss.00550>.")
    (license expat)))

(define-public r-targets
  (package
    (name "r-targets")
    (version "0.4.2")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "targets" version))
        (sha256
          (base32
            "0vrdgikgxhm0gvcrs4qvlp3n63jvkkg54jhsjaqnyyimdhv15wm4"))))
    (properties `((upstream-name . "targets")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-callr" ,r-callr)
        ("r-cli" ,r-cli)
        ("r-codetools" ,r-codetools)
        ("r-data-table" ,r-data-table)
        ("r-digest" ,r-digest)
        ("r-igraph" ,r-igraph)
        ("r-r6" ,r-r6)
        ("r-rlang" ,r-rlang)
        ("r-tibble" ,r-tibble)
        ("r-tidyselect" ,r-tidyselect)
        ("r-vctrs" ,r-vctrs)
        ("r-withr" ,r-withr)
        ("r-yaml" ,r-yaml)))
    (native-inputs `(("r-knitr" ,r-knitr)))
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

(define-public r-visnetwork
  (package
    (name "r-visnetwork")
    (version "2.0.9")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "visNetwork" version))
        (sha256
          (base32
            "0854r9znpjd9iy6j5bgrn20vj13dhp606gs3b6iy0rhym71ks2sy"))))
    (properties `((upstream-name . "visNetwork")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-htmltools" ,r-htmltools)
        ("r-htmlwidgets" ,r-htmlwidgets)
        ("r-jsonlite" ,r-jsonlite)
        ("r-magrittr" ,r-magrittr)))
    (native-inputs `(("r-knitr" ,r-knitr)))
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
    (version "1.6.2")
    (source
      (origin
        (method url-fetch)
        (uri (cran-uri "workflowr" version))
        (sha256
          (base32
            "0m3aq9xxbk4xmqsb59xil56610hgw53gm80z28mq594mhfdh0g3l"))))
    (properties `((upstream-name . "workflowr")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-callr" ,r-callr)
        ("r-fs" ,r-fs)
        ("r-getpass" ,r-getpass)
        ("r-git2r" ,r-git2r)
        ("r-glue" ,r-glue)
        ("r-httpuv" ,r-httpuv)
        ("r-httr" ,r-httr)
        ("r-knitr" ,r-knitr)
        ("r-rmarkdown" ,r-rmarkdown)
        ("r-rprojroot" ,r-rprojroot)
        ("r-rstudioapi" ,r-rstudioapi)
        ("r-stringr" ,r-stringr)
        ("r-whisker" ,r-whisker)
        ("r-xfun" ,r-xfun)
        ("r-yaml" ,r-yaml)))
    (native-inputs `(("r-knitr" ,r-knitr)))
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
  (let ((commit "0d3dccf"))
  (package
    (name "r-ameld")
    (version (string-append "0.0.7-" commit))
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/ampel-leipzig/ameld")
               (commit commit)))
        (file-name (string-append name version))
        (sha256
          (base32
            "01h8cq7xlfz6csf0adk3sn4d7dxp8hx4w1ljmvflii8gh5zilig7"))))
    (properties `((upstream-name . "ameld")))
    (build-system r-build-system)
    (propagated-inputs
      `(("r-survival" ,r-survival)))
    (native-inputs `(("r-knitr" ,r-knitr)))
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
    (native-inputs `(("r-knitr" ,r-knitr)))
    (home-page
      "https://cran.r-project.org/package=zlog")
    (synopsis
      "Z(log) Transformation for Laboratory Measurements")
    (description
      "Transformation of laboratory measurements into z or z(log)-value based on
      given or empirical reference limits as proposed in Hoffmann et al.
      2017 <doi:10.1515/labmed-2016-0087>.")
    (license gpl3+))))
