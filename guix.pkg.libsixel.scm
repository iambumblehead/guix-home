(define-module (libsixel)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system meson)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages image)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages gtk))

;;; guix package --install-from-file=guix.pkg.libsixel.scm
(define-public libsixel
 (package
   (name "libsixel")
   (version "1.10.3")
   (home-page "https://github.com/libsixel/libsixel")
   (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1nny4295ipy4ajcxmmh04c796hcds0y7z7rv3qd17mj70y8j0r2d"))))
   (build-system meson-build-system)
   (arguments
    (list
      #:build-type "release"
      #:configure-flags #~'("--buildtype=plain"
                            "-Dtests=enabled"
                            "-Dlibcurl=enabled"
                            "-Dgdk-pixbuf2=enabled")))
   (native-inputs (list pkg-config))
   (inputs (list
            libjpeg-turbo
            libpng
            python
            curl
            gdk-pixbuf))
    (synopsis "Provides encoder/decoder implementation for DEC SIXEL graphics.")
    (description
     "@command{libpixel} is a an encoder/decoder implementation
 for DEC SIXEL graphics, and some converter programs. SIXEL is
 one of image formats for printer and terminal imaging introduced
 by Digital Equipment Corp. (DEC). Its data scheme is represented
 as a terminal-friendly escape sequence. So if you want to view a
 SIXEL image file, all you have to do is \"cat\" it to your
 terminal.")
    (license license:expat)))

libsixel
