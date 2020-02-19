(declare-var a (Array Int Int))
(declare-var a1 (Array Int Int))
(declare-var i Int)
(declare-var i1 Int)
(declare-var sum Int)
(declare-var sum1 Int)
(declare-var n Int)

(declare-rel inv1 ((Array Int Int) Int Int Int))
(declare-rel inv2 ((Array Int Int) Int Int Int))
(declare-rel fail ())

(rule (inv1 a 0 n 0))

(rule (=> (and (inv1 a i n sum) (< i n) (= sum1 (+ sum 1)) (= i1 (+ i 1))) (inv1 a i1 n sum1)))

(rule (=> (and (inv1 a i n sum) (>= i n)) (inv2 a 0 n sum)))

(rule (=> (and (inv2 a i n sum) (< i n) (= a1 (store a i sum)) (= i1 (+ i 1))) (inv2 a i1 n sum)))

(rule (=> (and (inv2 a i n sum) (>= i n) (< 0 i1) (< i1 n) (not (= (select a i1) n))) fail))

(query fail)
