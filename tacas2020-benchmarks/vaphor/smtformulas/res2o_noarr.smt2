;Number of predicates (nodes) = 29
;Number of variables = 6
;Number of clauses = 36
;
(set-logic HORN)
(declare-rel assert_55_1_302 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_52_2_280 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_51_2_271 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_49_1_283 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_48_1_250 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_45_2_241 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_44_2_232 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_42_1_244 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_41_1_211 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_38_2_202 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_37_2_193 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_35_1_205 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_34_1_172 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_31_2_163 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_30_2_154 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_28_1_166 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_27_1_136 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_24_2_127 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_23_2_118 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_21_1_130 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_20_1_100 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_17_2_91 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_16_2_82 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_14_1_94 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_13_1_64 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_12_1_58 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_10_1_52 (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size)) (start sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (start sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_10_1_52 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (rnd Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_10_1_52 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_12_1_58 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val rnd i))))
;
;(assign)  sum := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_12_1_58 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_13_1_64 0 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_13_1_64 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_14_1_94 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_14_1_94 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_16_2_82 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_14_1_94 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_20_1_100 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_16_2_82 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val 1)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_17_2_91 sum c_size c1_ind c1_val b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_17_2_91 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_14_1_94 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_20_1_100 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_21_1_130 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_21_1_130 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_23_2_118 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_21_1_130 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_27_1_136 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) b[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_23_2_118 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind i) (= tmp_store_b1_val 1)) (and (not (= b1_ind i)) (= tmp_store_b1_val b1_val)))) (assign_24_2_127 sum c_size c1_ind c1_val tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_24_2_127 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_21_1_130 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_27_1_136 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_28_1_166 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_28_1_166 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_30_2_154 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_28_1_166 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_34_1_172 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) c[i] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int) (tmp_store_c1_ind Int) (tmp_store_c1_val Int) (tmp_store_c_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_30_2_154 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_c1_ind c1_ind) (= c_size tmp_store_c_size) (or (and (= c1_ind i) (= tmp_store_c1_val 1)) (and (not (= c1_ind i)) (= tmp_store_c1_val c1_val)))) (assign_31_2_163 sum tmp_store_c_size tmp_store_c1_ind tmp_store_c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_31_2_163 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_28_1_166 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_34_1_172 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_35_1_205 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_35_1_205 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assign_37_2_193 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_35_1_205 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_41_1_211 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+a[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_37_2_193 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_37_2_193 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assign_37_2_193 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size i tmp_select_a N i)))) (assign_38_2_202 (+ sum tmp_select_a) c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_38_2_202 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_35_1_205 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_41_1_211 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_42_1_244 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_42_1_244 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assign_44_2_232 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_42_1_244 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_48_1_250 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+b[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int) (tmp_select_b Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_44_2_232 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= b1_ind i) (= tmp_select_b b1_val)) (and (< i b1_ind) (<= 0 b_size) (assign_44_2_232 sum c_size c1_ind c1_val b_size i tmp_select_b a_size a1_ind a1_val N i)) (and (< b1_ind i) (<= 0 b_size) (assign_44_2_232 sum c_size c1_ind c1_val b_size i tmp_select_b a_size a1_ind a1_val N i)))) (assign_45_2_241 (+ sum tmp_select_b) c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_45_2_241 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_42_1_244 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_48_1_250 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_49_1_283 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_49_1_283 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assign_51_2_271 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_49_1_283 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assert_55_1_302 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  sum := (sum+c[i])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int) (tmp_select_c Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_51_2_271 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= c1_ind i) (= tmp_select_c c1_val)) (and (< i c1_ind) (<= 0 c_size) (assign_51_2_271 sum c_size i tmp_select_c b_size b1_ind b1_val a_size a1_ind a1_val N i)) (and (< c1_ind i) (<= 0 c_size) (assign_51_2_271 sum c_size i tmp_select_c b_size b1_ind b1_val a_size a1_ind a1_val N i)))) (assign_52_2_280 (+ sum tmp_select_c) c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_52_2_280 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_49_1_283 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assert)  ((N<=0)||(sum<=(3*N)))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assert_55_1_302 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (or (<= N 0) (<= sum (* 3 N))))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (sum Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assert_55_1_302 sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (end sum c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(check-sat)
