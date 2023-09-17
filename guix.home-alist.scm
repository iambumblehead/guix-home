(use-modules (guix gexp)
             ;;(guix utils)
             (srfi srfi-1)
             (srfi srfi-26)
             (ice-9 ftw)
             (ice-9 string-fun)
             (ice-9 regex))

(define %current-dir (dirname (current-filename)))

(define (path-join . args)
  (string-join args file-name-separator-string))

(define (path-expand path)
  (if (regexp-exec isrootstr-re path)
      path (path-join %current-dir path)))

(define (path-diff path-sub path-full)
  "(/full/path/ /full/path/to/file.cfg) -> to/file.cfg"
  (let ((path-sub-and-slash
         (string-append (dirname (path-expand path-sub))
                        file-name-separator-string)))
    (string-replace-substring path-full path-sub-and-slash "")))

(define isrootstr-re (make-regexp "^\\/"))

(define isdotstr-re (make-regexp "^\\.\\.?"))

(define istmpstr-re (make-regexp "~$"))

(define (isnotdotortmpstr? str)
  (and (not (regexp-exec isdotstr-re str))
       (not (regexp-exec istmpstr-re str))))

(define (list-recursive pathOrDir . files)
  (let ((filestat (stat pathOrDir)))
    (cond ((eq? (stat:type filestat) 'directory)
           (fold (lambda (str prev)
                   (append prev
                           (list-recursive
                            (path-join pathOrDir str))))
                 files
                 (scandir pathOrDir isnotdotortmpstr?)))
          ((eq? (stat:type filestat) 'regular)
           (cons pathOrDir files))
          (else
           files))))

(define (home-list-create-from-dir source home-lists)
  (let ((files (list-recursive source)))
    (fold (lambda (path-to prev)
            (let ((path-full (path-expand path-to)))
              (cons (list (path-diff source path-full)
                          (local-file path-full #:recursive? #t))
                    prev)))
          home-lists
          files)))

(define (home-alists-create-from-dirs sources . alists)
  (fold (lambda (source prev)
          (home-list-create-from-dir source prev))
        alists
        sources))

;;(display (home-alists-create-from-dirs
;;          (list
;;           "config/emacs"
;;           "config/fcitx5")))
