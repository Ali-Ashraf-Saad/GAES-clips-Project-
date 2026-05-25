(deftemplate person 
(slot name)
(slot age)
(slot eye-color)
)
;(set-fact-duplication TRUE)
(assert (person 
(name "Franz")
(age 46)
(eye-color brown)
))

(deffacts kurfesses
(person (name "Franz J. Kurfess")
(age 46)
(eye-color blue))

(person 
(name "Hubert Kurfess") 
(age 44)
(eye-color blue))
)
;(clear) ;del all facts
(reset); del all facts, assert deffacts

;(retract 1) ;del f-1

;(modify 1 (age 24)) ;del orginal (not shifted) and assert ed version (in end)

(duplicate 1 (name "Jack")); assert ed version (in end) and not del orginal

(facts)


(defrule find-blue-eyes

(person (name ?name) (eye-color blue) (age ?a))
(test (< ?a 45))

=>

(printout t  ?name " has blue eyes." crlf)
)

(watch rules)
(run)

;(save "file.clp") ; save current environment (rules, facts, templates)
;(load "file.clp") ; load CLIPS code from file

(exit)
; empty line at the end
