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
