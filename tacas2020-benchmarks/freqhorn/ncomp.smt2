(declare-var a (Array Int Int))
(declare-var a1 (Array Int Int))
(declare-var b (Array Int Int))
(declare-var b1 (Array Int Int))
(declare-var c (Array Int Int))
(declare-var c1 (Array Int Int))
(declare-var i Int)
(declare-var i1 Int)
(declare-var n Int)

(declare-rel inv1 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int))
(declare-rel inv2 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int))
(declare-rel inv3 ((Array Int Int) (Array Int Int) (Array Int Int) Int Int))
(declare-rel fail ())

(rule (inv1 a b c 0 n))

(rule (=> (and (inv1 a b c i n) (< i n)
    (= a1 (ite
      (= i 0)
      (store a i 6)
      (store a i (+ (select a (- i 1)) 6) )
    ))
    (= i1 (+ i 1))) (inv1 a1 b c i1 n)))

(rule (=> (and (inv1 a b c i n) (>= i n)) (inv2 a b c 0 n)))

(rule (=> (and (inv2 a b c i n) (< i n)
    (= b1 (ite
      (= i 0)
      (store b i 1)
      (store b i (+ (select b (- i 1)) (select a (- i 1))))
    ))
    (= i1 (+ i 1))) (inv2 a b1 c i1 n)))

(rule (=> (and (inv2 a b c i n) (>= i n)) (inv3 a b c 0 n)))

(rule (=> (and (inv3 a b c i n) (< i n)
    (= c1 (ite
      (= i 0)
      (store c i n)
      (store c i (+ (select c (- i 1)) (select b (- i 1))))
    ))
    (= i1 (+ i 1))) (inv3 a b c1 i1 n)))

(rule (=> (and (inv3 a b c i n) (>= i n) (< 0 i1) (< i1 n) (not (= (select c i1) (+ n (* i1 (* i1 i1))) )) ) fail))

(query fail)
