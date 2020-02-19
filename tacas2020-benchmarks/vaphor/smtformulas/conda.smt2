;Number of predicates (nodes) = 18
;Number of variables = 4
;Number of clauses = 23
;
(set-logic HORN)
(declare-fun assert_35_8_208 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_32_2_186 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_31_2_177 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_29_1_189 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_28_1_156 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_22_3_123 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_24_3_144 (Int (Array Int Int) Int Int ) Bool)
(declare-fun if_21_2_147 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_19_1_150 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_18_1_86 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_15_2_77 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_14_16_68 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_12_1_80 (Int (Array Int Int) Int Int ) Bool)
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
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_11_1_50 sum  a  N  i ) (while_12_1_80 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_1_80 sum  a  N  i ) (< i  N )) (arrayassign_14_16_68 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_1_80 sum  a  N  i ) (not (< i  N ))) (assign_18_1_86 sum  a  N  i ))))
;
;(aassign) a[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_14_16_68 sum  a  N  i ) (assign_15_2_77 sum  (store a  i  1) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_15_2_77 sum  a  N  i ) (while_12_1_80 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_18_1_86 sum  a  N  i ) (while_19_1_150 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_1_150 sum  a  N  i ) (< i  N )) (if_21_2_147 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_1_150 sum  a  N  i ) (not (< i  N ))) (assign_28_1_156 sum  a  N  i ))))
;
;(if)      if((a[i]==1))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_21_2_147 sum  a  N  i ) (= (select a  i ) 1)) (arrayassign_22_3_123 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_21_2_147 sum  a  N  i ) (not (= (select a  i ) 1))) (arrayassign_24_3_144 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_22_3_123 sum  a  N  i ) (while_19_1_150 sum  (store a  i  (+ (select a  i ) 1)) N  i ))))
;
;(aassign) a[i] := (a[i]-1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_24_3_144 sum  a  N  i ) (while_19_1_150 sum  (store a  i  (- (select a  i ) 1)) N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_28_1_156 sum  a  N  i ) (while_29_1_189 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_29_1_189 sum  a  N  i ) (< i  N )) (assign_31_2_177 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_29_1_189 sum  a  N  i ) (not (< i  N ))) (assert_35_8_208 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_31_2_177 sum  a  N  i ) (assign_32_2_186 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_32_2_186 sum  a  N  i ) (while_29_1_189 sum  a  N  (+ i  1)))))
;
;(assert)  ((N<=0)||(sum==(2*N)))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_35_8_208 sum  a  N  i ) (or (<= N  0) (= sum  (* 2 N ))))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_35_8_208 sum  a  N  i ) (end sum  a  N  i ))))
(check-sat)
