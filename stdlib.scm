(define (union set1 set2)
  (let ((adjoin (lambda (x xs)
                  (if (memq? x set2) xs (cons x xs)))))
    (foldr adjoin set2 set1)))

(define (delq x set)
  (if (is? '() set)
      '()
      (if (is? x ('first set))
          ('rest set)
          (cons ('first set) (delq x ('rest set))))))

(define (length xs)
  (letrec ((counting (lambda (n xs)
                       (if (is? '() xs)
                           n
                           (counting ('+ n 1) ('rest xs))))))
    (counting 0 xs)))

(define (map f xs)
  (foldr (lambda (x ys) (cons (f x) ys))
         '()
         xs))

(define list<-
  (make ('run () '())
        ('run (a) (cons a '()))
        ('run (a b) (cons a (list b)))
        ('run (a b c) (cons a (list b c)))))

(define chain
  (make ('run () '())
        ('run (xs) xs)
        ('run (xs ys) (foldr cons ys xs))
        ('run (xs ys zs) (chain xs (chain ys zs)))))

(define (foldr f z xs)
  (if (is? '() xs)
      z
      (f ('first xs) (foldr f z ('rest xs)))))

(define (memq? x set)
  (if (is? '() set)
      #f
      (if (is? x ('first set))
          #t
          (memq? x ('rest set)))))

(define (list-index x xs)
  (letrec ((searching (lambda (i xs)
                        (if (is? x ('first xs))
                            i
                            (searching ('+ n 1) ('rest xs))))))
    (searching 0 xs)))

(define (print x)
  (write x)
  (newline))
