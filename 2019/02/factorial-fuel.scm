(import (scheme base) (scheme file) (scheme process-context) (scheme write))

(define println
  (lambda (line)
    (display line)
    (newline)))

(define fuel-for-mass
  (lambda (mass)
    (let ((fuel (- (truncate/ mass 3) 2)))
      (if (< fuel 0)
	  0
	  (+ fuel (fuel-for-mass fuel))))))

(define input-file (cadr (command-line)))

(define sum-fuels
  (lambda (port)
    (let ((line (read-line port)))
      (cond
       ((eof-object? line) 0)
       (else
	(+ (fuel-for-mass (string->number line))
	   (sum-fuels port)))))))

(println (call-with-input-file input-file sum-fuels))
