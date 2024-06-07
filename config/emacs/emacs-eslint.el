;; locate the file which exists at path inside root
;; recursively traversing 'up' root until path is found no parent exists
;;
;; useful for mono-repos that locate eslint to a parent project directory
(defun findupward (root path)
  (when (and root (file-directory-p root))
    (let* ((fullroot (expand-file-name root))
           (eslint (and root (expand-file-name path root))))
      (if (or (file-exists-p eslint)
              (string-equal fullroot "/")) eslint
        (findupward (concat root "../../") path)))))

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory) "node_modules"))
         (eslint (findupward root "node_modules/eslint/bin/eslint.js")))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
