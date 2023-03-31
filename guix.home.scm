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
        "ncurses"
        "adwaita-icon-theme"
        "glib:bin"
        "gsettings-desktop-schemas"
        "font-google-noto"
        "font-google-noto-sans-cjk"
        "font-google-noto-serif-cjk"
        "font-liberation"
        "font-sarasa-gothic"
        "font-jetbrains-mono"
        "qtwayland@5.15.5"
        "qutebrowser"
        "waybar"
        "pipewire"
        "wl-clipboard"
        "swayidle"
        "python"
        "i3-autotiling"
        "mutt"
        "imv"
        "cfm"
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
        "w3m"
        "gnupg"
        "zathura"
        "zathura-pdf-mupdf"
        "unzip"
        "pinentry-tty"
        "zstd"))

(define %packages-emacs
  (list "emacs-next-pgtk"
        "emacs-doom-themes"
        "emacs-dash"
        "emacs-web-mode"
        "emacs-js2-mode"
        "emacs-json-mode"
        "emacs-flycheck"
        "emacs-tempel"
        "emacs-eglot-tempel"
        "emacs-magit"
        "emacs-geiser"
        "emacs-geiser-guile"
        "emacs-markdown-mode"
        "emacs-pinentry"
        "emacs-smartparens"
        "emacs-use-package"))

(define %xdg-config-files
  `(("foot.ini" . "foot/foot.ini")
    ("muttrc" . "mutt/muttrc")
    ("mutt.colors.muttrc" . "mutt/mutt.colors.muttrc")
    ("mutt.layout.muttrc" . "mutt/mutt.layout.muttrc")
    ("mutt.mailcap" . "mutt/mutt.mailcap")
    ("waybar.config" . "waybar/config")
    ("waybar.css" . "waybar/style.css")))

(define %dotfiles
  `(("git.config" . ".config/git/config")
    ("guix.channels.scm" . ".config/guix/channels.scm")
    ("pipewire.conf" . ".config/pipewire/pipewire.conf")
    ("wireplumber.conf" . ".config/wireplumber/wireplumber.conf")
    ("wireplumber.disable-logind.lua" .
     ".config/wireplumber/bluetooth.lua.d/80-disable-logind.lua")
    ("wireplumber.disable-dbus.lua" .
     ".config/wireplumber/main.lua.d/80-disable-dbus.lua")
    ("sway.config" . ".config/sway/config")
    ("sway.inactive-windows-transparent.py" .
     ".config/sway/inactive-windows-transparent.py")
    ("qutebrowser.theme.gruvbox.dark.py" .
     ".config/qutebrowser/qutebrowser.theme.gruvbox.dark.py")
    ("qutebrowser.theme.city-lights.py" .
     ".config/qutebrowser/qutebrowser.theme.city-lights.py")
    ("qutebrowser.config.py" . ".config/qutebrowser/config.py")
    ("icon.theme" . ".icons/default/index.theme")
    ("zathurarc" . ".config/zathura/zathurarc")

    ("emacs.el" . ".emacs.d/init.el")
    ("emacs-nox.el" . ".emacs.d/emacs-nox.el")
    ("emacs-font.el" . ".emacs.d/emacs-font.el")
    ("emacs-clipboard.el" . ".emacs.d/emacs-clipboard.el")
    ("emacs-colorize-buffer.el" . ".emacs.d/emacs-colorize-buffer.el")))

(home-environment
 (packages (specifications->packages
            (append %packages
                    %packages-emacs)))
 (services
  (list (simple-service 'env-vars home-environment-variables-service-type
                        '(("EDITOR" . "emacs")
                          ("OPENER" . "sh.opener.sh")
                          ("BROWSER" . "qutebrowser")
                          ("QT_QPA_PLATFORM" . "wayland")
                          ("QT_SCALE_FACTOR" . "1")
                          ("XDG_SESSION_TYPE" . "wayland")
                          ("XDG_SESSION_DESKTOP" . "sway")
                          ("XDG_CURRENT_DESKTOP" . "sway")
                          ("DESKTOP_SESSION" . "sway")
                          ("LIBSEAT_BACKEND" . "seatd")))
        (service home-xdg-configuration-files-service-type
                 (map normalize-config %xdg-config-files))
        (service home-files-service-type
                 (map normalize-config %dotfiles))
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
                   (list (config-file "sh.bashrc.sh")))
                  (bash-profile
                   (list (config-file "sh.bash_profile.sh"))))))))
