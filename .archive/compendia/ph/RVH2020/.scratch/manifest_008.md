# Manifest: Page 008

## REPAIR_MATH
- RAW: ```
X _ { k } = ( X _ { k } ^ { v } ) _ { v \in \mathbb { Z } ^ { d } } \in E ^ { \mathbb { Z } ^ { d } } \quad \text {and} \quad Y _ { k } = ( Y _ { k } ^ { v } ) _ { v \in \mathbb { Z } ^ { d } } \in F ^ { \mathbb { Z } ^ { d } } .
```
  FIX: ```
$$
X _ { k } = ( X _ { k } ^ { v } ) _ { v \in \mathbb { Z } ^ { d } } \in E ^ { \mathbb { Z } ^ { d } } \quad \text {and} \quad Y _ { k } = ( Y _ { k } ^ { v } ) _ { v \in \mathbb { Z } ^ { d } } \in F ^ { \mathbb { Z } ^ { d } } .
$$
```
- RAW: ```
P ( x , d z ) = \prod _ { v \in \mathbb { Z } ^ { d } } P ^ { v } ( x , d z ^ { v } ) , \quad \Phi ( x , z , d y ) = \prod _ { v \in \mathbb { Z } ^ { d } } \Phi ^ { v } ( x , z , d y ^ { v } ) ,
```
  FIX: ```
$$
P ( x , d z ) = \prod _ { v \in \mathbb { Z } ^ { d } } P ^ { v } ( x , d z ^ { v } ) , \quad \Phi ( x , z , d y ) = \prod _ { v \in \mathbb { Z } ^ { d } } \Phi ^ { v } ( x , z , d y ^ { v } ) ,
$$
```
- RAW: ```
P ^ { v } ( x , A ) \ \text { and } \ \Phi ^ { v } ( x , z , B ) \ \text { depend only on } x ^ { w } , z ^ { w } \text { for } \| w - v \| \leq 1 .
```
  FIX: ```
$$
P ^ { v } ( x , A ) \ \text { and } \ \Phi ^ { v } ( x , z , B ) \ \text { depend only on } x ^ { w } , z ^ { w } \text { for } \| w - v \| \leq 1 .
$$
```
- RAW: ```
Each v ∈ Z d should be viewed
```
  FIX: ```
Each \( v \in \mathbb{Z}^d \) should be viewed
```
- RAW: ```
an inﬁnite collection ( X v k ,Y v k ) k ≥ 0 of hidden Markov models whose dynamics and observations are locally coupled to their neighbors in Z d .
```
  FIX: ```
an inﬁnite collection \( (X_k^v, Y_k^v)_{k \ge 0} \) of hidden Markov models whose dynamics and observations are locally coupled to their neighbors in \( \mathbb{Z}^d \).
```
- RAW: ```
positive density of the form Φ v ( x,z,dy v ) = g ( z v ,y v ) ϕ ( dy v ), so that the observations are locally nondegenerate . Choose two values e,e ∈ E such that g ( e, · ) = g ( e , · ), and deﬁne the constant conﬁgurations z,z as z v = e and z v = e for all v ∈ Z d . Then the measures Φ( x,z, · ) and Φ( x,z , · ) are two distinct laws
```
  FIX: ```
positive density of the form \( \Phi^v(x, z, dy^v) = g(z^v, y^v) \phi(dy^v) \), so that the observations are locally nondegenerate. Choose two values \( e, e' \in E \) such that \( g(e, \cdot) = g(e', \cdot) \), and deﬁne the constant conﬁgurations \( z, z' \) as \( z^v = e \) and \( z^v = e' \) for all \( v \in \mathbb{Z}^d \). Then the measures \( \Phi(x, z, \cdot) \) and \( \Phi(x, z', \cdot) \) are two distinct laws
```
- RAW: ```
it is often the case that the law of X k is singular with respect to λ for all k < ∞ , which rules out
```
  FIX: ```
it is often the case that the law of \( X_k \) is singular with respect to \( \lambda \) for all \( k < \infty \), which rules out
```
- RAW: ```
models where X k is infinite-dimensional but Y k is (effectively) finite-dimensional. It is only when the observations Y k are also infinitedimensional that new phenomena arise.
```
  FIX: ```
models where \( X_k \) is infinite-dimensional but \( Y_k \) is (effectively) finite-dimensional. It is only when the observations \( Y_k \) are also infinitedimensional that new phenomena arise.
```
- RAW: ```
each location v may possess a diﬀerent local state space E v .
```
  FIX: ```
each location \( v \) may possess a diﬀerent local state space \( E_v \).
```

## REPAIR_PROSE
- RAW: ```
We initiate the investigation of such problems in the sequel.

glyph[negationslash]

Remark 2.5.
```
  FIX: ```
We initiate the investigation of such problems in the sequel.

Remark 2.5.
```
