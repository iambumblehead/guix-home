(use-modules
 (ice-9 match)
 (srfi srfi-26))

(define %conf-dir
  (dirname (current-filename)))

(define (path-join . args)
  (string-join args "/"))

(define (config-file file)
  (local-file (path-join %conf-dir file)))

(define normalize-config
  (match-lambda
   ((input . output)
    (list output (if (string? input)
                     (config-file input)
                     input)))
   (output (list output (config-file (basename output))))))
