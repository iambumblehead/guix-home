;; This is an operating system configuration template
;; for a "bare bones" setup, w/ no display server.

(use-modules (gnu)
             (gnu home)
             (gnu packages admin)
             (gnu packages wm)
             (gnu packages xdisorg)
             (gnu packages terminals)
             (gnu services)
             (gnu services desktop)
             (gnu system setuid)

             (guix packages)
             (guix download)
             ;;(guixrus packages wayland-xyz)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules cups ssh networking)
(use-package-modules cups ssh bootloaders certs emacs screen)

(define %conf-dir
    (dirname (current-filename)))

(define (make-file path name)
  (local-file
   (string-append %conf-dir "/" path)))
   ;;name
   ;;#:recursive? #t))

(define %privileged-programs
  (list (file-append swaylock-effects "/bin/swaylock")
        (file-append shepherd "/sbin/halt")
        (file-append shepherd "/sbin/reboot")))

(operating-system
  (host-name "guix-xps")
  (timezone "America/Los_Angeles")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us" #:options '("ctrl:nocaps")))
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (initrd-modules (cons "i915" %base-initrd-modules))

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets (list "/boot/efi"))
               (keyboard-layout keyboard-layout)
               ;;(theme (grub-theme
               ;;        (inherit (grub-theme))
               ;;        (gfxmode '("auto"))
               ;;        (image (local-file "/home/bumble/software/guix-home/guix-checkered-16-9.svg"))))
                ))

  (swap-devices
   (list
    (swap-space (target (uuid "5b7826f3-fd1f-4b7d-a12b-9c5cabbf0087")))))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "my-root"))
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device (uuid "2EBD-CDBC" 'fat32))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (cons (user-account
                (name "bumble")
                (comment "honey worker")
                (group "users")
                (supplementary-groups
                 (list "wheel" "netdev" "seat" "audio" "video")))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (append (list screen
                          emacs
                          sway
                          swaylock-effects
                          nss-certs)
                    %base-packages))

  (setuid-programs
   (append (map (lambda (prog)
                  (setuid-program
                   (program prog)))
                %privileged-programs)
           %setuid-programs))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (append (list (service cups-service-type
                                   (cups-configuration
                                    (web-interface? #t)
                                    (extensions
                                     (list cups-filters hplip))))
                          (service greetd-service-type
                                   (greetd-configuration
                                    (greeter-supplementary-groups
                                     (list "video" "input" "seat"))
                                    (terminals
                                     (list
                                      ;; we can make any terminal active by default
                                      (greetd-terminal-configuration
                                       (terminal-vt "1")
                                       (terminal-switch #t))
                                       ;;;(default-session-command
                                       ;;;  (greetd-wlgreet-sway-session
                                       ;;;   (sway sway)
                                       ;;;   (wlgreet-session
                                       ;;;    (greetd-wlgreet-session
                                       ;;;     (command (file-append sway "/bin/sway"))))
                                       ;;;   (sway-configuration
                                       ;;;    (make-file "sway-greetd.conf" "greeter")))))
                                      (greetd-terminal-configuration
                                       (terminal-vt "2"))
                                      (greetd-terminal-configuration
                                       (terminal-vt "3"))
                                      (greetd-terminal-configuration
                                       (terminal-vt "4"))
                                      (greetd-terminal-configuration
                                       (terminal-vt "5"))
                                      (greetd-terminal-configuration
                                       (terminal-vt "6"))
                                      ))))
                          (service mingetty-service-type
                                   (mingetty-configuration (tty "tty8")))
                          fontconfig-file-system-service
                          ;;(service thermald-service-type)

                          ;;;(pam-limits-service ;; Enables wireplumber to enter realtime
                          ;;; (list
                          ;;;  (pam-limits-entry "@realtime" 'both 'rtprio 99)
                          ;;;  (pam-limits-entry "@realtime" 'both 'nice -11)
                          ;;;  (pam-limits-entry "@realtime" 'both 'memlock 256)))
                          (service upower-service-type
                                   (upower-configuration
                                    (use-percentage-for-policy? #t)
                                    (percentage-low 12)
                                    (percentage-critical 8)
                                    (percentage-action 5)
                                    (critical-power-action 'power-off)))
                          (service dhcp-client-service-type)
                          (service seatd-service-type) ;; for sway
                          (service wpa-supplicant-service-type
                                   (wpa-supplicant-configuration
                                    (interface "wlp2s0")
                                    (config-file (make-file "wpa_supplicant.conf" "wpa-supplicant"))))
                          (service openssh-service-type
                                   (openssh-configuration
                                    (openssh openssh-sans-x)
                                    (port-number 2222))))
                    (modify-services %base-services
                                     (delete agetty-service-type)
                                     (delete mingetty-service-type)
                                     (guix-service-type config =>
                                                        (guix-configuration
                                                         (inherit config)
                                                         (substitute-urls
                                                          (cons* "https://nonguix.org"
                                                                 %default-substitute-urls))
                                                         (authorized-keys
                                                          (cons* (origin
                                                                  (method url-fetch)
                                                                  (uri "https://substitutes.nonguix.org/signing-key.pub")
                                                                  (file-name "nonguix.pub")
                                                                  (sha256
                                                                   (base32
                                                                    "0j66nq1bxvbxf5n8q2py14sjbkn57my0mjwq7k1qm9ddghca7177")))
                                                                 %default-authorized-guix-keys))))))))
