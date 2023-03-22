;; load then use this file
;;
;; (load-file "~/path/to/DOTemacs-bind-clipboard.el")
;; (bind-system-clipboard-paste-to)
;; (bind-system-clipboard-copy-from)

(defun wl-copy-paste-to (text)
  (let ((process-connection-type nil))
    (let ((proc (start-process "wl-copy" "*Messages*" "wl-copy" "-n" )))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun wl-paste-copy-from ()
  (shell-command-to-string "wl-paste -n | tr -d '\r'"))

(defun xsel-paste-clear ()
  (with-temp-buffer
    (insert "")
    (call-process-region (point-min) (point-max) "xsel" nil nil nil "-i" "-b")))    

(defun xsel-paste-to (text &optional push)  
  (if (region-active-p)
      (progn
        (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
        (deactivate-mark))
    (with-temp-buffer
      (let ((last-clipped (shell-command-to-string "xsel -o -b")))
        (insert (if (string-suffix-p last-clipped "\n")
                    (concat last-clipped text) text))
        (call-process-region (point-min) (point-max) "xsel" nil nil nil "-i" "-b")))))

(defun xsel-copy-from ()
  (shell-command-to-string "xsel -o -b"))

(defun pbcopy-paste-to (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun pbpaste-copy-from ()
  (shell-command-to-string "pbpaste"))

;; This variable provides a way of communicating killed text to other programs,
;; when you are using a window system. Its value should be nil or a function of
;; one required argument.
;;
;; If the value is a function, kill-new and kill-append call it with the new
;; first element of the kill ring as the argument.
;;
;; The normal use of this function is to put newly killed text in the window
;; system's clipboard. See Window System Selections. 
(defun bind-system-clipboard-paste-to ()
  (interactive)
  (cond ((executable-find "pbcopy") ;; osx
         (setq interprogram-cut-function 'pbcopy-paste-to))
        ((executable-find "xsel") ;; linux
         (xsel-paste-clear)
         (setq interprogram-cut-function 'xsel-paste-to))
        ((executable-find "wl-copy") ;; not as good as xsel
         (setq interprogram-cut-function 'wl-copy-paste-to))))

;; This variable provides a way of transferring killed text from other programs,
;; when you are using a window system. Its value should be nil or a function of
;; no arguments.
;;
;; If the value is a function, current-kill calls it to get the most recent kill.
;; If the function returns a non-nil value, then that value is used as the most
;; recent kill. If it returns nil, then the front of the kill ring is used.
;;
;; To facilitate support for window systems that support multiple selections,
;; this function may also return a list of strings. In that case, the first
;; string is used as the most recent kill, and all the other strings are pushed
;; onto the kill ring, for easy access by yank-pop. 
(defun bind-system-clipboard-copy-from ()
  (interactive)
  (cond ((executable-find "pbpaste") ;; osx
         (setq interprogram-paste-function 'pbpaste-copy-from))
        ((executable-find "xsel") ;; linux
         (setq interprogram-paste-function 'xsel-copy-from))
        ((executable-find "wl-paste") ;; not as good as xsel
         (setq interprogram-paste-function 'wl-paste-copy-from))))
