; =========================================================
; Sample test cases
; =========================================================

(deffacts sample_applicants
   ; c1 -> admit with full status
   (applicant (id c1) (us_degree yes) (toefl 0) (transcript available)
              (gpr_last60 3.20) (honour_student no) (special_honors no)
              (prior_grad_work no) (gre_score 1120) (gre_verbal 410))

   ; c2 -> admit conditionally (honour-student branch)
   (applicant (id c2) (us_degree no) (toefl 520) (transcript unavailable)
              (gpr_last60 3.40) (honour_student yes) (special_honors yes)
              (prior_grad_work yes) (gre_score 1000) (gre_verbal 380))

   ; c3 -> admit provisionally with English remediation
   (applicant (id c3) (us_degree no) (toefl 600) (transcript available)
              (gpr_last60 3.00) (honour_student no) (special_honors no)
              (prior_grad_work no) (gre_score 1000) (gre_verbal 350))

   ; c4 -> wait for transcript (GPR branch)
   (applicant (id c4) (us_degree yes) (toefl 0) (transcript unavailable)
              (gpr_last60 3.20) (honour_student no) (special_honors yes)
              (prior_grad_work yes) (gre_score 1200) (gre_verbal 410))

   ; c5 -> deny normal admission (language not met)
   (applicant (id c5) (us_degree no) (toefl 300) (transcript available)
              (gpr_last60 3.50) (honour_student no) (special_honors no)
              (prior_grad_work no) (gre_score 900) (gre_verbal 350))

   ; c6 -> deny normal admission (low GPR)
   (applicant (id c6) (us_degree yes) (toefl 0) (transcript available)
              (gpr_last60 2.40) (honour_student no) (special_honors no)
              (prior_grad_work no) (gre_score 950) (gre_verbal 390))

   ; c7 -> admit conditionally (GRE branch)
   (applicant (id c7) (us_degree no) (toefl 550) (transcript unavailable)
              (gpr_last60 3.40) (honour_student no) (special_honors no)
              (prior_grad_work yes) (gre_score 1120) (gre_verbal 410))

   ; c8 -> wait for transcript (GRE branch)
   (applicant (id c8) (us_degree no) (toefl 580) (transcript unavailable)
              (gpr_last60 3.50) (honour_student no) (special_honors no)
              (prior_grad_work yes) (gre_score 900) (gre_verbal 390))
)
