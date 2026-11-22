#lang racket/base

;; Returns the value stored at the root of a non-empty binary tree node.
(define (tree-value t)
  (car t))

;; Returns the left subtree of a non-empty binary tree node.
(define (tree-left t)
  (cadr t))

;; Returns the right subtree of a non-empty binary tree node.
(define (tree-right t)
  (caddr t))

;; Returns the inorder traversal list (left, node, right) of tree t prepended to acc.
(define (inorder t acc)
  (if (null? t)
      acc
      (inorder (tree-left t)
               (cons (tree-value t)
                     (inorder (tree-right t) acc)))))

;; Returns the preorder traversal list (node, left, right) of tree t prepended to acc.
(define (preorder t acc)
  (if (null? t)
      acc
      (cons (tree-value t)
            (preorder (tree-left t)
                      (preorder (tree-right t) acc)))))

;; Returns the postorder traversal list (left, right, node) of tree t prepended to acc.
(define (postorder t acc)
  (if (null? t)
      acc
      (postorder (tree-left t)
                 (postorder (tree-right t)
                            (cons (tree-value t) acc)))))

;; Returns a two-element list (height leaf-count) for binary tree t.
(define (height-and-leaves t)
  (if (null? t)
      (list 0 0)
      (if (and (null? (tree-left t)) (null? (tree-right t)))
          (list 1 1)
          (let ((l (height-and-leaves (tree-left t)))
                (r (height-and-leaves (tree-right t))))
            (list (+ 1 (max (car l) (car r)))
                  (+ (cadr l) (cadr r)))))))

;; Prints the inorder traversal list of tree followed by a newline.
(define (print-inorder tree)
  (display (inorder tree '()))
  (newline))

;; Prints the inorder, preorder, and postorder traversal lists of tree on three separate lines.
(define (print-all-traversals tree)
  (display (inorder tree '()))
  (newline)
  (display (preorder tree '()))
  (newline)
  (display (postorder tree '()))
  (newline))

;; Prints the (height leaf-count) list of tree followed by a newline.
(define (print-height-and-leaves tree)
  (display (height-and-leaves tree))
  (newline))