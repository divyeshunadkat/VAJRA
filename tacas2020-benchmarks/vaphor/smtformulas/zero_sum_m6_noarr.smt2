;Number of predicates (nodes) = 53
;Number of variables = 4
;Number of clauses = 66
;
(set-logic HORN)
(declare-rel assert_95_1_522 (Int Int Int Int Int Int))
(declare-rel assign_92_2_509 (Int Int Int Int Int Int))
(declare-rel assign_91_2_500 (Int Int Int Int Int Int))
(declare-rel while_89_1_512 (Int Int Int Int Int Int))
(declare-rel assign_88_1_479 (Int Int Int Int Int Int))
(declare-rel assign_85_2_470 (Int Int Int Int Int Int))
(declare-rel assign_84_2_461 (Int Int Int Int Int Int))
(declare-rel while_82_1_473 (Int Int Int Int Int Int))
(declare-rel assign_81_1_440 (Int Int Int Int Int Int))
(declare-rel assign_78_2_431 (Int Int Int Int Int Int))
(declare-rel assign_77_2_422 (Int Int Int Int Int Int))
(declare-rel while_75_1_434 (Int Int Int Int Int Int))
(declare-rel assign_74_1_401 (Int Int Int Int Int Int))
(declare-rel assign_71_2_392 (Int Int Int Int Int Int))
(declare-rel assign_70_2_383 (Int Int Int Int Int Int))
(declare-rel while_68_1_395 (Int Int Int Int Int Int))
(declare-rel assign_67_1_362 (Int Int Int Int Int Int))
(declare-rel assign_64_2_353 (Int Int Int Int Int Int))
(declare-rel assign_63_2_344 (Int Int Int Int Int Int))
(declare-rel while_61_1_356 (Int Int Int Int Int Int))
(declare-rel assign_60_1_323 (Int Int Int Int Int Int))
(declare-rel assign_57_2_314 (Int Int Int Int Int Int))
(declare-rel assign_56_2_305 (Int Int Int Int Int Int))
(declare-rel while_54_1_317 (Int Int Int Int Int Int))
(declare-rel assign_53_1_284 (Int Int Int Int Int Int))
(declare-rel assign_50_2_275 (Int Int Int Int Int Int))
(declare-rel assign_49_2_266 (Int Int Int Int Int Int))
(declare-rel while_47_1_278 (Int Int Int Int Int Int))
(declare-rel assign_46_1_245 (Int Int Int Int Int Int))
(declare-rel assign_43_2_236 (Int Int Int Int Int Int))
(declare-rel assign_42_2_227 (Int Int Int Int Int Int))
(declare-rel while_40_1_239 (Int Int Int Int Int Int))
(declare-rel assign_39_1_206 (Int Int Int Int Int Int))
(declare-rel assign_36_2_197 (Int Int Int Int Int Int))
(declare-rel assign_35_2_188 (Int Int Int Int Int Int))
(declare-rel while_33_1_200 (Int Int Int Int Int Int))
(declare-rel assign_32_1_167 (Int Int Int Int Int Int))
(declare-rel assign_29_2_158 (Int Int Int Int Int Int))
(declare-rel assign_28_2_149 (Int Int Int Int Int Int))
(declare-rel while_26_1_161 (Int Int Int Int Int Int))
(declare-rel assign_25_1_128 (Int Int Int Int Int Int))
(declare-rel assign_22_2_119 (Int Int Int Int Int Int))
(declare-rel assign_21_2_110 (Int Int Int Int Int Int))
(declare-rel while_19_1_122 (Int Int Int Int Int Int))
(declare-rel assign_18_1_89 (Int Int Int Int Int Int))
(declare-rel assign_15_2_80 (Int Int Int Int Int Int))
(declare-rel assign_14_2_71 (Int Int Int Int Int Int))
(declare-rel while_12_1_83 (Int Int Int Int Int Int))
(declare-rel assign_11_1_50 (Int Int Int Int Int Int))
(declare-rel assign_10_1_44 (Int Int Int Int Int Int))
(declare-rel assign_8_1_38 (Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (<= 0 a_size) (start sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (start sum a_size a1_ind a1_val N i)) (assign_8_1_38 sum a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (rnd Int) (sum Int)) (=> (and (<= 0 a_size) (assign_8_1_38 sum a_size a1_ind a1_val N i)) (assign_10_1_44 sum a_size a1_ind a1_val rnd i))))
;
;(assign)  sum := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_10_1_44 sum a_size a1_ind a1_val N i)) (assign_11_1_50 0 a_size a1_ind a1_val N i))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_11_1_50 sum a_size a1_ind a1_val N i)) (while_12_1_83 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_12_1_83 sum a_size a1_ind a1_val N i) (< i N)) (assign_14_2_71 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_12_1_83 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_18_1_89 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_14_2_71 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_14_2_71 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_14_2_71 sum a_size i tmp_select_a N i)))) (assign_15_2_80 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_15_2_80 sum a_size a1_ind a1_val N i)) (while_12_1_83 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_18_1_89 sum a_size a1_ind a1_val N i)) (while_19_1_122 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_19_1_122 sum a_size a1_ind a1_val N i) (< i N)) (assign_21_2_110 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_19_1_122 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_25_1_128 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_21_2_110 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_21_2_110 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_21_2_110 sum a_size i tmp_select_a N i)))) (assign_22_2_119 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_22_2_119 sum a_size a1_ind a1_val N i)) (while_19_1_122 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_25_1_128 sum a_size a1_ind a1_val N i)) (while_26_1_161 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_26_1_161 sum a_size a1_ind a1_val N i) (< i N)) (assign_28_2_149 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_26_1_161 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_32_1_167 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_28_2_149 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_28_2_149 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_28_2_149 sum a_size i tmp_select_a N i)))) (assign_29_2_158 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_29_2_158 sum a_size a1_ind a1_val N i)) (while_26_1_161 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_32_1_167 sum a_size a1_ind a1_val N i)) (while_33_1_200 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_33_1_200 sum a_size a1_ind a1_val N i) (< i N)) (assign_35_2_188 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_33_1_200 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_39_1_206 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_35_2_188 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_35_2_188 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_35_2_188 sum a_size i tmp_select_a N i)))) (assign_36_2_197 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_36_2_197 sum a_size a1_ind a1_val N i)) (while_33_1_200 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_39_1_206 sum a_size a1_ind a1_val N i)) (while_40_1_239 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_40_1_239 sum a_size a1_ind a1_val N i) (< i N)) (assign_42_2_227 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_40_1_239 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_46_1_245 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_42_2_227 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_42_2_227 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_42_2_227 sum a_size i tmp_select_a N i)))) (assign_43_2_236 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_43_2_236 sum a_size a1_ind a1_val N i)) (while_40_1_239 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_46_1_245 sum a_size a1_ind a1_val N i)) (while_47_1_278 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_47_1_278 sum a_size a1_ind a1_val N i) (< i N)) (assign_49_2_266 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_47_1_278 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_53_1_284 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_49_2_266 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_49_2_266 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_49_2_266 sum a_size i tmp_select_a N i)))) (assign_50_2_275 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_50_2_275 sum a_size a1_ind a1_val N i)) (while_47_1_278 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_53_1_284 sum a_size a1_ind a1_val N i)) (while_54_1_317 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_54_1_317 sum a_size a1_ind a1_val N i) (< i N)) (assign_56_2_305 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_54_1_317 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_60_1_323 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_56_2_305 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_56_2_305 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_56_2_305 sum a_size i tmp_select_a N i)))) (assign_57_2_314 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_57_2_314 sum a_size a1_ind a1_val N i)) (while_54_1_317 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_60_1_323 sum a_size a1_ind a1_val N i)) (while_61_1_356 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_61_1_356 sum a_size a1_ind a1_val N i) (< i N)) (assign_63_2_344 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_61_1_356 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_67_1_362 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_63_2_344 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_63_2_344 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_63_2_344 sum a_size i tmp_select_a N i)))) (assign_64_2_353 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_64_2_353 sum a_size a1_ind a1_val N i)) (while_61_1_356 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_67_1_362 sum a_size a1_ind a1_val N i)) (while_68_1_395 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_68_1_395 sum a_size a1_ind a1_val N i) (< i N)) (assign_70_2_383 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_68_1_395 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_74_1_401 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_70_2_383 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_70_2_383 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_70_2_383 sum a_size i tmp_select_a N i)))) (assign_71_2_392 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_71_2_392 sum a_size a1_ind a1_val N i)) (while_68_1_395 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_74_1_401 sum a_size a1_ind a1_val N i)) (while_75_1_434 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_75_1_434 sum a_size a1_ind a1_val N i) (< i N)) (assign_77_2_422 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_75_1_434 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_81_1_440 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_77_2_422 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_77_2_422 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_77_2_422 sum a_size i tmp_select_a N i)))) (assign_78_2_431 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_78_2_431 sum a_size a1_ind a1_val N i)) (while_75_1_434 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_81_1_440 sum a_size a1_ind a1_val N i)) (while_82_1_473 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_82_1_473 sum a_size a1_ind a1_val N i) (< i N)) (assign_84_2_461 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_82_1_473 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_88_1_479 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_84_2_461 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_84_2_461 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_84_2_461 sum a_size i tmp_select_a N i)))) (assign_85_2_470 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_85_2_470 sum a_size a1_ind a1_val N i)) (while_82_1_473 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_88_1_479 sum a_size a1_ind a1_val N i)) (while_89_1_512 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_89_1_512 sum a_size a1_ind a1_val N i) (< i N)) (assign_91_2_500 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_89_1_512 sum a_size a1_ind a1_val N i) (not (< i N))) (assert_95_1_522 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_91_2_500 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_91_2_500 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_91_2_500 sum a_size i tmp_select_a N i)))) (assign_92_2_509 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_92_2_509 sum a_size a1_ind a1_val N i)) (while_89_1_512 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assert)  (sum==0)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_95_1_522 sum a_size a1_ind a1_val N i)) (= sum 0))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_95_1_522 sum a_size a1_ind a1_val N i)) (end sum a_size a1_ind a1_val N i))))
(check-sat)
