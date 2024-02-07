(define-module (yambar-wayland)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system meson)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages web)
  #:use-module (gnu packages mpd)
  #:use-module (gnu packages man))

; gnu: Add yambar-wayland.
;;; guix package --install-from-file=guix.pkg.yambar.scm
(define-public yambar-wayland
 (package
   (name "yambar-wayland")
   (version "1.10.0")
   (home-page "https://codeberg.org/dnkl/yambar")
   (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "14lxhgyyia7sxyqjwa9skps0j9qlpqi8y7hvbsaidrwmy4857czr"))))
   (build-system meson-build-system)
   (arguments
    (list
      #:build-type "release"
      #:configure-flags #~'("-Db_lto=true"
                            "-Dbackend-x11=disabled"
                            "-Dbackend-wayland=enabled")))
    (native-inputs (list pkg-config tllist scdoc wayland-protocols flex bison))
    (inputs (list
             fcft
             wayland
             pipewire
             libyaml
             pixman
             alsa-lib
             json-c
             libmpdclient
             eudev))
    (synopsis "X11 and Wayland status panel")
    (description
     "@command{yambar} is a lightweight and configurable status
 panel (bar, for short) for X11 and Wayland, that goes to great
 lengths to be both CPU and battery efficient - polling is only
 done when absolutely necessary.")
    (license license:expat)))

yambar-wayland
