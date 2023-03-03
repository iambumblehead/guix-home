(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu packages)
             (gnu packages qt)
             (gnu packages fonts)
             (gnu services)
             (guix gexp))

(define wireplumber-sans-elogind
  (load "guix.package.wireplumber-sans-elogind.scm"))

(define anki
  (load "guix.package.anki-bin.scm"))

(primitive-load "guix.common.scm")

(define %xdg-config-files
  `(("foot.ini" . "foot/foot.ini")
    ("muttrc" . "mutt/muttrc")
    ("mutt.colors.muttrc" . "mutt/mutt.colors.muttrc")
    ("mutt.layout.muttrc" . "mutt/mutt.layout.muttrc")
    ("mutt.mailcap" . "mutt/mutt.mailcap")
    ("waybar.config" . "waybar/config")
    ("waybar.css" . "waybar/style.css")))

(define %dotfiles
  `(("git.config" . ".git/gitconfig")
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
    ("icon.theme" . ".icons/default/index.theme")))

(home-environment
 (packages (specifications->packages (list "git"
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
                                           "qtwayland@5.15.5"
                                           "qutebrowser"
                                           "waybar"
                                           "pipewire"
                                           "wl-clipboard"
                                           ;;; "qview"
                                           ;;; "nheko"
                                           ;;; "wireplumber"
                                           "swayidle"
                                           ;;;"python"
                                           ;;;"python-i3ipc"
                                           "mutt"
                                           "wlsunset"
                                           "grimshot"
                                           "pamixer"
                                           "light"
                                           "bemenu"
                                           "mpv"
                                           "wob"
                                           "yt-dlp"
                                           "foot"
                                           "w3m"
                                           "zstd")))

  (services
   (list (simple-service 'env-vars home-environment-variables-service-type
                         '(("EDITOR" . "emacs")
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
                              ("gup" . "guix pull && guix upgrade")
                              ("gud" . "guix package --delete-generations")
                              ("ghr" . "guix home reconfigure")
                              ("gsr" . "sudo guix system reconfigure")))
                   (bashrc
                    (list (config-file "bashrc")))
                   (bash-profile
                    (list (config-file "bash_profile"))))))))
