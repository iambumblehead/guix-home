(use-modules (gnu)
             (gnu home)
             (gnu packages wm)
             (gnu packages ssh)
             (gnu packages cups)
             (gnu packages fonts)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages linux)
             (gnu packages xdisorg)
             (gnu packages terminals)
             (gnu services)
             (gnu services xorg)
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

(define (subs-service-create config)
  (guix-configuration
   (inherit config)
   (substitute-urls
    (cons* "https://substitutes.nonguix.org"
           ;;"https://guix.tobias.gr"
           %default-substitute-urls))
   (authorized-keys
    (cons* (origin
            (method url-fetch)
            (uri "https://substitutes.nonguix.org/signing-key.pub")
            (file-name "nonguix.pub")
            (sha256
             (base32
              "0j66nq1bxvbxf5n8q2py14sjbkn57my0mjwq7k1qm9ddghca7177")))
           ;;(origin
           ;; (method url-fetch)
           ;; (uri "https://guix.tobias.gr/signing-key.pub")
           ;; (file-name "tobias.pub")
           ;; (sha256
           ;;  (base32
           ;;   "0m51azgj3xas6f598d5mq9716v57zw745dr8bwn4cki2p8l4inlg")))
           %default-authorized-guix-keys))))

(define %services
  (cons* (service cups-service-type
                  (cups-configuration
                   (web-interface? #t)
                   (default-paper-size "Letter")
                   (extensions
                    (list cups-filters hplip-minimal))))

         ;; https://lists.gnu.org/archive/html/guix-devel/2023-05/msg00278.html
         (simple-service 'cups-pam-service
                         pam-root-service-type
                         (list (unix-pam-service
                                "cups" #:allow-empty-passwords? #f)))

         (udev-rules-service 'light light
                             #:groups '("light"))
         (service
          (service-type
           (name 'screen-locker)
           (extensions
            (list (service-extension pam-root-service-type
                                     (@@ (gnu services xorg) screen-locker-pam-services))))
            (description "-"))
          (screen-locker-configuration
           (name "swaylock")
           (program (file-append swaylock-effects "/bin/swaylock"))
           (using-pam? #t)
           (using-setuid? #f)))

         (service greetd-service-type
                  (greetd-configuration
                   (greeter-supplementary-groups
                    (list "video" "input" "seat"))
                   (terminals
                    (list
                     (greetd-terminal-configuration
                      (terminal-vt "1")
                      (terminal-switch #t)
                      ;; https://issues.guix.gnu.org/65769
                      (default-session-command
                        (greetd-wlgreet-sway-session
                         (sway-configuration
                          (make-file "config/sway/sway-greetd.conf")))))
                     (greetd-terminal-configuration
                      (terminal-vt "2"))
                     (greetd-terminal-configuration
                      (terminal-vt "3"))
                     (greetd-terminal-configuration
                      (terminal-vt "4"))
                     (greetd-terminal-configuration
                      (terminal-vt "5"))
                     (greetd-terminal-configuration
                      (terminal-vt "6"))))))
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
         (service console-font-service-type
                  (map (lambda (tty)
                         (cons tty (file-append
                                    font-terminus
                                    "/share/consolefonts/ter-124n")))
                       '("tty1" "tty2" "tty3" "tty4" "tty5" "tty6")))
         (modify-services %base-services
                          (delete agetty-service-type)
                          (delete login-service-type)
                          (delete console-font-service-type)
                          (delete mingetty-service-type)
                          (guix-service-type
                           config =>
                           (subs-service-create config)))))

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
                       (gfxmode '("800x600" "auto"))
                       (image (make-file "config/guix-checkered-16-10.svg"))))))
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
                        (type "vfat"))
                       (file-system
                        (device "/dev/sdb1")
                        (mount-point "/mnt/usb")
                        (type "ext4")
                        (options "rw,noauto,user")
                        (create-mount-point? #t)
                        (mount? #f))
                       (file-system
                        (device "/dev/mmcblk0p1")
                        (mount-point "/mnt/sd")
                        (type "ext4")
                        (options "rw,noauto,user")
                        (create-mount-point? #t)
                        (mount? #f)))
                 %base-file-systems))
  (sudoers-file
   (plain-file "etc-sudoers-config"
               (string-append "Defaults  timestamp_timeout=480" "\n"
                              "root      ALL=(ALL) ALL" "\n"
                              "%wheel    ALL=(ALL) ALL" "\n"
                              "bumble    ALL=(ALL) NOPASSWD:"
                              "/run/current-system/profile/sbin/halt,"
                              "/run/current-system/profile/sbin/reboot")))
  (users (cons (user-account
                (name "bumble")
                (comment "honey worker")
                (group "users")
                (supplementary-groups
                 (list "wheel" "netdev" "seat"
                       "audio" "video" "light")))
               %base-user-accounts))
  (packages (append 
             (specifications->packages
              (list "sway"
                    "swaylock-effects"
                    "nss-certs"))
             %base-packages))
  (setuid-programs %setuid-programs)
  (services %services))
