; Copyright (c) 2018, Joshua Scoggins
; 
; This software is provided 'as-is', without any express or implied
; warranty. In no event will the authors be held liable for any damages
; arising from the use of this software.
; 
; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it and redistribute it
; freely, subject to the following restrictions:
; 
; 1. The origin of this software must not be misrepresented; you must not
;    claim that you wrote the original software. If you use this software
;    in a product, an acknowledgment in the product documentation would be
;    appreciated but is not required.
; 2. Altered source versions must be plainly marked as such, and must not be
;    misrepresented as being the original software.
; 3. This notice may not be removed or altered from any source distribution.
(defglobal MAIN
           ?*debug* = TRUE)
(deffunction debug-printout
             (?router $?options)
             (if ?*debug* then
               (printout ?router "DEBUG: " (expand$ ?options))))
(deffacts preparation
          (preparation 1 Sun-dried)
          (preparation 2 Heirloom)
          (preparation 3 Charred)
          (preparation 4 Fresh)
          (preparation 5 Smoked)
          (preparation 6 Small-batch)
          (preparation 7 Roasted)
          (preparation 8 Pickled)
          (preparation 9 Blistered)
          (preparation 10 Home-grown)
          (preparation 11 Fermented)
          (preparation 12 Ripe))

(deffacts pepper-types
          (birth-month-to-pepper JAN "Wiri Wiri")
          (birth-month-to-pepper FEB "Devil's Tongue")
          (birth-month-to-pepper MAR Scorpion)
          (birth-month-to-pepper APR Ghost)
          (birth-month-to-pepper MAY 7-Pot)
          (birth-month-to-pepper JUN Fatali)
          (birth-month-to-pepper JUL Infinity)
          (birth-month-to-pepper AUG "Naga Viper")
          (birth-month-to-pepper SEP "Chile de Arbol")
          (birth-month-to-pepper OCT "Lemon Drop")
          (birth-month-to-pepper NOV "Komodo Dragon")
          (birth-month-to-pepper DEC "Brazilian Starfish"))

(deffacts modifiers 
          (modifier 1 Summer)
          (modifier 2 Local)
          (modifier 3 Foraged)
          (modifier 4 Autumn)
          (modifier 5 Jumbo)
          (modifier 6 Arctic)
          (modifier 7 Wild)
          (modifier 8 Mountain)
          (modifier 9 Tropical)
          (modifier 10 Baby))

(deffacts key-ingredient
          (key-ingredient A Kale)
          (key-ingredient B Pineapple)
          (key-ingredient C Basil)
          (key-ingredient D Raspberry)
          (key-ingredient E Juniper)
          (key-ingredient F Ramps)
          (key-ingredient G Durian)
          (key-ingredient H Gooseberry)
          (key-ingredient I Culantro)
          (key-ingredient J Shrimp)
          (key-ingredient K Peppercorns)
          (key-ingredient L Sassafras)
          (key-ingredient M Yam)
          (key-ingredient N Anchovies)
          (key-ingredient O Kiwi)
          (key-ingredient P Kumquat)
          (key-ingredient Q Mangosteen)
          (key-ingredient R Lingonberry)
          (key-ingredient S Rosehip)
          (key-ingredient T Sesame)
          (key-ingredient U Dill)
          (key-ingredient V Portobella)
          (key-ingredient W Eggplant)
          (key-ingredient X Artichoke)
          (key-ingredient Y Tomato)
          (key-ingredient Z Cabbage))


(deffacts month-simplification
          (simplify JANUARY to JAN)
          (simplify FEBRUARY to FEB)
          (simplify MARCH to MAR)
          (simplify APRIL to APR)
          (simplify MAY to MAY)
          (simplify JUNE to JUN)
          (simplify JULY to JUL)
          (simplify AUGUST to AUG)
          (simplify SEPTEMBER to SEP)
          (simplify OCTOBER to OCT)
          (simplify NOVEMBER to NOV)
          (simplify DECEMBER to DEC))

(deftemplate stage
             (slot current
                   (type SYMBOL)
                   (default ?NONE))
             (multislot rest
                        (type SYMBOL)
                        (default ?NONE)))

(deffacts stages
          (stage (current first-name)
                 (rest birth-month
                       spicy-level
                       last-name
                       collate))
          (ask first-name)
          (ask birth-month)
          (ask spicy-level)
          (ask last-name))

(defrule next-stage
         (declare (salience -10000))
         ?f <- (stage (rest ?next 
                            $?rest))
         =>
         (modify ?f
                 (current ?next)
                 (rest ?rest)))
; getting the first name
(defrule request-first-name
         (stage (current first-name))
         ?f <- (ask first-name)
         =>
         (retract ?f)
         (printout t "enter your first name: ")
         (assert (raw-first-name (readline))))

