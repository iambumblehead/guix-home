(setq guix-emacs-packages-path
      (expand-file-name
       "~/.guix-home/profile/share/emacs/site-lisp/"))

(add-to-list 'load-path guix-emacs-packages-path)
(load-file (concat guix-emacs-packages-path "subdirs.el"))

(guix-emacs-autoload-packages)

(load-file "emacs-nox.el")
(load-file "emacs-font.el")
(load-file "emacs-clipboard.el")
(load-file "emacs-colorize-buffer.el")

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

;; other good themes: 'zenburn, 'tsdh-dark
;; different theme for window and terminal emacs
;; different highlight for different theme
(if (display-graphic-p)
    (progn (load-theme 'doom-peacock t)
           (set-face-background 'hl-line "#1c1c1c"))
  (progn (load-theme 'doom-peacock t)
         (set-face-background 'hl-line "#1c1c1c")))

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



(load-file "~/software/DOTemacs/DOTemacs.el")
