(declare-var a (Array Int Int))
(declare-var i Int)
(declare-var i1 Int)
(declare-var sum Int)
(declare-var sum1 Int)
(declare-var n Int)

(declare-rel inv1 ((Array Int Int) Int Int Int))
(declare-rel inv2 ((Array Int Int) Int Int Int))
(declare-rel fail ())

(rule (inv1 a 0 n 0))

(rule (=> (and (inv1 a i n sum) (< i n) (= sum1 (+ sum (select a i))) (= i1 (+ i 1))) (inv1 a i1 n sum1)))

(rule (=> (and (inv1 a i n sum) (>= i n)) (inv2 a 0 n sum)))

(rule (=> (and (inv2 a i n sum) (< i n) (= sum1 (- sum (select a i))) (= i1 (+ i 1))) (inv2 a i1 n sum1)))

(rule (=> (and (inv2 a i n sum) (>= i n) (not (= sum 0))) fail))

(query fail)
