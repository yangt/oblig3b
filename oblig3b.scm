(load "evaluator.scm")

(set! the-global-environment (setup-environment))
;;(read-eval-print-loop)
;; 1a
(mc-eval '(define (foo cond else)
           (cond ((= cond 2) 0)
                 (else (else cond)))) the-global-environment)

(mc-eval '(define cond 3) the-global-environment)
(mc-eval '(define (else x) (/ x 2)) the-global-environment)
(mc-eval '(define (square x) (* x x)) the-global-environment)
#| Test run:
(mc-eval '(foo 2 square) the-global-environment) ;; --> 0. 
#|
First and foremost, the conditial statement "(cond ..." will be correctly
recognized as a conditional statement, and not the variable "cond",
since neither self-evaluating expressions nor variable names start with "(".
Specifically this means that self-evaluating? -> number? and string? will return
false. As will variable? -> symbol?.

The variable cond binds to 2. 
cond evaluates the first statement (= cond 2) which is true, 
so 0 is returned.
|#
(mc-eval '(foo 4 square) the-global-environment)  ;; --> 16
#|
The first statement is false, so the else-statement is evaluated.
else binds to the procedure square which takes one argument. 
cond is 4 and (else cond) --> (square 4) --> 16.
|#
(mc-eval '(cond ((= cond 2) 0)
      (else (else 8)) the-global-environment) ;; --> 4
#|
Now, cond is 3. The first statement is false.
The second else is the procedure which divide the input by 2.
8 is divided by 2 which is 4.
|#
|#
;; 2a
(mc-eval '(define (1+ x) (+ x 1)) the-global-environment)
(mc-eval '(define (1- x) (- x 1)) the-global-environment)
#| Test run:
(mc-eval '(1+ 2) the-global-environment)
(mc-eval '(1- 2) the-global-environment)
|#
;; 2b
(define (install-primitive! proc-name proc)
  (set! primitive-procedures 
        (cons (list proc-name proc) primitive-procedures)))

;; 3a
;; 3b
;; 3c
;; 3d
;; 3e
;; 4
