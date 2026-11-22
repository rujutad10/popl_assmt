
#lang racket/base

(require "../code/2_q4.rkt")

;; Test 1: Main example
(display (insert-if-short 42
                          '((1 2) (3 4 5) (6) ())
                          3))
(newline)

;; Test 2: Nested lists
(display (insert-if-short 0
                          '(((1) 2) (3) ((4 5 6) ()))
                          3))
(newline)

;; Test 3: Empty top-level list
(display (insert-if-short 7 '() 3))
(newline)

;; Test 4: Empty list with n = 0
(display (insert-if-short 7 '() 0))
(newline)

;; Test 5: Length exactly equal to n
(display (insert-if-short 9 '(1 2 3) 3))
(newline)

;; Test 6: Length less than n
(display (insert-if-short 5 '(1 2) 10))
(newline)

;; Test 7: Nested empty list
(display (insert-if-short 'x '(() (1)) 2))
(newline)
