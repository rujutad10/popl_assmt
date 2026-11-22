#lang racket/base

(define (my-length lst)
  (let loop ((remaining lst)
             (count 0))
    (if (null? remaining)
        count
        (loop (cdr remaining)
              (+ count 1)))))

(define (my-reverse lst)
  (let loop ((remaining lst)
             (result '()))
    (if (null? remaining)
        result
        (loop (cdr remaining)
              (cons (car remaining) result)))))

(define (my-map f lst)
  (let loop ((remaining lst)
             (result '()))
    (if (null? remaining)
        (my-reverse result)
        (loop (cdr remaining)
              (cons (f (car remaining)) result)))))

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

(define (insert-if-short x lst n)
  ((make-inserter x
                  (lambda (len)
                    (< len n)))
   lst))

(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))

;; Test 1: First assignment example
(display (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
(newline)

;; Test 2: Second assignment example
(display (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))
(newline)

;; Test 3: Empty top-level list, positive threshold
(display (insert-if-short 7 '() 3))
(newline)

;; Test 4: Empty top-level list, zero threshold
(display (insert-if-short 7 '() 0))
(newline)

;; Test 5: List length equal to threshold
(display (insert-if-short 9 '(1 2 3) 3))
(newline)

;; Test 6: List length less than threshold
(display (insert-if-short 5 '(1 2) 10))
(newline)

;; Test 7: Nested empty list
(display (insert-if-short 'x '(() (1)) 2))
(newline)


;; Test 7: Nested empty list
(display (insert-if-short 'x '(() (1)) 2))
(newline)
