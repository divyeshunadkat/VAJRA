(declare-var a (Array Int Int))
(declare-var a1 (Array Int Int))
(declare-var b (Array Int Int))
(declare-var b1 (Array Int Int))
(declare-var i Int)
(declare-var i1 Int)
(declare-var sum Int)
(declare-var sum1 Int)
(declare-var n Int)

(declare-rel inv1 ((Array Int Int) (Array Int Int) Int Int Int))
(declare-rel inv2 ((Array Int Int) (Array Int Int) Int Int Int))
(declare-rel inv3 ((Array Int Int) (Array Int Int) Int Int Int))
(declare-rel inv4 ((Array Int Int) (Array Int Int) Int Int Int))
(declare-rel fail ())

(rule (inv1 a b 0 n 0))

(rule (=> (and (inv1 a b i n sum) (< i n) (= a1 (store a i 1)) (= i1 (+ i 1))) (inv1 a1 b i1 n sum)))

(rule (=> (and (inv1 a b i n sum) (>= i n)) (inv2 a b 0 n sum)))

(rule (=> (and (inv2 a b i n sum) (< i n) (= b1 (store b i 1)) (= i1 (+ i 1))) (inv2 a b1 i1 n sum)))

(rule (=> (and (inv2 a b i n sum) (>= i n)) (inv3 a b 0 n sum)))

(rule (=> (and (inv3 a b i n sum) (< i n) (= sum1 (+ sum (select a i))) (= i1 (+ i 1))) (inv3 a b i1 n sum1)))

(rule (=> (and (inv3 a b i n sum) (>= i n)) (inv4 a b 0 n sum)))

(rule (=> (and (inv4 a b i n sum) (< i n) (= a1 (store a i (+ (select b i) sum))) (= i1 (+ i 1))) (inv4 a1 b i1 n sum)))

(rule (=> (and (inv4 a b i n sum) (>= i n) (< 0 i1) (< i1 n) (not (= (select a i1) (+ n 1)))) fail))

(query fail)
