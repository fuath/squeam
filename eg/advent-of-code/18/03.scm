;; (Use run.scm to run this.)

(let input (with-input-file '.read-lines data-file))

(let parse
  (simple-parser<- "'#' :nat ' @ ' :nat ',' :nat ': ' :nat 'x' :nat"))

(let claims (each parse input))


(display "Part 1\n")

(to (area<- `(,_ ,x0 ,y0 ,w ,h))
  (grid* (x0 .span w) (y0 .span h)))

(let covered-area (bag<- (gather area<- claims)))

(let n-conflicts (for tally ((n covered-area.values))
                   (< 1 n)))
(print `(the area is ,n-conflicts))


(display "Part 2\n")

(to (undisputed? claim)
  (for every ((point (area<- claim)))
    (= 1 (covered-area point))))

(print `(the undisputed claims are ,(those undisputed? claims)))
