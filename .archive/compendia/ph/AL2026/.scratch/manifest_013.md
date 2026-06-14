# Manifest: Page 013

## REPAIR_MATH
- RAW: ```
V _ { I } ( x ) \colon = \begin{cases} \mathbb { k } , & \text {if } x \in I , \\ 0 , & \text {otherwise} , \end{cases}
```
  FIX: ```
$$
V _ { I } ( x ) \colon = \begin{cases} \mathbb { k } , & \text {if } x \in I , \\ 0 , & \text {otherwise} , \end{cases}
$$
```
- RAW: ```
V _ { I } ( p ) \coloneqq \begin{cases} k \mathbb { I } _ { k } , & \text {if } ( x , y ) \in [ \leq ] _ { I } \text { and } p \coloneqq k p _ { y , x } \text { for some } k \in \mathbb { K } , \\ 0 , & \text {otherwise.} \end{cases}
```
  FIX: ```
$$
V _ { I } ( p ) \coloneqq \begin{cases} k \mathbb { I } _ { k } , & \text {if } ( x , y ) \in [ \leq ] _ { I } \text { and } p \coloneqq k p _ { y , x } \text { for some } k \in \mathbb { K } , \\ 0 , & \text {otherwise.} \end{cases}
$$
```

## REPAIR_PROSE
- RAW: ```
In this case, we define [ K,L ] : = { y ∈ P | x ≤ y ≤ z for some x ∈ K and for some z ∈ L } . Therefore, every interval I of P can be expressed by [sc( I ) , sk( I )] .
```
  FIX: ```
In this case, we define \( [ K,L ] := \{ y \in P \mid x \leq y \leq z \text{ for some } x \in K \text{ and for some } z \in L \} \). Therefore, every interval \( I \) of \( P \) can be expressed by \( [\text{sc}( I ) , \text{sk}( I )] \).
```
- RAW: ```
# Definition 2.5. Let I be an interval of P .
```
  FIX: ```
# Definition 2.5. Let \( I \) be an interval of \( P \).
```
- RAW: ```
(1) A persistence module V I over P is defined as follows. For x ∈ P ,
```
  FIX: ```
(1) A persistence module \( V_I \) over \( P \) is defined as follows. For \( x \in P \),
```
- RAW: ```
and for p ∈ k [ P ]( x,y ) ,
```
  FIX: ```
and for \( p \in k[P](x,y) \),
```
- RAW: ```
It is easy to check that V I is indecomposable.
```
  FIX: ```
It is easy to check that \( V_I \) is indecomposable.
```
- RAW: ```
- (2) A persistence module isomorphic to V I for some I ∈ I is called an interval module .
```
  FIX: ```
- (2) A persistence module isomorphic to \( V_I \) for some \( I \in \mathcal{I} \) is called an interval module.
```
- RAW: ```
- (3) A persistence module is said to be interval-decomposable if it is isomorphic to a finite direct sum of interval modules. Thus 0 is trivially interval-decomposable.
```
  FIX: ```
- (3) A persistence module is said to be interval-decomposable if it is isomorphic to a finite direct sum of interval modules. Thus \( 0 \) is trivially interval-decomposable.
```
- RAW: ```
We will use the notation d M ( L ) to denote the multiplicity of an indecomposable direct summand L of a module M in its indecomposable decomposition as explained in the following well-known theorem.
```
  FIX: ```
We will use the notation \( d_M(L) \) to denote the multiplicity of an indecomposable direct summand \( L \) of a module \( M \) in its indecomposable decomposition as explained in the following well-known theorem.
```
- RAW: ```
Theorem 2.6 (Krull–Schmidt) . Let C be a finite k -linear category, and fix a complete set L = L C of representatives of isoclasses of indecomposable objects in mod C . Then every finite-dimensional left C -module M is isomorphic to the direct sum L ∈ L L d M ( L ) for some unique function d M : L → Z ≥ 0 . Therefore another finitedimensional left C -module N is isomorphic to M if and only if d M = d N . In this sense, the function d M is a complete invariant of M under isomorphisms.
```
  FIX: ```
Theorem 2.6 (Krull–Schmidt). Let \( \mathcal{C} \) be a finite \( k \)-linear category, and fix a complete set \( \mathcal{L} = \mathcal{L}_{\mathcal{C}} \) of representatives of isoclasses of indecomposable objects in \( \text{mod }\mathcal{C} \). Then every finite-dimensional left \( \mathcal{C} \)-module \( M \) is isomorphic to the direct sum \( \bigoplus_{L \in \mathcal{L}} L^{d_M(L)} \) for some unique function \( d_M : \mathcal{L} \to \mathbb{Z}_{\geq 0} \). Therefore another finite-dimensional left \( \mathcal{C} \)-module \( N \) is isomorphic to \( M \) if and only if \( d_M = d_N \). In this sense, the function \( d_M \) is a complete invariant of \( M \) under isomorphisms.
```
- RAW: ```
In the sequel, we simply call d M ( L ) the interval multiplicity of L (in M ) whenever L is an interval module. In one-parameter persistent homology, this function d M corresponds to the persistence diagram of M .
```
  FIX: ```
In the sequel, we simply call \( d_M(L) \) the interval multiplicity of \( L \) (in \( M \)) whenever \( L \) is an interval module. In one-parameter persistent homology, this function \( d_M \) corresponds to the persistence diagram of \( M \).
```
- RAW: ```
Notation 2.7. Let M ∈ mod A , and x,y ∈ P .
```
  FIX: ```
Notation 2.7. Let \( M \in \text{mod }A \), and \( x,y \in P \).
```
- RAW: ```
(1) We set P x : = A ( x, -) (resp. P ′ x : = A op ( x, -) ) to be the projective indecomposable A -module (resp. k [ P op ] -module) corresponding to the vertex x , and Q x : = D ( A (,x )) (resp. Q ′ x : = D ( A op (,x )) ) to be the injective indecomposable A -module (resp. A op -module) corresponding to the vertex x .
```
  FIX: ```
(1) We set \( P_x := A(x, -) \) (resp. \( P'_x := A^{\text{op}}(x, -) \)) to be the projective indecomposable \( A \)-module (resp. \( k[P^{\text{op}}] \)-module) corresponding to the vertex \( x \), and \( Q_x := D(A(-, x)) \) (resp. \( Q'_x := D(A^{\text{op}}(-, x)) \)) to be the injective indecomposable \( A \)-module (resp. \( A^{\text{op}} \)-module) corresponding to the vertex \( x \).
```
