(import (scheme base) (scheme file) (scheme process-context) (scheme write))

(define search-string-starting-at
  (lambda (string char index)
    (cond
     ((equal? (string-ref string index) char) index)
     ((= index (string-length string)) #f)
     (else (search-string-starting-at string char (+ index 1))))))

(define search-string
  (lambda (string char)
    (search-string-starting-at string char 0)))

(define split-string
  (lambda (string index)
    (cons
     (string-copy string 0 index)
     (string-copy string index))))

(define read-lines
  (lambda (port)
    (let ((line (read-line port)))
      (if (eof-object? line)
	  '()
	  (cons line (read-lines port))))))

(define input
  (map
   (lambda (pair)
     (cons
      (string-copy (cdr pair) 1)
      (car pair)))
   (map
    (lambda (line)
      (split-string
       line
       (search-string
	line
	#\))))
    (call-with-input-file (cadr (command-line)) read-lines))))

(define path-to-com
  (lambda (point depth alist)
    (let
	((link (assoc point alist)))
      (cons
       (cons point depth)
       (if link
	   (path-to-com (cdr link) (+ depth 1) alist)
	   '())))))

(define find-common-orbit
  (lambda (point depth orbits path)
    (let
	((link (assoc point path)))
      (if link
	  (+ (cdr link) depth)
	  (find-common-orbit (cdr (assoc point orbits)) (+ depth 1) orbits path)))))

(display
 (find-common-orbit
  (cdr (assoc "SAN" input))
  0
  input
  (path-to-com
   (cdr (assoc "YOU" input))
   0
   input)))
(newline)
