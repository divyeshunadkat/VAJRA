;Number of predicates (nodes) = 21
;Number of variables = 4
;Number of clauses = 26
;
(set-logic HORN)
(declare-rel assert_38_1_210 (Int Int Int Int Int Int))
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
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_21_2_110 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_21_2_110 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_21_2_110 sum a_size i tmp_select_a N i)))) (assign_22_2_119 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
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
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_33_1_200 sum a_size a1_ind a1_val N i) (not (< i N))) (assert_38_1_210 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum-a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_35_2_188 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_35_2_188 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_35_2_188 sum a_size i tmp_select_a N i)))) (assign_36_2_197 (- sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_36_2_197 sum a_size a1_ind a1_val N i)) (while_33_1_200 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assert)  (sum==0)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_38_1_210 sum a_size a1_ind a1_val N i)) (= sum 0))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_38_1_210 sum a_size a1_ind a1_val N i)) (end sum a_size a1_ind a1_val N i))))
(check-sat)
