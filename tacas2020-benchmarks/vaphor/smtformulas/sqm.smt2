;Number of predicates (nodes) = 17
;Number of variables = 4
;Number of clauses = 21
;
(set-logic HORN)
(declare-fun assign_31_2_215 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assert_30_2_206 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_28_1_218 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_27_1_169 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_24_2_160 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_23_2_151 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_21_1_163 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_20_1_113 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_17_2_104 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_16_2_95 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_14_1_107 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_13_1_67 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_11_1_61 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_10_1_51 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_8_1_41 ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun end ((Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun start ((Array Int Int) (Array Int Int) Int Int ) Bool)
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start b  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (start b  a  N  i ) (assign_8_1_41 b  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_8_1_41 b  a  N  i ) (arrayassign_10_1_51 b  a  rnd i ))))
;
;(aassign) b[0] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_10_1_51 b  a  N  i ) (arrayassign_11_1_61 (store b  0 1) a  N  i ))))
;
;(aassign) a[0] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_11_1_61 b  a  N  i ) (assign_13_1_67 b  (store a  0 1) N  i ))))
;
;(assign)  i := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_13_1_67 b  a  N  i ) (while_14_1_107 b  a  N  1))))
;
;(while)   while((i<N))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_14_1_107 b  a  N  i ) (< i  N )) (arrayassign_16_2_95 b  a  N  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_14_1_107 b  a  N  i ) (not (< i  N ))) (assign_20_1_113 b  a  N  i ))))
;
;(aassign) b[i] := (b[(i-1)]+2)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_16_2_95 b  a  N  i ) (assign_17_2_104 (store b  i  (+ (select b  (- i  1)) 2)) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_17_2_104 b  a  N  i ) (while_14_1_107 b  a  N  (+ i  1)))))
;
;(assign)  i := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_20_1_113 b  a  N  i ) (while_21_1_163 b  a  N  1))))
;
;(while)   while((i<N))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_163 b  a  N  i ) (< i  N )) (arrayassign_23_2_151 b  a  N  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_163 b  a  N  i ) (not (< i  N ))) (assign_27_1_169 b  a  N  i ))))
;
;(aassign) a[i] := ((a[(i-1)]+b[(i-1)])+2)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (arrayassign_23_2_151 b  a  N  i ) (assign_24_2_160 b  (store a  i  (+ (+ (select a  (- i  1)) (select b  (- i  1))) 2)) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_24_2_160 b  a  N  i ) (while_21_1_163 b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_27_1_169 b  a  N  i ) (while_28_1_218 b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_28_1_218 b  a  N  i ) (< i  N )) (assert_30_2_206 b  a  N  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_28_1_218 b  a  N  i ) (not (< i  N ))) (end b  a  N  i ))))
;
;(assert)  (a[i]==((i+1)*(i+1)))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assert_30_2_206 b  a  N  i ) (= (select a  i ) (* (+ i  1) (+ i  1))))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assert_30_2_206 b  a  N  i ) (assign_31_2_215 b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_31_2_215 b  a  N  i ) (while_28_1_218 b  a  N  (+ i  1)))))
(check-sat)
