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

(define-public r-zlog
(package
  (name "r-zlog")
  (version "1.0.0")
  (source
    (origin
      (method url-fetch)
      (uri (cran-uri "zlog" version))
      (sha256
        (base32
          "1d5j31p0h3rrn230087h3ngpvwknlisjv0f1qdbicdj9m177spci"))))
  (properties `((upstream-name . "zlog")))
  (build-system r-build-system)
  (native-inputs `(("r-knitr" ,r-knitr)))
  (home-page
    "https://cran.r-project.org/package=zlog")
  (synopsis
    "Z(log) Transformation for Laboratory Measurements")
  (description
    "Transformation of laboratory measurements into z or z(log)-value based on given or empirical reference limits as proposed in Hoffmann et al.  2017 <doi:10.1515/labmed-2016-0087>.")
  (license gpl3+))
)
