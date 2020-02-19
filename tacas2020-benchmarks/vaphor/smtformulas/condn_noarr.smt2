;Number of predicates (nodes) = 13
;Number of variables = 3
;Number of clauses = 17
;
(set-logic HORN)
(declare-rel assign_24_2_140 (Int Int Int Int Int))
(declare-rel assert_23_2_131 (Int Int Int Int Int))
(declare-rel while_21_1_143 (Int Int Int Int Int))
(declare-rel assign_20_1_109 (Int Int Int Int Int))
(declare-rel assign_17_2_100 (Int Int Int Int Int))
(declare-rel arrayassign_13_3_74 (Int Int Int Int Int))
(declare-rel arrayassign_15_3_88 (Int Int Int Int Int))
(declare-rel if_11_2_91 (Int Int Int Int Int))
(declare-rel while_9_1_103 (Int Int Int Int Int))
(declare-rel assign_8_1_40 (Int Int Int Int Int))
(declare-rel assign_7_1_34 (Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (<= 0 a_size) (start a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (start a_size a1_ind a1_val N i)) (assign_7_1_34 a_size a1_ind a1_val N i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (rnd Int)) (=> (and (<= 0 a_size) (assign_7_1_34 a_size a1_ind a1_val N i)) (assign_8_1_40 a_size a1_ind a1_val rnd i))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_8_1_40 a_size a1_ind a1_val N i)) (while_9_1_103 a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_9_1_103 a_size a1_ind a1_val N i) (< i N)) (if_11_2_91 a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_9_1_103 a_size a1_ind a1_val N i) (not (< i N))) (assign_20_1_109 a_size a1_ind a1_val N i))))
;
;(if)      if((a[i]<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (if_11_2_91 a_size a1_ind a1_val N i) (< tmp_select_a N) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_11_2_91 a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (if_11_2_91 a_size i tmp_select_a N i)))) (arrayassign_13_3_74 a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (if_11_2_91 a_size a1_ind a1_val N i) (not (< tmp_select_a N)) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_11_2_91 a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (if_11_2_91 a_size i tmp_select_a N i)))) (arrayassign_15_3_88 a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := a[i]
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_13_3_74 a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_13_3_74 a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_13_3_74 a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val tmp_select_a)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_17_2_100 tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(aassign) a[i] := N
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_15_3_88 a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val N)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_17_2_100 tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_17_2_100 a_size a1_ind a1_val N i)) (while_9_1_103 a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_20_1_109 a_size a1_ind a1_val N i)) (while_21_1_143 a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_21_1_143 a_size a1_ind a1_val N i) (< i N)) (assert_23_2_131 a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_21_1_143 a_size a1_ind a1_val N i) (not (< i N))) (end a_size a1_ind a1_val N i))))
;
;(assert)  (a[i]<=N)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assert_23_2_131 a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assert_23_2_131 a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assert_23_2_131 a_size i tmp_select_a N i)))) (<= tmp_select_a N))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assert_23_2_131 a_size a1_ind a1_val N i)) (assign_24_2_140 a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_24_2_140 a_size a1_ind a1_val N i)) (while_21_1_143 a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
