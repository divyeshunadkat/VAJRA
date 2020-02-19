(declare-var a (Array Int Int))
(declare-var a1 (Array Int Int))
(declare-var b (Array Int Int))
(declare-var b1 (Array Int Int))
(declare-var i Int)
(declare-var i1 Int)
(declare-var n Int)

(declare-rel inv1 ((Array Int Int) (Array Int Int) Int Int))
(declare-rel inv2 ((Array Int Int) (Array Int Int) Int Int))
(declare-rel fail ())

(rule (inv1 a b 0 n))

(rule (=> (and (inv1 a b i n) (< i n)
    (= a1 (ite
      (= i 0)
      (store a i 10)
      (store a i (+ (select a (- i 1)) 10) )
    ))
    (= i1 (+ i 1))) (inv1 a1 b i1 n)))

(rule (=> (and (inv1 a b i n) (>= i n)) (inv2 a b 0 n)))

(rule (=> (and (inv2 a b i n) (< i n)
    (= b1 (ite
      (= i 0)
      (store b i 1)
      (store b i (+ (select b (- i 1)) (select a (- i 1))))
    ))
    (= i1 (+ i 1))) (inv2 a b1 i1 n)))

(rule (=> (and (inv2 a b i n) (>= i n) (< 0 i1) (< i1 n) (not (= (select b i1) (+ (* (* 5 i1) i1) (* 5 i1) 1) )) ) fail))

(query fail)
