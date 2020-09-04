(use-modules (ice-9 textual-ports))

(define (parentheses-to-numbers port nums)
  (let ((c (read-char port)))
    (cond ((eof-object? c) (reverse nums))
	  ((eq? c #\() (parentheses-to-numbers port (cons 1 nums)))
	  ((eq? c #\)) (parentheses-to-numbers port (cons -1 nums)))
	  (else (parentheses-to-numbers port nums)))))

(define (first-basement-hit nums current-floor position)
  (if (null? nums)
      -1
      (let ((ncf (+ current-floor (car nums)))
	    (np (1+ position)))
	(if (negative? ncf)
	    np
	    (first-basement-hit (cdr nums)
				ncf
				np)))))

(define (read-nql-from-input-file file)
  (if (not (file-exists? file))
      (error "File does not exist: READ-NQL-FROM-INPUT-FILE" file)
      (call-with-input-file
	  file
	(lambda (p)
	  (let ((nums (parentheses-to-numbers p '())))
	    (first-basement-hit nums 0 0))))))

(for-each (lambda (f)
	    (display (read-nql-from-input-file f))
	    (newline))
	  (cdr (command-line)))
