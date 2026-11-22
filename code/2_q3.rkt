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
```[cite: 3, 4]
*(Press **Ctrl + S** to save).*

**3. Open `prompts\S1.md` in VS Code and paste Prompt 1:**
```markdown
## Prompt 1: accessors
Using the scheme-dev skill, write three small functions tree-value, tree-left, tree-right for a binary tree that is either () or (value left right). Use only car/cadr/caddr.

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