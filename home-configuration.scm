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

;;(define %waybar-config
;;  (computed-file "waybar.json"
;;    #~(begin
;;       (use-modules (ice-9 format)
;;                    (ice-9 rdelim)
;;                    (ice-9 textual-ports)
;;                    (language tree-il))
;;       (primitive-load #$(config-file "common.scm"))
;;       (call-with-input-file #$(config-file "waybar.json")
;;         (lambda (in)
;;           (call-with-output-file #$output
;;             (lambda (out)
;;               (do ((line "" (read-line in)))
;;                   ((eof-object? line))
;;                 (when (not (string-prefix? "//" line))
;;                   (format out "~a~%" line))))))))))

;;(define %config-files
;;  `("guix/channels.scm"
;;    ;; ("sway.conf" . "sway/config")
;;    (,%waybar-config . "waybar/config")
;;    ("waybar.css" . "waybar/style.css")))

(define %dotfiles
  `((".config/waybar/waybar"
     ,(make-file
       "waybar/.config/waybar/waybar"
       "waybar-config"))
    (".config/waybar/waybar.css"
     ,(make-file
       "waybar/.config/waybar/waybar.css"
       "waybarcss-config"))
    (".config/qutebrowser/config.py"
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
			   ("TERM" . "xterm")
			   ("QT_QPA_PLATFORM" . "WAYLAND")
			   ("QT_SCALE_FACTOR" . "1")))
	 (simple-service 'dotfiles-installation home-files-service-type
			 %dotfiles)
         ;;(service home-xdg-configuration-files-service-type
         ;;         (map normalize-config %config-files))
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
