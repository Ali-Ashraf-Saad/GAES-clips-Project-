; =========================================================
; GAES - Graduate Admission Expert System
; CLIPS implementation of the paper's sample rules
; =========================================================

; =========================================
; Function to ask user for input
; =========================================

(deffunction ask-question (?question)
   (printout t ?question " ")
   (bind ?answer (read))
   ?answer
)

; --------- Main input template ----------
(deftemplate applicant
   (slot id)
   (slot us_degree (allowed-symbols yes no) (default no))
   (slot toefl (type INTEGER) (default 0))
   (slot transcript (allowed-symbols available unavailable) (default unavailable))
   (slot gpr_last60 (type NUMBER) (default 0))
   (slot honour_student (allowed-symbols yes no) (default no))
   (slot special_honors (allowed-symbols yes no) (default no))
   (slot prior_grad_work (allowed-symbols yes no) (default no))
   (slot gre_score (type INTEGER) (default 0))
   (slot gre_verbal (type INTEGER) (default 0))
)

; --------- Derived facts ----------
(deftemplate language_requirement_met (slot id))
(deftemplate full_decision (slot id))
(deftemplate conditional_decision (slot id))
(deftemplate undergrad_gpr_considered (slot id))

(deftemplate admit_with_full_status (slot id))
(deftemplate admit_conditionally (slot id))
(deftemplate admit_provisionally_english_remediation (slot id))
(deftemplate wait_for_transcript (slot id))
(deftemplate deny_normal_admission (slot id))

; =========================================
; Rule to get applicant input
; =========================================

(defrule get-input
   =>
   (bind ?id (ask-question "Enter applicant id:"))
   (bind ?us-degree (ask-question "US degree? (yes/no):"))
   (bind ?toefl (ask-question "TOEFL score:"))
   (bind ?transcript (ask-question "Transcript available? (available/unavailable):"))
   (bind ?gpr (ask-question "GPR last 60 hours:"))
   (bind ?honour (ask-question "Honour student? (yes/no):"))
   (bind ?special (ask-question "Special honors? (yes/no):"))
   (bind ?prior (ask-question "Prior graduate work? (yes/no):"))
   (bind ?gre (ask-question "GRE score:"))
   (bind ?gre-verbal (ask-question "GRE verbal score:"))

   (assert
      (applicant
         (id ?id)
         (us_degree ?us-degree)
         (toefl ?toefl)
         (transcript ?transcript)
         (gpr_last60 ?gpr)
         (honour_student ?honour)
         (special_honors ?special)
         (prior_grad_work ?prior)
         (gre_score ?gre)
         (gre_verbal ?gre-verbal)
      )
   )
)

; ---------------------------------------------------------
; R1: Language requirement met
; rule: US degree OR TOEFL > 499
; ---------------------------------------------------------

(defrule R1_language_from_us_degree
   (declare (salience 120))
   (applicant (id ?id) (us_degree yes))
   (not (language_requirement_met (id ?id)))
   =>
   (assert (language_requirement_met (id ?id)))
   (printout t "Case " ?id ": language requirement met by US degree." crlf)
)

(defrule R1_language_from_toefl
   (declare (salience 119))
   (applicant (id ?id) (us_degree no) (toefl ?s&:(> ?s 499)))
   (not (language_requirement_met (id ?id)))
   =>
   (assert (language_requirement_met (id ?id)))
   (printout t "Case " ?id ": language requirement met by TOEFL." crlf)
)

; ---------------------------------------------------------
; R2: Full decision
; Language requirement met AND final transcript available
; ---------------------------------------------------------

(defrule R2_full_decision
   (declare (salience 110))
   (language_requirement_met (id ?id))
   (applicant (id ?id) (transcript available))
   (not (full_decision (id ?id)))
   =>
   (assert (full_decision (id ?id)))
   (printout t "Case " ?id ": full decision." crlf)
)

; ---------------------------------------------------------
; R7: Conditional decision
; Language requirement met AND transcript unavailable
; ---------------------------------------------------------

(defrule R7_conditional_decision
   (declare (salience 105))
   (language_requirement_met (id ?id))
   (applicant (id ?id) (transcript unavailable))
   (not (conditional_decision (id ?id)))
   =>
   (assert (conditional_decision (id ?id)))
   (printout t "Case " ?id ": conditional decision (transcript unavailable)." crlf)
)

; ---------------------------------------------------------
; R5: If no prior graduate work, consider UG GPR
; ---------------------------------------------------------

(defrule R5_undergrad_gpr_considered
   (declare (salience 100))
   (applicant (id ?id) (prior_grad_work no))
   (not (undergrad_gpr_considered (id ?id)))
   =>
   (assert (undergrad_gpr_considered (id ?id)))
   (printout t "Case " ?id ": undergraduate GPR considered = true." crlf)
)

; ---------------------------------------------------------
; R3: Admit conditionally
; conditional_decision AND GPR last60 > 3.29 AND honour student
; ---------------------------------------------------------

