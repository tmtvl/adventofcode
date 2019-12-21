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
      (car pair)
      (string-copy (cdr pair) 1)))
   (map
    (lambda (line)
      (split-string
       line
       (search-string
	line
	#\))))
    (call-with-input-file (cadr (command-line)) read-lines))))

(define all-assoc
  (lambda (obj alist)
    (cond
     ((null? alist) '())
     ((equal? obj (caar alist)) (cons (cons obj (cdar alist)) (all-assoc obj (cdr alist))))
     (else (all-assoc obj (cdr alist))))))

(define parse-orbits
  (lambda (parent-name parent-depth alist)
    (let
	((pairs (all-assoc parent-name alist)))
      (cons
       (cons parent-name parent-depth)
       (if (null? pairs)
	   '()
	   (apply
	    append
	    (map
	     (lambda (p)
	       (parse-orbits
		(cdr p)
		(+ parent-depth 1)
		alist))
	     pairs)))))))

(define orbits
  (parse-orbits "COM" 0 input))

(display
 (apply
  +
  (map
   cdr
   orbits)))
(newline)
