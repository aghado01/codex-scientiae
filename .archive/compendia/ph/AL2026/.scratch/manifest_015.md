# Manifest: Page 015

## REPAIR_PROSE
- RAW: ```
[Page 15]

```
  FIX: ```
```

## REPAIR_MATH
- RAW: ```
$$
P ( [ a _ { j i } p _ { y , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } ) & \coloneqq [ a _ { j i } P _ { y , x _ { i } } ] _ { ( i , j ) \in [ m ] \times [ n ] } \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } } , \\ M ( [ a _ { j i } p _ { y , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } ) & \coloneqq M ( [ a _ { j i } P _ { y _ { j } , x _ { i } } ] _ { ( i , j ) \in [ m ] \times [ n ] } ) \colon \bigoplus _ { i \in [ m ] } M ( x _ { i } ) \to \bigoplus _ { j \in [ n ] } M ( y _ { j } ) .
$$

$$
( 2 . 6 )
$$
```
  FIX: ```
\[
\begin{aligned}
P ( [ a _ { j i } p _ { y , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } ) & \coloneqq [ a _ { j i } P _ { y , x _ { i } } ] _ { ( i , j ) \in [ m ] \times [ n ] } \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } } , \\ M ( [ a _ { j i } p _ { y , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } ) & \coloneqq M ( [ a _ { j i } P _ { y _ { j } , x _ { i } } ] _ { ( i , j ) \in [ m ] \times [ n ] } ) \colon \bigoplus _ { i \in [ m ] } M ( x _ { i } ) \to \bigoplus _ { j \in [ n ] } M ( y _ { j } ) .
\end{aligned} \tag{2.6}
\]
```
- RAW: ```
$$
\bigoplus _ { j \in [ n ] } P _ { y _ { j } } \stackrel { \mu } { \rightarrow } \bigoplus _ { i \in [ m ] } P _ { x _ { i } } \stackrel { \varepsilon } { \rightarrow } C \rightarrow 0
$$
```
  FIX: ```
\[
\bigoplus _ { j \in [ n ] } P _ { y _ { j } } \stackrel { \mu } { \rightarrow } \bigoplus _ { i \in [ m ] } P _ { x _ { i } } \stackrel { \varepsilon } { \rightarrow } C \rightarrow 0
\]
```
- RAW: ```
$$
\dim H o m _ { A } ( C , M ) = \sum _ { i = 1 } ^ { m } \dim M ( x _ { i } ) - \text {rank} \, M ( \mu ) .
$$
```
  FIX: ```
\[
\dim \operatorname{Hom} _ { A } ( C , M ) = \sum _ { i = 1 } ^ { m } \dim M ( x _ { i } ) - \operatorname{rank} \, M ( \mu ) .
\]
```
- RAW: ```
$$
0 \to H o m _ { A } ( C , M ) \to H o m _ { A } ( X , M ) \xrightarrow { H o m _ { A } ( \mu , M ) } H o m _ { A } ( Y , M ) .
$$
```
  FIX: ```
\[
0 \to \operatorname{Hom} _ { A } ( C , M ) \to \operatorname{Hom} _ { A } ( X , M ) \xrightarrow { \operatorname{Hom} _ { A } ( \mu , M ) } \operatorname{Hom} _ { A } ( Y , M ) .
\]
```
- RAW: ```
We refer this to Section 4 . By this reason, we also set P ( α ) : = µ and M ( α ) : = M ( µ ) , more explicitly
```
  FIX: ```
We refer this to Section 4. By this reason, we also set \( P(\alpha) \coloneqq \mu \) and \( M(\alpha) \coloneqq M(\mu) \), more explicitly
```
- RAW: ```
In the above, notice the difference of p and P , and also the positions of i,j and [ m ] , [ n ] . This formulation makes it possible to unify all various cases of formulas ( 3.35 ) by using empty matrices.
```
  FIX: ```
In the above, notice the difference of \( p \) and \( P \), and also the positions of \( i,j \) and \( [m], [n] \). This formulation makes it possible to unify all various cases of formulas (3.35) by using empty matrices.
```
- RAW: ```
We cite the following from ( Asashiba et al. 2024 , Lemma 4.8) including its proof for the convenience of the reader. For any C,M ∈ mod A , the following lemma makes it possible to compute the dimension of Hom A ( C,M ) by using a projective presentation of C and the module structure of M . Later we will mainly apply this to the case where C is a term of the almost split sequence starting from an interval module V I for some I ∈ I .
```
  FIX: ```
We cite the following from (Asashiba et al. 2024, Lemma 4.8) including its proof for the convenience of the reader. For any \( C, M \in \operatorname{mod} A \), the following lemma makes it possible to compute the dimension of \( \operatorname{Hom}_A(C,M) \) by using a projective presentation of \( C \) and the module structure of \( M \). Later we will mainly apply this to the case where \( C \) is a term of the almost split sequence starting from an interval module \( V_I \) for some \( I \in \mathcal{I} \).
```
- RAW: ```
Lemma 2.10. Let C,M ∈ mod A . Assume that C has a projective presentation
```
  FIX: ```
**Lemma 2.10.** Let \( C, M \in \operatorname{mod} A \). Assume that \( C \) has a projective presentation
```
- RAW: ```
for some x 1 ,x 2 ...,x m ,y 1 ,y 2 ,...,y n ∈ P , and µ : = a ji P y j ,x i ( i,j ) ∈ [ m ] × [ n ] with a ji ∈ k , (( i,j ) ∈ [ m ] × [ n ]) . Then we have
```
  FIX: ```
for some \( x_1, x_2, \dots, x_m, y_1, y_2, \dots, y_n \in P \), and \( \mu \coloneqq [a_{ji} P_{y_j, x_i}]_{(i,j) \in [m] \times [n]} \) with \( a_{ji} \in k \) (\( (i,j) \in [m] \times [n] \)). Then we have
```
- RAW: ```
Proof Set Y : = j ∈ [ n ] P y j , X : = i ∈ [ m ] P x i for short. Then we have an exact sequence Y µ −→ X ε −→ C → 0 , which yields an exact sequence
```
  FIX: ```
*Proof.* Set \( Y \coloneqq \bigoplus_{j \in [n]} P_{y_j} \), \( X \coloneqq \bigoplus_{i \in [m]} P_{x_i} \) for short. Then we have an exact sequence \( Y \xrightarrow{\mu} X \xrightarrow{\varepsilon} C \to 0 \), which yields an exact sequence
```
