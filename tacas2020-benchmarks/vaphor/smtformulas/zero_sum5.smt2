;Number of predicates (nodes) = 45
;Number of variables = 4
;Number of clauses = 56
;
(set-logic HORN)
(declare-fun assert_81_1_444 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_78_2_431 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_77_2_422 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_75_1_434 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_74_1_401 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_71_2_392 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_70_2_383 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_68_1_395 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_67_1_362 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_64_2_353 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_63_2_344 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_61_1_356 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_60_1_323 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_57_2_314 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_56_2_305 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_54_1_317 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_53_1_284 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_50_2_275 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_49_2_266 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_47_1_278 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_46_1_245 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_43_2_236 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_42_2_227 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_40_1_239 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_39_1_206 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_36_2_197 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_35_2_188 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_33_1_200 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_32_1_167 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_29_2_158 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_28_2_149 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_26_1_161 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_25_1_128 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_22_2_119 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_21_2_110 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_19_1_122 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_18_1_89 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_15_2_80 (Int (Array Int Int) Int Int ) Bool)
(declare-fun assign_14_2_71 (Int (Array Int Int) Int Int ) Bool)
(declare-fun while_12_1_83 (Int (Array Int Int) Int Int ) Bool)
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
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_11_1_50 sum  a  N  i ) (while_12_1_83 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_1_83 sum  a  N  i ) (< i  N )) (assign_14_2_71 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_12_1_83 sum  a  N  i ) (not (< i  N ))) (assign_18_1_89 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_14_2_71 sum  a  N  i ) (assign_15_2_80 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_15_2_80 sum  a  N  i ) (while_12_1_83 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_18_1_89 sum  a  N  i ) (while_19_1_122 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_1_122 sum  a  N  i ) (< i  N )) (assign_21_2_110 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_19_1_122 sum  a  N  i ) (not (< i  N ))) (assign_25_1_128 sum  a  N  i ))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_21_2_110 sum  a  N  i ) (assign_22_2_119 (- sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_22_2_119 sum  a  N  i ) (while_19_1_122 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_25_1_128 sum  a  N  i ) (while_26_1_161 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_1_161 sum  a  N  i ) (< i  N )) (assign_28_2_149 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_26_1_161 sum  a  N  i ) (not (< i  N ))) (assign_32_1_167 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_28_2_149 sum  a  N  i ) (assign_29_2_158 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_29_2_158 sum  a  N  i ) (while_26_1_161 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_32_1_167 sum  a  N  i ) (while_33_1_200 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_33_1_200 sum  a  N  i ) (< i  N )) (assign_35_2_188 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_33_1_200 sum  a  N  i ) (not (< i  N ))) (assign_39_1_206 sum  a  N  i ))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_35_2_188 sum  a  N  i ) (assign_36_2_197 (- sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_36_2_197 sum  a  N  i ) (while_33_1_200 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_39_1_206 sum  a  N  i ) (while_40_1_239 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_40_1_239 sum  a  N  i ) (< i  N )) (assign_42_2_227 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_40_1_239 sum  a  N  i ) (not (< i  N ))) (assign_46_1_245 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_42_2_227 sum  a  N  i ) (assign_43_2_236 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_43_2_236 sum  a  N  i ) (while_40_1_239 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_46_1_245 sum  a  N  i ) (while_47_1_278 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_47_1_278 sum  a  N  i ) (< i  N )) (assign_49_2_266 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_47_1_278 sum  a  N  i ) (not (< i  N ))) (assign_53_1_284 sum  a  N  i ))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_49_2_266 sum  a  N  i ) (assign_50_2_275 (- sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_50_2_275 sum  a  N  i ) (while_47_1_278 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_53_1_284 sum  a  N  i ) (while_54_1_317 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_54_1_317 sum  a  N  i ) (< i  N )) (assign_56_2_305 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_54_1_317 sum  a  N  i ) (not (< i  N ))) (assign_60_1_323 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_56_2_305 sum  a  N  i ) (assign_57_2_314 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_57_2_314 sum  a  N  i ) (while_54_1_317 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_60_1_323 sum  a  N  i ) (while_61_1_356 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_61_1_356 sum  a  N  i ) (< i  N )) (assign_63_2_344 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_61_1_356 sum  a  N  i ) (not (< i  N ))) (assign_67_1_362 sum  a  N  i ))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_63_2_344 sum  a  N  i ) (assign_64_2_353 (- sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_64_2_353 sum  a  N  i ) (while_61_1_356 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_67_1_362 sum  a  N  i ) (while_68_1_395 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_68_1_395 sum  a  N  i ) (< i  N )) (assign_70_2_383 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_68_1_395 sum  a  N  i ) (not (< i  N ))) (assign_74_1_401 sum  a  N  i ))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_70_2_383 sum  a  N  i ) (assign_71_2_392 (+ sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_71_2_392 sum  a  N  i ) (while_68_1_395 sum  a  N  (+ i  1)))))
;
;(assign)  i := 0
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_74_1_401 sum  a  N  i ) (while_75_1_434 sum  a  N  0))))
;
;(while)   while((i<N))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_75_1_434 sum  a  N  i ) (< i  N )) (assign_77_2_422 sum  a  N  i ))))
(assert (forall ((sum Int) (a (Array Int Int)) (N Int) (i Int) ) ( => ( and (while_75_1_434 sum  a  N  i ) (not (< i  N ))) (assert_81_1_444 sum  a  N  i ))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_77_2_422 sum  a  N  i ) (assign_78_2_431 (- sum  (select a  i )) a  N  i ))))
;
;(assign)  i := (i+1)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assign_78_2_431 sum  a  N  i ) (while_75_1_434 sum  a  N  (+ i  1)))))
;
;(assert)  (sum==0)
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_81_1_444 sum  a  N  i ) (= sum  0))))
(assert (forall ((i Int) (N Int) (a (Array Int Int)) (sum Int) ) ( => (assert_81_1_444 sum  a  N  i ) (end sum  a  N  i ))))
(check-sat)
