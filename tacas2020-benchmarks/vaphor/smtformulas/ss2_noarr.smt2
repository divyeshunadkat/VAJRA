;Number of predicates (nodes) = 32
;Number of variables = 4
;Number of clauses = 40
;
(set-logic HORN)
(declare-rel assign_57_2_326 (Int Int Int Int Int Int))
(declare-rel assert_56_2_317 (Int Int Int Int Int Int))
(declare-rel while_54_1_329 (Int Int Int Int Int Int))
(declare-rel assign_53_1_286 (Int Int Int Int Int Int))
(declare-rel assign_50_2_277 (Int Int Int Int Int Int))
(declare-rel arrayassign_49_2_268 (Int Int Int Int Int Int))
(declare-rel while_47_1_280 (Int Int Int Int Int Int))
(declare-rel assign_46_1_243 (Int Int Int Int Int Int))
(declare-rel assign_43_2_234 (Int Int Int Int Int Int))
(declare-rel assign_42_2_225 (Int Int Int Int Int Int))
(declare-rel while_40_1_237 (Int Int Int Int Int Int))
(declare-rel assign_39_1_204 (Int Int Int Int Int Int))
(declare-rel assign_36_2_195 (Int Int Int Int Int Int))
(declare-rel arrayassign_35_2_186 (Int Int Int Int Int Int))
(declare-rel while_33_1_198 (Int Int Int Int Int Int))
(declare-rel assign_32_1_161 (Int Int Int Int Int Int))
(declare-rel assign_29_2_152 (Int Int Int Int Int Int))
(declare-rel arrayassign_28_16_143 (Int Int Int Int Int Int))
(declare-rel while_26_1_155 (Int Int Int Int Int Int))
(declare-rel assign_25_1_125 (Int Int Int Int Int Int))
(declare-rel assign_22_2_116 (Int Int Int Int Int Int))
(declare-rel assign_21_2_107 (Int Int Int Int Int Int))
(declare-rel while_19_1_119 (Int Int Int Int Int Int))
(declare-rel assign_18_1_86 (Int Int Int Int Int Int))
(declare-rel assign_15_2_77 (Int Int Int Int Int Int))
(declare-rel arrayassign_14_16_68 (Int Int Int Int Int Int))
(declare-rel while_12_1_80 (Int Int Int Int Int Int))
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
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_11_1_50 sum a_size a1_ind a1_val N i)) (while_12_1_80 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_12_1_80 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_14_16_68 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_12_1_80 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_18_1_86 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_14_16_68 sum a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val 1)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_15_2_77 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_15_2_77 sum a_size a1_ind a1_val N i)) (while_12_1_80 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_18_1_86 sum a_size a1_ind a1_val N i)) (while_19_1_119 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_19_1_119 sum a_size a1_ind a1_val N i) (< i N)) (assign_21_2_107 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_19_1_119 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_25_1_125 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_21_2_107 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_21_2_107 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_21_2_107 sum a_size i tmp_select_a N i)))) (assign_22_2_116 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_22_2_116 sum a_size a1_ind a1_val N i)) (while_19_1_119 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_25_1_125 sum a_size a1_ind a1_val N i)) (while_26_1_155 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_26_1_155 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_28_16_143 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_26_1_155 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_32_1_161 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_28_16_143 sum a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val 0)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_29_2_152 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_29_2_152 sum a_size a1_ind a1_val N i)) (while_26_1_155 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_32_1_161 sum a_size a1_ind a1_val N i)) (while_33_1_198 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_33_1_198 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_35_2_186 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_33_1_198 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_39_1_204 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_35_2_186 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_35_2_186 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_35_2_186 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a sum))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_36_2_195 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_36_2_195 sum a_size a1_ind a1_val N i)) (while_33_1_198 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_39_1_204 sum a_size a1_ind a1_val N i)) (while_40_1_237 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_40_1_237 sum a_size a1_ind a1_val N i) (< i N)) (assign_42_2_225 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_40_1_237 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_46_1_243 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_42_2_225 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_42_2_225 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_42_2_225 sum a_size i tmp_select_a N i)))) (assign_43_2_234 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_43_2_234 sum a_size a1_ind a1_val N i)) (while_40_1_237 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_46_1_243 sum a_size a1_ind a1_val N i)) (while_47_1_280 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_47_1_280 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_49_2_268 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_47_1_280 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_53_1_286 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[i]+sum)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_49_2_268 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_49_2_268 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_49_2_268 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a sum))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_50_2_277 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_50_2_277 sum a_size a1_ind a1_val N i)) (while_47_1_280 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_53_1_286 sum a_size a1_ind a1_val N i)) (while_54_1_329 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_54_1_329 sum a_size a1_ind a1_val N i) (< i N)) (assert_56_2_317 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_54_1_329 sum a_size a1_ind a1_val N i) (not (< i N))) (end sum a_size a1_ind a1_val N i))))
;
;(assert)  (a[i]==(N*(N+2)))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assert_56_2_317 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assert_56_2_317 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assert_56_2_317 sum a_size i tmp_select_a N i)))) (= tmp_select_a (* N (+ N 2))))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_56_2_317 sum a_size a1_ind a1_val N i)) (assign_57_2_326 sum a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_57_2_326 sum a_size a1_ind a1_val N i)) (while_54_1_329 sum a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
