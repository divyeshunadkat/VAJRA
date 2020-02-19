(declare-var a (Array Int Int))
(declare-var a1 (Array Int Int))
(declare-var i Int)
(declare-var i1 Int)
(declare-var n Int)

(declare-rel inv1 ((Array Int Int) Int Int))
(declare-rel inv2 ((Array Int Int) Int Int))
(declare-rel fail ())

(rule (inv1 a 0 n))

(rule (=> (and (inv1 a i n) (< i n) (= a1 (store a i 0)) (= i1 (+ i 1))) (inv1 a1 i1 n)))

(rule (=> (and (inv1 a i n) (>= i n)) (inv2 a 0 n)))

(rule (=> (and (inv2 a i n) (< i n) (= a1 (ite (= (mod n 2) 0) (store a i (+ (select a i) 2)) (store a i (+ (select a i) 1)))) (= i1 (+ i 1))) (inv2 a1 i1 n)))

(rule (=> (and (inv2 a i n) (>= i n) (< 0 i1) (< i1 n) (not (= (mod (select a i1) 2) (mod n 2)))) fail))

(query fail)
