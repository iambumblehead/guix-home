(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu packages)
             (gnu services)
             (guix gexp))

(primitive-load "guix.common.scm")

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
        "swayidle"
        "python"
        "i3-autotiling"
        "mutt"
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

(define %xdg-config-files
  `(("config/foot.ini" . "foot/foot.ini")
    ("config/muttrc" . "mutt/muttrc")
    ("config/mutt.colors.muttrc" . "mutt/mutt.colors.muttrc")
    ("config/mutt.layout.muttrc" . "mutt/mutt.layout.muttrc")
    ("config/mutt.mailcap" . "mutt/mutt.mailcap")
    ("config/waybar.config" . "waybar/config")
    ("config/waybar.css" . "waybar/style.css")

    ("git.sendemail.config" . "git/git.sendemail.config")
    ("guix.channels.scm" . "guix/channels.scm")
    ("config/git.config" . "git/config")
    ("config/fcitx5-config.conf" . "fcitx5/config")
    ("config/fcitx5-profile.conf" . "fcitx5/profile")
    ("config/pipewire.conf" . "pipewire/pipewire.conf")
    ("config/wireplumber.conf" . "wireplumber/wireplumber.conf")
    ("config/wireplumber.disable-logind.lua" .
     "wireplumber/bluetooth.lua.d/80-disable-logind.lua")
    ("config/wireplumber.disable-dbus.lua" .
     "wireplumber/main.lua.d/80-disable-dbus.lua")
    ("config/swaynag.config" . "swaynag/config")
    ("config/sway.config" . "sway/config")
    ("config/sway.inactive-windows-transparent.py" .
     "sway/inactive-windows-transparent.py")
    ("config/qutebrowser.theme.gruvbox.dark.py" .
     "qutebrowser/qutebrowser.theme.gruvbox.dark.py")
    ("config/qutebrowser.theme.city-lights.py" .
     "qutebrowser/qutebrowser.theme.city-lights.py")
    ("config/qutebrowser.config.py" . "qutebrowser/config.py")
    ("config/zathurarc" . "zathura/zathurarc")
    ("config/ranger.rc.conf" . "ranger/rc.conf")
    ("config/ranger.scope.sh" . "ranger/scope.sh")

    ("config/emacs.el" . "emacs/init.el")
    ("config/emacs-erc.el" . "emacs/emacs-erc.el")
    ("config/emacs-nox.el" . "emacs/emacs-nox.el")
    ("config/emacs-font.el" . "emacs/emacs-font.el")
    ("config/emacs-clipboard.el" . "emacs/emacs-clipboard.el")
    ("config/emacs-colorize-buffer.el" . "emacs/emacs-colorize-buffer.el")))

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
                 (map normalize-config %xdg-config-files))
        (service home-files-service-type
                 (map normalize-config
                      `(("config/icon.theme" . ".icons/default/index.theme"))))
        (service home-bash-service-type
                 (home-bash-configuration
                  (guix-defaults? #f)
                  (aliases '(("grep" . "grep --color=auto")
                             ("ll" . "ls -l")
                             ("ls" . "ls -p --color=auto")
                             ("gud" . "guix system delete-generations")
                             ("gup" . "guix pull && guix upgrade")
                             ("ghr" . "guix home reconfigure")
                             ("gsr" . "sudo guix system reconfigure")
                             ("zathura" . "zathura --plugins-dir=$HOME/.guix-home/profile/lib/zathura")))
                  (bashrc
                   (list (config-file "config/sh.bashrc.sh")))
                  (bash-profile
                   (list (config-file "config/sh.bash_profile.sh"))))))))
