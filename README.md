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


What's good
 * wireplumber, screen lock, fcitx5, brightness and audio
 * no: gtk4, firefox, systemd, dbus, elogind, ibus


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
