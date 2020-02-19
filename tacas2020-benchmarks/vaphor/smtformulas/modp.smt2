;Number of predicates (nodes) = 16
;Number of variables = 4
;Number of clauses = 20
;
(set-logic HORN)
(declare-fun assign_29_2_155 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assert_28_2_146 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_26_8_158 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_25_1_121 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_22_2_112 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_21_2_103 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_19_8_115 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_18_1_85 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_15_2_76 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_14_2_67 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_12_8_79 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_11_1_50 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_10_1_44 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_8_1_38 (Int (Array Int Int) Int Int ) Bool)
(declare-fun end (Int (Array Int Int) Int Int ) Bool)
(declare-fun start (Int (Array Int Int) Int Int ) Bool)
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start sum  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (start sum  a  N  i ) (assign_8_1_38 sum  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_8_1_38 sum  a  N  i ) (assign_10_1_44 sum  a  rnd i ))))
;
;(assign)  sum := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_10_1_44 sum  a  N  i ) (assign_11_1_50 0 a  N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_11_1_50 sum  a  N  i ) (while_12_8_79 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_8_79 sum  a  N  i ) (< i  N )) (assign_14_2_67 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_8_79 sum  a  N  i ) (not (< i  N ))) (assign_18_1_85 sum  a  N  i ))))
;
;(assign)  sum := (sum+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_14_2_67 sum  a  N  i ) (assign_15_2_76 (+ sum  1) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_15_2_76 sum  a  N  i ) (while_12_8_79 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_18_1_85 sum  a  N  i ) (while_19_8_115 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_8_115 sum  a  N  i ) (< i  N )) (arrayassign_21_2_103 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_8_115 sum  a  N  i ) (not (< i  N ))) (assign_25_1_121 sum  a  N  i ))))
;
;(aassign) a[i] := sum
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_21_2_103 sum  a  N  i ) (assign_22_2_112 sum  (store a  i  sum ) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_22_2_112 sum  a  N  i ) (while_19_8_115 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_25_1_121 sum  a  N  i ) (while_26_8_158 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_8_158 sum  a  N  i ) (< i  N )) (assert_28_2_146 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_8_158 sum  a  N  i ) (not (< i  N ))) (end sum  a  N  i ))))
;
;(assert)  ((a[i]%N)==0)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_28_2_146 sum  a  N  i ) (= (mod (select a  i ) N ) 0))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_28_2_146 sum  a  N  i ) (assign_29_2_155 sum  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_29_2_155 sum  a  N  i ) (while_26_8_158 sum  a  N  (+ i  1)))))
(check-sat)
