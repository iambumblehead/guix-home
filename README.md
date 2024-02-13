# GNU Guix system and home files

```diff
+░░░                                     ░░░
+░░▒▒░░░░░░░░░               ░░░░░░░░░▒▒░░
+ ░░▒▒▒▒▒░░░░░░░           ░░░░░░░▒▒▒▒▒░
+     ░▒▒▒░░▒▒▒▒▒         ░░░░░░░▒▒░
+           ░▒▒▒▒░       ░░░░░░
+            ▒▒▒▒▒      ░░░░░░
+             ▒▒▒▒▒     ░░░░░
+             ░▒▒▒▒▒   ░░░░░
+              ▒▒▒▒▒   ░░░░░
+               ▒▒▒▒▒ ░░░░░
+               ░▒▒▒▒▒░░░░░
+                ▒▒▒▒▒▒░░░
+                 ▒▒▒▒▒▒░
+  _____ _   _ _    _    _____       _
+ / ____| \ | | |  | |  / ____|     (_)
+| |  __|  \| | |  | | | |  __ _   _ ___  __
+| | |_ | . ' | |  | | | | |_ | | | | \ \/ /
+| |__| | |\  | |__| | | |__| | |_| | |>  <
+ \_____|_| \_|\____/   \_____|\__,_|_/_/\_\
```

This guix configuration mainly provides a "current" system without dbus. What's good
 * pipewire with alsa, screen lock and brightness, fcitx5 r_shift+ctrl, wayland
 * no: firefox, systemd, dbus, elogind, ibus


Caution wifi; Guix's `wpa-supplicant-service-type` writes a read-only `wpa_supplicant.conf` file and `wpa_cli` is unable to persist and apply network changes. To change things, stop the service and use commands below,
```bash
$ sudo herd stop wpa-supplicant
$ iwconfig # list network interfaces
$ cat wpa_supplicant.conf
ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=wheel
update_config=1

network={
  ssid="YOURESSID"
  key_mgmt=WPA-PSK
  psk="YOURPASSWORD"
}
$ sudo wpa_supplicant -i wlp2s0 -c wpa_supplicant.conf
$ sudo wpa_cli -p /run/wpa_supplicant
> scan
> scan_results # lists access points
> quit
```

Administer
```bash
guix pull
guix pull --delete-generations
sudo guix system reconfigure guix.system.scm
sudo guix system delete-generations
guix home reconfigure guix.home.scm
guix home delete-generations
guix upgrade
guix package --delete-generations
guix gc
guix gc -d1w # delete generations older than 1 week
df -h
```

Other good ones
 * https://git.sr.ht/~unwox/etc/
 * https://git.sr.ht/~unmatched-paren/conf/

Links
 * https://rendaw.gitlab.io/blog/
 * https://toys.whereis.みんな
 * https://github.com/iambumblehead/guix-xps13-9343
 * https://github.com/iambumblehead/guix-notes
