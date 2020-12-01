(use-modules (ice-9 textual-ports))

(define (make-point x y)
  (cons x y))

(define (point-x point)
  (car point))

(define (point-y point)
  (cdr point))

(define (go-up point)
  (cons (point-x point)
	(1+ (point-y point))))

(define (go-down point)
  (cons (point-x point)
	(1- (point-y point))))

(define (go-right point)
  (cons (1+ (point-x point))
	(point-y point)))

(define (go-left point)
  (cons (1- (point-x point))
	(point-y point)))

(define (move point instruction)
  (cond ((eq? instruction #\^)
	 (go-up point))
	((eq? instruction #\v)
	 (go-down point))
	((eq? instruction #\>)
	 (go-right point))
	((eq? instruction #\<)
	 (go-left point))
	(else #f)))

(define (input->moves input-port)
  (define (ITM point moves)
    (let ((char (get-char input-port)))
      (if (eof-object? char)
	  moves
	  (let ((new-point (move point char)))
	    (cond ((not new-point)
		   (ITM point moves))
		  ((member new-point moves)
		   (ITM new-point moves))
		  (else
		   (ITM new-point (cons new-point moves))))))))
  (let ((starting-point (make-point 0 0)))
    (ITM starting-point (list starting-point))))

(define (parse-input-file file)
  (length (call-with-input-file
	      file
	    input->moves)))

(for-each (lambda (file)
	    (display (parse-input-file file))
	    (newline))
	  (cdr (command-line)))
