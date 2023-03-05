;; This is an operating system configuration template
;; for a "bare bones" setup, w/ no display server.

(use-modules (gnu)
             (gnu home)
             (gnu packages wm)
             (gnu packages ssh)
             (gnu packages cups)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages emacs)
             (gnu packages linux)
             (gnu packages xdisorg)
             (gnu packages terminals)
             (gnu services)
             (gnu services ssh)
             (gnu services cups)
             (gnu services desktop)
             (gnu services networking)
             (gnu system setuid)
             (gnu system locale)
             (guix packages)
             (guix download)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(define (make-file path)
  (local-file
   (string-append (dirname (current-filename)) "/" path)))

(define %privileged-programs
  (list (file-append swaylock-effects "/bin/swaylock")
        ;; (file-append shepherd "/sbin/halt")
        ;; (file-append shepherd "/sbin/reboot")
        ))

(define (nonguixsub-service-create config)
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
           %default-authorized-guix-keys))))

(define %services
  (cons* (service cups-service-type
                  (cups-configuration
                   (web-interface? #t)
                   (extensions
                    (list cups-filters hplip))))
         (udev-rules-service 'light light
                             #:groups '("light"))
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
         (service upower-service-type
                  (upower-configuration
                   (use-percentage-for-policy? #t)
                   (percentage-low 12)
                   (percentage-critical 8)
                   (percentage-action 5)
                   (critical-power-action 'power-off)))
         (service dhcp-client-service-type)
         (service seatd-service-type)
         (service wpa-supplicant-service-type
                  (wpa-supplicant-configuration
                   (interface "wlp2s0")
                   (config-file (make-file "wpa_supplicant.conf"))))
         (service openssh-service-type
                  (openssh-configuration
                   (openssh openssh-sans-x)
                   (port-number 2222)))
         (modify-services %base-services
                          (delete agetty-service-type)
                          (delete mingetty-service-type)
                          (guix-service-type
                           config =>
                           (nonguixsub-service-create config)))))

(operating-system
  (host-name "guix-xps")
  (timezone "America/Los_Angeles")
  (locale "ja_JP.utf8")
  (locale-definitions
   (append
    (list (locale-definition (source "ja_JP")
                             (name   "ja_JP.utf8"))
          (locale-definition (source "en_US")
                             (name   "en_US.utf8")))
    %default-locale-definitions))
  (keyboard-layout (keyboard-layout "us" #:options '("ctrl:nocaps")))
  (kernel linux)
  (initrd microcode-initrd)
  (firmware
   (append (list iwlwifi-firmware)
           %base-firmware))
  (initrd-modules (cons "i915" %base-initrd-modules))

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets (list "/boot/efi"))
               (keyboard-layout keyboard-layout)
               (theme (grub-theme
                       (inherit (grub-theme))
                       (gfxmode '("auto"))
                       (image (make-file "guix-checkered-16-10.svg"))))))
  (swap-devices
   (list
    (swap-space (target (file-system-label "my-swap")))))
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
  (users (cons (user-account
                (name "bumble")
                (comment "honey worker")
                (group "users")
                (supplementary-groups
                 (list "wheel" "netdev" "seat"
                       "audio" "video" "light")))
               %base-user-accounts))
  (packages (append (list emacs
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
  (services %services))
