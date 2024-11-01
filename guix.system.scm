(use-modules (gnu)
             (gnu packages wm)
             (gnu packages cups)
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
  (cons* fontconfig-file-system-service
         (udev-rules-service 'light
                             (specification->package "light")
                             #:groups '("light"))
         (service cups-service-type
                  (cups-configuration
                   (web-interface? #t)
                   (default-paper-size "Letter")
                   (extensions (list cups-filters hplip-minimal))))
         (service screen-locker-service-type
                  (screen-locker-configuration
                   (name "swaylock")
                   (program (file-append swaylock-effects "/bin/swaylock"))
                   (using-pam? #t)
                   (using-setuid? #f)))
         (service greetd-service-type
                  (greetd-configuration
                   (greeter-supplementary-groups '("video" "input" "seat" "users"))
                   (terminals
                    (list
                     (greetd-terminal-configuration
                      (terminal-vt "1")
                      (terminal-switch #t)
                      ;;(default-session-command
                      ;;  (greetd-agreety-session)))
                      ;; wlgreet often breaks, comment-out this section
                      (default-session-command
                        (greetd-wlgreet-sway-session
                         (sway-configuration ;; issues.guix.gnu.org/65769
                          (make-file "config/sway/sway-greetd.conf")))))
                     (greetd-terminal-configuration (terminal-vt "2"))
                     (greetd-terminal-configuration (terminal-vt "3"))
                     (greetd-terminal-configuration (terminal-vt "4"))
                     (greetd-terminal-configuration (terminal-vt "5"))
                     (greetd-terminal-configuration (terminal-vt "6"))))))
         (service mingetty-service-type
                  (mingetty-configuration (tty "tty8")))
         (service dhcp-client-service-type)
         (service seatd-service-type)
         (service wpa-supplicant-service-type
                  (wpa-supplicant-configuration
                   (interface "wlp2s0")
                   (dbus? #f)
                   (config-file (make-file "wpa_supplicant.conf"))))
         ;; ssh user@host -p 2222
         (service openssh-service-type
                  (openssh-configuration
                   (openssh (specification->package "openssh-sans-x"))
                   (port-number 2222)))
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
  (keyboard-layout (keyboard-layout "us" #:options '("ctrl:nocaps")))
  (locale-definitions
   (append (list (locale-definition (source "ja_JP") (name "ja_JP.utf8"))
                 (locale-definition (source "en_US") (name "en_US.utf8"))
                 (locale-definition (source "th_TH") (name "th_TH.utf8")))
           %default-locale-definitions))
  (users (append
          (list (user-account
                 (name "bumble")
                 (comment "honey worker")
                 (group "users")
                 (supplementary-groups
                  '("wheel" "netdev" "seat"
                    "audio" "video" "light"))))
          %base-user-accounts))
  (kernel linux)
  (initrd microcode-initrd)
  (initrd-modules (cons "i915" %base-initrd-modules))
  (firmware (cons iwlwifi-firmware %base-firmware))
  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets '("/boot/efi"))
               (keyboard-layout keyboard-layout)
               (theme (grub-theme
                       (inherit (grub-theme))
                       (gfxmode '("800x600" "auto"))
                       (image (make-file "config/guix-checkered-16-10.svg"))))))
  (swap-devices (list (swap-space
                       (target (file-system-label "my-swap")))))
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
  ;; (sudoers-file
  ;;  (plain-file "etc-sudoers-config"
  ;;              (string-append "Defaults  timestamp_timeout=480" "\n"
  ;;                             "root      ALL=(ALL) ALL" "\n"
  ;;                             "%wheel    ALL=(ALL) ALL" "\n"
  ;;                             "bumble    ALL=(ALL) NOPASSWD:"
  ;;                             "/run/current-system/profile/sbin/halt,"
  ;;                             "/run/current-system/profile/sbin/reboot")))
  (packages (append
             (specifications->packages
              '("sway" "swaylock-effects" "glibc-locales"))
             %base-packages))
  (setuid-programs %setuid-programs)
  (services %services))
