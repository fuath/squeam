(import (use "lib/regex-gen") regex-generate regex-parse)

(to (test regex n)
  (let r (regex-parse regex))
  (format "~d (~w)\n~d\n" regex n ("-" .repeat regex.count))
  (let Ns ((0 .to n) .range))
  (for each! ((string (regex-generate r Ns)))
    (format "~w\n" string))
  (newline))

(print (regex-parse "."))

(test "." 2)
(test "X" 2)
(test "XY" 3)
(test "X|Y" 2)
(test "X+" 3)
(test "a(b|c)*d" 4)
(test "a.*d" 5)
(test "a[bc]*d" 4)
(test "a[x]+z()*|c.hi" 5)

;; Suppressed for faster testing for now
;;(test "(Chloe|Yvette), a( precocious)? (toddler|writer)" 28)
