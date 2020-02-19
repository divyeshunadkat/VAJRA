;Number of predicates (nodes) = 29
;Number of variables = 4
;Number of clauses = 36
;
(set-logic HORN)
(declare-fun assign_51_2_302 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assert_50_2_293 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_48_1_305 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_47_1_256 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_44_2_247 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_43_2_238 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_41_1_250 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_40_1_213 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_37_2_204 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_36_2_195 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_34_1_207 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_33_1_174 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_32_1_168 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_29_2_159 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_28_2_150 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_26_1_162 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_25_1_125 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_22_2_116 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_21_2_107 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_19_1_119 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_18_1_86 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_15_2_77 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_14_16_68 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_12_1_80 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_11_1_50 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_10_1_44 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_8_1_38 (Int (Array Int Int) Int Int ) Bool)
(declare-fun end (Int (Array Int Int) Int Int ) Bool)
(declare-fun start (Int (Array Int Int) Int Int ) Bool)
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start sum  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (start sum  a  N  i ) (assign_8_1_38 sum  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_8_1_38 sum  a  N  i ) (assign_10_1_44 sum  a  rnd i ))))
;
;(assign)  sum := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_10_1_44 sum  a  N  i ) (assign_11_1_50 0 a  N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_11_1_50 sum  a  N  i ) (while_12_1_80 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_1_80 sum  a  N  i ) (< i  N )) (arrayassign_14_16_68 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_1_80 sum  a  N  i ) (not (< i  N ))) (assign_18_1_86 sum  a  N  i ))))
;
;(aassign) a[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_14_16_68 sum  a  N  i ) (assign_15_2_77 sum  (store a  i  1) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_15_2_77 sum  a  N  i ) (while_12_1_80 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_18_1_86 sum  a  N  i ) (while_19_1_119 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_1_119 sum  a  N  i ) (< i  N )) (assign_21_2_107 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_1_119 sum  a  N  i ) (not (< i  N ))) (assign_25_1_125 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_21_2_107 sum  a  N  i ) (assign_22_2_116 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_22_2_116 sum  a  N  i ) (while_19_1_119 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_25_1_125 sum  a  N  i ) (while_26_1_162 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_1_162 sum  a  N  i ) (< i  N )) (arrayassign_28_2_150 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_1_162 sum  a  N  i ) (not (< i  N ))) (assign_32_1_168 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_28_2_150 sum  a  N  i ) (assign_29_2_159 sum  (store a  i  (+ (select a  i ) sum )) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_29_2_159 sum  a  N  i ) (while_26_1_162 sum  a  N  (+ i  1)))))
;
;(assign)  sum := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_32_1_168 sum  a  N  i ) (assign_33_1_174 0 a  N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_33_1_174 sum  a  N  i ) (while_34_1_207 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_34_1_207 sum  a  N  i ) (< i  N )) (assign_36_2_195 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_34_1_207 sum  a  N  i ) (not (< i  N ))) (assign_40_1_213 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_36_2_195 sum  a  N  i ) (assign_37_2_204 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_37_2_204 sum  a  N  i ) (while_34_1_207 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_40_1_213 sum  a  N  i ) (while_41_1_250 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_41_1_250 sum  a  N  i ) (< i  N )) (arrayassign_43_2_238 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_41_1_250 sum  a  N  i ) (not (< i  N ))) (assign_47_1_256 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_43_2_238 sum  a  N  i ) (assign_44_2_247 sum  (store a  i  (+ (select a  i ) sum )) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_44_2_247 sum  a  N  i ) (while_41_1_250 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_47_1_256 sum  a  N  i ) (while_48_1_305 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_48_1_305 sum  a  N  i ) (< i  N )) (assert_50_2_293 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_48_1_305 sum  a  N  i ) (not (< i  N ))) (end sum  a  N  i ))))
;
;(assert)  (a[i]==((N+1)*(N+1)))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_50_2_293 sum  a  N  i ) (= (select a  i ) (* (+ N  1) (+ N  1))))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_50_2_293 sum  a  N  i ) (assign_51_2_302 sum  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_51_2_302 sum  a  N  i ) (while_48_1_305 sum  a  N  (+ i  1)))))
(check-sat)
