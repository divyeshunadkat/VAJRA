;Number of predicates (nodes) = 17
;Number of variables = 4
;Number of clauses = 21
;
(set-logic HORN)
(declare-rel assign_30_2_210 (Int Int Int Int Int Int Int Int))
(declare-rel assert_29_2_201 (Int Int Int Int Int Int Int Int))
(declare-rel while_27_1_213 (Int Int Int Int Int Int Int Int))
(declare-rel assign_26_1_164 (Int Int Int Int Int Int Int Int))
(declare-rel assign_23_2_155 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_22_9_146 (Int Int Int Int Int Int Int Int))
(declare-rel while_20_1_158 (Int Int Int Int Int Int Int Int))
(declare-rel assign_19_1_111 (Int Int Int Int Int Int Int Int))
(declare-rel assign_16_2_102 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_15_2_93 (Int Int Int Int Int Int Int Int))
(declare-rel while_13_1_105 (Int Int Int Int Int Int Int Int))
(declare-rel assign_12_1_65 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_10_1_59 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_9_1_49 (Int Int Int Int Int Int Int Int))
(declare-rel assign_7_1_39 (Int Int Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size)) (start b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (start b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_7_1_39 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rnd Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_7_1_39 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (arrayassign_9_1_49 b_size b1_ind b1_val a_size a1_ind a1_val rnd i))))
;
;(aassign) a[0] := 8
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_9_1_49 b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind 0) (= tmp_store_a1_val 8)) (and (not (= a1_ind 0)) (= tmp_store_a1_val a1_val)))) (arrayassign_10_1_59 b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(aassign) b[0] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_10_1_59 b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind 0) (= tmp_store_b1_val 1)) (and (not (= b1_ind 0)) (= tmp_store_b1_val b1_val)))) (assign_12_1_65 tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_12_1_65 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_13_1_105 b_size b1_ind b1_val a_size a1_ind a1_val N 1))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_13_1_105 b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_15_2_93 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_13_1_105 b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_19_1_111 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[(i-1)]+8)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_15_2_93 b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= a1_ind (- i 1)) (= tmp_select_a a1_val)) (and (< (- i 1) a1_ind) (<= 0 a_size) (arrayassign_15_2_93 b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i)) (and (< a1_ind (- i 1)) (<= 0 a_size) (arrayassign_15_2_93 b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a 8))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_16_2_102 b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_16_2_102 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_13_1_105 b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_19_1_111 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_20_1_158 b_size b1_ind b1_val a_size a1_ind a1_val N 1))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_20_1_158 b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_22_9_146 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_20_1_158 b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_26_1_164 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) b[i] := (b[(i-1)]+a[(i-1)])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_select_a Int) (tmp_select_b Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_22_9_146 b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_22_9_146 b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i)) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_22_9_146 b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i))) (or (and (= a1_ind (- i 1)) (= tmp_select_a a1_val)) (and (< (- i 1) a1_ind) (<= 0 a_size) (arrayassign_22_9_146 b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_22_9_146 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_22_9_146 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)))) (and (< a1_ind (- i 1)) (<= 0 a_size) (arrayassign_22_9_146 b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_22_9_146 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_22_9_146 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i))))) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind i) (= tmp_store_b1_val (+ tmp_select_b tmp_select_a))) (and (not (= b1_ind i)) (= tmp_store_b1_val b1_val)))) (assign_23_2_155 tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_23_2_155 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_20_1_158 b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_26_1_164 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_27_1_213 b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_27_1_213 b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assert_29_2_201 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_27_1_213 b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (end b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assert)  (b[i]==((((4*i)*i)+(4*i))+1))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_select_b Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_29_2_201 b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= b1_ind i) (= tmp_select_b b1_val)) (and (< i b1_ind) (<= 0 b_size) (assert_29_2_201 b_size i tmp_select_b a_size a1_ind a1_val N i)) (and (< b1_ind i) (<= 0 b_size) (assert_29_2_201 b_size i tmp_select_b a_size a1_ind a1_val N i)))) (= tmp_select_b (+ (+ (* (* 4 i) i) (* 4 i)) 1)))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_29_2_201 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_30_2_210 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_30_2_210 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_27_1_213 b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
