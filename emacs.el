(setq guix-emacs-packages-path
      (expand-file-name
       "~/.guix-home/profile/share/emacs/site-lisp/"))

(add-to-list 'load-path guix-emacs-packages-path)
(load-file (concat guix-emacs-packages-path "subdirs.el"))

(guix-emacs-autoload-packages)

(load-file "~/.emacs.d/emacs-nox.el")
(load-file "~/.emacs.d/emacs-font.el")
(load-file "~/.emacs.d/emacs-clipboard.el")
(load-file "~/.emacs.d/emacs-colorize-buffer.el")

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

;; change backup file dir
(setq backup-by-copying t)
(setq backup-directory-alist `(("." . "~/.emacs.d/saves/")))
(setq create-lockfiles nil)

(setq hl-line-face 'hl-line)
(global-hl-line-mode 1)

;; streamline windowed emacs ui
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; indent with spaces
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)
(setq tab-width 2)

(line-number-mode 1)
(column-number-mode 1)
(show-paren-mode 1)

 ;; break long lines w/ newline
(add-hook 'markdown-mode-hook 'visual-line-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.m?js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

;; Assuming the Guix checkout is in ~/src/guix.
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/software/guix"))
;; Tempel configuration
(with-eval-after-load 'tempel
  ;; Ensure tempel-path is a list -- it may also be a string.
  (unless (listp 'tempel-path)
    (setq tempel-path (list tempel-path)))
  (add-to-list 'tempel-path "~/software/guix/etc/snippets/tempel/*"))

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
             (set-face-background 'hl-line "#1c1c1c"))
    (progn (load-theme 'doom-peacock t)
           (set-background-color "ARGBBB000000")
           (set-face-background 'hl-line "#1c1c1c"))))

(set-theme)
(add-hook 'emacs-startup-hook 'set-theme)

;;; https://kristofferbalintona.me/posts/202206071000/
(defun toggle-alpha-on ()
  (interactive)
  (set-frame-parameter nil 'alpha-background 30)
  (set-background-color "ARGBBB000000"))

(defun toggle-alpha-half ()
  (interactive)
  (set-frame-parameter nil 'alpha-background 50))

(defun toggle-alpha-off ()
  (interactive)
  (set-frame-parameter nil 'alpha-background 100)
  (set-background-color nil))
