;Number of predicates (nodes) = 13
;Number of variables = 3
;Number of clauses = 17
;
(set-logic HORN)
(declare-fun assign_24_2_140 ((Array Int Int) Int Int ) Bool)
(declare-fun assert_23_2_131 ((Array Int Int) Int Int ) Bool)
(declare-fun while_21_1_143 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_20_1_109 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_17_2_100 ((Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_13_3_74 ((Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_15_3_88 ((Array Int Int) Int Int ) Bool)
(declare-fun if_11_2_91 ((Array Int Int) Int Int ) Bool)
(declare-fun while_9_1_103 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_8_1_40 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_7_1_34 ((Array Int Int) Int Int ) Bool)
(declare-fun end ((Array Int Int) Int Int ) Bool)
(declare-fun start ((Array Int Int) Int Int ) Bool)
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => true (start a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (start a  N  i ) (assign_7_1_34 a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) ) ( => (assign_7_1_34 a  N  i ) (assign_8_1_40 a  rnd i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_8_1_40 a  N  i ) (while_9_1_103 a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_9_1_103 a  N  i ) (< i  N )) (if_11_2_91 a  N  i ))))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_9_1_103 a  N  i ) (not (< i  N ))) (assign_20_1_109 a  N  i ))))
;
;(if)      if((a[i]<N))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_11_2_91 a  N  i ) (< (select a  i ) N )) (arrayassign_13_3_74 a  N  i ))))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_11_2_91 a  N  i ) (not (< (select a  i ) N ))) (arrayassign_15_3_88 a  N  i ))))
;
;(aassign) a[i] := a[i]
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (arrayassign_13_3_74 a  N  i ) (assign_17_2_100 (store a  i  (select a  i )) N  i ))))
;
;(aassign) a[i] := N
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (arrayassign_15_3_88 a  N  i ) (assign_17_2_100 (store a  i  N ) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_17_2_100 a  N  i ) (while_9_1_103 a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_20_1_109 a  N  i ) (while_21_1_143 a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_143 a  N  i ) (< i  N )) (assert_23_2_131 a  N  i ))))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_143 a  N  i ) (not (< i  N ))) (end a  N  i ))))
;
;(assert)  (a[i]<=N)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assert_23_2_131 a  N  i ) (<= (select a  i ) N ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assert_23_2_131 a  N  i ) (assign_24_2_140 a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_24_2_140 a  N  i ) (while_21_1_143 a  N  (+ i  1)))))
(check-sat)
