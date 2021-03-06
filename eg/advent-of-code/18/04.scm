;; (Use run.scm to run this.)

(let input (with-input-file '.read-lines data-file))

(let grammar (grammar<- "
shifts:    shift* :end.
shift:     start [nap* :hug] :hug.
start:     timestamp :drop 'Guard #' :nat ' begins shift\n'.

nap:       timestamp 'falls asleep\n'
           timestamp 'wakes up\n'    :hug.

timestamp: '[' date _ time ']' _.
date:      (!_ :skip)+.
time:      :nat :drop ':' :nat.

_:         :whitespace.
"))
(let grammar/semantics (grammar (map<-)))
(let parse-shifts (grammar/semantics 'shifts))

(to (parse string)
  ('.results (parson-parse parse-shifts string)))

(let shifts (parse (chain-lines (sort input))))

(let zzzs (map<-))            ; guard -> bag of minutes they're asleep
(for each! ((`(,guard ,naps) shifts))
  (for each! ((nap naps))
    ((zzzs .get-set! guard bag<-) .add-all! (call range<- nap))))

(let guards zzzs.keys)

;; TODO another idea: mapreduce the shifts to concatenate the naps for each guard,
;; producing an overall map guard -> naps


(display "Part 1\n")

(to (tally-winks guard)
  (let bag (zzzs guard))
  (sum bag.values))                     ;TODO bag.total or something

(to (max-winks guard)
  (let bag (zzzs guard))
  (max-by bag bag.keys))

(let guard1 (max-by tally-winks guards))
(print `(the sleepiest is ,guard1 at ,(tally-winks guard1) minutes))

(let minute1 (max-winks guard1))
(format "their sleepiest minute is ~w\n" minute1)
(format "result code ~w\n" (* guard1 minute1))


(display "\nPart 2\n")

(to (winks-at-max guard)
  ((zzzs guard) (max-winks guard)))

(let guard2 (max-by winks-at-max guards))
(let minute2 (max-winks guard2))

(print `(count ,(winks-at-max guard2) minute ,minute2 guard ,guard2))
(print `(result code ,(* minute2 guard2)))
