(to (expect expected value)
  (unless (= expected value)
    (error "Smoke test failed" expected value)))

(expect 42           42)
(expect 'hello       'hello)
; (print (make _))
(expect '()          ((make (xs xs))))
(expect '(1 2 3)     ((make (xs xs)) 1 2 3))
(expect 2            (if #no 1 2))
(expect 1            (if #yes 1 2))
(expect 'no          ((make ('(#no) 'no) (_ 'yes)) #no))
(expect 'yes         ((make ('(#no) 'no) (_ 'yes)) #yes))
(expect '(hello yes) `(hello ,(if #yes 'yes 'no)))
(expect 5            (2 .+ 3))
(expect 55           (hide (let x 55)))
(expect 136          (hide (to (f) 136) (f)))
(expect 120          (hide
                       (to (factorial n)
                         (match n
                           (0 1)
                           (_ (n .* (factorial (n .- 1))))))
                       (factorial 5)))
