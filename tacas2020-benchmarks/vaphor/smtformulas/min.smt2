;Number of predicates (nodes) = 13
;Number of variables = 5
;Number of clauses = 17
;
(set-logic HORN)
(declare-fun assign_24_2_134 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun assert_23_2_125 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun while_21_8_137 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun assign_20_1_103 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun assign_17_2_94 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun assign_15_3_82 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun if_14_2_86 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun while_12_8_97 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun assign_11_1_52 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun assign_10_1_46 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun assign_8_1_40 (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun end (Int (Array Int Int) Int Int Int ) Bool)
(declare-fun start (Int (Array Int Int) Int Int Int ) Bool)
(assert (forall ((min Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => true (start min  a  N  x  i ))))
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (start min  a  N  x  i ) (assign_8_1_40 min  a  N  x  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assign_8_1_40 min  a  N  x  i ) (assign_10_1_46 min  a  rnd x  i ))))
;
;(assign)  min := 0
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assign_10_1_46 min  a  N  x  i ) (assign_11_1_52 0 a  N  x  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assign_11_1_52 min  a  N  x  i ) (while_12_8_97 min  a  N  x  0))))
;
;(while)   while((i<N))
(assert (forall ((min Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_12_8_97 min  a  N  x  i ) (< i  N )) (if_14_2_86 min  a  N  x  i ))))
(assert (forall ((min Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_12_8_97 min  a  N  x  i ) (not (< i  N ))) (assign_20_1_103 min  a  N  x  i ))))
;
;(if)      if((a[i]<min))
(assert (forall ((min Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (if_14_2_86 min  a  N  x  i ) (< (select a  i ) min )) (assign_15_3_82 min  a  N  x  i ))))
(assert (forall ((min Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (if_14_2_86 min  a  N  x  i ) (not (< (select a  i ) min ))) (assign_17_2_94 min  a  N  x  i ))))
;
;(assign)  min := a[i]
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assign_15_3_82 min  a  N  x  i ) (assign_17_2_94 (select a  i ) a  N  x  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assign_17_2_94 min  a  N  x  i ) (while_12_8_97 min  a  N  x  (+ i  1)))))
;
;(assign)  x := 0
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assign_20_1_103 min  a  N  x  i ) (while_21_8_137 min  a  N  0 i ))))
;
;(while)   while((x<N))
(assert (forall ((min Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_21_8_137 min  a  N  x  i ) (< x  N )) (assert_23_2_125 min  a  N  x  i ))))
(assert (forall ((min Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_21_8_137 min  a  N  x  i ) (not (< x  N ))) (end min  a  N  x  i ))))
;
;(assert)  (a[x]>=min)
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assert_23_2_125 min  a  N  x  i ) (>= (select a  x ) min ))))
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assert_23_2_125 min  a  N  x  i ) (assign_24_2_134 min  a  N  x  i ))))
;
;(assign)  x := (x+1)
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (min Int) ) ( => (assign_24_2_134 min  a  N  x  i ) (while_21_8_137 min  a  N  (+ x  1) i ))))
(check-sat)
