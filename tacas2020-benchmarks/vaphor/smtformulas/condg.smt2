;Number of predicates (nodes) = 22
;Number of variables = 4
;Number of clauses = 28
;
(set-logic HORN)
(declare-fun assign_39_2_231 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assert_38_16_222 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_36_1_234 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_35_1_200 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_32_2_191 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_28_3_158 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_30_3_179 (Int (Array Int Int) Int Int ) Bool)
(declare-fun if_27_9_182 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_25_1_194 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_24_1_125 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_21_2_116 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_20_2_107 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_18_1_119 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_17_1_86 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_16_1_80 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_13_2_71 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_12_16_62 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_10_1_74 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_9_1_44 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_8_1_38 (Int (Array Int Int) Int Int ) Bool)
(declare-fun end (Int (Array Int Int) Int Int ) Bool)
(declare-fun start (Int (Array Int Int) Int Int ) Bool)
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start sum  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (start sum  a  N  i ) (assign_8_1_38 sum  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_8_1_38 sum  a  N  i ) (assign_9_1_44 sum  a  rnd i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_9_1_44 sum  a  N  i ) (while_10_1_74 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_10_1_74 sum  a  N  i ) (< i  N )) (arrayassign_12_16_62 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_10_1_74 sum  a  N  i ) (not (< i  N ))) (assign_16_1_80 sum  a  N  i ))))
;
;(aassign) a[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_12_16_62 sum  a  N  i ) (assign_13_2_71 sum  (store a  i  1) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_13_2_71 sum  a  N  i ) (while_10_1_74 sum  a  N  (+ i  1)))))
;
;(assign)  sum := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_16_1_80 sum  a  N  i ) (assign_17_1_86 0 a  N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_17_1_86 sum  a  N  i ) (while_18_1_119 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_18_1_119 sum  a  N  i ) (< i  N )) (assign_20_2_107 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_18_1_119 sum  a  N  i ) (not (< i  N ))) (assign_24_1_125 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_20_2_107 sum  a  N  i ) (assign_21_2_116 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_21_2_116 sum  a  N  i ) (while_18_1_119 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_24_1_125 sum  a  N  i ) (while_25_1_194 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_25_1_194 sum  a  N  i ) (< i  N )) (if_27_9_182 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_25_1_194 sum  a  N  i ) (not (< i  N ))) (assign_35_1_200 sum  a  N  i ))))
;
;(if)      if((sum==N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_27_9_182 sum  a  N  i ) (= sum  N )) (arrayassign_28_3_158 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (if_27_9_182 sum  a  N  i ) (not (= sum  N ))) (arrayassign_30_3_179 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]-1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_28_3_158 sum  a  N  i ) (assign_32_2_191 sum  (store a  i  (- (select a  i ) 1)) N  i ))))
;
;(aassign) a[i] := (a[i]+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_30_3_179 sum  a  N  i ) (assign_32_2_191 sum  (store a  i  (+ (select a  i ) 1)) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_32_2_191 sum  a  N  i ) (while_25_1_194 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_35_1_200 sum  a  N  i ) (while_36_1_234 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_36_1_234 sum  a  N  i ) (< i  N )) (assert_38_16_222 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_36_1_234 sum  a  N  i ) (not (< i  N ))) (end sum  a  N  i ))))
;
;(assert)  (a[i]==0)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_38_16_222 sum  a  N  i ) (= (select a  i ) 0))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_38_16_222 sum  a  N  i ) (assign_39_2_231 sum  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_39_2_231 sum  a  N  i ) (while_36_1_234 sum  a  N  (+ i  1)))))
(check-sat)
