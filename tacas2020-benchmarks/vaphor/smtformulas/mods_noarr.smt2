;Number of predicates (nodes) = 24
;Number of variables = 4
;Number of clauses = 30
;
(set-logic HORN)
(declare-rel assign_42_2_248 (Int Int Int Int Int Int))
(declare-rel assert_41_2_239 (Int Int Int Int Int Int))
(declare-rel while_39_1_251 (Int Int Int Int Int Int))
(declare-rel assign_38_1_217 (Int Int Int Int Int Int))
(declare-rel assign_35_2_208 (Int Int Int Int Int Int))
(declare-rel arrayassign_34_2_199 (Int Int Int Int Int Int))
(declare-rel while_32_1_211 (Int Int Int Int Int Int))
(declare-rel assign_31_1_168 (Int Int Int Int Int Int))
(declare-rel assign_28_2_159 (Int Int Int Int Int Int))
(declare-rel arrayassign_27_2_150 (Int Int Int Int Int Int))
(declare-rel while_25_1_162 (Int Int Int Int Int Int))
(declare-rel assign_24_1_125 (Int Int Int Int Int Int))
(declare-rel assign_21_2_116 (Int Int Int Int Int Int))
(declare-rel assign_20_2_107 (Int Int Int Int Int Int))
(declare-rel while_18_1_119 (Int Int Int Int Int Int))
(declare-rel assign_17_1_86 (Int Int Int Int Int Int))
(declare-rel assign_14_2_77 (Int Int Int Int Int Int))
(declare-rel arrayassign_13_16_68 (Int Int Int Int Int Int))
(declare-rel while_11_1_80 (Int Int Int Int Int Int))
(declare-rel assign_10_1_50 (Int Int Int Int Int Int))
(declare-rel assign_9_1_44 (Int Int Int Int Int Int))
(declare-rel assign_8_1_38 (Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (<= 0 a_size) (start sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (start sum a_size a1_ind a1_val N i)) (assign_8_1_38 sum a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (rnd Int) (sum Int)) (=> (and (<= 0 a_size) (assign_8_1_38 sum a_size a1_ind a1_val N i)) (assign_9_1_44 sum a_size a1_ind a1_val rnd i))))
;
;(assign)  sum := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_9_1_44 sum a_size a1_ind a1_val N i)) (assign_10_1_50 0 a_size a1_ind a1_val N i))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_10_1_50 sum a_size a1_ind a1_val N i)) (while_11_1_80 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_11_1_80 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_13_16_68 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_11_1_80 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_17_1_86 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_13_16_68 sum a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val 1)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_14_2_77 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_14_2_77 sum a_size a1_ind a1_val N i)) (while_11_1_80 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_17_1_86 sum a_size a1_ind a1_val N i)) (while_18_1_119 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_18_1_119 sum a_size a1_ind a1_val N i) (< i N)) (assign_20_2_107 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_18_1_119 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_24_1_125 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_20_2_107 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_20_2_107 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_20_2_107 sum a_size i tmp_select_a N i)))) (assign_21_2_116 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_21_2_116 sum a_size a1_ind a1_val N i)) (while_18_1_119 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_24_1_125 sum a_size a1_ind a1_val N i)) (while_25_1_162 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_25_1_162 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_27_2_150 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_25_1_162 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_31_1_168 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_27_2_150 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_27_2_150 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_27_2_150 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a sum))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_28_2_159 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_28_2_159 sum a_size a1_ind a1_val N i)) (while_25_1_162 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_31_1_168 sum a_size a1_ind a1_val N i)) (while_32_1_211 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_32_1_211 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_34_2_199 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_32_1_211 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_38_1_217 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[i]%(sum+1))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_34_2_199 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_34_2_199 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_34_2_199 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (mod tmp_select_a (+ sum 1)))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_35_2_208 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_35_2_208 sum a_size a1_ind a1_val N i)) (while_32_1_211 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_38_1_217 sum a_size a1_ind a1_val N i)) (while_39_1_251 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_39_1_251 sum a_size a1_ind a1_val N i) (< i N)) (assert_41_2_239 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_39_1_251 sum a_size a1_ind a1_val N i) (not (< i N))) (end sum a_size a1_ind a1_val N i))))
;
;(assert)  (a[i]==0)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assert_41_2_239 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assert_41_2_239 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assert_41_2_239 sum a_size i tmp_select_a N i)))) (= tmp_select_a 0))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_41_2_239 sum a_size a1_ind a1_val N i)) (assign_42_2_248 sum a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_42_2_248 sum a_size a1_ind a1_val N i)) (while_39_1_251 sum a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
