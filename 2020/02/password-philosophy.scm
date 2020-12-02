(import (rnrs (6)))

(define (matches-count? str char min max)
  "Checks whether the given string STR contains the given character CHAR at
least MIN times and no more than MAX times."
  (let ((matches (string-fold
		  (lambda (cur res)
		    (if (char=? cur char)
			(1+ res)
			res))
		  0
		  str)))
    (and (>= matches min)
	 (<= matches max))))

(define (matches-xor? str char a b)
  "Checks whether the given character CHAR matches position A XOR position B in
the given string STR."
  (let ((match-a (string-ref str (1- a)))
	(match-b (string-ref str (1- b))))
    (and (or (char=? match-a char)
	     (char=? match-b char))
	 (or (not (char=? match-a char))
	     (not (char=? match-b char))))))

(define (eval-instruction proto ins-str)
  "Evaluate the instruction string INS_STR to the prototype PROTO."
  (let ((dash-index (string-index ins-str #\-))
	(space-index (string-index ins-str #\space)))
    (proto
     (substring ins-str (+ space-index 4))
     (string-ref ins-str (1+ space-index))
     (string->number
      (substring ins-str 0 dash-index))
     (string->number
      (substring ins-str (1+ dash-index) space-index)))))

(define (count-matches proto lines)
  "Count LINES that match the instruction parsed onto the prototype PROTO."
  (length
   (filter (lambda (l) (eval-instruction proto l)) lines)))

(define (find-in-file proc file)
  (proc
   (call-with-input-file file
      (lambda (p)
	(let lines ((l (get-line p))
		    (result '()))
	  (if (eof-object? l)
	      result
	      (lines (get-line p) (cons l result))))))))
