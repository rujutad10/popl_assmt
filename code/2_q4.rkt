
#lang racket/base

;; CS F301 - Principles of Programming Languages
;; Assignment 2 - S2: Conditional Insert

;; S2.b - Calculate the length of a list

(define (my-length lst)
  (let loop ((remaining lst)
             (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining)
              (+ count 1)))))


;; S2.b - Apply a function to every element

(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))


;; S2.c - Create a function that conditionally inserts x

(define (make-inserter x len-ok?)
  (letrec
      ((walk
        (lambda (lst)
          (let ((processed
                 (my-map
                  (lambda (item)
                    (if (or (null? item) (pair? item))
                        (walk item)
                        item))
                  lst)))
            (if (len-ok? (my-length lst))
                (cons x processed)
                processed)))))
    walk))


;; S2.b and S2.c - Insert x into lists shorter than n

(define (insert-if-short x lst n)
  ((make-inserter x
                  (lambda (len)
                    (< len n)))
   lst))


;; S2.a - Read input and print the result

(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
