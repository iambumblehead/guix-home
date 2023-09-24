(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu packages)
             (gnu services)
             (guix gexp))

(primitive-load "guix.home-alist.scm")

(define %packages
  (list "git"
        ;; https://www.mail-archive.com/help-guix@gnu.org/msg09871.html
        ;; https://github.com/guix-mirror/guix/blob/master/gnu/packages.scm
        ;; hoping specifications->packages will be fixed to handle this
        ;; again in future, for now: `guix install -i git:send-email`
        "git:send-email"
        "curl"
        "bemenu"
        "btop"
        "ncurses"
        "adwaita-icon-theme"
        "glib:bin"
        "gsettings-desktop-schemas"
        "irssi"
        "fcitx5"
        "fcitx5-anthy"
        "fcitx5-gtk"
        "fcitx5-qt"
        "fcitx5-material-color-theme"
        "fonts-tlwg"
        "font-google-noto"
        "font-google-noto-emoji"
        "font-google-noto-sans-cjk"
        "font-google-noto-serif-cjk"
        "font-liberation"
        "font-sarasa-gothic"
        "font-jetbrains-mono"
        "qtwayland@5.15"
        "qutebrowser"
        "waybar"
        "pipewire"
        "wl-clipboard"
        "guile"
        "guile-ncurses"
        "guile-readline"
        "guile-colorized"
        "swayidle"
        "python"
        "i3-autotiling"
        "mutt"
        "w3m"
        "imv"
        "wlsunset"
        "grimshot"
        "pamixer"
        "imagemagick"
        "light"
        "bemenu"
        "mpv"
        "wob"
        "password-store"
        "yt-dlp"
        "foot"
        "gnupg"
        "ranger"
        "highlight"
        "zathura"
        "zathura-pdf-mupdf"
        "bash-completion"
        "unzip"
        "wireplumber"
        "pinentry-tty"
        "zstd"))

(define %packages-emacs
  (list "emacs-next-pgtk"
        "emacs-doom-themes"
        "emacs-dash"
        "emacs-debbugs"
        "emacs-rainbow-delimiters"
        "emacs-markdown-mode"
        "emacs-web-mode"
        "emacs-js2-mode"
        "emacs-json-mode"
        "emacs-flycheck"
        "emacs-circe"
        "emacs-tempel"
        "emacs-tempel-collection"
        "emacs-corfu"
        "emacs-corfu-terminal"
        "emacs-eglot-tempel"
        "emacs-magit"
        "emacs-geiser"
        "emacs-geiser-guile"
        "emacs-markdown-mode"
        "emacs-pinentry"
        "emacs-smartparens"
        "emacs-use-package"))

(home-environment
 (packages (specifications->packages
            (append %packages
                    %packages-emacs)))
 (services
  (list (simple-service 'env-vars home-environment-variables-service-type
                        '(("EDITOR" . "emacs")
                          ("OPENER" . "sh.opener.sh")
                          ("BROWSER" . "qutebrowser")
                          ("GTK_IM_MODULE" . "fcitx")
                          ("QT_IM_MODULE" . "fcitx")
                          ("XMODIFIERS" . "@im=fcitx")
                          ("QT_QPA_PLATFORM" . "wayland")
                          ("QT_SCALE_FACTOR" . "1")
                          ("XDG_SESSION_TYPE" . "wayland")
                          ("XDG_SESSION_DESKTOP" . "sway")
                          ("XDG_CURRENT_DESKTOP" . "sway")
                          ("DESKTOP_SESSION" . "sway")
                          ("LIBSEAT_BACKEND" . "seatd")))
        (service home-inputrc-service-type
                 (home-inputrc-configuration
                  (variables `(("show-all-if-unmodified" . #t)
                               ("colored-stats" . #t)
                               ("visible-stats" . #t)
                               ("mark-symlinked-directories" . #t)
                               ("colored-completion-prefix" . #t)
                               ("colored-stats" . #t)
                               ("menu-complete-display-prefix" . #t)))))
        (service home-xdg-configuration-files-service-type
                 (home-alists-create-from-dirs
                  (list "config/emacs"
                        "config/fcitx5"
                        "config/pipewire"
                        "config/ranger"
                        "config/waybar"
                        "config/wireplumber"
                        "config/zathura"
                        "config/guix"
                        "config/foot"
                        "config/git"
                        "config/sway"
                        "config/swaynag"
                        "config/qutebrowser"
                        "config/mutt")))
        (service home-files-service-type
                 (list (list ".icons/default/index.theme"
                             (plain-file "gtk-waybar-needs"
                                         (string-append
                                          "[Icon Theme]" "\n"
                                          "Name=Default" "\n"
                                          "Inherits=Adwaita")))
                       (list ".guile"
                             (plain-file "guile-config"
                                         (string-append
                                          "(use-modules"
                                          " (ice-9 readline)"
                                          " (ice-9 colorized))"
                                          "(activate-readline)"
                                          "(activate-colorized)")))))
        (service home-bash-service-type
                 (home-bash-configuration
                  (guix-defaults? #f)
                  (aliases '(("grep" . "grep --color=auto")
                             ("ll" . "ls -l")
                             ("ls" . "ls -p --color=auto")
                             ("gap" . "swaymsg gaps outer 10")
                             ("gud" . "guix system delete-generations")
                             ("gup" . "guix pull && guix upgrade")
                             ("ghr" . "guix home reconfigure")
                             ("gsr" . "sudo guix system reconfigure")))
                  (bashrc
                   (list (local-file "./config/sh.bashrc.sh"
                                     #:recursive? #t)))
                  (bash-profile
                   (list (local-file "./config/sh.bash_profile.sh"
                                     #:recursive? #t))))))))
