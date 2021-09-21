(define-module (ampel packages parallel)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu packages parallel))

(define-public slurm-21.08
  (package
    (inherit slurm)
    (version "21.08.1")
    (source (origin
      (inherit (package-source slurm))
        (method url-fetch)
        (uri (string-append
          "https://download.schedmd.com/slurm/slurm-" version ".tar.bz2"))
        (sha256
          (base32
            "010ciqmfsv58n96jv49n9jq2k97smsyvjl67i30zaxv40dj8hr2v"))))))
