(declare-var a (Array Int Int))
(declare-var a1 (Array Int Int))
(declare-var i Int)
(declare-var i1 Int)
(declare-var n Int)

(declare-rel inv1 ((Array Int Int) Int Int))
(declare-rel fail ())

(rule (inv1 a 0 n))

(rule (=> (and (inv1 a i n) (< i n) (= a1 (ite (< (select a i) n) (store a i (select a i)) (store a i n))) (= i1 (+ i 1))) (inv1 a1 i1 n)))

(rule (=> (and (inv1 a i n) (>= i n) (< 0 i1) (< i1 n) (not (<= (select a i1) n))) fail))

(query fail)
