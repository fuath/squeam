;; Run a whole lot of examples, none of which should take long.

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
(((loud-use "lib/roman") 'main) '(_ "mcmlxix" "1969" "i" "0"))

(loud-use "test/test-export-import")
(loud-use "test/test-quasiquote")
(loud-use "test/test-strings")
(loud-use "test/test-continuations")
(loud-use "test/test-pattern-matching")
(loud-use "test/test-use")

(loud-use "test/test-hashmap")
(loud-use "test/test-format")
(loud-use "test/test-flexarray")
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
((loud-use "test/test-pairing-heap") '())
(loud-use "test/test-2048")
(loud-use "test/test-kernel")
(loud-use "test/test-cycle-write")
(loud-use "test/test-sokoban")
(loud-use "test/test-pretty-print")
(loud-use "test/test-bag")
(loud-use "test/test-text-wrap")
(loud-use "test/test-regex-gen")
(loud-use "test/test-random")
(loud-use "test/test-format-tables")

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
(loud-use "eg/squickcheck-examples")
(((loud-use "eg/slow-life") 'smoke-test))
(((loud-use "eg/oodles") 'main) '(_ "garlic"))
(((loud-use "eg/trivial72") 'main) '(_))
(((loud-use "eg/trm") 'main) '(_))
(((loud-use "eg/tusl") 'main) '(_))

(loud-use "test/test-metaterp")
