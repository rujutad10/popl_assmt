#lang racket/base

;; Calculates the number of top-level elements in a list.
(define (my-length lst)
  (let loop ((remaining lst)
             (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining)
              (+ count 1)))))

;; Reverses a list using tail recursion.
(define (my-reverse lst)
  (let loop ((remaining lst)
             (result '()))
    (if (null? remaining)
        result
        (loop (cdr remaining)
              (cons (car remaining) result)))))

;; Applies a function to every element of a list.
(define (my-map f lst)
  (let loop ((remaining lst)
             (result '()))
    (if (null? remaining)
        (my-reverse result)
        (loop (cdr remaining)
              (cons (f (car remaining)) result)))))

;; Creates a function that recursively inserts x
;; into every list satisfying len-ok?.
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

;; Inserts x into every list whose original length is less than n.
(define (insert-if-short x lst n)
  ((make-inserter x
                  (lambda (len)
                    (< len n)))
   lst))

;; Reads x, lst and n, then prints the result.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))

         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
