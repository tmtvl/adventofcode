(use-modules (ice-9 textual-ports))

(define (read-nql-from-input-file file)
  (if (not (file-exists? file))
      (error "File does not exist: READ-NQL-FROM-INPUT-FILE" file)
      (call-with-input-file
	  file
	(lambda (p)
	  (let* ((s (get-string-all p))
		 (lps (string-count s #\())
		 (rps (string-count s #\))))
	    (- lps rps))))))

(for-each (lambda (f)
	    (display (read-nql-from-input-file f))
	    (newline))
	  (cdr (command-line)))
