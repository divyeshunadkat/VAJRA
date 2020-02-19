;Number of predicates (nodes) = 22
;Number of variables = 5
;Number of clauses = 27
;
(set-logic HORN)
(declare-fun assign_38_2_269 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assert_37_2_260 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_35_1_272 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_34_1_232 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_31_2_223 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_30_9_214 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_28_1_226 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_27_1_179 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_24_2_170 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_23_9_161 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_21_1_173 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_20_1_126 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_17_2_117 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_16_2_108 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_14_1_120 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_13_1_80 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_11_1_74 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_10_1_64 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_9_1_54 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_7_1_44 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun end ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun start ((Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start c  b  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (start c  b  a  N  i ) (assign_7_1_44 c  b  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_7_1_44 c  b  a  N  i ) (arrayassign_9_1_54 c  b  a  rnd i ))))
;
;(aassign) a[0] := 6
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (arrayassign_9_1_54 c  b  a  N  i ) (arrayassign_10_1_64 c  b  (store a  0 6) N  i ))))
;
;(aassign) b[0] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (arrayassign_10_1_64 c  b  a  N  i ) (arrayassign_11_1_74 c  (store b  0 1) a  N  i ))))
;
;(aassign) c[0] := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (arrayassign_11_1_74 c  b  a  N  i ) (assign_13_1_80 (store c  0 0) b  a  N  i ))))
;
;(assign)  i := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_13_1_80 c  b  a  N  i ) (while_14_1_120 c  b  a  N  1))))
;
;(while)   while((i<N))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_14_1_120 c  b  a  N  i ) (< i  N )) (arrayassign_16_2_108 c  b  a  N  i ))))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_14_1_120 c  b  a  N  i ) (not (< i  N ))) (assign_20_1_126 c  b  a  N  i ))))
;
;(aassign) a[i] := (a[(i-1)]+6)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (arrayassign_16_2_108 c  b  a  N  i ) (assign_17_2_117 c  b  (store a  i  (+ (select a  (- i  1)) 6)) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_17_2_117 c  b  a  N  i ) (while_14_1_120 c  b  a  N  (+ i  1)))))
;
;(assign)  i := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_20_1_126 c  b  a  N  i ) (while_21_1_173 c  b  a  N  1))))
;
;(while)   while((i<N))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_173 c  b  a  N  i ) (< i  N )) (arrayassign_23_9_161 c  b  a  N  i ))))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_173 c  b  a  N  i ) (not (< i  N ))) (assign_27_1_179 c  b  a  N  i ))))
;
;(aassign) b[i] := (b[(i-1)]+a[(i-1)])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (arrayassign_23_9_161 c  b  a  N  i ) (assign_24_2_170 c  (store b  i  (+ (select b  (- i  1)) (select a  (- i  1)))) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_24_2_170 c  b  a  N  i ) (while_21_1_173 c  b  a  N  (+ i  1)))))
;
;(assign)  i := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_27_1_179 c  b  a  N  i ) (while_28_1_226 c  b  a  N  1))))
;
;(while)   while((i<N))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_28_1_226 c  b  a  N  i ) (< i  N )) (arrayassign_30_9_214 c  b  a  N  i ))))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_28_1_226 c  b  a  N  i ) (not (< i  N ))) (assign_34_1_232 c  b  a  N  i ))))
;
;(aassign) c[i] := (c[(i-1)]+b[(i-1)])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (arrayassign_30_9_214 c  b  a  N  i ) (assign_31_2_223 (store c  i  (+ (select c  (- i  1)) (select b  (- i  1)))) b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_31_2_223 c  b  a  N  i ) (while_28_1_226 c  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_34_1_232 c  b  a  N  i ) (while_35_1_272 c  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_35_1_272 c  b  a  N  i ) (< i  N )) (assert_37_2_260 c  b  a  N  i ))))
(assert (forall ((c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_35_1_272 c  b  a  N  i ) (not (< i  N ))) (end c  b  a  N  i ))))
;
;(assert)  (c[i]==((i*i)*i))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assert_37_2_260 c  b  a  N  i ) (= (select c  i ) (* (* i  i ) i )))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assert_37_2_260 c  b  a  N  i ) (assign_38_2_269 c  b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) ) ( => (assign_38_2_269 c  b  a  N  i ) (while_35_1_272 c  b  a  N  (+ i  1)))))
(check-sat)
