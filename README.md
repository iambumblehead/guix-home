# GNU Guix system and home config files

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


How to administer
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


Other good ones
 * https://git.sr.ht/~unwox/etc/
 * https://git.sr.ht/~unmatched-paren/conf/


Links
 * https://rendaw.gitlab.io/blog/
 * https://toys.whereis.みんな

Use `run-geiser` or `run-guile` with emacs and guile sources.

Send a patch upstream,
 * from `M-x magit-commit` use `tempel-insert [add]` for example and follow the message pattern of previous commits
 * then `git send-email --dry-run --to="guix-patches@gnu.org" HEAD^` see [git-send-email.io](https://git-send-email.io)
