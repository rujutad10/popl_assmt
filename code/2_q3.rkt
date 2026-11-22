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
```[cite: 3, 4]

**2. Add Prompt 5 to the bottom of `prompts\S1.md` and press `Ctrl + S`:**
```markdown
Prompt 5: height and leaves

Write (height-and-leaves t) that returns (list height leaf-count). Height of () is 0, a single node has height 1, a leaf is a node whose left and right are both (), and the empty tree has 0 leaves. Only whitelisted built-ins.