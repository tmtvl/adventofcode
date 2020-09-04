(use-modules (ice-9 textual-ports))

(define (string->ribbon str)
  (let ((hwl (map string->number
		  (string-split str #\x))))
    (+ (* (+ (min (car hwl) (cadr hwl))
	     (min (max (car hwl) (cadr hwl))
		  (caddr hwl)))
	  2)
       (apply * hwl))))

(define (parse-input file)
  (define (lines p)
    (let ((l (get-line p)))
      (if (eof-object? l)
	  '()
	  (cons l (lines p)))))
  (if (not (file-exists? file))
      (error "File does not exist: PARSE-INPUT" file)
      (call-with-input-file
	  file
	(lambda (p)
	  (apply + (map string->ribbon
			(lines p)))))))

(for-each (lambda (f)
	    (display (parse-input f))
	    (newline))
	  (cdr (command-line)))
