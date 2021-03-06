#! /usr/bin/scheme --program
#!chezscheme
(import (chezscheme)
  (terp util)
  (terp macros)
  (terp read)
  (terp parse)
  (terp env)
  (terp elaborate)
  (terp primitives)
  (terp terp))

;; The Squeam interpreter and global environment.

(define (repl . opt-args)
  (squeam-interpret `(call repl ',opt-args)))

(run-load "lib/stdlib.scm")
(squeam-interpret
 '(do
;    (use "test/smoke-test")
    ;; Let's default to traceback-on-error:
    ;; TODO: also stash the error in the-last-error for below
;    (push-signal-handler ((use "lib/traceback") 'on-error-traceback))
    (import (use "lib/flexarray")  flexarray<- flexarray<-list)
    (import (use "lib/sort")       sort sort-by)
    (import (use "lib/bag")        bag<-)))

;(unless (squeam-interpret '(the-last-error .^))
(repl (cdr (command-line)))
;)
