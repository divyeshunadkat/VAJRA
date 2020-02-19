;Number of predicates (nodes) = 17
;Number of variables = 4
;Number of clauses = 21
;
(set-logic HORN)
(declare-rel assign_31_2_215 (Int Int Int Int Int Int Int Int))
(declare-rel assert_30_2_206 (Int Int Int Int Int Int Int Int))
(declare-rel while_28_1_218 (Int Int Int Int Int Int Int Int))
(declare-rel assign_27_1_169 (Int Int Int Int Int Int Int Int))
(declare-rel assign_24_2_160 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_23_2_151 (Int Int Int Int Int Int Int Int))
(declare-rel while_21_1_163 (Int Int Int Int Int Int Int Int))
(declare-rel assign_20_1_113 (Int Int Int Int Int Int Int Int))
(declare-rel assign_17_2_104 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_16_2_95 (Int Int Int Int Int Int Int Int))
(declare-rel while_14_1_107 (Int Int Int Int Int Int Int Int))
(declare-rel assign_13_1_67 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_11_1_61 (Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_10_1_51 (Int Int Int Int Int Int Int Int))
(declare-rel assign_8_1_41 (Int Int Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size)) (start b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (start b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_8_1_41 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rnd Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_8_1_41 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (arrayassign_10_1_51 b_size b1_ind b1_val a_size a1_ind a1_val rnd i))))
;
;(aassign) b[0] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_10_1_51 b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind 0) (= tmp_store_b1_val 1)) (and (not (= b1_ind 0)) (= tmp_store_b1_val b1_val)))) (arrayassign_11_1_61 tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(aassign) a[0] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_11_1_61 b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind 0) (= tmp_store_a1_val 1)) (and (not (= a1_ind 0)) (= tmp_store_a1_val a1_val)))) (assign_13_1_67 b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_13_1_67 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_14_1_107 b_size b1_ind b1_val a_size a1_ind a1_val N 1))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_14_1_107 b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_16_2_95 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_14_1_107 b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_20_1_113 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) b[i] := (b[(i-1)]+2)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_select_b Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_16_2_95 b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_16_2_95 b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i)) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_16_2_95 b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i))) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind i) (= tmp_store_b1_val (+ tmp_select_b 2))) (and (not (= b1_ind i)) (= tmp_store_b1_val b1_val)))) (assign_17_2_104 tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_17_2_104 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_14_1_107 b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_20_1_113 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_21_1_163 b_size b1_ind b1_val a_size a1_ind a1_val N 1))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_21_1_163 b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_23_2_151 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_21_1_163 b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_27_1_169 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := ((a[(i-1)]+b[(i-1)])+2)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_select_a Int) (tmp_select_b Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (arrayassign_23_2_151 b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= a1_ind (- i 1)) (= tmp_select_a a1_val)) (and (< (- i 1) a1_ind) (<= 0 a_size) (arrayassign_23_2_151 b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i)) (and (< a1_ind (- i 1)) (<= 0 a_size) (arrayassign_23_2_151 b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i))) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_23_2_151 b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i) (or (and (= a1_ind (- i 1)) (= tmp_select_a a1_val)) (and (< (- i 1) a1_ind) (<= 0 a_size) (arrayassign_23_2_151 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)) (and (< a1_ind (- i 1)) (<= 0 a_size) (arrayassign_23_2_151 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)))) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_23_2_151 b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i) (or (and (= a1_ind (- i 1)) (= tmp_select_a a1_val)) (and (< (- i 1) a1_ind) (<= 0 a_size) (arrayassign_23_2_151 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)) (and (< a1_ind (- i 1)) (<= 0 a_size) (arrayassign_23_2_151 b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i))))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ (+ tmp_select_a tmp_select_b) 2))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_24_2_160 b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_24_2_160 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_21_1_163 b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_27_1_169 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_28_1_218 b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_28_1_218 b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assert_30_2_206 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_28_1_218 b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (end b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assert)  (a[i]==((i+1)*(i+1)))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_30_2_206 b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assert_30_2_206 b_size b1_ind b1_val a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assert_30_2_206 b_size b1_ind b1_val a_size i tmp_select_a N i)))) (= tmp_select_a (* (+ i 1) (+ i 1))))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_30_2_206 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_31_2_215 b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_31_2_215 b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_28_1_218 b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
