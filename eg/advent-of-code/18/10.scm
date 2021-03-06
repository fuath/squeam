;; (Use run.scm to run this.)

(let input (with-input-file '.read-lines data-file))

(let parse
  (simple-parser<- "'position=<'_ :int ','_ :int :hug ['> velocity=<'_ :int ','_ :int '>' :hug]"))

(let states (each parse input))


(display "\nPart 1\n")

;; TODO just skip ahead using x = v*t

(to (part1)
  (let `(,ps0 ,vs) (transpose states))
  (show ps0)
  (begin stepping ((t 1) (ps ps0))
    (when (100 .divides? t)
      (format "time ~w\n" t))
    (let next (zip-with vector+ ps vs))
    (when (< 10500 t)
      (format "After ~w seconds:\n" t)
      (if #yes ;(compact? next)
          (show next)
          (format "spread\n")))
    (when (< t 11000)
      (stepping (+ t 1) next))))

(to (compact? ps)
  (let `((,xl ,yl) (,xh ,yh)) (bounds<- ps))
  (let dy (- yh yl))
  (< dy 50))
;;that could use zip-with too

(to (show points)
  (let `((,xl ,yl) (,xh ,yh)) (bounds<- points))
  (let dx (- xh xl))
  (let dy (- yh yl))
  (format "spread: ~w ~w\n" dx dy)
  (when (< dx 100)
    (let set (set<-list points))
    (for each! ((y (yl .to yh)))
      (for each! ((x (xl .to xh)))
        (display (if (set `(,x ,y)) #\# #\.)))
      (newline))
    (newline)))

(format "~w\n" (part1))
