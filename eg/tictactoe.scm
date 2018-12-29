;; Tic-tac-toe game

(import (use "lib/memoize") memoize)
(import (use "lib/sturm") cbreak-mode render get-key cursor green)

(to (main `(,me ,@args))
  (let players
    (case (args.empty? (list<- human-play spock-play))
          ((= args.count 2) (each parse-player args)) ;TODO catch errors
          (else
           (format "Usage: ~d [X-player O-player]\n" me)
           (format "Available players: ~d\n" (" " .join (sort parse-player.keys)))
           (os-exit 1))))
  (call tty-ttt `(,@players ,empty-grid)))

(to (quick-test)
  (let g {grid 0o610 0o061})
  (tic-tac-toe spock-play spock-play g))

;; Text-stream interface
(to (tic-tac-toe player opponent grid)
  (format "~d\n\n" (show grid))
  (case ((won? grid)   (format "~d wins.\n" (last-to-move grid)))
        ((drawn? grid) (format "A draw.\n"))
        (else
         (unless (`(,player ,opponent) .find? human-play)
           (format "~w to move ~d. (Press a key.)\n"
                   player (whose-move grid))
;           (get-key)                    ;XXX
           )
         (tic-tac-toe opponent player (player grid)))))

;; Graphical TTY interface
(to (tty-ttt player opponent grid)
  (for cbreak-mode ()
    (tty-playing player opponent grid)))

(to (tty-playing player opponent grid)
  (to (continue)
    (tty-playing opponent player (player grid)))
  (to (render-grid message)
    (render `(,(show grid) "\n\n" ,message)))
  (case ((won? grid)
         (render-grid ("~d wins." .format (last-to-move grid))))
        ((drawn? grid)
         (render-grid "A draw."))
        ((`(,player.name ,opponent.name) .find? 'Human)
         (continue))
        (else
         (render-grid ("~w to move ~d.\n(Press a key.)"
                       .format player.name (whose-move grid)))
         (unless (= (get-key) 'esc)  ;XXX sturm doesn't return 'esc
           ;; TODO erase the to-move msg while it's thinking
           (continue)))))

(make human-play
  ({.name} 'Human)
  (`(,grid) 
   (let prompt ("~d move? [1-9] " .format (whose-move grid)))
   (begin asking ((plaint #no))
     (render `(,(or plaint "")
               "\n\n"
               ,(if plaint (show-with-moves grid) (show grid))
               "\n\n"
               ,prompt ,cursor))
     (let key (get-key))
     (match (and (char? key)
                 (<= #\1 key #\9)
                 (apply-move grid (move<-key key)))
       (#no (asking "Hey, that's not a move. Give me one of the digits below."))
       (successor successor)))))

(to (show-with-moves grid)
  (each (highlight-if '.digit?) (show grid (1 .up-to 9))))

(to ((highlight-if special?) x)
  (if (special? x) (green x) x))

(to (move<-key digit-char)
  (- #\9 digit-char))

(make drunk-play
  ({.name} 'Drunk)
  (`(,grid) (min-by drunk-value (successors grid))))

(make spock-play
  ({.name} 'Spock)
  (`(,grid) (min-by spock-value (successors grid))))

(make max-play
  ({.name} 'Max)
  (`(,grid)
   (min-by (compound-key<- spock-value drunk-value)
           (successors grid))))

(let parse-player
  (map<- (for each ((player (list<- human-play drunk-play spock-play max-play)))
           (let string player.name.name.lowercase)
           `(,string ,player))))

(let drunk-value
  (memoize (given (grid)
             (if (won? grid)
                 -1
                 (match (successors grid)
                   ('() 0)
                   (succs (- (average (each drunk-value succs)))))))))

(let spock-value
  (memoize (given (grid)
             (if (won? grid)
                 -1
                 (match (successors grid)
                   ('() 0)
                   (succs (- (call min (each spock-value succs)))))))))

(to (average numbers)
  (/ (sum numbers) numbers.count))


(to (player-marks {grid p q})
  (if (= (sum (player-bits p))
         (sum (player-bits q)))
      "XO"
      "OX"))

(to (player-bits bits)
  (for each ((i (0 .up-to 8)))
    (1 .and (bits .>> i))))

(to (won? {grid p q})
  (for some ((way ways-to-win))
    (= way (way .and q))))

(to (drawn? grid)
  ((successors grid) .empty?))

(to (successors grid)
  (for filter ((move (0 .up-to 8)))
    (apply-move grid move)))

(to (apply-move {grid p q} move)
  (let bit (1 .<< move))
  (and (= 0 (bit .and (p .or q)))
       {grid q (p .or bit)}))

(to (whose-move grid)
  ((player-marks grid) 0))

(to (last-to-move grid)
  ((player-marks grid) 1))

(to (show {grid p q} @(optional opt-spaces))
  (let spaces (or opt-spaces ("." .repeat 9)))
  (let marks (player-marks {grid p q}))
  (let values (for each ((slot (zip (reverse (player-bits p))
                                    (reverse (player-bits q))
                                    spaces)))
                (match slot
                  (`(1 0 ,_) (marks 0))
                  (`(0 1 ,_) (marks 1))
                  (`(0 0 ,s) s))))
  (call grid-format `{.format ,@values})) ;ugh

(let grid-format ("\n" .join ('(" ~d ~d ~d") .repeat 3)))

(let ways-to-win '(0o700 0o070 0o007 0o444 0o222 0o111 0o421 0o124))

(let empty-grid {grid 0 0})

(export main quick-test)
