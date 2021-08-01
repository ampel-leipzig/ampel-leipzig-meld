(define-module (ampel packages haskell)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system haskell)
  #:use-module (gnu packages)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-xyz))

(define-public ghc-open-browser
  (package
    (name "ghc-open-browser")
    (version "0.2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (string-append
               "https://hackage.haskell.org/package/open-browser/open-browser-"
               version
               ".tar.gz"))
        (sha256
          (base32
            "0rna8ir2cfp8gk0rd2q60an51jxc08lx4gl0liw8wwqgh1ijxv8b"))))
    (build-system haskell-build-system)
    (home-page
      "https://github.com/rightfold/open-browser")
    (synopsis "Open a web browser from Haskell.")
    (description
      "Open a web browser from Haskell. Currently BSD, Linux, OS X and Windows are supported.")
    (license license:bsd-3)))

(define-public ghc-roman-numerals
  (package
    (name "ghc-roman-numerals")
    (version "0.5.1.5")
    (source
      (origin
        (method url-fetch)
        (uri (string-append
               "https://hackage.haskell.org/package/roman-numerals/roman-numerals-"
               version
               ".tar.gz"))
        (sha256
          (base32
            "10da5vls9l5i255bapms4b2r7dnwmxgsaa1cdll2lrmid5dikixr"))))
    (build-system haskell-build-system)
    (inputs
      `(("ghc-base-unicode-symbols"
         ,ghc-base-unicode-symbols)))
    (home-page
      "https://github.com/roelvandijk/roman-numerals")
    (synopsis
      "Parsing and pretty printing of Roman numerals")
    (description
      "This library provides functions for parsing and pretty printing Roman numerals. Because the notation of Roman numerals has varied through the centuries this package allows for some customisation using a configuration that is passed to the conversion functions.")
    (license license:bsd-3)))

(define-public ghc-data-accessor-template
  (package
    (name "ghc-data-accessor-template")
    (version "0.2.1.16")
    (source
      (origin
        (method url-fetch)
        (uri (string-append
               "https://hackage.haskell.org/package/data-accessor-template/data-accessor-template-"
               version
               ".tar.gz"))
        (sha256
          (base32
            "15gd6xlrq5ica514m5rdcz2dl8bibdmbsmnc98ddhx491c9g5rwk"))))
    (build-system haskell-build-system)
    (inputs
      `(("ghc-data-accessor" ,ghc-data-accessor)
        ("ghc-utility-ht" ,ghc-utility-ht)))
    (arguments
      `(#:cabal-revision
        ("1"
         "0zz2v420zvinphs6jnngc40x7h8jn5rqj3nj8alpgfyqx59w41my")))
    (home-page
      "http://www.haskell.org/haskellwiki/Record_access")
    (synopsis
      "Utilities for accessing and manipulating fields of records")
    (description
      "Automate generation of @Accessor@'s of the @data-accessor@ package by Template Haskell functions.")
    (license license:bsd-3)))

(define-public ghc-pandoc-crossref
  (package
    (name "ghc-pandoc-crossref")
    (version "0.3.4.2")
    (source
      (origin
        (method url-fetch)
        (uri (string-append
               "https://hackage.haskell.org/package/pandoc-crossref/pandoc-crossref-"
               version
               ".tar.gz"))
        (sha256
          (base32
            "03bdi57x49rnyi991wzrhqkiz01vv7j9dvc9vwhgfm5x3yhgr0v2"))))
    (build-system haskell-build-system)
    (inputs
      `(("ghc-data-accessor" ,ghc-data-accessor)
        ("ghc-data-accessor-template"
         ,ghc-data-accessor-template)
        ("ghc-data-accessor-transformers"
         ,ghc-data-accessor-transformers)
        ("ghc-data-default" ,ghc-data-default)
        ("ghc-pandoc" ,ghc-pandoc)
        ("ghc-pandoc-types" ,ghc-pandoc-types)
        ("ghc-roman-numerals" ,ghc-roman-numerals)
        ("ghc-syb" ,ghc-syb)
        ("ghc-utility-ht" ,ghc-utility-ht)
        ("ghc-gitrev" ,ghc-gitrev)
        ("ghc-open-browser" ,ghc-open-browser)
        ("ghc-optparse-applicative"
         ,ghc-optparse-applicative)
        ("ghc-temporary" ,ghc-temporary)))
    (native-inputs
      `(("ghc-hspec" ,ghc-hspec)
        ("ghc-hspec" ,ghc-hspec)))
    (home-page
      "https://github.com/lierdakil/pandoc-crossref#readme")
    (synopsis "Pandoc filter for cross-references")
    (description
      "pandoc-crossref is a pandoc filter for numbering figures, equations, tables and cross-references to them.")
    (license license:gpl2)))

