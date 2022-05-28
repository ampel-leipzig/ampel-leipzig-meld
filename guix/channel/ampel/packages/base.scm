(define-module (ampel packages base)
  #:use-module (gnu packages base))

(define-public glibc-english-utf8-locales
  (make-glibc-utf8-locales
   glibc
   #:locales (list "en_US")
   #:name "glibc-english-utf8-locales"))
