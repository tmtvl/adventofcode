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
  (define (ITM current-point extra-point current-moves extra-moves)
    (let ((char (get-char input-port)))
      (if (eof-object? char)
	  (append current-moves
		  (filter (lambda (p)
			    (not (member p current-moves)))
			  extra-moves))
	  (let ((new-point (move current-point char)))
	    (cond ((not new-point)
		   (ITM current-point extra-point
			current-moves extra-moves))
		  ((member new-point current-moves)
		   (ITM extra-point new-point
			extra-moves current-moves))
		  (else
		   (ITM extra-point
			new-point
			extra-moves
			(cons new-point current-moves))))))))
  (let ((starting-point (make-point 0 0)))
    (ITM starting-point starting-point
	 (list starting-point) (list starting-point))))

(define (parse-input-file file)
  (length (call-with-input-file
	      file
	    input->moves)))

(for-each (lambda (file)
	    (display (parse-input-file file))
	    (newline))
	  (cdr (command-line)))
