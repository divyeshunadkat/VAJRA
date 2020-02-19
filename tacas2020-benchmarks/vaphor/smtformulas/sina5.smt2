;Number of predicates (nodes) = 28
;Number of variables = 5
;Number of clauses = 35
;
(set-logic HORN)
(declare-fun assign_51_2_287 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assert_50_2_278 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_48_1_290 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_47_1_250 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_44_2_241 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_43_2_232 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_41_1_244 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_40_1_207 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_37_2_198 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_36_2_189 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_34_1_201 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_33_1_168 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_30_2_159 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_29_2_150 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_27_1_162 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_26_1_129 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_23_2_120 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_22_16_111 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_20_1_123 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_19_1_93 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_16_2_84 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_15_16_75 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_13_1_87 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_12_1_57 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_11_1_51 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_9_1_45 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun end (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun start (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start sum  b  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (start sum  b  a  N  i ) (assign_9_1_45 sum  b  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_9_1_45 sum  b  a  N  i ) (assign_11_1_51 sum  b  a  rnd i ))))
;
;(assign)  sum := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_11_1_51 sum  b  a  N  i ) (assign_12_1_57 0 b  a  N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_12_1_57 sum  b  a  N  i ) (while_13_1_87 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_13_1_87 sum  b  a  N  i ) (< i  N )) (arrayassign_15_16_75 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_13_1_87 sum  b  a  N  i ) (not (< i  N ))) (assign_19_1_93 sum  b  a  N  i ))))
;
;(aassign) a[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (arrayassign_15_16_75 sum  b  a  N  i ) (assign_16_2_84 sum  b  (store a  i  1) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_16_2_84 sum  b  a  N  i ) (while_13_1_87 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_19_1_93 sum  b  a  N  i ) (while_20_1_123 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_20_1_123 sum  b  a  N  i ) (< i  N )) (arrayassign_22_16_111 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_20_1_123 sum  b  a  N  i ) (not (< i  N ))) (assign_26_1_129 sum  b  a  N  i ))))
;
;(aassign) b[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (arrayassign_22_16_111 sum  b  a  N  i ) (assign_23_2_120 sum  (store b  i  1) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_23_2_120 sum  b  a  N  i ) (while_20_1_123 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_26_1_129 sum  b  a  N  i ) (while_27_1_162 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_27_1_162 sum  b  a  N  i ) (< i  N )) (assign_29_2_150 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_27_1_162 sum  b  a  N  i ) (not (< i  N ))) (assign_33_1_168 sum  b  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_29_2_150 sum  b  a  N  i ) (assign_30_2_159 (+ sum  (select a  i )) b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_30_2_159 sum  b  a  N  i ) (while_27_1_162 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_33_1_168 sum  b  a  N  i ) (while_34_1_201 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_34_1_201 sum  b  a  N  i ) (< i  N )) (assign_36_2_189 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_34_1_201 sum  b  a  N  i ) (not (< i  N ))) (assign_40_1_207 sum  b  a  N  i ))))
;
;(assign)  sum := (sum+b[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_36_2_189 sum  b  a  N  i ) (assign_37_2_198 (+ sum  (select b  i )) b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_37_2_198 sum  b  a  N  i ) (while_34_1_201 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_40_1_207 sum  b  a  N  i ) (while_41_1_244 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_41_1_244 sum  b  a  N  i ) (< i  N )) (arrayassign_43_2_232 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_41_1_244 sum  b  a  N  i ) (not (< i  N ))) (assign_47_1_250 sum  b  a  N  i ))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (arrayassign_43_2_232 sum  b  a  N  i ) (assign_44_2_241 sum  b  (store a  i  (+ (select a  i ) sum )) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_44_2_241 sum  b  a  N  i ) (while_41_1_244 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_47_1_250 sum  b  a  N  i ) (while_48_1_290 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_48_1_290 sum  b  a  N  i ) (< i  N )) (assert_50_2_278 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_48_1_290 sum  b  a  N  i ) (not (< i  N ))) (end sum  b  a  N  i ))))
;
;(assert)  (a[i]==((2*N)+1))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assert_50_2_278 sum  b  a  N  i ) (= (select a  i ) (+ (* 2 N ) 1)))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assert_50_2_278 sum  b  a  N  i ) (assign_51_2_287 sum  b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_51_2_287 sum  b  a  N  i ) (while_48_1_290 sum  b  a  N  (+ i  1)))))
(check-sat)