;;; https://kristofferbalintona.me/posts/202206071000/
(defun bgalpha-on ()
  (interactive)
  (set-frame-parameter nil 'alpha-background 30)
  (set-background-color "ARGBBB000000"))

(defun bgalpha-half ()
  (interactive)
  (set-frame-parameter nil 'alpha-background 50))

(defun bgalpha-off ()
  (interactive)
  (set-frame-parameter nil 'alpha-background 100)
  (set-background-color nil))
