# Manifest: Page 014

## REPAIR_MATH
- RAW: ```
M ( x ) \rightarrow H o m _ { A } ( P _ { x } , M ) , \ \ m \mapsto \rho _ { m } ^ { M } \ ( m \in M ( x ) ) ,
```
  FIX: ```
$$
M ( x ) \rightarrow H o m _ { A } ( P _ { x } , M ) , \ \ m \mapsto \rho _ { m } ^ { M } \ ( m \in M ( x ) ) ,
$$
```
- RAW: ```
N ( x ) \to H o m _ { A ^ { o p } } ( P _ { x } ^ { \prime } , N ) , \ \ m \mapsto \lambda _ { m } ^ { N } \left ( m \in N ( x ) \right ) ,
```
  FIX: ```
$$
N ( x ) \to H o m _ { A ^ { o p } } ( P _ { x } ^ { \prime } , N ) , \ \ m \mapsto \lambda _ { m } ^ { N } \left ( m \in N ( x ) \right ) ,
$$
```
- RAW: ```
\mu \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } }
```
  FIX: ```
$$
\mu \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } }
$$
```
- RAW: ```
M ( \mu ) \coloneqq [ a _ { j i } M _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } .
```
  FIX: ```
$$
M ( \mu ) \coloneqq [ a _ { j i } M _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } .
$$
```

## REPAIR_PROSE
- RAW: ```
where ρ M m : P x → M is a morphism ( ρ M m,y : P x ( y ) → M ( y )) y ∈ P defined by ρ M m,y ( p ) : = M ( p )( m )(= p · m ) for all y ∈ P and p ∈ P x ( y ) = A ( x,y ) , where M ( p ): M ( x ) → M ( y ) is a structure linear map of M . Sometimes we just write ρ M m ( p ) : = M ( p )( m ) by omitting y . op
```
  FIX: ```
where \( \rho_m^M \colon P_x \to M \) is a morphism \( (\rho_{m,y}^M \colon P_x(y) \to M(y))_{y \in P} \) defined by \( \rho_{m,y}^M(p) \coloneqq M(p)(m) (= p \cdot m) \) for all \( y \in P \) and \( p \in P_x(y) = A(x,y) \), where \( M(p) \colon M(x) \to M(y) \) is a structure linear map of \( M \). Sometimes we just write \( \rho_m^M(p) \coloneqq M(p)(m) \) by omitting \( y \).
```
- RAW: ```
Similarly, by considering an A -module N to be a right A -module, we have an isomorphism
```
  FIX: ```
Similarly, by considering an \( A \)-module \( N \) to be a right \( A \)-module, we have an isomorphism
```
- RAW: ```
where λ N m : P ′ x → N is defined by λ N m ( p ) : = N ( p )( m )(= m · p ) .
```
  FIX: ```
where \( \lambda_m^N \colon P_x^\prime \to N \) is defined by \( \lambda_m^N(p) \coloneqq N(p)(m) (= m \cdot p) \).
```
- RAW: ```
- (3) For a morphism p y,x : x → y in P , we set M y,x to be the linear map M ( p y,x ): M ( x ) → M ( y ) . P x
```
  FIX: ```
- (3) For a morphism \( p_{y,x} \colon x \to y \) in \( P \), we set \( M_{y,x} \) to be the linear map \( M(p_{y,x}) \colon M(x) \to M(y) \).
```
- RAW: ```
- (4) Since p y,x ∈ A ( x,y ) = P x ( y ) , we can set P y,x : = ρ p y,x : = ρ p y,x : P y → P x . We note here that P y,x = 0 if x ≰ y in P . Similarly, we set p op x,y : = p y,x ∈ P op ( y,x ) = P ( x,y ) for all ( x,y ) ∈ [ ≤ ] P . It induces a morphism P ′ x,y : = ρ p op x,y : P ′ x → P ′ y in mod A op .
```
  FIX: ```
- (4) Since \( p_{y,x} \in A(x,y) = P_x(y) \), we can set \( P_{y,x} \coloneqq \rho_{p_{y,x}} \colon P_y \to P_x \). We note here that \( P_{y,x} = 0 \) if \( x \not\le y \) in \( P \). Similarly, we set \( p^{op}_{x,y} \coloneqq p_{y,x} \in P^{op}(y,x) = P(x,y) \) for all \( (x,y) \in [\le]_P \). It induces a morphism \( P^\prime_{x,y} \coloneqq \rho_{p^{op}_{x,y}} \colon P^\prime_x \to P^\prime_y \) in \( \text{mod } A^{op} \).
```
- RAW: ```
# Notation 2.8. Let M ∈ mod A , and
```
  FIX: ```
**Notation 2.8.** Let \( M \in \text{mod } A \), and
```
- RAW: ```
a morphism between projective modules of the form µ : = a ji P y j ,x i ( i,j ) ∈ [ m ] × [ n ] with a ji ∈ k , (( i,j ) ∈ [ m ] × [ n ]) for some x 1 ,x 2 ...,x m ,y 1 ,y 2 ,...,y n ∈ P . Then we set M ( µ ): i ∈ [ m ] M ( x i ) → j ∈ [ n ] M ( y j ) to be the linear map defined by the matrix
```
  FIX: ```
a morphism between projective modules of the form \( \mu \coloneqq [a_{ji} P_{y_j, x_i}]_{(i,j) \in [m] \times [n]} \) with \( a_{ji} \in k \) for some \( x_1, x_2, \dots, x_m, y_1, y_2, \dots, y_n \in P \). Then we set \( M(\mu) \colon \bigoplus_{i \in [m]} M(x_i) \to \bigoplus_{j \in [n]} M(y_j) \) to be the linear map defined by the matrix
```
- RAW: ```
The right-hand side is obtained from µ by first replacing the letter P with M , and then making the transpose.
```
  FIX: ```
The right-hand side is obtained from \( \mu \) by first replacing the letter \( P \) with \( M \), and then making the transpose.
```
- RAW: ```
Remark 2.9. Since both P y,x = ρ p y,x : P y → P x and M y,x = M ( p y,x ): M ( x ) → M ( y ) are defined by p y,x for all x,y ∈ P , we can think that both µ and M ( µ ) come from the common matrix α : = a ji p y j ,x i ( j,i ) ∈ [ n ] × [ m ] with entries in k [ P ]( x i ,y j ) = k p y j ,x i regarded as a morphism ( x 1 ,...,x m ) → ( y 1 ,...,y n ) , where we set a ji p y j ,x i : = 0 unless x i ≤ y j . This point of view is formalized as the formal additive hull k [ P ] of k [ P ] .
```
  FIX: ```
**Remark 2.9.** Since both \( P_{y,x} = \rho_{p_{y,x}} \colon P_y \to P_x \) and \( M_{y,x} = M(p_{y,x}) \colon M(x) \to M(y) \) are defined by \( p_{y,x} \) for all \( x,y \in P \), we can think that both \( \mu \) and \( M(\mu) \) come from the common matrix \( \alpha \coloneqq [a_{ji} p_{y_j, x_i}]_{(j,i) \in [n] \times [m]} \) with entries in \( k[P](x_i, y_j) = k p_{y_j, x_i} \) regarded as a morphism \( (x_1, \dots, x_m) \to (y_1, \dots, y_n) \), where we set \( a_{ji} p_{y_j, x_i} \coloneqq 0 \) unless \( x_i \le y_j \). This point of view is formalized as the formal additive hull \( k[P] \) of \( k[P] \).
```
