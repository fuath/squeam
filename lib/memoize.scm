(make not-yet)

(define (memoize f)
  (let memos (map<-))
  (define (memoized @arguments)
    (let value (memos .get arguments not-yet))
    (if (= value not-yet)
        (do (let computed (call f arguments))
            (memos .set! arguments computed)
            computed)
        value)))

(export memoize)
