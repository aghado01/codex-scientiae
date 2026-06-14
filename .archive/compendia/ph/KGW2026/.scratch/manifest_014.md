# Manifest: Page 014

## REPAIR_MATH
- RAW: ```
\partial ( e _ { a , i _ { 1 } , \cdots , i _ { p - 1 } , b } ) = e _ { i _ { 1 } , \cdots , i _ { p - 1 } , b } + \xi ^ { p } e _ { a , i _ { 1 } , \cdots , i _ { p - 1 } } + \sum _ { j = 1 } ^ { p - 1 } \xi ^ { j } e _ { a , i _ { 1 } , \cdots , i _ { j } ^ { * } , i _ { p - 1 } , b } .
```
  FIX: ```
$$
\partial ( e _ { a , i _ { 1 } , \cdots , i _ { p - 1 } , b } ) = e _ { i _ { 1 } , \cdots , i _ { p - 1 } , b } + \xi ^ { p } e _ { a , i _ { 1 } , \cdots , i _ { p - 1 } } + \sum _ { j = 1 } ^ { p - 1 } \xi ^ { j } e _ { a , i _ { 1 } , \cdots , i _ { j } ^ { * } , i _ { p - 1 } , b } .
$$
```
- RAW: ```
e _ { a , j _ { t } , k _ { t } , b } + e _ { a , j _ { t + 1 } , k _ { t } , b }
```
  FIX: ```
$$
e _ { a , j _ { t } , k _ { t } , b } + e _ { a , j _ { t + 1 } , k _ { t } , b }
$$
```

## REPAIR_PROSE
- RAW: ```
[Page 14]
```
  FIX: ```
```
- RAW: ```
Figure 6: Trapezohedron T m
```
  FIX: ```
Figure 6: Trapezohedron \( T_m \)
```
- RAW: ```
Definition 9. A p-path v = v i 0 , ··· ,i p e i 0 , ··· ,i p is called ( a,b ) -cluster if all the elementary paths e i 0 , ··· ,i p with nonzero coefficients have i 0 = a and i p = b . A path is called cluster if it is a ( a,b ) cluster for some a,b ∈ V ( G ) .
```
  FIX: ```
Definition 9. A \( p \)-path \( v = v_{i_0, \cdots, i_p} e_{i_0, \cdots, i_p} \) is called \( (a,b) \)-cluster if all the elementary paths \( e_{i_0, \cdots, i_p} \) with nonzero coefficients have \( i_0 = a \) and \( i_p = b \). A path is called cluster if it is a \( (a,b) \)-cluster for some \( a,b \in V(G) \).
```
- RAW: ```
It is known that any p -path in Ω 2 p is a sum of Ω 2 p clusters [6] . We extend this to Mayer setting.
```
  FIX: ```
It is known that any \( p \)-path in \( \Omega_2^p \) is a sum of \( \Omega_2^p \) clusters [6]. We extend this to Mayer setting.
```
- RAW: ```
Lemma 3.3. Any element v ∈ Ω N, 1 n is a sum of ( a,b ) -clusters v a,b ∈ Ω N, 1 n .
```
  FIX: ```
Lemma 3.3. Any element \( v \in \Omega_{N,1}^n \) is a sum of \( (a,b) \)-clusters \( v_{a,b} \in \Omega_{N,1}^n \).
```
- RAW: ```
Proof. Let v ∈ Ω N, 1 n than ∂ ( v ) ∈ A n − 1 . Observe that v can be written as a sum of ( a,b )-clusters so that v = a,b ∈ V ( G ) v a,b where v a,b ∈ A p . Observe that,
```
  FIX: ```
Proof. Let \( v \in \Omega_{N,1}^n \) then \( \partial(v) \in A_{n-1} \). Observe that \( v \) can be written as a sum of \( (a,b) \)-clusters so that \( v = \sum_{a,b \in V(G)} v_{a,b} \) where \( v_{a,b} \in A_p \). Observe that,
```
- RAW: ```
Observe that e a,i 1 , ··· ,i ∗ j ··· ,i p − 1 ,b might be non-allowed. The cancellation can occur in two different ways such as v − v ′ or v + N − 1 m =1 ξ m v m where at least one v m ̸ = v and v ′ ,v m has the same non-allowed face. Both of the cancellation happens within the cluster since v ′ and v m are in ( a,b )-cluster.
```
  FIX: ```
Observe that \( e_{a, i_1, \cdots, i_j^*, \cdots, i_{p-1}, b} \) might be non-allowed. The cancellation can occur in two different ways such as \( v - v' \) or \( v + \sum_{m=1}^{N-1} \xi^m v_m \) where at least one \( v_m \neq v \) and \( v', v_m \) has the same non-allowed face. Both of the cancellation happens within the cluster since \( v' \) and \( v_m \) are in \( (a,b) \)-cluster.
```
- RAW: ```
Let w ∈ Ω N, 1 3 be called minimal element if no sub linear combinations of its components are in Ω N, 1 3 . By [Lemma 2.4 of [6]], every Ω 2 , 1 p -cluster is a sum of minimal Ω 2 , 1 p -clusters which leads to the basis of Ω 2 , 1 p as stated at Proposition 2.5 at [6]. These results can be stated for Ω N, 1 p . The basis of Ω 2 3 contains an core element which is called trapezohedron T m defined as for m ≥ 2
```
  FIX: ```
Let \( w \in \Omega_{N,1}^3 \) be called minimal element if no sub linear combinations of its components are in \( \Omega_{N,1}^3 \). By [Lemma 2.4 of [6]], every \( \Omega_{2,1}^p \)-cluster is a sum of minimal \( \Omega_{2,1}^p \)-clusters which leads to the basis of \( \Omega_{2,1}^p \) as stated at Proposition 2.5 at [6]. These results can be stated for \( \Omega_{N,1}^p \). The basis of \( \Omega_2^3 \) contains an core element which is called trapezohedron \( T_m \) defined as for \( m \geq 2 \)
```
- RAW: ```
for all t = 0 , ··· ,m − 1 (mod m ) as in Fig 6.
```
  FIX: ```
for all \( t = 0, \cdots, m-1 \pmod{m} \) as in Fig 6.
```
- RAW: ```
For the completeness we will state the results from [6] and [12]. Let G be a directed graph whose vertex set is partitioned into disjoint subsets A 1 ,A 2 , ··· ,A n . Let H be the directed graph with vertices a 1 ,a 2 , ··· ,a n . Define a map f : G → H by f ( x ) = a i for all x ∈ A i . If
```
  FIX: ```
For the completeness we will state the results from [6] and [12]. Let \( G \) be a directed graph whose vertex set is partitioned into disjoint subsets \( A_1, A_2, \cdots, A_n \). Let \( H \) be the directed graph with vertices \( a_1, a_2, \cdots, a_n \). Define a map \( f : G \to H \) by \( f(x) = a_i \) for all \( x \in A_i \). If
```
- RAW: ```
a i → a j in H if and only if there exist x ∈ A i and y ∈ A j such that x → y in G
```
  FIX: ```
\( a_i \to a_j \) in \( H \) if and only if there exist \( x \in A_i \) and \( y \in A_j \) such that \( x \to y \) in \( G \)
```
