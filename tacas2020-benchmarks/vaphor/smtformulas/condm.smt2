;Number of predicates (nodes) = 17
;Number of variables = 3
;Number of clauses = 22
;
(set-logic HORN)
(declare-fun assign_33_2_191 ((Array Int Int) Int Int ) Bool)
(declare-fun assert_32_2_182 ((Array Int Int) Int Int ) Bool)
(declare-fun while_30_1_194 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_29_1_154 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_26_2_145 ((Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_20_3_112 ((Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_24_3_133 ((Array Int Int) Int Int ) Bool)
(declare-fun if_18_2_136 ((Array Int Int) Int Int ) Bool)
(declare-fun while_16_1_148 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_15_1_76 ((Array Int Int) Int Int ) Bool)
(declare-fun assign_12_2_67 ((Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_11_2_58 ((Array Int Int) Int Int ) Bool)
(declare-fun while_9_1_70 ((Array Int Int) Int Int ) Bool)
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
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_8_1_40 a  N  i ) (while_9_1_70 a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_9_1_70 a  N  i ) (< i  N )) (arrayassign_11_2_58 a  N  i ))))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_9_1_70 a  N  i ) (not (< i  N ))) (assign_15_1_76 a  N  i ))))
;
;(aassign) a[i] := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (arrayassign_11_2_58 a  N  i ) (assign_12_2_67 (store a  i  0) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_12_2_67 a  N  i ) (while_9_1_70 a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_15_1_76 a  N  i ) (while_16_1_148 a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_16_1_148 a  N  i ) (< i  N )) (if_18_2_136 a  N  i ))))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_16_1_148 a  N  i ) (not (< i  N ))) (assign_29_1_154 a  N  i ))))
;
;(if)      if(((N%2)==0))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_18_2_136 a  N  i ) (= (mod N  2) 0)) (arrayassign_20_3_112 a  N  i ))))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_18_2_136 a  N  i ) (not (= (mod N  2) 0))) (arrayassign_24_3_133 a  N  i ))))
;
;(aassign) a[i] := (a[i]+2)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (arrayassign_20_3_112 a  N  i ) (assign_26_2_145 (store a  i  (+ (select a  i ) 2)) N  i ))))
;
;(aassign) a[i] := (a[i]+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (arrayassign_24_3_133 a  N  i ) (assign_26_2_145 (store a  i  (+ (select a  i ) 1)) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_26_2_145 a  N  i ) (while_16_1_148 a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_29_1_154 a  N  i ) (while_30_1_194 a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_30_1_194 a  N  i ) (< i  N )) (assert_32_2_182 a  N  i ))))
(assert (forall ((a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_30_1_194 a  N  i ) (not (< i  N ))) (end a  N  i ))))
;
;(assert)  ((a[i]%2)==(N%2))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assert_32_2_182 a  N  i ) (= (mod (select a  i ) 2) (mod N  2)))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assert_32_2_182 a  N  i ) (assign_33_2_191 a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) ) ( => (assign_33_2_191 a  N  i ) (while_30_1_194 a  N  (+ i  1)))))
(check-sat)
