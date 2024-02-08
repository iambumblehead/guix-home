(use-modules (gnu home)
             (gnu home services)
             (gnu home services gnupg)
             (gnu home services shells)
             (gnu packages)
             (gnu packages qt)
             (gnu packages gnupg)
             (gnu packages linux)
             (gnu services)
             (guix gexp))

(primitive-load "guix.home-alist.scm")

(define (asoundrc)
  (mixed-text-file
   "asoundrc"
   "<" pipewire "/share/alsa/alsa.conf.d/50-pipewire.conf>\n"
   "<" pipewire "/share/alsa/alsa.conf.d/99-pipewire-default.conf>\n"
   "pcm_type.pipewire {\n"
   "  lib \"" pipewire "/lib/alsa-lib/libasound_module_pcm_pipewire.so\"\n"
   "}\n"
   "ctl_type.pipewire {\n"
   "  lib \"" pipewire "/lib/alsa-lib/libasound_module_ctl_pipewire.so\"\n"
   "}\n"))

(define %packages
  (list "git"
        "git:send-email"
        "curl"
        "bemenu"
        "btop"
        "ncurses"
        "node"
        "adwaita-icon-theme"
        "gsettings-desktop-schemas"
        "weechat"
        "fcitx5"
        "fcitx5-anthy"
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
        "qtwayland"
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
        "vifm" "perl-image-exiftool" "bc"
        "wireplumber-minimal"
        "pinentry-tty"
        "zstd"))

(define %packages-emacs
  (list "emacs-next-pgtk"
        "emacs-doom-themes"
        "emacs-dash"
        "emacs-nerd-icons"
        "emacs-treemacs"
        "emacs-debbugs"
        "emacs-rainbow-delimiters"
        "emacs-markdown-mode"
        "emacs-web-mode"
        "emacs-js2-mode"
        "emacs-json-mode"
        "emacs-flycheck"
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
 (packages (append (map specification->package+output
                        (append %packages
                                %packages-emacs))))

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
        ;; https://issues.guix.gnu.org/68483
        (simple-service 'qtwayland-vars-service
                        home-environment-variables-service-type
                        `(("QT_PLUGIN_PATH" .
                           ,(file-append qtwayland "/lib/qt6/plugins"))
                          ("QT_QPA_PLATFORM_PLUGIN_PATH" .
                           ,(file-append qtwayland "/lib/qt6/plugins/platforms"))))
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
                        "config/yambar"
                        "config/waybar"
                        "config/wireplumber"
                        "config/vifm"
                        "config/zathura"
                        "config/guix"
                        "config/foot"
                        "config/git"
                        "config/sway"
                        "config/swaynag"
                        "config/qutebrowser"
                        "config/mutt")))
        (service home-files-service-type
                 (list (list ".asoundrc" (asoundrc))
                       (list ".icons/default/index.theme"
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
        (service home-gpg-agent-service-type
                 (home-gpg-agent-configuration
                  (pinentry-program
                   (file-append pinentry "/bin/pinentry-curses"))
                  (ssh-support? #t)
                  (default-cache-ttl 3000)
                  (max-cache-ttl 6000)
                  (extra-content (string-append
                                  "allow-loopback-pinentry" "\n"
                                  "allow-emacs-pinentry" "\n"))))
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
