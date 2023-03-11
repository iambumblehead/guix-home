(define-module (fonts-thai)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages fontutils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system font))

;;; guix package --install-from-file=guix.pkg.fonts-thai-lwg.scm
(define-public fonts-tlwg
 (package
   (name "fonts-tlwg")
   (version "0.7.3")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/tlwg/" name
           "/releases/download/v" version "/" name "-" version ".tar.xz"))
     (sha256
      (base32
       "00mv8rmjpsk8jbbl978q3yrc2pxj8a86a3d092563dlc9n8gykkf"))))
   (native-inputs (list fontforge))
   (build-system gnu-build-system)
   ;; (build-system font-build-system)
   (home-page "https://github.com/tlwg/fonts-tlwg/")
   (synopsis "Collection of scalable Thai fonts")
   (description "Fonts-TLWG is a collection of Thai scalable fonts available under free
licenses.  Its goal is to provide fonts that conform to existing standards
and recommendations, so that it can be a reference implementation.")
   (license license:gpl2)))

fonts-tlwg
