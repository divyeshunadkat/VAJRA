;Number of predicates (nodes) = 21
;Number of variables = 5
;Number of clauses = 26
;
(set-logic HORN)
(declare-rel assert_40_1_220 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_37_2_198 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_36_2_189 (Int Int Int Int Int Int Int Int Int))
(declare-rel while_34_1_201 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_33_1_168 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_30_2_159 (Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_29_2_150 (Int Int Int Int Int Int Int Int Int))
(declare-rel while_27_1_162 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_26_1_132 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_23_2_123 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_22_2_114 (Int Int Int Int Int Int Int Int Int))
(declare-rel while_20_1_126 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_19_1_93 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_16_2_84 (Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_15_2_75 (Int Int Int Int Int Int Int Int Int))
(declare-rel while_13_1_87 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_12_1_57 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_11_1_51 (Int Int Int Int Int Int Int Int Int))
(declare-rel assign_9_1_45 (Int Int Int Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size)) (start sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (start sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_9_1_45 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rnd Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_9_1_45 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_11_1_51 sum b_size b1_ind b1_val a_size a1_ind a1_val rnd i))))
;
;(assign)  sum := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_11_1_51 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_12_1_57 0 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_12_1_57 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_13_1_87 sum b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_13_1_87 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_15_2_75 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_13_1_87 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_19_1_93 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_15_2_75 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val 1)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_16_2_84 sum b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_16_2_84 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_13_1_87 sum b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_19_1_93 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_20_1_126 sum b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_20_1_126 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assign_22_2_114 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_20_1_126 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_26_1_132 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_22_2_114 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_22_2_114 sum b_size b1_ind b1_val a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_22_2_114 sum b_size b1_ind b1_val a_size i tmp_select_a N i)))) (assign_23_2_123 (+ sum tmp_select_a) b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_23_2_123 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_20_1_126 sum b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_26_1_132 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_27_1_162 sum b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_27_1_162 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_29_2_150 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_27_1_162 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_33_1_168 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) b[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_29_2_150 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind i) (= tmp_store_b1_val 1)) (and (not (= b1_ind i)) (= tmp_store_b1_val b1_val)))) (assign_30_2_159 sum tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_30_2_159 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_27_1_162 sum b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_33_1_168 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_34_1_201 sum b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_34_1_201 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assign_36_2_189 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_34_1_201 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assert_40_1_220 sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+b[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int) (tmp_select_b Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_36_2_189 sum b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= b1_ind i) (= tmp_select_b b1_val)) (and (< i b1_ind) (<= 0 b_size) (assign_36_2_189 sum b_size i tmp_select_b a_size a1_ind a1_val N i)) (and (< b1_ind i) (<= 0 b_size) (assign_36_2_189 sum b_size i tmp_select_b a_size a1_ind a1_val N i)))) (assign_37_2_198 (+ sum tmp_select_b) b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_37_2_198 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_34_1_201 sum b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assert)  ((N<=0)||(sum<=(2*N)))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_40_1_220 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (or (<= N 0) (<= sum (* 2 N))))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_40_1_220 sum b_size b1_ind b1_val a_size a1_ind a1_val N i)) (end sum b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(check-sat)
