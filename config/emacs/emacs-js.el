;;(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))
;;(add-hook 'typescript-mode-hook 'eglot-ensure)

(add-hook 'js2-mode-hook 'flycheck-mode)
(add-hook 'js2-mode-hook 'eglot-ensure)
(add-hook 'js2-mode-hook 'company-mode)

;; Turn off js2 mode errors & warnings (we lean on eslint/standard)
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)
;; javascript and jsx indent
(setq js-indent-level 2)
(setq sgml-basic-offset 2)
