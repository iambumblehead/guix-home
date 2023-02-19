(define-module (wireplumber-sans-elogind)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu packages linux)
  #:use-module (guix packages))

(define-public wireplumber-sans-elogind
  (package
   (inherit wireplumber)
   (inputs (modify-inputs (package-inputs wireplumber)
                          (delete "elogind")))))

wireplumber-sans-elogind
