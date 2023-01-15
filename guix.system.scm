;; This is an operating system configuration template
;; for a "bare bones" setup, w/ no display server.

(use-modules (gnu)
	     ;; -----
	     (gnu home)
	     (gnu packages wm)
	     (gnu packages xdisorg)
	     (gnu packages terminals)
	     ;; -----
	     (gnu services)
	     (gnu services desktop)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules networking ssh)
(use-package-modules bootloaders certs emacs screen ssh)

(operating-system
  (host-name "guix-xps")
  (timezone "America/Los_Angeles")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us" #:options '("ctrl:nocaps")))
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (initrd-modules (cons "i915" %base-initrd-modules))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

  (swap-devices
   (list
    (swap-space (target (uuid "5b7826f3-fd1f-4b7d-a12b-9c5cabbf0087")))))

  ;; It's fitting to support the equally bare bones ‘-nographic’
  ;; QEMU option, which also nicely sidesteps forcing QWERTY.
  ;; (kernel-arguments (list "console=ttyS0,115200"))
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

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam.
                (supplementary-groups '("wheel" "netdev" "seat" ;; seat for sway
                                        "audio" "video")))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (append (list
                     screen emacs
		     sway
                     ;; for HTTPS access
                     nss-certs)
                    %base-packages))  

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (append (list (simple-service 'env-vars session-environment-service-type
					  '(("XDG_RUNTIME_DIR" . "/tmp/")))
		          (service dhcp-client-service-type)
                          (service wpa-supplicant-service-type)
			  (service seatd-service-type) ;; for sway
                          (service openssh-service-type
                                   (openssh-configuration
                                    (openssh openssh-sans-x)
                                    (port-number 2222))))
                    %base-services)))
