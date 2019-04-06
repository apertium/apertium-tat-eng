#lang racket

; Racket interface for apertium-tat-eng;

; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide tat-eng
         tat-eng-from-pretransfer-to-biltrans
         tat-eng-from-t1x-to-postgen)

(require pkg/lib
         rackunit
         rash
         apertiumpp/streamparser)

(define (symbol-append s1 s2)
  (string->symbol (string-append (symbol->string s1) (symbol->string s2))))

(define A-TAT-ENG './)
(define A-TAT-ENG-BIL (symbol-append A-TAT-ENG 'tat-eng.autobil.bin))
(define A-TAT-ENG-T1X (symbol-append A-TAT-ENG 'apertium-tat-eng.tat-eng.t1x))
(define A-TAT-ENG-T1X-BIN (symbol-append A-TAT-ENG 'tat-eng.t1x.bin))
(define A-TAT-ENG-T2X (symbol-append A-TAT-ENG 'apertium-tat-eng.tat-eng.t2x))
(define A-TAT-ENG-T2X-BIN (symbol-append A-TAT-ENG 'tat-eng.t2x.bin))
(define A-TAT-ENG-T3X (symbol-append A-TAT-ENG 'apertium-tat-eng.tat-eng.t3x))
(define A-TAT-ENG-T3X-BIN (symbol-append A-TAT-ENG 'tat-eng.t3x.bin))
(define A-TAT-ENG-GEN (symbol-append A-TAT-ENG 'tat-eng.autogen.bin))

(define (tat-eng s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-eng")])
    (rash
     "echo (values s) | apertium -d . tat-eng")))

(define (tat-eng-from-pretransfer-to-biltrans s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-eng")])
    (rash
     "echo (values s) | apertium-pretransfer | "
     "lt-proc -b (values A-TAT-ENG-BIL)")))

(define (tat-eng-from-t1x-to-postgen s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-eng")])
    (rash
     "echo (values s) | "
     "apertium-transfer -b (values A-TAT-ENG-T1X) (values A-TAT-ENG-T1X-BIN) | "
     "apertium-interchunk (values A-TAT-ENG-T2X) (values A-TAT-ENG-T2X-BIN) | "
     "apertium-postchunk (values A-TAT-ENG-T3X) (values A-TAT-ENG-T3X-BIN) | "
     "lt-proc -g (values A-TAT-ENG-GEN)")))
