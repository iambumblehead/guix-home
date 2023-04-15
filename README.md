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
 * wireplumber, screen lock, brightness and audio 
 * no: gtk4, firefox, systemd, dbus, elogind, ibus


How to administer
 * `guix pull`
 * `sudo guix system reconfigure guix.system.scm`
 * `sudo guix system delete-generations`
 * `guix home reconfigure guix.home.scm`
 * `guix home delete-generations`
 * `guix upgrade`
 * `df -h`


Other good ones
 * https://git.sr.ht/~unwox/etc/
 * https://git.sr.ht/~unmatched-paren/conf/


Links
 * https://rendaw.gitlab.io/blog/
 * https://toys.whereis.xn--q9jyb4c/


Still to do
 * setup emacs with guix powers
   * https://issues.guix.gnu.org/58652
   * https://guix.gnu.org/manual/en/html_node/The-Perfect-Setup.html
   * https://guix.gnu.org/manual/en/html_node/Building-from-Git.html
 * setup git sendmail
   * https://git-send-email.io/#step-2
 * add to gitconfig gpgsign
