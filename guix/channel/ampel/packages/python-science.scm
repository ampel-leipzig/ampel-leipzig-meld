(define-module (ampel packages python-science)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages python-compression)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz))

(define-public python-torchtuples
  (package
    (name "python-torchtuples")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "torchtuples" version))
        (sha256
          (base32
            "1hzzizb8rc6w5c3vsy6kjjz4kj32pchmh0c1kvyr9dbyjxlzxiz0"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f)) ; no test target
    (propagated-inputs
      `(("python-matplotlib" ,python-matplotlib)
        ("python-numpy" ,python-numpy)
        ("python-pytorch" ,python-pytorch)
        ("python-pandas" ,python-pandas)))
    (home-page
      "https://github.com/havakv/torchtuples")
    (synopsis "Training neural networks in PyTorch")
    (description
      "Training neural networks in PyTorch")
    (license #f)))

(define-public python-pycox
  (package
    (name "python-pycox")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "pycox" version))
        (sha256
          (base32
            "0axby1pb1f9laqb5f8bzycgx7r79j5870k3va1nwk9b8hkbmcjvv"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-feather-format" ,python-feather-format)
        ("python-h5py" ,python-h5py)
        ("python-numba" ,python-numba)
        ("python-py7zr" ,python-py7zr)
        ("python-pytorch" ,python-pytorch)
        ("python-requests" ,python-requests)
        ("python-scikit-learn" ,python-scikit-learn)
        ("python-torchtuples" ,python-torchtuples)))
    (home-page "https://github.com/havakv/pycox")
    (synopsis "Survival analysis with PyTorch")
    (description "Survival analysis with PyTorch")
    (license #f)))
