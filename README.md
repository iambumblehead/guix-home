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
 * pipewire with alsa, screen lock and brightness, fcitx5 ctrl+shift, wayland
 * no: gtk4, firefox, systemd, dbus, elogind, ibus


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

Test a change
```bash
# https://guix.gnu.org/manual/en/html_node/Contributing.html
# https://guix.gnu.org/en/blog/2018/a-packaging-tutorial-for-guix/
# use `M-x run-geiser` or `M-x run-guile` w/ guile sources
guix shell -D guix --pure --check
./bootstrap && ./configure && make
./pre-inst-env guix build --keep-failed fonts-tlwg
./pre-inst-env guix lint fonts-tlwg
./pre-inst-env guix style fonts-tlwg
```

Send a patch
```bash
# https://guix.gnu.org/manual/en/html_node/Submitting-Patches.html
# https://git-send-email.io
# see previous commit message patterns
# use `M-x magit-commit` and `tempel-insert [add]`
git send-email --dry-run --base=master --to="guix-patches@gnu.org" -1
```

Other good ones
 * https://git.sr.ht/~unwox/etc/
 * https://git.sr.ht/~unmatched-paren/conf/

Links
 * https://rendaw.gitlab.io/blog/
 * https://toys.whereis.みんな
