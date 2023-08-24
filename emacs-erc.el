;(make-variable-buffer-local 'erc-fill-column)
;(add-hook 'window-configuration-change-hook 
;	        '(lambda ()
;	           (save-excursion
;	             (walk-windows
;		            (lambda (w)
;		              (let ((buffer (window-buffer w)))
;		                (set-buffer buffer)
;		                (when (eq major-mode 'erc-mode)
;		                  (setq erc-fill-column (- (window-width w) 2)))))))))

(add-hook 'window-configuration-change-hook 
          '(lambda ()
	           (setq erc-fill-column (- (window-width) 2))))
