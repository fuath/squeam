;; (Use run.scm to run this.)

(let input (with-input-file '.read-lines data-file))

(let initial-lineup (input.first .slice ("initial state: " .count)))

(let parse
  (simple-parser<- "{:skip :skip :skip :skip :skip} ' => ' :anyone"))

(let inputs (each parse input.rest.rest))


(display "\nPart 1\n")

(let rules
  ('.range (for where ((outcome (map<- inputs)))
             (= outcome "#"))))

(to (state<-lineup lineup)
  ('.range (for where ((ch lineup))
             (= ch #\#))))

(to (part1)
  (let state0 (state<-lineup initial-lineup))
  (let state (after-generations 20 state0))
  (sum state.keys))

(to (after-generations n state0)
  (for foldl ((state state0) (i (0 .to< n)))
    (format "~w: sum ~w\n" i (sum state.keys))
    (generate state)))

(to (generate state)
  (if state.empty?
      state
      (do (let `(,lo ,hi) (bounds-1d<- state.keys))
          ('.range (for those ((pot ((- lo 2) .to (+ hi 2))))
                     (generate-1 state pot))))))

(to (generate-1 state pot)
  (let key (string<- (at state (- pot 2))
                     (at state (- pot 1))
                     (at state pot)
                     (at state (+ pot 1))
                     (at state (+ pot 2))))
  (rules key))

(to (at state pot)
  (if (state pot) #\# #\.))

(format "~w\n" (part1))

;; part2 done by leting part1 run longer, extrapolating the sums by inspection
