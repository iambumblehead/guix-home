(add-hook 'window-configuration-change-hook
          #'(lambda ()
              (save-excursion
                (walk-windows
                 (lambda (w)
                   (let ((major (with-current-buffer (window-buffer w) major-mode)))
                     (when (eq major 'erc-mode)
                       (setq erc-fill-column (- (window-width w) 2)))))))))

(defmacro unpack-color (color red green blue &rest body)
  `(let ((,red   (car ,color))
         (,green (car (cdr ,color)))
         (,blue  (car (cdr (cdr ,color)))))
     ,@body))

(defun rgb-to-html (color)
  (unpack-color color red green blue
   (concat "#" (format "%02x%02x%02x" red green blue))))

(defun hexcolor-luminance (color)
  (unpack-color color red green blue
   (floor (+ (* 0.299 red) (* 0.587 green) (* 0.114 blue)))))

(defun invert-color (color)
  (unpack-color color red green blue
   `(,(- 255 red) ,(- 255 green) ,(- 255 blue))))

(defun erc-get-color-for-nick (nick dark)
  (let* ((hash     (md5 (downcase nick)))
         (red      (mod (string-to-number (substring hash 0 10) 16) 256))
         (blue     (mod (string-to-number (substring hash 10 20) 16) 256))
         (green    (mod (string-to-number (substring hash 20 30) 16) 256))
         (color    `(,red ,green ,blue)))
    (rgb-to-html (if (if dark (< (hexcolor-luminance color) 85)
                       (> (hexcolor-luminance color) 170))
                     (invert-color color)
                   color))))

(defun erc-highlight-nicknames ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\w+" nil t)
      (let* ((bounds (bounds-of-thing-at-point 'symbol))
             (nick   (buffer-substring-no-properties (car bounds) (cdr bounds))))
        (when (erc-get-server-user nick)
          (put-text-property
           (car bounds) (cdr bounds) 'face
           (cons 'foreground-color (erc-get-color-for-nick nick 't))))))))





(defvar erc-fill-wrapped-input-p nil
  "Keeps track of whether auto-fill-mode has wrapped the input text.
Reset to NIL after a message is successfully sent.")
(make-variable-buffer-local 'erc-wrapped-input-p)

(setq normal-auto-fill-function
      (lambda ()
        (setq erc-fill-wrapped-input-p t)
        (do-auto-fill)))

(defun erc-user-input ()
  "Return the input of the user in the current buffer.
If `erc-wrapped-input-p' is true, strips all newlines."
  (let ((literal-input (buffer-substring-no-properties
                        erc-input-marker
                        (erc-end-of-input-line))))
    (if erc-fill-wrapped-input-p
        (replace-regexp-in-string "\n *" " " literal-input)
      literal-input)))

(add-hook 'erc-mode-hook
          (lambda ()
            (set-fill-column (- erc-fill-column 2))
            (auto-fill-mode)))

(add-hook 'erc-send-completed-hook
          (lambda (message)
            (declare (ignore message))
            (setq erc-fill-wrapped-input-p nil)))
