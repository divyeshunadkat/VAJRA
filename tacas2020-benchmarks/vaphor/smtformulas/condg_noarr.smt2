;Number of predicates (nodes) = 22
;Number of variables = 4
;Number of clauses = 28
;
(set-logic HORN)
(declare-rel assign_39_2_231 (Int Int Int Int Int Int))
(declare-rel assert_38_16_222 (Int Int Int Int Int Int))
(declare-rel while_36_1_234 (Int Int Int Int Int Int))
(declare-rel assign_35_1_200 (Int Int Int Int Int Int))
(declare-rel assign_32_2_191 (Int Int Int Int Int Int))
(declare-rel arrayassign_28_3_158 (Int Int Int Int Int Int))
(declare-rel arrayassign_30_3_179 (Int Int Int Int Int Int))
(declare-rel if_27_9_182 (Int Int Int Int Int Int))
(declare-rel while_25_1_194 (Int Int Int Int Int Int))
(declare-rel assign_24_1_125 (Int Int Int Int Int Int))
(declare-rel assign_21_2_116 (Int Int Int Int Int Int))
(declare-rel assign_20_2_107 (Int Int Int Int Int Int))
(declare-rel while_18_1_119 (Int Int Int Int Int Int))
(declare-rel assign_17_1_86 (Int Int Int Int Int Int))
(declare-rel assign_16_1_80 (Int Int Int Int Int Int))
(declare-rel assign_13_2_71 (Int Int Int Int Int Int))
(declare-rel arrayassign_12_16_62 (Int Int Int Int Int Int))
(declare-rel while_10_1_74 (Int Int Int Int Int Int))
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
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_9_1_44 sum a_size a1_ind a1_val N i)) (while_10_1_74 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_10_1_74 sum a_size a1_ind a1_val N i) (< i N)) (arrayassign_12_16_62 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_10_1_74 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_16_1_80 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_12_16_62 sum a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val 1)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_13_2_71 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_13_2_71 sum a_size a1_ind a1_val N i)) (while_10_1_74 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  sum := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_16_1_80 sum a_size a1_ind a1_val N i)) (assign_17_1_86 0 a_size a1_ind a1_val N i))))
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
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_24_1_125 sum a_size a1_ind a1_val N i)) (while_25_1_194 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_25_1_194 sum a_size a1_ind a1_val N i) (< i N)) (if_27_9_182 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_25_1_194 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_35_1_200 sum a_size a1_ind a1_val N i))))
;
;(if)      if((sum==N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (if_27_9_182 sum a_size a1_ind a1_val N i) (= sum N)) (arrayassign_28_3_158 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (if_27_9_182 sum a_size a1_ind a1_val N i) (not (= sum N))) (arrayassign_30_3_179 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[i]-1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_28_3_158 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_28_3_158 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_28_3_158 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (- tmp_select_a 1))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_32_2_191 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(aassign) a[i] := (a[i]+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_30_3_179 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_30_3_179 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_30_3_179 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a 1))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_32_2_191 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_32_2_191 sum a_size a1_ind a1_val N i)) (while_25_1_194 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_35_1_200 sum a_size a1_ind a1_val N i)) (while_36_1_234 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_36_1_234 sum a_size a1_ind a1_val N i) (< i N)) (assert_38_16_222 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_36_1_234 sum a_size a1_ind a1_val N i) (not (< i N))) (end sum a_size a1_ind a1_val N i))))
;
;(assert)  (a[i]==0)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assert_38_16_222 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assert_38_16_222 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assert_38_16_222 sum a_size i tmp_select_a N i)))) (= tmp_select_a 0))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_38_16_222 sum a_size a1_ind a1_val N i)) (assign_39_2_231 sum a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_39_2_231 sum a_size a1_ind a1_val N i)) (while_36_1_234 sum a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
