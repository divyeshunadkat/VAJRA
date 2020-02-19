;Number of predicates (nodes) = 24
;Number of variables = 5
;Number of clauses = 30
;
(set-logic HORN)
(declare-fun assign_44_2_252 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assert_43_2_243 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_41_1_255 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_40_1_218 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_37_2_209 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_36_2_200 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_34_1_212 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_33_1_175 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_30_2_166 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_29_2_157 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_27_1_169 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_26_1_132 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_23_2_123 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_22_2_114 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_20_1_126 (Int (Array Int Int) (Array Int Int) Int Int ) Bool)
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
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_19_1_93 sum  b  a  N  i ) (while_20_1_126 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_20_1_126 sum  b  a  N  i ) (< i  N )) (assign_22_2_114 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_20_1_126 sum  b  a  N  i ) (not (< i  N ))) (assign_26_1_132 sum  b  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_22_2_114 sum  b  a  N  i ) (assign_23_2_123 (+ sum  (select a  i )) b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_23_2_123 sum  b  a  N  i ) (while_20_1_126 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_26_1_132 sum  b  a  N  i ) (while_27_1_169 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_27_1_169 sum  b  a  N  i ) (< i  N )) (arrayassign_29_2_157 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_27_1_169 sum  b  a  N  i ) (not (< i  N ))) (assign_33_1_175 sum  b  a  N  i ))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (arrayassign_29_2_157 sum  b  a  N  i ) (assign_30_2_166 sum  b  (store a  i  (+ (select a  i ) sum )) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_30_2_166 sum  b  a  N  i ) (while_27_1_169 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_33_1_175 sum  b  a  N  i ) (while_34_1_212 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_34_1_212 sum  b  a  N  i ) (< i  N )) (arrayassign_36_2_200 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_34_1_212 sum  b  a  N  i ) (not (< i  N ))) (assign_40_1_218 sum  b  a  N  i ))))
;
;(aassign) b[i] := (a[i]+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (arrayassign_36_2_200 sum  b  a  N  i ) (assign_37_2_209 sum  (store b  i  (+ (select a  i ) 1)) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_37_2_209 sum  b  a  N  i ) (while_34_1_212 sum  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_40_1_218 sum  b  a  N  i ) (while_41_1_255 sum  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_41_1_255 sum  b  a  N  i ) (< i  N )) (assert_43_2_243 sum  b  a  N  i ))))
(assert (forall ((sum Int) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_41_1_255 sum  b  a  N  i ) (not (< i  N ))) (end sum  b  a  N  i ))))
;
;(assert)  (b[i]==(N+2))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assert_43_2_243 sum  b  a  N  i ) (= (select b  i ) (+ N  2)))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assert_43_2_243 sum  b  a  N  i ) (assign_44_2_252 sum  b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (sum Int) ) ( => (assign_44_2_252 sum  b  a  N  i ) (while_41_1_255 sum  b  a  N  (+ i  1)))))
(check-sat)
