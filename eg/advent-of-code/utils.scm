(import (use "lib/parson-core") feed take-1)

(let parson (use "lib/parson"))
(import parson grammar<-)
(let parson-parse (parson 'parse))

(to (average numbers)
  (surely (not numbers.empty?) "Average of an empty list")
  (/ (sum numbers) numbers.count))

(to (all-mins-by fn xs)
  (for foldl ((best (list<- xs.first))
              (x xs.rest))
    (match ((fn best.first) .compare (fn x))
      (-1 best)
      ( 0 (cons x best))
      (+1 (list<- x)))))
         
(to (fill! array value)                 ;TODO should be a mutable-map-trait method
  (for each! ((i array.keys))
    (array .set! i value)))

(to (cycle xs)
  (begin cycling ((ys xs))
    (if ys.empty?
        (cycling xs)
        (cons/lazy ys.first (given () (cycling ys.rest))))))

(to (scanl/lazy f z xs)
  (begin scanning ((z z) (xs xs))
    (cons/lazy z
               (given ()
                 (if xs.empty?
                     '()
                     (scanning (f z xs.first) xs.rest))))))

;; TODO is this worth it? sometimes what you want is the filter/lazy equivalent
(to (detect include? xs)
  ((those/lazy include? xs) .first))

;; TODO I reimplemented this in 18/25.scm
(to (pairs<- xs)
  (begin outer ((outers xs))
    (unless outers.empty?
      (let x1 outers.first)
      (begin inner ((inners outers.rest))
        (if inners.empty?
            (outer outers.rest)
            (do (let x2 inners.first)
                (cons/lazy `(,x1 ,x2)
                           (given () (inner inners.rest)))))))))

(to (filter/lazy f xs)
  (foldr/lazy (given (x z-thunk)
                (let fx (f x))
                (if fx
                    (cons/lazy fx z-thunk)
                    (z-thunk)))
              xs
              (given () '())))

(to (duplicates<- xs)
  (let seen (set<-))
  (begin looking ((xs xs))
    (if xs.empty?
        '()
        (do (let x xs.first)
            (if (seen x)
                (cons/lazy x (given () (looking xs.rest)))
                (do (seen .add! x)
                    (looking xs.rest)))))))

(to (deletions<- s)
  (for each ((i (range<- s.count)))
    `(,(s .slice 0 i)
      ,(s .slice (+ i 1)))))

(to (chain-lines lines)
  (call chain (for each ((line lines))
                (chain line "\n"))))

;; I wish Parson made this convenient without the wrapper:
(to (simple-parser<- template)
  (let grammar (grammar<- (chain "start: " template " :end.\n"
                                 "_ = :whitespace*.")))
  (let peg ((grammar (map<-)) 'start))
  (make parser
    (`(,string)     ((parson-parse peg string) .results))
    ({.parse string} (parson-parse peg string))))

;; TODO how much slower is this?
;; (to (neighbors<- p)
;;   (for filter ((d (grid* '(-1 0 1) '(-1 0 1))))
;;     (and (not= d '(0 0))
;;          (vector+ p d))))
(to (neighbors8<- `(,x ,y))
  (for gather ((dx '(-1 0 1)))
    (for filter ((dy '(-1 0 1)))
      (and (not= `(,dx ,dy) '(0 0))
           `(,(+ x dx) ,(+ y dy))))))

(to (vector+ p q) (zip-with + p q))
(to (vector- p q) (zip-with - p q))

(to (manhattan-distance<- p q)
  (sum (zip-with (compose abs -) p q)))

(to (bounds<- points)
  (transpose (each bounds-1d<- (transpose points))))

(to (bounds-1d<- ns)
  `(,(call min ns) ,(call max ns)))

(export
  cycle scanl/lazy detect pairs<- filter/lazy 
  duplicates<- deletions<-
  chain-lines all-mins-by average neighbors8<-
  simple-parser<- vector+ vector- manhattan-distance<-
  grammar<- parson-parse feed take-1
  bounds<- bounds-1d<- 
  )
