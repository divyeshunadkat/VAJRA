;Number of predicates (nodes) = 17
;Number of variables = 4
;Number of clauses = 21
;
(set-logic HORN)
(declare-fun assign_30_2_210 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assert_29_2_201 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_27_1_213 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_26_1_164 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_23_2_155 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_22_9_146 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_20_1_158 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_19_1_111 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_16_2_102 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_15_2_93 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_13_1_105 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_12_1_65 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_10_1_59 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_9_1_49 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_7_1_39 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun end ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun start ((Array Int Int) (Array Int Int) Int Int ) Bool)
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start b  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (start b  a  N  i ) (assign_7_1_39 b  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_7_1_39 b  a  N  i ) (arrayassign_9_1_49 b  a  rnd i ))))
;
;(aassign) a[0] := 6
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_9_1_49 b  a  N  i ) (arrayassign_10_1_59 b  (store a  0 6) N  i ))))
;
;(aassign) b[0] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_10_1_59 b  a  N  i ) (assign_12_1_65 (store b  0 1) a  N  i ))))
;
;(assign)  i := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_12_1_65 b  a  N  i ) (while_13_1_105 b  a  N  1))))
;
;(while)   while((i<N))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_13_1_105 b  a  N  i ) (< i  N )) (arrayassign_15_2_93 b  a  N  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_13_1_105 b  a  N  i ) (not (< i  N ))) (assign_19_1_111 b  a  N  i ))))
;
;(aassign) a[i] := (a[(i-1)]+6)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_15_2_93 b  a  N  i ) (assign_16_2_102 b  (store a  i  (+ (select a  (- i  1)) 6)) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_16_2_102 b  a  N  i ) (while_13_1_105 b  a  N  (+ i  1)))))
;
;(assign)  i := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_19_1_111 b  a  N  i ) (while_20_1_158 b  a  N  1))))
;
;(while)   while((i<N))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_20_1_158 b  a  N  i ) (< i  N )) (arrayassign_22_9_146 b  a  N  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_20_1_158 b  a  N  i ) (not (< i  N ))) (assign_26_1_164 b  a  N  i ))))
;
;(aassign) b[i] := (b[(i-1)]+a[(i-1)])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_22_9_146 b  a  N  i ) (assign_23_2_155 (store b  i  (+ (select b  (- i  1)) (select a  (- i  1)))) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_23_2_155 b  a  N  i ) (while_20_1_158 b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_26_1_164 b  a  N  i ) (while_27_1_213 b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_27_1_213 b  a  N  i ) (< i  N )) (assert_29_2_201 b  a  N  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_27_1_213 b  a  N  i ) (not (< i  N ))) (end b  a  N  i ))))
;
;(assert)  (b[i]==((((3*i)*i)+(3*i))+1))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assert_29_2_201 b  a  N  i ) (= (select b  i ) (+ (+ (* (* 3 i ) i ) (* 3 i )) 1)))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assert_29_2_201 b  a  N  i ) (assign_30_2_210 b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_30_2_210 b  a  N  i ) (while_27_1_213 b  a  N  (+ i  1)))))
(check-sat)
