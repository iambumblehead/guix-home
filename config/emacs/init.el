(when (file-directory-p "/run/current-system/profile/bin/env")
  (let ((guix-emacs-packages-path
         (expand-file-name
          "~/.guix-home/profile/share/emacs/site-lisp/")))
    (add-to-list 'load-path guix-emacs-packages-path)
    (load-file (concat guix-emacs-packages-path "subdirs.el"))
    (guix-emacs-autoload-packages)))
;;(setq guix-emacs-packages-path
;;      (expand-file-name
;;       "~/.guix-home/profile/share/emacs/site-lisp/"))
;;
;;(add-to-list 'load-path guix-emacs-packages-path)
;;(load-file (concat guix-emacs-packages-path "subdirs.el"))
;;(guix-emacs-autoload-packages)

(when (boundp 'package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

(setq xdghome (or (getenv "XDG_CONFIG_HOME")
                  (and (getenv "HOME") (concat (getenv "HOME") "/.config"))
                  (expand-file-name "~/.config")))

(load-file (concat xdghome "/emacs/emacs-erc.el"))
(load-file (concat xdghome "/emacs/emacs-nox.el"))
(load-file (concat xdghome "/emacs/emacs-font.el"))
(load-file (concat xdghome "/emacs/emacs-eslint.el"))
(load-file (concat xdghome "/emacs/emacs-clipboard.el"))
(load-file (concat xdghome "/emacs/emacs-colorize-buffer.el"))

(bind-system-clipboard-paste-to)
(bind-system-clipboard-copy-from)

;; steve yegge
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)

;; terminal-like history scroll in emacs shell
(defun bind-shell-history-keys ()
  (global-set-key (kbd "C-p") 'comint-previous-input)
  (global-set-key (kbd "C-n") 'comint-next-input))
(add-hook 'shell-mode-hook 'bind-shell-history-keys)

(defun split-horizontally-for-temp-buffers ()
  "Split the window horizontally for temp buffers."
  (when (one-window-p t) (split-window-horizontally)))

(defconst cache-directory
  (concat (or (getenv "XDG_CACHE_HOME")
              (concat (getenv "HOME")
                      "/.cache"))
          "/emacs"))

(use-package emacs
  :custom
  (auto-save-file-name-transforms
   `((".*" ,cache-directory t)))
  (backup-directory-alist
   `((".*" . ,cache-directory)))
  (indent-tabs-mode nil)
  (lock-file-name-transforms
   `((".*" ,cache-directory t)))
  (truncate-lines t)
  (tab-width 2)
  (tab-always-indent t)
  (user-full-name "chris")
  (user-mail-address "chris@bumblhead.com")
  :config
  (make-directory cache-directory t)
  (when (file-exists-p "~/software/guix/etc/copyright.el")
    (load-file "~/software/guix/etc/copyright.el")))

(setq hl-line-face 'hl-line)
(global-hl-line-mode 1)

;; streamline windowed emacs ui
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; store configurations here rather than write-protected files
(defconst cache-directory-custom-el
  (concat cache-directory "/custom.el"))
(setq custom-file cache-directory-custom-el)
(when (file-exists-p cache-directory-custom-el)
  (load-file cache-directory-custom-el))

(line-number-mode 1)
(column-number-mode 1)
(show-paren-mode 1)

 ;; break long lines w/ newline
(add-hook 'markdown-mode-hook 'visual-line-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))
(add-to-list 'auto-mode-alist '("\\.*rc$" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("mutt-*" . mail-mode))

(add-hook 'mail-mode-hook
          '(lambda ()
             (visual-line-mode 1)))

(use-package tempel
  :bind
  (([M-tab] . tempel-complete)
   ([M-return] . tempel-insert))
  :config
  (unless (listp 'tempel-path)
    (setq tempel-path (list tempel-path)))
  (add-to-list 'tempel-path "~/software/guix/etc/snippets/tempel/*")
  (define-key tempel-map [tab] #'tempel-next)
  (define-key tempel-map [backtab] #'tempel-previous)
  (define-key tempel-map [return] #'tempel-done))

(use-package corfu
  :config
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator))

(use-package tempel-collection)

(setq user-full-name "chris")
(setq user-mail-address "chris@bumblehead.com")
(load-file "~/software/guix/etc/copyright.el")
(setq copyright-names-regexp
      (format "%s <%s>" user-full-name user-mail-address))

;; other good themes: 'zenburn, 'tsdh-dark
;; different theme + highlight for window and terminal
(defun set-theme ()
  (if (display-graphic-p)
      (progn (load-theme 'doom-peacock t)
             (set-frame-parameter nil 'alpha-background 60)
             (set-face-background 'hl-line "#1c1c1c")
             ;;(set-face-foreground 'font-lock-string-face "red")
             (set-face-foreground 'font-lock-comment-face "light salmon")
             )
    (progn (load-theme 'doom-peacock t)
           (set-background-color "ARGBBB000000")
           (set-face-background 'hl-line "#1c1c1c")
           (set-face-foreground 'font-lock-comment-face "light salmon"))))

(set-theme)
(add-hook 'emacs-startup-hook 'set-theme)

(use-package geiser
  :hook ((scheme-mode . geiser-mode))
  :config
  (setq geiser-repl-query-on-kill-p nil)
  (setq geiser-mode-start-repl-p t)
  (setq geiser-default-implementation 'guile)
  (geiser-smart-tab-mode)
  (setq geiser-smart-tab-p t))

(use-package geiser-guile
  :after geiser
  :custom
  (geiser-default-implementation 'guile)
  :config
  (add-to-list 'geiser-guile-load-path "~/software/guix")
  (add-to-list 'geiser-guile-load-path "~/software/guix-home")
  (add-to-list 'geiser-guile-load-path "~/software/guf")
  (add-to-list 'geiser-guile-load-path "~/software/guf/guf"))

(use-package erc
  :custom
  (erc-nick "bumble")
  (erc-password nil)
  (erc-server "irc.libera.chat")
  (erc-port 6667)
  (erc-autojoin-channels-alist '(("irc.libera.chat" "#guix")))
  (erc-autojoin-timing 'ident)
  (erc-prompt-for-nickserv-password nil)
  (erc-server-reconnect-attempts 5)
  (erc-server-reconnect-timeout 3)
  :init
  (add-hook 'erc-insert-modify-hook 'erc-highlight-nicknames)
  :config
  (erc-services-mode 1)
  (erc-update-modules))

(use-package treesit
  :defer t
  :hook ((html-ts-mode js-ts-mode typescript-ts-mode
          json-ts-mode css-ts-mode yaml-ts-mode) . lsp-deferred)
  :init
  (setq treesit-font-lock-level 6)
  (setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (c "https://github.com/tree-sitter/tree-sitter-c")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (common-lisp "https://github.com/theHamsta/tree-sitter-commonlisp")
     (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (csharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (go-mod "https://github.com/camdencheek/tree-sitter-go-mod")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (js . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (lua "https://github.com/Azganoth/tree-sitter-lua")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (r "https://github.com/r-lib/tree-sitter-r")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
     (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
     (yaml "https://github.com/ikatyang/tree-sitter-yaml"))))

(use-package js2-mode
  :ensure t
  :init
  (setq js-basic-indent 2
        js-indent-level 2)
  (setq-default js2-basic-indent 2
                js2-basic-offset 2
                
                js2-auto-indent-p t
                js2-bounce-indent-p t
                js2-cleanup-whitespace t
                js2-strict-missing-semi-warning nil
                js2-enter-indents-newline nil
                js2-indent-on-enter-key nil
                js2-global-externs (list "window" "module" "require"
                                         "assert" "setTimeout" "clearTimeout"
                                         "setInterval" "clearInterval"
                                         "console" "JSON" "fetch"))
  (add-to-list 'auto-mode-alist '("\\.js$" . js-ts-mode))
  (add-hook 'js2-mode-hook
            (lambda () (flycheck-select-checker 'javascript-eslint)))
  (add-hook 'js2-mode-hook 'flycheck-mode))

;; M-x flycheck-verify-setup
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  (add-hook 'flycheck-mode-hook #'use-eslint-from-node-modules)
  (flycheck-add-mode 'javascript-eslint 'js-ts-mode))
