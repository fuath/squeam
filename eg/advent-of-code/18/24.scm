;; (Use run.scm to run this.)

(import (use "lib/pretty-print")
  pp)

(let input (with-input-file '.read-all data-file))

;; Return yes if Immune System wins.
(to (battle armies)
  (begin battling ()
    (let immune-system (armies "Immune System"))
    (let infection     (armies "Infection"))
    (format "Round: ~w vs. ~w\n" 
            (each '.count infection)
            (each '.count immune-system))
;    (when (= (each '.count infection) '(1273))
;      (error "break"))
    (let a1 (select-targets "Infection"     infection immune-system))
    (let a2 (select-targets "Immune System" immune-system infection))
    (let counts-before (for each ((groups armies.values))
                         (sum (each '.count groups))))
    (case ((some '.empty? armies.values)
           (not immune-system.empty?))
          (else
           ;; Fight a round.
           (attacking (map<- (chain a1 a2)))
           (for each! ((`(,army ,groups) armies.items))
             (armies .set! army (those '.alive? groups)))
          
           (let counts-after (for each ((groups armies.values))
                               (sum (each '.count groups))))
           (if (= counts-before counts-after)
               #no      ; Stalemate
               (battling))))))

(to (select-targets my-name my-groups enemy-groups)
  (let result (flexarray<-))
  (let enemies (flexarray<-list enemy-groups)) ;; clumsy? probably ought to be a set
  (let enemy-nums (flexarray<-list (1 .to enemy-groups.count)))  ;; just for the messages
  (for each! ((`(,i ,group) (sort-by (given (`(,_ ,group)) group.target-selection-key)
                                     my-groups.items)))
    (unless enemies.empty?
      (let damages (for each ((enemy enemies.values))
                     (group .would-damage enemy)))
;;      (for each! ((`(,j ,damage) damages.items))
;;        (format "~d group ~w would deal defending group ~w ~w damage\n"
;;                my-name (+ i 1) (enemy-nums j) damage))
      (let j (for max-by ((j enemies.keys))
               (let enemy (enemies j))
               (list<- (damages j)   ;; or just compute it here
                       enemy.effective-power
                       enemy.initiative)))
      (when (< 0 (damages j))
        (result .push! `(,group ,(enemies j)))
        (enemies .pop! j)
        (enemy-nums .pop! j))))
  result.values)

(to (attacking selections)
  (for each! ((group (sort-by (given (g) (- g.initiative))
                              selections.keys)))
    (when group.alive?
      (match (selections .get group)
        (#no)
        (target (group .attack! target))))))

(to (cook-group n-units hit-points qualities attack-damage attack-type initiative)
  (let immunities (set<-))
  (let weaknesses (set<-))
  (for each! ((`(,type ,attack-strings) qualities)) ;TODO could use a group-by or map-reduce again
    (let set (match type
               ("immune" immunities)
               ("weak"   weaknesses)))
    (set .add-all! (each symbol<- attack-strings)))
  (given (army-boost)
    (group<- n-units hit-points immunities weaknesses
             (+ army-boost attack-damage) (symbol<- attack-type) initiative)))

(to (group<- initial-n-units hit-points immunities weaknesses
             attack-damage attack-type initiative)
  (let n-units (box<- initial-n-units))
  (to (effective-power) (* n-units.^ attack-damage))
  (surely (not (immunities .intersects? weaknesses)))  ; TODO method .disjoint?
  (let qualities (map<- (chain (for each ((immune immunities.keys)) `(,immune immunity))
                               (for each ((weak   weaknesses.keys)) `(,weak weakness)))))
  (make group
    ({.count} n-units.^)
    ({.effective-power} (effective-power))
    ({.initiative} initiative)
    ({.target-selection-key} (list<- (- (effective-power)) (- initiative)))
    ({.would-damage target}
     (target .damage-from attack-type (effective-power)))
    ({.attack! target}
;;     (format "attack: ~w ~w\n" attack-type (effective-power))
     (target .receive! attack-type (effective-power)))
    ({.damage-from attacker-attack-type attack-power}
     (match (qualities .get attacker-attack-type)
       ('immunity 0)
       ('weakness (* 2 attack-power))
       (#no       attack-power)))
    ({.receive! attacker-attack-type attack-power}
     (let damage (group .damage-from attacker-attack-type attack-power))
     (let mortality (min n-units.^ (damage .quotient hit-points)))
     (n-units .^= (- n-units.^ mortality))
;;     (format "power ~w, damage ~w, killing ~w units, leaving ~w\n"
;;             attack-power damage mortality n-units.^)
     )
    ({.alive?} (< 0 n-units.^))
    ({.show}
     (pp {group {size n-units.^}
                {hp hit-points}
                {immune-to immunities.keys}
                {weak-to weaknesses.keys}
                {attack attack-damage attack-type {initiative initiative}}}))))

(let grammar (grammar<- "
main: army**separator :end.
army: army_name ':\n' [group* :hug] :hug.
army_name: { (!':' :skip)* }.
group: :nat ' units each with ' :nat ' hit points ' opt_qualities 
       'with an attack that does ' :nat ' ' word 
       ' damage at initiative ' :nat '\n' :Group.
opt_qualities: '(' qualities ') ' | :hug.
qualities: quality_list++'; ' :hug.
quality_list: {'weak'|'immune'} ' to ' [word++', ' :hug] :hug.
word: :letter+ :join.  # TODO ugly
separator: '\n'.
"))
(let semantics (grammar (map<- `((Group ,(feed cook-group))))))
(let parse-main (semantics 'main))
(to (parse string)
  ('.results (parson-parse parse-main string)))

(let matchup (parse input))


(display "\nPart 1\n")

(to (show-count armies)
  (for each! ((`(,army ,groups) (sort armies.items)))
    (format "~d:\n" army)
    (for each! ((`(,i ,group) groups.items))
      (format "Group ~w contains ~w units\n" (+ i 1) group.count))))

(to (part-1)
  (let armies (map<- (for each ((`(,name ,group-makers) matchup))
                       `(,name ,(for each ((group-maker group-makers))
                                  (group-maker 0))))))
  (show-count armies)
  (battle armies)
;;  (sum (each '.count (call chain armies.values)))  TODO is this nicer?
  (sum (for gather ((groups armies.values))
         (each '.count groups))))

(format "Part 1: ~w\n" (part-1))


(display "\nPart 2\n")

(to (part-2)
  (begin bounding ((low 0))
    (let high (max 1 (* low 2)))
    (if (enough-boost? high)
        (binary-search enough-boost? low high)
        (bounding high))))

(to (enough-boost? boost)
  (let armies (map<- (for each ((`(,name ,group-makers) matchup))
                       `(,name ,(do (let my-boost (match name
                                                    ("Immune System" boost)
                                                    (_               0)))
                                    (for each ((group-maker group-makers))
                                      (group-maker my-boost)))))))
  (format "Trying immune boost of ~w\n" boost)
  (let win? (battle armies))
  (format "Immune boost of ~w ~d\n" boost (if win? "WORKED!" "failed"))
  (when win?
    (format "leaving ~w units\n" (sum (each '.count (armies "Immune System")))))
  (newline)
  win?)

;; Return the least number in (low..high] that's `ok?`.
;; Pre: low is not ok, and high is.
;; Pre: there's just one cross-over point.
;; TODO redesign, extract to lib
(to (binary-search ok? low high)
  (begin searching ((L low) (H high))
    (surely (< L H))
    (if (= (+ L 1) H)
        H
        (do (let M ((+ L H) .quotient 2))
            (surely (< M H))
            (if (ok? M)
                (searching L M)
                (searching M H))))))

(format "Part 2: ~w\n" (part-2))
