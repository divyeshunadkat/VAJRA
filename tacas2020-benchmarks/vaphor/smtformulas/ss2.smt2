;Number of predicates (nodes) = 32
;Number of variables = 4
;Number of clauses = 40
;
(set-logic HORN)
(declare-fun assign_57_2_326 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assert_56_2_317 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_54_1_329 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_53_1_286 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_50_2_277 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_49_2_268 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_47_1_280 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_46_1_243 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_43_2_234 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_42_2_225 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_40_1_237 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_39_1_204 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_36_2_195 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_35_2_186 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_33_1_198 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_32_1_161 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_29_2_152 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_28_16_143 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_26_1_155 (Int (Array Int Int) Int Int ) Bool)
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
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_25_1_125 sum  a  N  i ) (while_26_1_155 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_1_155 sum  a  N  i ) (< i  N )) (arrayassign_28_16_143 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_1_155 sum  a  N  i ) (not (< i  N ))) (assign_32_1_161 sum  a  N  i ))))
;
;(aassign) a[i] := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_28_16_143 sum  a  N  i ) (assign_29_2_152 sum  (store a  i  0) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_29_2_152 sum  a  N  i ) (while_26_1_155 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_32_1_161 sum  a  N  i ) (while_33_1_198 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_33_1_198 sum  a  N  i ) (< i  N )) (arrayassign_35_2_186 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_33_1_198 sum  a  N  i ) (not (< i  N ))) (assign_39_1_204 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_35_2_186 sum  a  N  i ) (assign_36_2_195 sum  (store a  i  (+ (select a  i ) sum )) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_36_2_195 sum  a  N  i ) (while_33_1_198 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_39_1_204 sum  a  N  i ) (while_40_1_237 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_40_1_237 sum  a  N  i ) (< i  N )) (assign_42_2_225 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_40_1_237 sum  a  N  i ) (not (< i  N ))) (assign_46_1_243 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_42_2_225 sum  a  N  i ) (assign_43_2_234 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_43_2_234 sum  a  N  i ) (while_40_1_237 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_46_1_243 sum  a  N  i ) (while_47_1_280 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_47_1_280 sum  a  N  i ) (< i  N )) (arrayassign_49_2_268 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_47_1_280 sum  a  N  i ) (not (< i  N ))) (assign_53_1_286 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_49_2_268 sum  a  N  i ) (assign_50_2_277 sum  (store a  i  (+ (select a  i ) sum )) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_50_2_277 sum  a  N  i ) (while_47_1_280 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_53_1_286 sum  a  N  i ) (while_54_1_329 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_54_1_329 sum  a  N  i ) (< i  N )) (assert_56_2_317 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_54_1_329 sum  a  N  i ) (not (< i  N ))) (end sum  a  N  i ))))
;
;(assert)  (a[i]==(N*(N+2)))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_56_2_317 sum  a  N  i ) (= (select a  i ) (* N  (+ N  2))))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_56_2_317 sum  a  N  i ) (assign_57_2_326 sum  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_57_2_326 sum  a  N  i ) (while_54_1_329 sum  a  N  (+ i  1)))))
(check-sat)