(defrule R3_admit_conditionally_honour
   (declare (salience 95))
   (conditional_decision (id ?id))
   (applicant (id ?id)
      (gpr_last60 ?g&:(> ?g 3.29))
      (honour_student yes))
   (not (admit_conditionally (id ?id)))
   =>
   (assert (admit_conditionally (id ?id)))
   (printout t "Case " ?id ": admit conditionally (honour-student branch)." crlf)
)

; ---------------------------------------------------------
; R8: Wait for transcript
; conditional_decision AND GPR last60 < 3.3
; ---------------------------------------------------------

(defrule R8_wait_for_transcript
   (declare (salience 90))
   (conditional_decision (id ?id))
   (applicant (id ?id) (gpr_last60 ?g&:(< ?g 3.3)))
   (not (wait_for_transcript (id ?id)))
   =>
   (assert (wait_for_transcript (id ?id)))
   (printout t "Case " ?id ": wait for transcript." crlf)
)

; ---------------------------------------------------------
; R6: Wait for transcript
; conditional_decision AND not special honors AND GRE < 1100
; ---------------------------------------------------------

(defrule R6_wait_for_transcript_gre
   (declare (salience 89))
   (conditional_decision (id ?id))
   (applicant (id ?id)
      (special_honors no)
      (gre_score ?gre&:(< ?gre 1100)))
   (not (wait_for_transcript (id ?id)))
   =>
   (assert (wait_for_transcript (id ?id)))
   (printout t "Case " ?id ": wait for transcript (GRE branch)." crlf)
)

; ---------------------------------------------------------
; R9: Admit conditionally
; conditional_decision AND not special honors AND GRE > 1099
; ---------------------------------------------------------

(defrule R9_admit_conditionally_gre
   (declare (salience 88))
   (conditional_decision (id ?id))
   (applicant (id ?id)
      (special_honors no)
      (gre_score ?gre&:(> ?gre 1099)))
   (not (admit_conditionally (id ?id)))
   =>
   (assert (admit_conditionally (id ?id)))
   (printout t "Case " ?id ": admit conditionally (GRE branch)." crlf)
)

; ---------------------------------------------------------
; R4: Admit provisionally + English remediation
; undergrad_gpr_considered AND GPR last60 > 2.49 AND not special honors
; AND 900 < GRE < 1100 AND GRE verbal < 400
; ---------------------------------------------------------

(defrule R4_provisional_english_remediation
   (declare (salience 85))
   (undergrad_gpr_considered (id ?id))
   (applicant (id ?id)
      (gpr_last60 ?g&:(> ?g 2.49))
      (special_honors no)
      (gre_score ?gre&:(> ?gre 899)&:(< ?gre 1100))
      (gre_verbal ?gv&:(< ?gv 400)))
   (not (admit_provisionally_english_remediation (id ?id)))
   =>
   (assert (admit_provisionally_english_remediation (id ?id)))
   (printout t "Case " ?id ": admit provisionally with English remediation." crlf)
)

; ---------------------------------------------------------
; R10: Admit with full status
; full_decision AND undergrad_gpr_considered AND GPR last60 > 2.99
; AND not special honors AND GRE > 1099 AND GRE verbal > 399
; ---------------------------------------------------------

(defrule R10_admit_full_status
   (declare (salience 80))
   (full_decision (id ?id))
   (undergrad_gpr_considered (id ?id))
   (applicant (id ?id)
      (gpr_last60 ?g&:(> ?g 2.99))
      (special_honors no)
      (gre_score ?gre&:(> ?gre 1099))
      (gre_verbal ?gv&:(> ?gv 399)))
   (not (admit_with_full_status (id ?id)))
   =>
   (assert (admit_with_full_status (id ?id)))
   (printout t "Case " ?id ": admit with full status." crlf)
)

; ---------------------------------------------------------
; R12: Deny normal admission
; undergrad_gpr_considered AND GPR last60 < 2.5
; ---------------------------------------------------------

(defrule R12_deny_low_gpr
   (declare (salience 75))
   (undergrad_gpr_considered (id ?id))
   (applicant (id ?id) (gpr_last60 ?g&:(< ?g 2.5)))
   (not (deny_normal_admission (id ?id)))
   =>
   (assert (deny_normal_admission (id ?id)))
   (printout t "Case " ?id ": deny normal admission (low GPR)." crlf)
)

; ---------------------------------------------------------
; R11: Deny normal admission if language requirement not met
; This covers the case where US degree is no AND TOEFL <= 499
; ---------------------------------------------------------

(defrule R11_deny_language
   (declare (salience 70))
   (applicant (id ?id) (us_degree no) (toefl ?s&:(<= ?s 499)))
   (not (language_requirement_met (id ?id)))
   =>
   (assert (deny_normal_admission (id ?id)))
   (printout t "Case " ?id ": deny normal admission (language requirement not met)." crlf)
)

; =========================================================
; Run:
   ; (load /home/ali/coding/clipsCode/GAES.clp)
   ; (reset)
   ; (run)
; =========================================================
