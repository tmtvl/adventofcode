(use-modules (ice-9 textual-ports))

(define (string->dimensions str)
  (let ((hwl (map string->number
		  (string-split str #\x))))
    (list (* (car hwl) (cadr hwl))
	  (* (car hwl) (caddr hwl))
	  (* (cadr hwl) (caddr hwl)))))

(define (dimensions->wp dims)
  (define (double x) (* x 2))
  (if (not (= (length dims) 3))
      (error "Impossible dimensions: DIMENSIONS->WP" dims)
      (+ (apply + (map double dims))
	 (apply min dims))))

(define (add-up-dimensions p)
  (define (lines p)
    (let ((l (get-line p)))
      (if (eof-object? l)
	  '()
	  (cons l (lines p)))))
  (apply + (map (lambda (l)
		  (if (string-null? l)
		      0
		      (dimensions->wp (string->dimensions l))))
		(lines p))))

(define (parse-input file)
  (if (not (file-exists? file))
      (error "File does not exist: PARSE-INPUT" file)
      (call-with-input-file
	  file
	(lambda (p)
	  (add-up-dimensions p)))))

(for-each (lambda (f)
	    (display (parse-input f))
	    (newline))
	  (cdr (command-line)))
