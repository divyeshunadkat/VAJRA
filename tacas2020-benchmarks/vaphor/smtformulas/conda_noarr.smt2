;Number of predicates (nodes) = 18
;Number of variables = 4
;Number of clauses = 23
;
(set-logic HORN)
(declare-rel assert_35_8_208 (Int Int Int Int Int Int))
(declare-rel assign_32_2_186 (Int Int Int Int Int Int))
(declare-rel assign_31_2_177 (Int Int Int Int Int Int))
(declare-rel while_29_1_189 (Int Int Int Int Int Int))
(declare-rel assign_28_1_156 (Int Int Int Int Int Int))
(declare-rel arrayassign_22_3_123 (Int Int Int Int Int Int))
(declare-rel arrayassign_24_3_144 (Int Int Int Int Int Int))
(declare-rel if_21_2_147 (Int Int Int Int Int Int))
(declare-rel while_19_1_150 (Int Int Int Int Int Int))
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
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_18_1_86 sum a_size a1_ind a1_val N i)) (while_19_1_150 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_19_1_150 sum a_size a1_ind a1_val N i) (< i N)) (if_21_2_147 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_19_1_150 sum a_size a1_ind a1_val N i) (not (< i N))) (assign_28_1_156 sum a_size a1_ind a1_val N i))))
;
;(if)      if((a[i]==1))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (if_21_2_147 sum a_size a1_ind a1_val N i) (= tmp_select_a 1) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_21_2_147 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (if_21_2_147 sum a_size i tmp_select_a N i)))) (arrayassign_22_3_123 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (if_21_2_147 sum a_size a1_ind a1_val N i) (not (= tmp_select_a 1)) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_21_2_147 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (if_21_2_147 sum a_size i tmp_select_a N i)))) (arrayassign_24_3_144 sum a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[i]+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_22_3_123 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_22_3_123 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_22_3_123 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a 1))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (while_19_1_150 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(aassign) a[i] := (a[i]-1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_24_3_144 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_24_3_144 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_24_3_144 sum a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (- tmp_select_a 1))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (while_19_1_150 sum tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_28_1_156 sum a_size a1_ind a1_val N i)) (while_29_1_189 sum a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_29_1_189 sum a_size a1_ind a1_val N i) (< i N)) (assign_31_2_177 sum a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (while_29_1_189 sum a_size a1_ind a1_val N i) (not (< i N))) (assert_35_8_208 sum a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assign_31_2_177 sum a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_31_2_177 sum a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_31_2_177 sum a_size i tmp_select_a N i)))) (assign_32_2_186 (+ sum tmp_select_a) a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assign_32_2_186 sum a_size a1_ind a1_val N i)) (while_29_1_189 sum a_size a1_ind a1_val N (+ i 1)))))
;
;(assert)  ((N<=0)||(sum==(2*N)))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_35_8_208 sum a_size a1_ind a1_val N i)) (or (<= N 0) (= sum (* 2 N))))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (assert_35_8_208 sum a_size a1_ind a1_val N i)) (end sum a_size a1_ind a1_val N i))))
(check-sat)
