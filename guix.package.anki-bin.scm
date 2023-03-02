(define-module (anki)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download))

(package
 (name "anki")
 (version "2.1.60")
 (home-page "https://apps.ankiweb.net/")
 (synopsis "Powerful, intelligent flash cards")
 (description "Anki is a program which makes remembering ...")
 (license license:agpl3+)
 (source
  (local-file "/home/bumble/software/anki" "anki" #:recursive? #t))
 ;;
 ;; (source (local-dir "/home/bumble/software/anki/anki"))
 ;;
 ;; source expects tar.gz and tar.zst from github results in error
 ;;
 ;; (source
 ;;  (origin
 ;;   (method url-fetch)
 ;;   (uri (string-append
 ;;         "https://github.com/ankitects/anki/releases/download/"
 ;;         version "/anki-" version "-linux-qt6.tar.zst"))
 ;;   (sha256
 ;;    (base32 "0dfdcxjjppc96sf5syhnpgdd1825xlynfphvn7d18r0sqxa0hy11"))))
 (supported-systems '("x86_64-linux"))
 (build-system binary-build-system)
 (arguments
  `(#:patchelf-plan
    `(("anki" ("libc" "gcc:lib")))
    #:install-plan
    `(("anki" "bin/")
      ("lib" "bin/lib"))
    #:phases
    (modify-phases %standard-phases
                   (add-after 'unpack 'chmod-to-allow-patchelf
                              (lambda _
                                (chmod "anki" #o755)))
                   )))
 (inputs
  `(("gcc:lib" ,gcc "lib"))))
