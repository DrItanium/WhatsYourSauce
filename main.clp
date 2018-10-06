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
          (preparation 12 Ripe)
          (preparation default Ripe))

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
                       last-name))
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

(defrule request-first-name
         (stage (current first-name))
         ?f <- (ask last-name)
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
         (assert (ask last-name))
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
         (assert (ask last-name))
         (printout t "bad first name!" crlf))

(defrule good-translated-first-name
         (stage (current first-name))
         ?f <- (fielded-first-name ?field)
         (test (symbolp ?field))
         =>
         (retract ?f)
         (assert (first-name-length (str-length ?field))))

        


