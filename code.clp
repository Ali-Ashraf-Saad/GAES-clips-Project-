; Ask User Input
(deffunction ask-question (?question)
   (printout t ?question)
   (return (read))
)

(defrule get-input
   =>
   (bind ?toefl (ask-question "Enter TOEFL score: "))
   (bind ?transcript (ask-question "Is transcript available? (yes/no): "))
   (bind ?gpr (ask-question "Enter GPR: "))
   (bind ?gre (ask-question "Enter GRE score: "))
   (bind ?honors (ask-question "Is student honors? (yes/no): "))

   (assert (toefl ?toefl))
   (assert (transcript ?transcript))
   (assert (gpr ?gpr))
   (assert (gre ?gre))
   (assert (honors ?honors))
)


; Rules
; Rule 1: Language Requirement
(defrule language-met
    (toefl ?score&:(>= ?score 500))
    =>
    (assert (language yes))
)

(defrule language-not-met
    (toefl ?score&:(< ?score 500))
    =>
    (assert (decision deny))
)

; Rule 2: Transcript Check
(defrule no-transcript
    (language yes)
    (transcript no)
    =>
    (assert (decision conditional))
)

;Rule 3: Academic Criteria Met
(defrule full-admission
    (language yes)
    (transcript yes)
    (gpr ?g&:(>= ?g 3.0))
    (gre ?gr&:(>= ?gr 1000))
    (honors yes)
    =>
    (assert (decision full))
)

; Rule 4: Provisional
(defrule provisional-admission
    (language yes)
    (transcript yes)
    (gpr ?g&:(< ?g 3.0))
    =>
    (assert (decision provisional))
)

; Output
(defrule print-result
    (decision ?d)
    =>
    (printout t "Final Decision: " ?d crlf)
)
(reset)
(run)
