;; Game of Life again.
;; Represent a grid as a set of populated locations.
;; A location is an `(,x ,y) coordinate pair.

(import (use "lib/sturm")
  cbreak-mode)
(import (use "lib/ansi-term")
  clear-screen cursor-show cursor-hide)

(to (main args)
  (let n-steps (match args
                 (`(,_) 20)
                 (`(,_ ,n-str) (number<-string n-str))
                 (`(,prog ,@_) (error ("Usage: ~d [#steps]" .format prog)))))
  (for cbreak-mode ()
    (display cursor-hide)
    (run r-pentomino n-steps)
    (display cursor-show)))

(to (run grid n-steps)
  (for foldl ((grid grid) (_ (1 .to n-steps)))
    (display clear-screen)
    (show grid)
    (update grid)))

(to (update grid)
  (let active (bag<- (gather neighbors grid.keys)))
  ('.range (for filter ((`(,pos ,n-live) active.items))
             (match n-live
               (3 pos)
               (2 (and (grid .maps? pos) pos))
               (_ #no)))))

(to (neighbors `(,x ,y))
  (for gather ((dx '(-1 0 1)))
    (for filter ((dy '(-1 0 1)))
      (and (not= `(,dx ,dy) '(0 0))
           `(,(+ x dx) ,(+ y dy))))))

(to (show grid)
  (let `((,x-lo ,x-hi) (,y-lo ,y-hi))
    (each bounds<- (transpose grid.keys)))
  (for each! ((y (y-lo .to y-hi)))
    (for each! ((x (x-lo .to x-hi)))
      (display (if (grid .maps? `(,x ,y)) "O " "  ")))
    (newline)))

(to (bounds<- numbers)
  `(,(call min numbers)
    ,(call max numbers)))

(to (paint lines)
  ('.range (for where ((ch (map<-lines lines)))
             (not ch.whitespace?))))

(to (map<-lines lines)
  (map<- (for gather ((`(,row ,line) lines.items))
           (for each ((`(,col ,ch) line.items))
             `((,col ,(- row)) ,ch))))) ; minus so y-coordinates increase upwards

(let r-pentomino (paint '(" **"
                          "** "
                          " * ")))

(export update show paint r-pentomino)
