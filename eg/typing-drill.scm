;; How fast do you type?

(import (use "lib/sturm") cbreak-mode render cursor get-key)

(to (main _)
  (cbreak-mode interact))

(to (interact)
  (show 0 "(Start typing...)")
  (let strokes (flexarray<- (get-key)))
  (let start (nano-now))
  (begin typing ()
    (show (/ (- (nano-now) start) 1000000000)
          (string<-list strokes))
    (case (stdin.ready?
           (match (get-key)
             ('esc
              'done)
             ('backspace
              (unless strokes.empty?
                strokes.pop!)
              (typing))
             (key
              (when (char? key)
                (strokes .push! key))
              (typing))))
          (else
           ;; XXX This polling/sleeping approach sucks, but it's
           ;; supported by the underlying Scheme.
           (nanosleep 50000000)  ; 1/20 sec
           (typing)))))

(to (show t body)
  (let cps (if (or (= t 0) body.empty?)
               0
               (/ (- body.count 1) t)))
  (let wpm (/ (* cps 60) 5))
  (render `(,("~w seconds  ~w words/minute"
              .format (floor t) (floor wpm))
            "   (Hit Esc to quit.)\n\n"
            ,body ,cursor)))
