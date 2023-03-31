(define-module (openersh)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system copy))

;;; guix package --install-from-file=guix.pkg.opener.scm
(define-public openersh
 (package
   (name "openersh")
   (version "0.0.1")
   (source
    (local-file
     (string-append (dirname (current-filename)) "/sh.opener.sh")
     #:recursive? #t))
   (build-system copy-build-system)
   (arguments
    '(#:install-plan
      '(("." "./bin/"))))
   (home-page "https://github.com/dylanaraps/shfm")
   (synopsis "a file opener")
   (description "shell file opener from Dylan Araps")
   (license license:gpl3)))

openersh
