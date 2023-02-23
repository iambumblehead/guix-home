(define-module (anki)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages))

;;; how to run a dynamically compiled ... stackexchange
(package
 (name "anki")
 (version "2.1.58")
 (home-page "https://apps.ankiweb.net/")
 (synopsis "Powerful, intelligent flash cards")
 (description "Anki is a program which makes remembering ...")
 (license license:agpl3+)
 (source (local-file "/home/bumble/software/anki/anki"))
 (supported-systems '("x86_64-linux"))
 (build-system binary-build-system)
 (arguments
  `(#:patchelf-plan
    `(("anki" ("libc" "gcc:lib")))
    #:install-plan
    `(("anki" "bin/"))
    #:phases
    (modify-phases %standard-phases
                   (add-after 'unpack 'chmod-to-allow-patchelf
                              (lambda _
                                (chmod "anki" #o755)))
                   ;;;(add-after 'install 'make-wrapper
                   ;;;           (lambda* (#:key inputs outputs #:allow-other-keys)
                   ;;;                    (let* ((out (assoc-ref outputs "out"))
                   ;;;                           (wrapper (string-append out "/bin/beglitched"))
                   ;;;                           (binary (string-append out "/share/beglitched/" ,binary)))
                   ;;;                      (make-wrapper
                   ;;;                       wrapper binary
                   ;;;                       `("PATH" ":" prefix
                   ;;;                         (,(string-append (assoc-ref inputs "pulseaudio") "/bin")))))
                   ;;;                    #t))
                   )))
 (inputs
  `(("gcc:lib" ,gcc "lib"))))
;;; note how the first string must match the one in
;;; patchelf-plan. libc is already implicitely defined
;;;
;;; guix build -s x86_64-linux -f my-package.scm
