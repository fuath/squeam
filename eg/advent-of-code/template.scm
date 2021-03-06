(let input (with-input-file '.read-lines data-file))
;(each! print (input .slice 0 5))

(let parse
  (simple-parser<- "(:int | :skip)*"))

(let grammar (grammar<- "
main: '#' :nat ' @ ' :nat ',' :nat ': ' :nat 'x' :nat :end.
"))
(let semantics (grammar (map<-)))
(let parse-main (semantics 'main))
(to (parse string)
  ('.results (parson-parse parse-main string)))

(let inputs (each parse input))
;(print inputs)


(display "\nPart 1\n")

(to (part-1)
  'xxx)

(format "~w\n" (part-1))


;(display "\nPart 2\n")

(to (part-2)
  'xxx)

;(format "~w\n" (part-2))
