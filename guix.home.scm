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
  `(("foot.ini" . "foot/foot.ini")
    ("muttrc" . "mutt/muttrc")
    ("mutt.colors.muttrc" . "mutt/mutt.colors.muttrc")
    ("mutt.layout.muttrc" . "mutt/mutt.layout.muttrc")
    ("mutt.mailcap" . "mutt/mutt.mailcap")
    ("waybar.config" . "waybar/config")
    ("waybar.css" . "waybar/style.css")))

(define %dotfiles
  `(("git.config" . ".config/git/config")
    ("git.sendemail.config" . ".config/git/git.sendemail.config")
    ("guix.channels.scm" . ".config/guix/channels.scm")
    ("fcitx5-config.conf" . ".config/fcitx5/config")
    ("fcitx5-profile.conf" . ".config/fcitx5/profile")
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
    ("ranger.rc.conf" . ".config/ranger/rc.conf")
    ("ranger.scope.sh" . ".config/ranger/scope.sh")

    ("emacs.el" . ".emacs.d/init.el")
    ("emacs-erc.el" . ".emacs.d/emacs-erc.el")
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
                          ("GTK_IM_MODULE" . "fcitx")
                          ("QT_IM_MODULE" . "fcitx")
                          ("XMODIFIERS" . "@im=fcitx")
                          ("QT_QPA_PLATFORM" . "wayland")
                          ("QT_SCALE_FACTOR" . "1")
                          ("XDG_RUNTIME_DIR" . "/run/user/1000/")
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
