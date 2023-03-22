;; allow mouse at emacs -nw
(unless (window-system)
  (xterm-mouse-mode)
  (global-set-key
   [mouse-4] (lambda ()
               (interactive)
               (scroll-down 1)))
  (global-set-key
   [mouse-5] (lambda ()
               (interactive)
               (scroll-up 1))))

;; http://www.emacswiki.org/emacs/WindowResize
(global-set-key (kbd "C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<down>") 'shrink-window)
(global-set-key (kbd "C-<up>") 'enlarge-window)
