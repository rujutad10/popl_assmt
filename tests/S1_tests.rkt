#lang racket

(require rackunit)

;; Load all top-level definitions from ../code/2_q3.rkt into the current namespace
(define ns (make-base-namespace))
(parameterize ([current-namespace ns])
  (namespace-require "../code/2_q3.rkt"))

(define (run-fn name . args)
  (apply (namespace-variable-value name #t #f ns) args))

(define (capture-output thunk)
  (with-output-to-string thunk))

;; Example trees from assignment specification
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define empty-tree '())
(define single-node '(42 () ()))

;; Build a 10,000-deep right-skewed chain: (1 () (2 () ... (10000 () ())))
(define (make-chain n)
  (let loop ([i n] [acc '()])
    (if (= i 0)
        acc
        (loop (- i 1) (list i '() acc)))))

(define deep-chain (make-chain 10000))

;; 1. Test t1
(check-equal? (capture-output (lambda () (run-fn 'print-inorder t1)))
              "(1 2 3 4 5 6 7)\n")
(check-equal? (capture-output (lambda () (run-fn 'print-all-traversals t1)))
              "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check-equal? (capture-output (lambda () (run-fn 'print-height-and-leaves t1)))
              "(3 4)\n")

;; 2. Test t2 (right-skewed)
(check-equal? (capture-output (lambda () (run-fn 'print-all-traversals t2)))
              "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check-equal? (capture-output (lambda () (run-fn 'print-height-and-leaves t2)))
              "(3 1)\n")

;; 3. Test t3 (symbol values)
(check-equal? (capture-output (lambda () (run-fn 'print-all-traversals t3)))
              "(b a c)\n(a b c)\n(b c a)\n")
(check-equal? (capture-output (lambda () (run-fn 'print-height-and-leaves t3)))
              "(2 2)\n")

;; 4. Test empty tree ()
(check-equal? (capture-output (lambda () (run-fn 'print-inorder empty-tree)))
              "()\n")
(check-equal? (capture-output (lambda () (run-fn 'print-all-traversals empty-tree)))
              "()\n()\n()\n")
(check-equal? (capture-output (lambda () (run-fn 'print-height-and-leaves empty-tree)))
              "(0 0)\n")

;; 5. Test single node
(check-equal? (capture-output (lambda () (run-fn 'print-all-traversals single-node)))
              "(42)\n(42)\n(42)\n")
(check-equal? (capture-output (lambda () (run-fn 'print-height-and-leaves single-node)))
              "(1 1)\n")

;; 6. Test 10,000-deep chain
(check-equal? (capture-output (lambda () (run-fn 'print-height-and-leaves deep-chain)))
              "(10000 1)\n")

(displayln "All S1 tests passed!")
```[cite: 4]

**2. Run your tests in the terminal to verify everything passes (if Racket is installed on your machine):**
```cmd
cd tests && racket S1_tests.rkt && cd ..