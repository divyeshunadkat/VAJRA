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
(assert (forall ((max Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => true (start max  a  N  x  i ))))
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (start max  a  N  x  i ) (assign_8_1_40 max  a  N  x  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assign_8_1_40 max  a  N  x  i ) (assign_10_1_46 max  a  rnd x  i ))))
;
;(assign)  max := 0
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assign_10_1_46 max  a  N  x  i ) (assign_11_1_52 0 a  N  x  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assign_11_1_52 max  a  N  x  i ) (while_12_8_97 max  a  N  x  0))))
;
;(while)   while((i<N))
(assert (forall ((max Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_12_8_97 max  a  N  x  i ) (< i  N )) (if_14_2_86 max  a  N  x  i ))))
(assert (forall ((max Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_12_8_97 max  a  N  x  i ) (not (< i  N ))) (assign_20_1_103 max  a  N  x  i ))))
;
;(if)      if((a[i]>max))
(assert (forall ((max Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (if_14_2_86 max  a  N  x  i ) (> (select a  i ) max )) (assign_15_3_82 max  a  N  x  i ))))
(assert (forall ((max Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (if_14_2_86 max  a  N  x  i ) (not (> (select a  i ) max ))) (assign_17_2_94 max  a  N  x  i ))))
;
;(assign)  max := a[i]
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assign_15_3_82 max  a  N  x  i ) (assign_17_2_94 (select a  i ) a  N  x  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assign_17_2_94 max  a  N  x  i ) (while_12_8_97 max  a  N  x  (+ i  1)))))
;
;(assign)  x := 0
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assign_20_1_103 max  a  N  x  i ) (while_21_8_137 max  a  N  0 i ))))
;
;(while)   while((x<N))
(assert (forall ((max Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_21_8_137 max  a  N  x  i ) (< x  N )) (assert_23_2_125 max  a  N  x  i ))))
(assert (forall ((max Int) (a (Array Int Int)) (N Int) (x Int) (i Int) ) ( => ( and (while_21_8_137 max  a  N  x  i ) (not (< x  N ))) (end max  a  N  x  i ))))
;
;(assert)  (a[x]<=max)
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assert_23_2_125 max  a  N  x  i ) (<= (select a  x ) max ))))
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assert_23_2_125 max  a  N  x  i ) (assign_24_2_134 max  a  N  x  i ))))
;
;(assign)  x := (x+1)
(assert (forall ((i Int) (x Int) (N Int) (a (Array Int Int)) (max Int) ) ( => (assign_24_2_134 max  a  N  x  i ) (while_21_8_137 max  a  N  (+ x  1) i ))))
(check-sat)
