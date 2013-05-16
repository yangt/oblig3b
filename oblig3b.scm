#| Delivery for
    Martin Vonheim Larsen (martinvl)
    Mathis Kappeler (mathisk)
    Yang Tran (yangt)
|#

(load "evaluator.scm")

(set! the-global-environment (setup-environment))

;; 1a
(mc-eval '(define (foo cond else)
           (cond ((= cond 2) 0)
                 (else (else cond)))) the-global-environment)

(mc-eval '(define cond 3) the-global-environment)
(mc-eval '(define (else x) (/ x 2)) the-global-environment)
(mc-eval '(define (square x) (* x x)) the-global-environment)
#| --- Test ---
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
#| --- Test case ---
(mc-eval '(1+ 2) the-global-environment)
(mc-eval '(1- 2) the-global-environment)
|#

;; 2b
(define (install-primitive! proc-name proc)
  (set! primitive-procedures 
        (cons (list proc-name proc) primitive-procedures)))

#| --- Test case ---
(install-primitive! 'square (lambda (x) (* x x))
(install-primitive! 'square (lambda (x) (* x x)))
(mc-eval '(square 8) the-global-environment)
|#

;; 3a
#| Made changes to evaluator.scm:
at line 73 and 74, added and? and or? clause in eval-special-form
at line 85 and 86, added and? and or? clause in special-form?
at line 124, added check for boolean self-evaluating expressions
below line 253, added eval-and, eval-or, and? and or?
|#
#| --- Test case ---
(mc-eval '(define (and-test)
           (and #t #t)) the-global-environment)
(mc-eval '(define (or-test)
           (and #t #f)) the-global-environment)

(mc-eval '(and #t #t #t #t) the-global-environment) ;; #t
(mc-eval '(and #t #t #f #f) the-global-environment) ;; #f
(mc-eval '(or #f #f #f #t) the-global-environment) ;; #t
(mc-eval '(or #t #f #f #t) the-global-environment) ;; #t
(mc-eval '(or #f #f #f #f) the-global-environment) ;; #f
|#

;; 3b
;; line 64 in evaluator.scm: 
;; calls the function eval-if-switch defined below

(define (eval-if-switch exp env)
  (if (tagged-list? (cddr exp) 'then)
      (eval-if-then exp env)
  (eval-if exp env)))

(define (eval-if-then exp env)
  (cond ((tagged-list? exp 'else)
         (mc-eval (cadr exp) env))
        ((and (or (tagged-list? exp 'if)
                  (tagged-list? exp 'elsif))
                  (mc-eval (cadr exp) env)) 
         (mc-eval (cadddr exp) env))
        (else (eval-if-then (cddddr exp) env))))
 
#| Test
(if (= 3 2) 
then 'a 
elsif (= 3 2) 
then 'b 
else 'c) 
;; --> c

(if (= 3 2) 
then 'a 
elsif (= 3 2) 
then 'fdsf 
elsif (= 3 2) 
then 'dfd 
elsif (= 3 3) 
then 'b 
else 'c)
;; --> b
|#
      
;; 3c
#| Made changes to evaluator.scm:
at line 72, added let? clause in eval-special-form
at line 84, added let? clause in special-form?
below line 280, added let?, let-args, let-vars, let-exps, let-body and eval-let
|#

#| --- Test case ---
(mc-eval '(let ((foo 2) (bar 3)) (+ (* 8 bar) foo)) the-global-environment) ;; 26
|#

;; 3d
#| Made changes to evaluator.scm:
below line 294, added alt-let-args, alt-let-vars, alt-let-exps, alt-let-body

uncomment the alternative implementation of eval-let at line 321 to test
|#
#| --- Test case --- 
(mc-eval '(let x = 2 and y = 3 in (display (cons x y)) (+ x y)) the-global-environment) ;; 5
|#

;; 3e
;; 4
