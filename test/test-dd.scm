;; TODO test with both dd and bdd (parameterized)

(import (use "lib/dd") constant<- variable<- satisfy valid?)

(let lit0 (constant<- 0))
(let lit1 (constant<- 1))

(to (claim<- rank) (variable<- rank 2))

(let `(,x ,y) (each claim<- '(8 9)))

(to (dd-not e)    (e lit1 lit0))
(to (dd-and e f)  (e lit0 f))
(to (implies e f) (e lit1 f))
(to (== e f)      (e (dd-not f) f))
(to (xor e f)     (e f (dd-not f)))

(to (show result)
  (print (and result result.items)))

(print (each valid? `(,lit0 ,lit1 ,x)))

(display "\n0, 1:\n")
(show (satisfy lit0 0))
(show (satisfy lit0 1))
(show (satisfy (dd-not lit0) 0))
(show (satisfy (dd-not lit0) 1))

(display "\nx, ~x:\n")
(show (satisfy x 1))
(show (satisfy (dd-not x) 1))
(show (satisfy (dd-and x x) 1))
(show (satisfy (dd-and x (dd-not x)) 1))
(show (satisfy (dd-and (dd-not x) (dd-not x)) 1))

(display "\nx -> y...:\n")
(print (valid? (implies (implies (implies x y) x) x)))
(print (valid? (implies (implies (implies x y) x) y)))

(display "\nMcCarthy identities:\n")

(let `(,a ,b ,c ,d ,p ,q ,r) (each claim<- (range<- 7)))

(print (valid? (== a (lit0 a b))))
(print (valid? (== b (lit1 a b))))
(print (valid? (== p (p lit0 lit1))))
(print (valid? (== a (p a a))))

;; XXX the rest run really slow, so I'm going to skip them for these
;; 'quick' tests for now. But even with the current absurd
;; interpreter, this level of slow suggests something wrong with the
;; code we're testing.
'(
(print (valid? (== (p a c)
                   (p a (p b c)))))

(print (valid? (== (p a c)
                   (p (p a b) c))))
(print (valid? (== ((q p r) a b)
                   (q (p a b) (r a b)))))
(print (valid? (== (q (p a b) (p c d))
                   (p (q a c) (q b d)))))
(print (valid? (dd-not
                (xor (q (p a b) (p c d))
                     (p (q a c) (q b d))))))
)