(defrule empty-first-name
         (stage (current first-name))
         ?f <- (raw-first-name ?str)
         (test (= (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (ask first-name))
         (printout t "bad first name!" crlf))

(defrule translate-first-name
         (stage (current first-name))
         ?f <- (raw-first-name ?str)
         (test (> (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (fielded-first-name (string-to-field ?str))))

(defrule bad-translated-first-name
         (stage (current first-name))
         ?f <- (fielded-first-name ?field)
         (test (not (symbolp ?field)))
         =>
         (retract ?f)
         (assert (ask first-name))
         (printout t "bad first name!" crlf))

(defrule good-translated-first-name
         (stage (current first-name))
         ?f <- (fielded-first-name ?field)
         (test (symbolp ?field))
         =>
         (retract ?f)
         (debug-printout t "first name length: " 
                         (str-length ?field) 
                         crlf)
         (assert (first-name-length (str-length ?field))))

(defrule normalize-first-name-length
         (stage (current first-name))
         ?f <- (first-name-length ?length)
         (test (> ?length 12))
         =>
         (retract ?f)
         (assert (first-name-length 12)))


; getting the birth month
(defrule request-birth-month
         (stage (current birth-month))
         ?f <- (ask birth-month)
         =>
         (retract ?f)
         (printout t "enter your birth month: ")
         (assert (raw-birth-month (readline))))

(defrule empty-birth-month
         (stage (current birth-month))
         ?f <- (raw-birth-month ?str)
         (test (= (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (ask birth-month))
         (printout t "bad birth month!" crlf))
(defrule translate-birth-month
         (stage (current birth-month))
         ?f <- (raw-birth-month ?str)
         (test (> (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (fielded-birth-month (string-to-field ?str))))

(defrule birth-month-not-a-symbol
         (stage (current birth-month))
         ?f <- (fielded-birth-month ?mon)
         (test (not (symbolp ?mon)))
         =>
         (printout t "bad birth month!" crlf)
         (retract ?f)
         (assert (ask birth-month)))
(defrule birth-month-a-symbol-so-upcase-it
         (stage (current birth-month))
         ?f <- (fielded-birth-month ?mon)
         (test (symbolp ?mon))
         =>
         (retract ?f)
         (assert (upcased-birth-month (upcase ?mon))))

(defrule bad-birth-month
         (stage (current birth-month))
         ?f <- (upcased-birth-month ?mon)
         (not (simplify ?mon to ?))
         =>
         (retract ?f)
         (printout t "bad birth month!" crlf)
         (assert (ask birth-month)))
(defrule good-birth-month
         (stage (current birth-month))
         ?f <- (upcased-birth-month ?mon)
         (simplify ?mon to ?compacted)
         =>
         (retract ?f)
         (debug-printout t "compacted birth month: " ?compacted crlf)
         (assert (birth-month ?compacted)))


; spicy level
(defrule request-spicy-level
         (stage (current spicy-level))
         ?f <- (ask spicy-level)
         =>
         (retract ?f)
         (printout t "How spicy are you (1-10)? ")
         (assert (raw-spicy-level (readline))))
(defrule empty-spicy-level
         (stage (current spicy-level))
         ?f <- (raw-spicy-level ?str)
         (test (= (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (ask spicy-level))
         (printout t "bad spicy level!" crlf))
(defrule translate-spicy-level
         (stage (current spicy-level))
         ?f <- (raw-spicy-level ?str)
         (test (> (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (fielded-spicy-level (string-to-field ?str))))

(defrule spicy-level-not-number
         (declare (salience 1))
         (stage (current spicy-level))
         ?f <- (fielded-spicy-level ?num)
         (test (not (integerp ?num)))
         =>
         (retract ?f)
         (assert (ask spicy-level))
         (printout t "bad spicy level!" crlf))

(defrule spicy-level-not-in-range
         (declare (salience 1))
         (stage (current spicy-level))
         ?f <- (fielded-spicy-level ?num)
         (test (and (integerp ?num)
                    (not (<= 1 ?num 10))))
         =>
         (retract ?f)
         (assert (ask spicy-level))
         (printout t "bad spicy level!" crlf))

(defrule spicy-level-is-good
         (stage (current spicy-level))
         ?f <- (fielded-spicy-level ?num)
         =>
         (retract ?f)
         (assert (spicy-level ?num)))

; last-name
(defrule request-last-name
         (stage (current last-name))
         ?f <- (ask last-name)
         =>
         (retract ?f)
         (printout t "enter your last name: ")
         (assert (raw-last-name (readline))))

(defrule empty-last-name
         (stage (current last-name))
         ?f <- (raw-last-name ?str)
         (test (= (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (ask last-name))
         (printout t "bad last name!" crlf))

(defrule translate-last-name
         (stage (current last-name))
         ?f <- (raw-last-name ?str)
         (test (> (str-length ?str) 0))
         =>
         (retract ?f)
         (assert (fielded-last-name (string-to-field ?str))))

(defrule bad-translated-last-name
         (stage (current last-name))
         ?f <- (fielded-last-name ?field)
         (test (not (symbolp ?field)))
         =>
         (retract ?f)
         (assert (ask last-name))
         (printout t "bad last name!" crlf))

(defrule good-translated-last-name
         (stage (current last-name))
         ?f <- (fielded-last-name ?field)
         (test (symbolp ?field))
         =>
         (retract ?f)
         (debug-printout t "last name: " 
                         (upcase ?field)
                         crlf)
         (assert (upcased-last-name (upcase ?field))))

(defrule extract-first-character
         (stage (current last-name))
         ?f <- (upcased-last-name ?last)
         =>
         (retract ?f)
         (assert (last-name-first-char (string-to-field (sub-string 1 1 ?last)))))

(defrule illegal-first-char-of-last-name:bad-type
         (stage (current last-name))
         ?f <- (last-name-first-char ?char)
         (not (key-ingredient ?char ?))
         =>
         (retract ?f)
         (assert (ask last-name))
         (printout t "bad last name!" crlf))
(defrule collate-results
         (stage (current collate))
         ?f <- (last-name-first-char ?char)
         (key-ingredient ?char ?key)
         ?f2 <- (spicy-level ?num)
         (modifier ?num ?modifier)
         ?f3 <- (birth-month ?month)
         (birth-month-to-pepper ?month ?pepper)
         ?f4 <- (first-name-length ?length)
         (preparation ?length ?prep)
         =>
         (retract ?f 
                  ?f2 
                  ?f3
                  ?f4)
         (format t 
                 "%s %s With %s %s%n"
                 ?prep
                 ?pepper
                 ?modifier
                 ?key))
