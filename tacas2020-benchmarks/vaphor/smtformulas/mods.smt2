;Number of predicates (nodes) = 24
;Number of variables = 4
;Number of clauses = 30
;
(set-logic HORN)
(declare-fun assign_42_2_248 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assert_41_2_239 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_39_1_251 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_38_1_217 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_35_2_208 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_34_2_199 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_32_1_211 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_31_1_168 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_28_2_159 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_27_2_150 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_25_1_162 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_24_1_125 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_21_2_116 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_20_2_107 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_18_1_119 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_17_1_86 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_14_2_77 (Int (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_13_16_68 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_11_1_80 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_10_1_50 (Int (Array Int Int) Int Int ) Bool)
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
;(assign)  sum := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_9_1_44 sum  a  N  i ) (assign_10_1_50 0 a  N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_10_1_50 sum  a  N  i ) (while_11_1_80 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_11_1_80 sum  a  N  i ) (< i  N )) (arrayassign_13_16_68 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_11_1_80 sum  a  N  i ) (not (< i  N ))) (assign_17_1_86 sum  a  N  i ))))
;
;(aassign) a[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_13_16_68 sum  a  N  i ) (assign_14_2_77 sum  (store a  i  1) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_14_2_77 sum  a  N  i ) (while_11_1_80 sum  a  N  (+ i  1)))))
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
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_24_1_125 sum  a  N  i ) (while_25_1_162 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_25_1_162 sum  a  N  i ) (< i  N )) (arrayassign_27_2_150 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_25_1_162 sum  a  N  i ) (not (< i  N ))) (assign_31_1_168 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_27_2_150 sum  a  N  i ) (assign_28_2_159 sum  (store a  i  (+ (select a  i ) sum )) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_28_2_159 sum  a  N  i ) (while_25_1_162 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_31_1_168 sum  a  N  i ) (while_32_1_211 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_32_1_211 sum  a  N  i ) (< i  N )) (arrayassign_34_2_199 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_32_1_211 sum  a  N  i ) (not (< i  N ))) (assign_38_1_217 sum  a  N  i ))))
;
;(aassign) a[i] := (a[i]%(sum+1))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (arrayassign_34_2_199 sum  a  N  i ) (assign_35_2_208 sum  (store a  i  (mod (select a  i ) (+ sum  1))) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_35_2_208 sum  a  N  i ) (while_32_1_211 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_38_1_217 sum  a  N  i ) (while_39_1_251 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_39_1_251 sum  a  N  i ) (< i  N )) (assert_41_2_239 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_39_1_251 sum  a  N  i ) (not (< i  N ))) (end sum  a  N  i ))))
;
;(assert)  (a[i]==0)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_41_2_239 sum  a  N  i ) (= (select a  i ) 0))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_41_2_239 sum  a  N  i ) (assign_42_2_248 sum  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_42_2_248 sum  a  N  i ) (while_39_1_251 sum  a  N  (+ i  1)))))
(check-sat)
