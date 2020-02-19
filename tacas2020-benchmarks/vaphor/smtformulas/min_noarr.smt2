;Number of predicates (nodes) = 13
;Number of variables = 5
;Number of clauses = 17
;
(set-logic HORN)
(declare-rel assign_24_2_134 (Int Int Int Int Int Int Int))
(declare-rel assert_23_2_125 (Int Int Int Int Int Int Int))
(declare-rel while_21_8_137 (Int Int Int Int Int Int Int))
(declare-rel assign_20_1_103 (Int Int Int Int Int Int Int))
(declare-rel assign_17_2_94 (Int Int Int Int Int Int Int))
(declare-rel assign_15_3_82 (Int Int Int Int Int Int Int))
(declare-rel if_14_2_86 (Int Int Int Int Int Int Int))
(declare-rel while_12_8_97 (Int Int Int Int Int Int Int))
(declare-rel assign_11_1_52 (Int Int Int Int Int Int Int))
(declare-rel assign_10_1_46 (Int Int Int Int Int Int Int))
(declare-rel assign_8_1_40 (Int Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int Int))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (<= 0 a_size) (start min a_size a1_ind a1_val N x i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (start min a_size a1_ind a1_val N x i)) (assign_8_1_40 min a_size a1_ind a1_val N x i))))
;
;(assign)  N := Support.random()
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (rnd Int) (x Int)) (=> (and (<= 0 a_size) (assign_8_1_40 min a_size a1_ind a1_val N x i)) (assign_10_1_46 min a_size a1_ind a1_val rnd x i))))
;
;(assign)  min := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (assign_10_1_46 min a_size a1_ind a1_val N x i)) (assign_11_1_52 0 a_size a1_ind a1_val N x i))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (assign_11_1_52 min a_size a1_ind a1_val N x i)) (while_12_8_97 min a_size a1_ind a1_val N x 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (while_12_8_97 min a_size a1_ind a1_val N x i) (< i N)) (if_14_2_86 min a_size a1_ind a1_val N x i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (while_12_8_97 min a_size a1_ind a1_val N x i) (not (< i N))) (assign_20_1_103 min a_size a1_ind a1_val N x i))))
;
;(if)      if((a[i]<min))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (tmp_select_a Int) (x Int)) (=> (and (<= 0 a_size) (if_14_2_86 min a_size a1_ind a1_val N x i) (< tmp_select_a min) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_14_2_86 min a_size i tmp_select_a N x i)) (and (< a1_ind i) (<= 0 a_size) (if_14_2_86 min a_size i tmp_select_a N x i)))) (assign_15_3_82 min a_size a1_ind a1_val N x i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (tmp_select_a Int) (x Int)) (=> (and (<= 0 a_size) (if_14_2_86 min a_size a1_ind a1_val N x i) (not (< tmp_select_a min)) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_14_2_86 min a_size i tmp_select_a N x i)) (and (< a1_ind i) (<= 0 a_size) (if_14_2_86 min a_size i tmp_select_a N x i)))) (assign_17_2_94 min a_size a1_ind a1_val N x i))))
;
;(assign)  min := a[i]
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (tmp_select_a Int) (x Int)) (=> (and (<= 0 a_size) (assign_15_3_82 min a_size a1_ind a1_val N x i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assign_15_3_82 min a_size i tmp_select_a N x i)) (and (< a1_ind i) (<= 0 a_size) (assign_15_3_82 min a_size i tmp_select_a N x i)))) (assign_17_2_94 tmp_select_a a_size a1_ind a1_val N x i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (assign_17_2_94 min a_size a1_ind a1_val N x i)) (while_12_8_97 min a_size a1_ind a1_val N x (+ i 1)))))
;
;(assign)  x := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (assign_20_1_103 min a_size a1_ind a1_val N x i)) (while_21_8_137 min a_size a1_ind a1_val N 0 i))))
;
;(while)   while((x<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (while_21_8_137 min a_size a1_ind a1_val N x i) (< x N)) (assert_23_2_125 min a_size a1_ind a1_val N x i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (while_21_8_137 min a_size a1_ind a1_val N x i) (not (< x N))) (end min a_size a1_ind a1_val N x i))))
;
;(assert)  (a[x]>=min)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (tmp_select_a Int) (x Int)) (=> (and (<= 0 a_size) (assert_23_2_125 min a_size a1_ind a1_val N x i) (or (and (= a1_ind x) (= tmp_select_a a1_val)) (and (< x a1_ind) (<= 0 a_size) (assert_23_2_125 min a_size x tmp_select_a N x i)) (and (< a1_ind x) (<= 0 a_size) (assert_23_2_125 min a_size x tmp_select_a N x i)))) (>= tmp_select_a min))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (assert_23_2_125 min a_size a1_ind a1_val N x i)) (assign_24_2_134 min a_size a1_ind a1_val N x i))))
;
;(assign)  x := (x+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (min Int) (x Int)) (=> (and (<= 0 a_size) (assign_24_2_134 min a_size a1_ind a1_val N x i)) (while_21_8_137 min a_size a1_ind a1_val N (+ x 1) i))))
(check-sat)
