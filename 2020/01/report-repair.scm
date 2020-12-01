(import (rnrs (6)))

(define (2020-pair numbers)
  (cond ((null? numbers) #f)
	((member (- 2020 (car numbers))
		 (cdr numbers))
	 (cons (car numbers)
	       (- 2020 (car numbers))))
	(else (2020-pair (cdr numbers)))))

(define (2020-triplet numbers)
  (letrec ((FP (lambda (target numbers)
		 (cond ((null? numbers) #f)
		       ((member (- target (car numbers))
				(cdr numbers))
			(list (car numbers)
			      (- target (car numbers))))
		       (else (FP target (cdr numbers)))))))
    (let FT ((numbers numbers))
      (if (null? numbers)
	  #f
	  (let ((t (FP (- 2020 (car numbers))
		       (cdr numbers))))
	    (if t
		(cons (car numbers) t)
		(FT (cdr numbers))))))))

(define (lines->numbers lines)
  (map string->number lines))

(define (find-in-file proc file)
  (proc
   (call-with-input-file file
      (lambda (p)
	(let lines ((l (get-line p))
		    (result '()))
	  (if (eof-object? l)
	      result
	      (lines (get-line p) (cons l result))))))))

(define (find-pair-in-file file)
  (find-in-file (lambda (lines) (2020-pair (lines->numbers lines))) file))

(define (find-triplet-in-file file)
  (find-in-file (lambda (lines) (2020-triplet (lines->numbers lines))) file))
