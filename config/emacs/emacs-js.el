;;(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))
;;(add-hook 'typescript-mode-hook 'eglot-ensure)

(add-hook 'js2-mode-hook 'flycheck-mode)
(add-hook 'js2-mode-hook 'eglot-ensure)
(add-hook 'js2-mode-hook 'company-mode)

;; javascript and jsx indent
(setq js-indent-level 2)
(setq sgml-basic-offset 2)
