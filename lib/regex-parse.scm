;; Parse regular expressions

(import (use "lib/parson") feed push parse grammar<-)

;; TODO: something like Python's raw string literals. \\\\ is awful.
(let grammar (grammar<- "
regex    :  exp :end.
exp      :  term ('|' exp     :either)*
         |                    :empty.
term     :  factor (term      :then)*.
factor   :  primary (  '*'    :star
                     | '+'    :plus
                     | '?'    :maybe
                    )?.
primary  :  '(' exp ')'
         |  '[' char* ']'     :join :oneof
         |  '.'               :dot
         |  '\\\\' :anyone    :literal
         |  !( '.' | '(' | ')'
             | '*' | '+' | '?'
             | '|' | '[' | ']')
            :anyone           :literal.
char     :  '\\\\' :anyone
         |  !']' :anyone.
"))

(to (regex-parser<- builder)
  (let semantics
    (map<- `((empty   ,(push (builder 'empty)))
             (literal ,(feed (builder 'literal)))
             (star    ,(feed (builder 'star)))
             (then    ,(feed (builder 'then)))
             (either  ,(feed (builder 'either)))
             (plus    ,(feed (builder 'plus)))
             (maybe   ,(feed (builder 'maybe)))
             (oneof   ,(feed (builder 'one-of)))
             (dot     ,(push (builder 'anyone))))))
  (let parser ((grammar semantics) 'regex))
  (to (parse-regex string)
    ((parse parser string) .result)))

(export regex-parser<-)
