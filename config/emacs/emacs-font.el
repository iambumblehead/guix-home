(when (member "JetBrains Mono" (font-family-list))
  (set-face-attribute
   'default nil
   :family "JetBrains Mono"
   :height 92))

(when (member "Menlo" (font-family-list))
  (set-face-attribute
   'default nil
   :family "Menlo"
   :height 180))

(when (member "Ubuntu Mono" (font-family-list))
  (set-face-attribute
   'default nil
   :family "Ubuntu Mono"
   :height 180))

(when (member "Cantarell" (font-family-list))
  (set-face-attribute
   'default nil
   :family "Cantarell"
   :height 180))

;; NOTE: emacs -nw uses terminal font, not customizable
