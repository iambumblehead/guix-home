(define-module (home-alist)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 regex))

(define isdotstr-re
  (make-regexp "^\\.\\.?"))

(define (isnotdotstr? str)
  (not (regexp-exec isdotstr-re str)))

(define (list-recursive pathOrDir . files)
  (let ((filestat (stat pathOrDir)))
    (cond ((eq? (stat:type filestat) 'directory)
           (fold (lambda (str prev)
                   (append prev
                           (list-recursive
                            (string-join (list pathOrDir str) "/"))))
                 files
                 (scandir pathOrDir isnotdotstr?)))
          ((eq? (stat:type filestat) 'regular)
           (cons pathOrDir files))
          (else
           files))))

(define (home-alists-create-from-dir source list)
  (display (list-recursive source)))

(define (home-alists-create-from-dirs . sources)
  (home-alists-create-from-dir (car sources) '()))

(home-alists-create-from-dirs
 "/home/bumble/software/guix-home/config/qutebrowser"
 "/home/bumble/software/guix-home/config/qutebrowser")


;;(display
;; (string-join (list-recursive (string-join (list (getcwd) "guf") "/")) "\n"))
