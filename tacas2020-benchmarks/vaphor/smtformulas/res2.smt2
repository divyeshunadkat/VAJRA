;Number of predicates (nodes) = 29
;Number of variables = 6
;Number of clauses = 36
;
(set-logic HORN)
(declare-fun assert_55_1_302 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_52_2_280 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_51_2_271 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_49_1_283 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_48_1_250 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_45_2_241 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_44_2_232 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_42_1_244 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_41_1_214 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_38_2_205 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_37_2_196 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_35_1_208 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_34_1_175 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_31_2_166 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_30_2_157 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_28_1_169 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_27_1_139 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_24_2_130 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_23_2_121 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_21_1_133 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_20_1_100 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_17_2_91 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun arrayassign_16_2_82 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun while_14_1_94 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_13_1_64 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_12_1_58 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun assign_10_1_52 (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun end (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(declare-fun start (Int (Array Int Int) (Array Int Int) (Array Int Int) Int Int ) Bool)
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => true (start sum  c  b  a  N  i ))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (start sum  c  b  a  N  i ) (assign_10_1_52 sum  c  b  a  N  i ))))
;
;(assign)  N := Support.random()
(assert (forall ((rnd Int) (i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_10_1_52 sum  c  b  a  N  i ) (assign_12_1_58 sum  c  b  a  rnd i ))))
;
;(assign)  sum := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_12_1_58 sum  c  b  a  N  i ) (assign_13_1_64 0 c  b  a  N  i ))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_13_1_64 sum  c  b  a  N  i ) (while_14_1_94 sum  c  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_14_1_94 sum  c  b  a  N  i ) (< i  N )) (arrayassign_16_2_82 sum  c  b  a  N  i ))))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_14_1_94 sum  c  b  a  N  i ) (not (< i  N ))) (assign_20_1_100 sum  c  b  a  N  i ))))
;
;(aassign) a[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (arrayassign_16_2_82 sum  c  b  a  N  i ) (assign_17_2_91 sum  c  b  (store a  i  1) N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_17_2_91 sum  c  b  a  N  i ) (while_14_1_94 sum  c  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_20_1_100 sum  c  b  a  N  i ) (while_21_1_133 sum  c  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_133 sum  c  b  a  N  i ) (< i  N )) (assign_23_2_121 sum  c  b  a  N  i ))))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_21_1_133 sum  c  b  a  N  i ) (not (< i  N ))) (assign_27_1_139 sum  c  b  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_23_2_121 sum  c  b  a  N  i ) (assign_24_2_130 (+ sum  (select a  i )) c  b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_24_2_130 sum  c  b  a  N  i ) (while_21_1_133 sum  c  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_27_1_139 sum  c  b  a  N  i ) (while_28_1_169 sum  c  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_28_1_169 sum  c  b  a  N  i ) (< i  N )) (arrayassign_30_2_157 sum  c  b  a  N  i ))))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_28_1_169 sum  c  b  a  N  i ) (not (< i  N ))) (assign_34_1_175 sum  c  b  a  N  i ))))
;
;(aassign) b[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (arrayassign_30_2_157 sum  c  b  a  N  i ) (assign_31_2_166 sum  c  (store b  i  1) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_31_2_166 sum  c  b  a  N  i ) (while_28_1_169 sum  c  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_34_1_175 sum  c  b  a  N  i ) (while_35_1_208 sum  c  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_35_1_208 sum  c  b  a  N  i ) (< i  N )) (assign_37_2_196 sum  c  b  a  N  i ))))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_35_1_208 sum  c  b  a  N  i ) (not (< i  N ))) (assign_41_1_214 sum  c  b  a  N  i ))))
;
;(assign)  sum := (sum+b[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_37_2_196 sum  c  b  a  N  i ) (assign_38_2_205 (+ sum  (select b  i )) c  b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_38_2_205 sum  c  b  a  N  i ) (while_35_1_208 sum  c  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_41_1_214 sum  c  b  a  N  i ) (while_42_1_244 sum  c  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_42_1_244 sum  c  b  a  N  i ) (< i  N )) (arrayassign_44_2_232 sum  c  b  a  N  i ))))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_42_1_244 sum  c  b  a  N  i ) (not (< i  N ))) (assign_48_1_250 sum  c  b  a  N  i ))))
;
;(aassign) c[i] := 1
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (arrayassign_44_2_232 sum  c  b  a  N  i ) (assign_45_2_241 sum  (store c  i  1) b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_45_2_241 sum  c  b  a  N  i ) (while_42_1_244 sum  c  b  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_48_1_250 sum  c  b  a  N  i ) (while_49_1_283 sum  c  b  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_49_1_283 sum  c  b  a  N  i ) (< i  N )) (assign_51_2_271 sum  c  b  a  N  i ))))
(assert (forall ((sum Int) (c (Array Int Int)) (b (Array Int Int)) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_49_1_283 sum  c  b  a  N  i ) (not (< i  N ))) (assert_55_1_302 sum  c  b  a  N  i ))))
;
;(assign)  sum := (sum+c[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_51_2_271 sum  c  b  a  N  i ) (assign_52_2_280 (+ sum  (select c  i )) c  b  a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assign_52_2_280 sum  c  b  a  N  i ) (while_49_1_283 sum  c  b  a  N  (+ i  1)))))
;
;(assert)  ((N<=0)||(sum<=(3*N)))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assert_55_1_302 sum  c  b  a  N  i ) (or (<= N  0) (<= sum  (* 3 N ))))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (b (Array Int Int)) (c (Array Int Int)) (sum Int) ) ( => (assert_55_1_302 sum  c  b  a  N  i ) (end sum  c  b  a  N  i ))))
(check-sat)
