;; Run a whole lot of examples, none of which should take long.

(print 42)
(print 'hello)
; (print (make _))
(print ((make (xs xs))))
(print ((make (xs xs)) 1 2 3))
(print (if #no 1 2))
(print (if #yes 1 2))
(print ((make ((#no) 'no) (_ 'yes)) #no))
(print ((make ((#no) 'no) (_ 'yes)) #yes))
(print `(hello ,(if #yes 'yes 'no)))
(print (2 .+ 3))
(print (hide (let x 55)))
(print (hide (to (f) 136) (f)))
(print (hide
        (to (factorial n)
          (match n
            (0 1)
            (_ (n .* (factorial (n .- 1))))))
        (factorial 10)))

(to (loud-use filename)
  (newline)
  (display "-------- ")
  (display filename)
  (display " --------")
  (newline)
  (use filename))

(loud-use "lib/memoize")
(loud-use "lib/parson-core")
(loud-use "lib/regex-match")
(loud-use "lib/parse")
(loud-use "lib/unify")

(loud-use "test/test-export-import")
(loud-use "test/test-quasiquote")
(loud-use "test/test-strings")
(loud-use "test/test-continuations")
(loud-use "test/test-pattern-matching")
(loud-use "test/test-use")

(loud-use "test/test-hashmap")
(loud-use "test/test-format")
(loud-use "test/test-fillvector")
(loud-use "test/test-sort")
(loud-use "test/test-hashset")
(loud-use "test/test-memoize")
(loud-use "test/test-regex-match")
(loud-use "test/test-parson")
(loud-use "test/test-parson-squared")
(loud-use "test/test-parse")
(loud-use "test/test-unify")
(loud-use "test/test-complex")
(loud-use "test/test-dd")
(loud-use "test/test-ratio")
(loud-use "test/test-text")
(loud-use "test/test-huffman")
(loud-use "test/test-pairing-heap")
(loud-use "test/test-2048")
(loud-use "test/test-kernel")
(loud-use "test/test-cycle-write")
(loud-use "test/test-sokoban")
(loud-use "test/test-pretty-print")
(loud-use "test/test-bag")
(loud-use "test/test-text-wrap")
(loud-use "test/test-regex-gen")

(loud-use "eg/compact-lambda")
(loud-use "eg/sicp1")
(loud-use "eg/sicp2")
(loud-use "eg/lambdacompiler")
(loud-use "eg/intset1")
(loud-use "eg/intset2")
(loud-use "eg/circuitoptimizer")
(loud-use "eg/fizzbuzz")
(loud-use "eg/failing")
(loud-use "eg/lambdaterp")
(loud-use "eg/tictactoe")
(loud-use "eg/max-path-sum")
(((loud-use "eg/slow-life") 'smoke-test))
(((loud-use "eg/oodles") 'main) '(_ "garlic"))
(((loud-use "eg/trivial72") 'main) '(_))
(((loud-use "eg/trm") 'main) '(_))
(((loud-use "eg/tusl") 'main) '(_))

(loud-use "test/test-metaterp")
