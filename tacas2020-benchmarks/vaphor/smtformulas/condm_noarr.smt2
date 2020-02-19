;Number of predicates (nodes) = 17
;Number of variables = 3
;Number of clauses = 22
;
(set-logic HORN)
(declare-rel assign_33_2_191 (Int Int Int Int Int))
(declare-rel assert_32_2_182 (Int Int Int Int Int))
(declare-rel while_30_1_194 (Int Int Int Int Int))
(declare-rel assign_29_1_154 (Int Int Int Int Int))
(declare-rel assign_26_2_145 (Int Int Int Int Int))
(declare-rel arrayassign_20_3_112 (Int Int Int Int Int))
(declare-rel arrayassign_24_3_133 (Int Int Int Int Int))
(declare-rel if_18_2_136 (Int Int Int Int Int))
(declare-rel while_16_1_148 (Int Int Int Int Int))
(declare-rel assign_15_1_76 (Int Int Int Int Int))
(declare-rel assign_12_2_67 (Int Int Int Int Int))
(declare-rel arrayassign_11_2_58 (Int Int Int Int Int))
(declare-rel while_9_1_70 (Int Int Int Int Int))
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
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_8_1_40 a_size a1_ind a1_val N i)) (while_9_1_70 a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_9_1_70 a_size a1_ind a1_val N i) (< i N)) (arrayassign_11_2_58 a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_9_1_70 a_size a1_ind a1_val N i) (not (< i N))) (assign_15_1_76 a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_11_2_58 a_size a1_ind a1_val N i) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val 0)) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_12_2_67 tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_12_2_67 a_size a1_ind a1_val N i)) (while_9_1_70 a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_15_1_76 a_size a1_ind a1_val N i)) (while_16_1_148 a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_16_1_148 a_size a1_ind a1_val N i) (< i N)) (if_18_2_136 a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_16_1_148 a_size a1_ind a1_val N i) (not (< i N))) (assign_29_1_154 a_size a1_ind a1_val N i))))
;
;(if)      if(((N%2)==0))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (if_18_2_136 a_size a1_ind a1_val N i) (= (mod N 2) 0)) (arrayassign_20_3_112 a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (if_18_2_136 a_size a1_ind a1_val N i) (not (= (mod N 2) 0))) (arrayassign_24_3_133 a_size a1_ind a1_val N i))))
;
;(aassign) a[i] := (a[i]+2)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_20_3_112 a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_20_3_112 a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_20_3_112 a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a 2))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_26_2_145 tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(aassign) a[i] := (a[i]+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_select_a Int) (tmp_store_a1_ind Int) (tmp_store_a1_val Int) (tmp_store_a_size Int)) (=> (and (<= 0 a_size) (arrayassign_24_3_133 a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (arrayassign_24_3_133 a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (arrayassign_24_3_133 a_size i tmp_select_a N i))) (= tmp_store_a1_ind a1_ind) (= a_size tmp_store_a_size) (or (and (= a1_ind i) (= tmp_store_a1_val (+ tmp_select_a 1))) (and (not (= a1_ind i)) (= tmp_store_a1_val a1_val)))) (assign_26_2_145 tmp_store_a_size tmp_store_a1_ind tmp_store_a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_26_2_145 a_size a1_ind a1_val N i)) (while_16_1_148 a_size a1_ind a1_val N (+ i 1)))))
;
;(assign)  i := 0
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_29_1_154 a_size a1_ind a1_val N i)) (while_30_1_194 a_size a1_ind a1_val N 0))))
;
;(while)   while((i<N))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_30_1_194 a_size a1_ind a1_val N i) (< i N)) (assert_32_2_182 a_size a1_ind a1_val N i))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (while_30_1_194 a_size a1_ind a1_val N i) (not (< i N))) (end a_size a1_ind a1_val N i))))
;
;(assert)  ((a[i]%2)==(N%2))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int) (tmp_select_a Int)) (=> (and (<= 0 a_size) (assert_32_2_182 a_size a1_ind a1_val N i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (assert_32_2_182 a_size i tmp_select_a N i)) (and (< a1_ind i) (<= 0 a_size) (assert_32_2_182 a_size i tmp_select_a N i)))) (= (mod tmp_select_a 2) (mod N 2)))))
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assert_32_2_182 a_size a1_ind a1_val N i)) (assign_33_2_191 a_size a1_ind a1_val N i))))
;
;(assign)  i := (i+1)
(assert (forall ((N Int) (a1_ind Int) (a1_val Int) (a_size Int) (i Int)) (=> (and (<= 0 a_size) (assign_33_2_191 a_size a1_ind a1_val N i)) (while_30_1_194 a_size a1_ind a1_val N (+ i 1)))))
(check-sat)
