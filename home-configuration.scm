;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
	     (gnu home services)
             (gnu packages)
	     (gnu packages qt)
	     (gnu packages fonts)
             (gnu services)
             (guix gexp)
             (gnu home services shells))

(define (make-file path name)
  (local-file
   (string-append (getenv "HOME") "/software/guix-home/" path)
   name
   #:recursive? #t))


(define %xdg-config-files
  `(("waybar/config"
     ,(make-file
       "waybar/.config/waybar/waybar"
       "waybar-config"))
    ("waybar/style.css"
     ,(make-file
       "waybar/.config/waybar/waybar.css"
       "waybarcss-config"))))  

(define %dotfiles
  `((".config/qutebrowser/config.py"
     ,(make-file
       "qutebrowser/.config/qutebrowser/config.py"
       "qutebrowser-config"))))

(home-environment
 ;; Below is the list of packages that will show up in your
 ;; Home profile, under ~/.guix-home/profile.
 (packages (specifications->packages (list "git"
                                           "curl"
                                           "ncurses"
					   "font-awesome"
					   "font-google-noto"
					   "font-google-noto-sans-cjk"
					   "font-google-noto-serif-cjk"
					   "font-liberation"
					   "font-sarasa-gothic"
					   "qtwayland@5.15.5"
					   "qutebrowser"
                                           "waybar"
                                           "wireplumber")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
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
                  %xdg-config-files)
	 (simple-service 'dotfiles-installation home-files-service-type
			 %dotfiles)
	 (service home-bash-service-type
                  (home-bash-configuration
		   (guix-defaults? #f)
		   ;(environment-variables
		   ; '(("XDG_RUNTIME_DIR" . "/tmp/")))
                   (aliases '(("grep" . "grep --color=auto") ("ll" . "ls -l")
                              ("ls" . "ls -p --color=auto")))
                   (bashrc (list (local-file
                                  "/home/bumble/src/guix-config/.bashrc"
                                  "bashrc")))
                   (bash-profile (list (local-file
                                        "/home/bumble/src/guix-config/.bash_profile"
                                        "bash_profile"))))))))
