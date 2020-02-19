;Number of predicates (nodes) = 13
;Number of variables = 6
;Number of clauses = 17
;
(set-logic HORN)
(declare-fun assign_22_2_148 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun assert_21_2_139 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun while_19_8_151 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun assign_18_1_107 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun assign_15_2_98 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun assign_13_3_86 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun if_12_2_90 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun while_11_1_101 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun assign_10_1_55 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun assign_9_1_49 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun assign_7_1_43 ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun end ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(declare-fun start ((Array Int Int) (Array Int Int) Int Int Int Int ) Bool)
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (rv Int) (SIZE Int) (x Int) (i Int) ) ( => true (start b  a  rv  SIZE  x  i ))))
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (start b  a  rv  SIZE  x  i ) (assign_7_1_43 b  a  rv  SIZE  x  i ))))
;
;(assign)  SIZE := Support.random()
(assert (forall ((rnd Int) (i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_7_1_43 b  a  rv  SIZE  x  i ) (assign_9_1_49 b  a  rv  rnd x  i ))))
;
;(assign)  rv := 1
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_9_1_49 b  a  rv  SIZE  x  i ) (assign_10_1_55 b  a  1 SIZE  x  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_10_1_55 b  a  rv  SIZE  x  i ) (while_11_1_101 b  a  rv  SIZE  x  0))))
;
;(while)   while((i<SIZE))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (rv Int) (SIZE Int) (x Int) (i Int) ) ( => ( and (while_11_1_101 b  a  rv  SIZE  x  i ) (< i  SIZE )) (if_12_2_90 b  a  rv  SIZE  x  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (rv Int) (SIZE Int) (x Int) (i Int) ) ( => ( and (while_11_1_101 b  a  rv  SIZE  x  i ) (not (< i  SIZE ))) (assign_18_1_107 b  a  rv  SIZE  x  i ))))
;
;(if)      if((!(a[i]==b[i])))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (rv Int) (SIZE Int) (x Int) (i Int) ) ( => ( and (if_12_2_90 b  a  rv  SIZE  x  i ) (not (= (select a  i ) (select b  i )))) (assign_13_3_86 b  a  rv  SIZE  x  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (rv Int) (SIZE Int) (x Int) (i Int) ) ( => ( and (if_12_2_90 b  a  rv  SIZE  x  i ) (not (not (= (select a  i ) (select b  i ))))) (assign_15_2_98 b  a  rv  SIZE  x  i ))))
;
;(assign)  rv := 0
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_13_3_86 b  a  rv  SIZE  x  i ) (assign_15_2_98 b  a  0 SIZE  x  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_15_2_98 b  a  rv  SIZE  x  i ) (while_11_1_101 b  a  rv  SIZE  x  (+ i  1)))))
;
;(assign)  x := 0
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_18_1_107 b  a  rv  SIZE  x  i ) (while_19_8_151 b  a  rv  SIZE  0 i ))))
;
;(while)   while((x<SIZE))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (rv Int) (SIZE Int) (x Int) (i Int) ) ( => ( and (while_19_8_151 b  a  rv  SIZE  x  i ) (< x  SIZE )) (assert_21_2_139 b  a  rv  SIZE  x  i ))))
(assert (forall ((b (Array Int Int)) (a (Array Int Int)) (rv Int) (SIZE Int) (x Int) (i Int) ) ( => ( and (while_19_8_151 b  a  rv  SIZE  x  i ) (not (< x  SIZE ))) (end b  a  rv  SIZE  x  i ))))
;
;(assert)  ((rv==0)||(a[x]==b[x]))
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assert_21_2_139 b  a  rv  SIZE  x  i ) (or (= rv  0) (= (select a  x ) (select b  x ))))))
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assert_21_2_139 b  a  rv  SIZE  x  i ) (assign_22_2_148 b  a  rv  SIZE  x  i ))))
;
;(assign)  x := (x+1)
(assert (forall ((i Int) (x Int) (SIZE Int) (rv Int) (a (Array Int Int)) (b (Array Int Int)) ) ( => (assign_22_2_148 b  a  rv  SIZE  x  i ) (while_19_8_151 b  a  rv  SIZE  (+ x  1) i ))))
(check-sat)
