;Number of predicates (nodes) = 22
;Number of variables = 5
;Number of clauses = 27
;
(set-logic HORN)
(declare-rel assign_38_2_269 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assert_37_2_260 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_35_1_272 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_34_1_232 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_31_2_223 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_30_9_214 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_28_1_226 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_27_1_179 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_24_2_170 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_23_9_161 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_21_1_173 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_20_1_126 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_17_2_117 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_16_2_108 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_14_1_120 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_13_1_80 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_11_1_74 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_10_1_64 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel arrayassign_9_1_54 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_7_1_44 (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size)) (start c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (start c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_7_1_44 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (rnd Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_7_1_44 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (arrayassign_9_1_54 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val rnd i))))
;
;(aassign) a[0] := 6
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_9_1_54 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind 0) (= tmp_store_a1_val 6)) (and (not (= a1_ind 0)) (= tmp_store_a1_val a1_val)))) (arrayassign_10_1_64 c_size c1_ind c1_val b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(aassign) b[0] := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_10_1_64 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind 0) (= tmp_store_b1_val 1)) (and (not (= b1_ind 0)) (= tmp_store_b1_val b1_val)))) (arrayassign_11_1_74 c_size c1_ind c1_val tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(aassign) c[0] := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (tmp_store_c1_ind Int) (tmp_store_c1_val Int) (tmp_store_c_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_11_1_74 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (= tmp_store_c1_ind c1_ind) (= c_size tmp_store_c_size) (or (and (= c1_ind 0) (= tmp_store_c1_val 0)) (and (not (= c1_ind 0)) (= tmp_store_c1_val c1_val)))) (assign_13_1_80 tmp_store_c_size tmp_store_c1_ind tmp_store_c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_13_1_80 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_14_1_120 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 1))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_14_1_120 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_16_2_108 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_14_1_120 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_20_1_126 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[(i-1)]+6)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_16_2_108 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= a1_ind (- i 1)) (= tmp_select_a a1_val)) (and (< (- i 1) a1_ind) (<= 0 a_size) (arrayassign_16_2_108 c_size c1_ind c1_val b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i)) (and (< a1_ind (- i 1)) (<= 0 a_size) (arrayassign_16_2_108 c_size c1_ind c1_val b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a 6))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_17_2_117 c_size c1_ind c1_val b_size b1_ind b1_val tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_17_2_117 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_14_1_120 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_20_1_126 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_21_1_173 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 1))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_21_1_173 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_23_9_161 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_21_1_173 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_27_1_179 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) b[i] := (b[(i-1)]+a[(i-1)])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (tmp_select_a Int) (tmp_select_b Int) (tmp_store_b1_ind Int) (tmp_store_b1_val Int) (tmp_store_b_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i)) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i))) (or (and (= a1_ind (- i 1)) (= tmp_select_a a1_val)) (and (< (- i 1) a1_ind) (<= 0 a_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)))) (and (< a1_ind (- i 1)) (<= 0 a_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size b1_ind b1_val a_size (- i 1) tmp_select_a N i) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i)) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_23_9_161 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size (- i 1) tmp_select_a N i))))) (= tmp_store_b1_ind b1_ind) (= b_size tmp_store_b_size) (or (and (= b1_ind i) (= tmp_store_b1_val (+ tmp_select_b tmp_select_a))) (and (not (= b1_ind i)) (= tmp_store_b1_val b1_val)))) (assign_24_2_170 c_size c1_ind c1_val tmp_store_b_size tmp_store_b1_ind tmp_store_b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_24_2_170 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_21_1_173 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 1
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_27_1_179 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_28_1_226 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 1))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_28_1_226 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (arrayassign_30_9_214 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_28_1_226 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (assign_34_1_232 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(aassign) c[i] := (c[(i-1)]+b[(i-1)])
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (tmp_select_b Int) (tmp_select_c Int) (tmp_store_c1_ind Int) (tmp_store_c1_val Int) (tmp_store_c_size Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (arrayassign_30_9_214 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= c1_ind (- i 1)) (= tmp_select_c c1_val)) (and (< (- i 1) c1_ind) (<= 0 c_size) (arrayassign_30_9_214 c_size (- i 1) tmp_select_c b_size b1_ind b1_val a_size a1_ind a1_val N i)) (and (< c1_ind (- i 1)) (<= 0 c_size) (arrayassign_30_9_214 c_size (- i 1) tmp_select_c b_size b1_ind b1_val a_size a1_ind a1_val N i))) (or (and (= b1_ind (- i 1)) (= tmp_select_b b1_val)) (and (< (- i 1) b1_ind) (<= 0 b_size) (arrayassign_30_9_214 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i) (or (and (= c1_ind (- i 1)) (= tmp_select_c c1_val)) (and (< (- i 1) c1_ind) (<= 0 c_size) (arrayassign_30_9_214 c_size (- i 1) tmp_select_c b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i)) (and (< c1_ind (- i 1)) (<= 0 c_size) (arrayassign_30_9_214 c_size (- i 1) tmp_select_c b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i)))) (and (< b1_ind (- i 1)) (<= 0 b_size) (arrayassign_30_9_214 c_size c1_ind c1_val b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i) (or (and (= c1_ind (- i 1)) (= tmp_select_c c1_val)) (and (< (- i 1) c1_ind) (<= 0 c_size) (arrayassign_30_9_214 c_size (- i 1) tmp_select_c b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i)) (and (< c1_ind (- i 1)) (<= 0 c_size) (arrayassign_30_9_214 c_size (- i 1) tmp_select_c b_size (- i 1) tmp_select_b a_size a1_ind a1_val N i))))) (= tmp_store_c1_ind c1_ind) (= c_size tmp_store_c_size) (or (and (= c1_ind i) (= tmp_store_c1_val (+ tmp_select_c tmp_select_b))) (and (not (= c1_ind i)) (= tmp_store_c1_val c1_val)))) (assign_31_2_223 tmp_store_c_size tmp_store_c1_ind tmp_store_c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_31_2_223 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_28_1_226 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_34_1_232 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_35_1_272 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_35_1_272 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (< i N)) (assert_37_2_260 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (while_35_1_272 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (not (< i N))) (end c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assert)  (c[i]==((i*i)*i))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int) (tmp_select_c Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assert_37_2_260 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i) (or (and (= c1_ind i) (= tmp_select_c c1_val)) (and (< i c1_ind) (<= 0 c_size) (assert_37_2_260 c_size i tmp_select_c b_size b1_ind b1_val a_size a1_ind a1_val N i)) (and (< c1_ind i) (<= 0 c_size) (assert_37_2_260 c_size i tmp_select_c b_size b1_ind b1_val a_size a1_ind a1_val N i)))) (= tmp_select_c (* (* i i) i)))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assert_37_2_260 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (assign_38_2_269 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (c1_ind Int) (c1_val Int) (c_size Int) (i Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (<= 0 c_size) (assign_38_2_269 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N i)) (while_35_1_272 c_size c1_ind c1_val b_size b1_ind b1_val a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
