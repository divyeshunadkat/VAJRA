;Number of predicates (nodes) = 13
;Number of variables = 6
;Number of clauses = 17
;
(set-logic HORN)
(declare-rel assign_22_2_148 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel assert_21_2_139 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_19_8_151 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_18_1_107 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_15_2_98 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_13_3_86 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel if_12_2_90 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel while_11_1_101 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_10_1_55 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_9_1_49 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel assign_7_1_43 (Int Int Int Int Int Int Int Int Int Int))
(declare-rel end (Int Int Int Int Int Int Int Int Int Int))
(declare-rel start (Int Int Int Int Int Int Int Int Int Int))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size)) (start b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (start b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (assign_7_1_43 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
;
;(assign)  SIZE := Support.random()
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rnd Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_7_1_43 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (assign_9_1_49 b_size b1_ind b1_val a_size a1_ind a1_val rv rnd x i))))
;
;(assign)  rv := 1
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_9_1_49 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (assign_10_1_55 b_size b1_ind b1_val a_size a1_ind a1_val 1 SIZE x i))))
;
;(assign)  i := 0
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_10_1_55 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (while_11_1_101 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x 0))))
;
;(while)   while((i<SIZE))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_11_1_101 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i) (< i SIZE)) (if_12_2_90 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_11_1_101 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i) (not (< i SIZE))) (assign_18_1_107 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
;
;(if)      if((!(a[i]==b[i])))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (tmp_select_a Int) (tmp_select_b Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (if_12_2_90 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i) (not (= tmp_select_a tmp_select_b)) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_12_2_90 b_size b1_ind b1_val a_size i tmp_select_a rv SIZE x i)) (and (< a1_ind i) (<= 0 a_size) (if_12_2_90 b_size b1_ind b1_val a_size i tmp_select_a rv SIZE x i))) (or (and (= b1_ind i) (= tmp_select_b b1_val)) (and (< i b1_ind) (<= 0 b_size) (if_12_2_90 b_size i tmp_select_b a_size a1_ind a1_val rv SIZE x i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)) (and (< a1_ind i) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)))) (and (< b1_ind i) (<= 0 b_size) (if_12_2_90 b_size i tmp_select_b a_size a1_ind a1_val rv SIZE x i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)) (and (< a1_ind i) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)))))) (assign_13_3_86 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (tmp_select_a Int) (tmp_select_b Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (if_12_2_90 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i) (not (not (= tmp_select_a tmp_select_b))) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_12_2_90 b_size b1_ind b1_val a_size i tmp_select_a rv SIZE x i)) (and (< a1_ind i) (<= 0 a_size) (if_12_2_90 b_size b1_ind b1_val a_size i tmp_select_a rv SIZE x i))) (or (and (= b1_ind i) (= tmp_select_b b1_val)) (and (< i b1_ind) (<= 0 b_size) (if_12_2_90 b_size i tmp_select_b a_size a1_ind a1_val rv SIZE x i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)) (and (< a1_ind i) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)))) (and (< b1_ind i) (<= 0 b_size) (if_12_2_90 b_size i tmp_select_b a_size a1_ind a1_val rv SIZE x i) (or (and (= a1_ind i) (= tmp_select_a a1_val)) (and (< i a1_ind) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)) (and (< a1_ind i) (<= 0 a_size) (if_12_2_90 b_size i tmp_select_b a_size i tmp_select_a rv SIZE x i)))))) (assign_15_2_98 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
;
;(assign)  rv := 0
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_13_3_86 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (assign_15_2_98 b_size b1_ind b1_val a_size a1_ind a1_val 0 SIZE x i))))
;
;(assign)  i := (i+1)
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_15_2_98 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (while_11_1_101 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x (+ i 1)))))
;
;(assign)  x := 0
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_18_1_107 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (while_19_8_151 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE 0 i))))
;
;(while)   while((x<SIZE))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_19_8_151 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i) (< x SIZE)) (assert_21_2_139 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (while_19_8_151 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i) (not (< x SIZE))) (end b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
;
;(assert)  ((rv==0)||(a[x]==b[x]))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (tmp_select_a Int) (tmp_select_b Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_21_2_139 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i) (or (and (= a1_ind x) (= tmp_select_a a1_val)) (and (< x a1_ind) (<= 0 a_size) (assert_21_2_139 b_size b1_ind b1_val a_size x tmp_select_a rv SIZE x i)) (and (< a1_ind x) (<= 0 a_size) (assert_21_2_139 b_size b1_ind b1_val a_size x tmp_select_a rv SIZE x i))) (or (and (= b1_ind x) (= tmp_select_b b1_val)) (and (< x b1_ind) (<= 0 b_size) (assert_21_2_139 b_size x tmp_select_b a_size a1_ind a1_val rv SIZE x i) (or (and (= a1_ind x) (= tmp_select_a a1_val)) (and (< x a1_ind) (<= 0 a_size) (assert_21_2_139 b_size x tmp_select_b a_size x tmp_select_a rv SIZE x i)) (and (< a1_ind x) (<= 0 a_size) (assert_21_2_139 b_size x tmp_select_b a_size x tmp_select_a rv SIZE x i)))) (and (< b1_ind x) (<= 0 b_size) (assert_21_2_139 b_size x tmp_select_b a_size a1_ind a1_val rv SIZE x i) (or (and (= a1_ind x) (= tmp_select_a a1_val)) (and (< x a1_ind) (<= 0 a_size) (assert_21_2_139 b_size x tmp_select_b a_size x tmp_select_a rv SIZE x i)) (and (< a1_ind x) (<= 0 a_size) (assert_21_2_139 b_size x tmp_select_b a_size x tmp_select_a rv SIZE x i)))))) (or (= rv 0) (= tmp_select_a tmp_select_b)))))
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assert_21_2_139 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (assign_22_2_148 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i))))
;
;(assign)  x := (x+1)
(assert (forall ((SIZE Int) (a1_ind Int) (a1_val Int) (a_size Int) (b1_ind Int) (b1_val Int) (b_size Int) (i Int) (rv Int) (x Int)) (=> (and (<= 0 a_size) (<= 0 b_size) (assign_22_2_148 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE x i)) (while_19_8_151 b_size b1_ind b1_val a_size a1_ind a1_val rv SIZE (+ x 1) i))))
(check-sat)
