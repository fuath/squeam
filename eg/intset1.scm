;; An example from William Cook's essay on OOP vs. ADTs
;; http://www.cs.utexas.edu/~wcook/Drafts/2009/essay.pdf

(make empty-set
  ({.empty?}   #yes)
  ({.has? _}   #no)
  ({.adjoin k} (adjoin<- k empty-set))
  ({.merge s}  s))

(to (adjoin<- n s)
  (if (s .has? n)
      s
      (make extension
        ({.empty?}   #no)
        ({.has? k}   (or (= n k) (s .has? k)))
        ({.adjoin k} (adjoin<- k extension))
        ({.merge s}  (merge<- extension s)))))

(to (merge<- s1 s2)
  (make meld
    ({.empty?}   (and s1.empty? s2.empty?))
    ({.has? k}   (or (s1 .has? k) (s2 .has? k)))
    ({.adjoin k} (adjoin<- k meld))
    ({.merge s}  (merge<- meld s))))

;; Smoke test

(hide
 (let eg ((empty-set .adjoin 6) .adjoin 5))

 (print (eg .has? 5))
 (print (eg .has? 6))
 (print (eg .has? 7))
)
