# Manifest: Page 031

## REPAIR_MATH
- RAW: ```
\uparrow I & = [ \{ a _ { 1 } , \dots , a _ { k } \} , \omega ] , \ \uparrow I = [ \{ a _ { 1 } ^ { \prime } , \dots , a _ { k ^ { \prime } } ^ { \prime } \} , \omega ] , \ \text {and} \\ \downarrow I & = [ 0 , \{ b _ { 1 } , \dots , b _ { l } \} ] , \ \downarrow I = [ 0 , \{ b _ { 1 } ^ { \prime } , \dots , b _ { l ^ { \prime } } ^ { \prime } \} ] .
```
  FIX: ```
$$
\uparrow I & = [ \{ a _ { 1 } , \dots , a _ { k } \} , \omega ] , \ \uparrow I = [ \{ a _ { 1 } ^ { \prime } , \dots , a _ { k ^ { \prime } } ^ { \prime } \} , \omega ] , \ \text {and} \\ \downarrow I & = [ 0 , \{ b _ { 1 } , \dots , b _ { l } \} ] , \ \downarrow I = [ 0 , \{ b _ { 1 } ^ { \prime } , \dots , b _ { l ^ { \prime } } ^ { \prime } \} ] .
$$
```
- RAW: ```
& s c _ { 1 } ^ { \circ } ( I ) = \{ a _ { i , i + 1 } \colon = a _ { i } \vee a _ { i + 1 } \, | \, i = 1 , \dots , k - 1 \} , \text { and } \\ & s k _ { 1 } ^ { \circ } ( I ) = \{ b _ { i , i + 1 } \colon = b _ { i } \wedge b _ { i + 1 } \, | \, i = 1 \dots , l - 1 \} .
```
  FIX: ```
$$
& s c _ { 1 } ^ { \circ } ( I ) = \{ a _ { i , i + 1 } \colon = a _ { i } \vee a _ { i + 1 } \, | \, i = 1 , \dots , k - 1 \} , \text { and } \\ & s k _ { 1 } ^ { \circ } ( I ) = \{ b _ { i , i + 1 } \colon = b _ { i } \wedge b _ { i + 1 } \, | \, i = 1 \dots , l - 1 \} .
$$
```
- RAW: ```
P _ { s c _ { 1 } ^ { \circ } ( U ) } \xrightarrow { \varepsilon _ { 1 } ^ { U } } P _ { s c ( U ) } \xrightarrow { \varepsilon _ { 0 } ^ { U } } V _ { U } \to 0 ,
```
  FIX: ```
$$
P _ { s c _ { 1 } ^ { \circ } ( U ) } \xrightarrow { \varepsilon _ { 1 } ^ { U } } P _ { s c ( U ) } \xrightarrow { \varepsilon _ { 0 } ^ { U } } V _ { U } \to 0 ,
$$
```
- RAW: ```
\varepsilon _ { 1 } ^ { U } \coloneqq \begin{bmatrix} P _ { a _ { 1 2 } , a _ { 1 } } & & & \\ - P _ { a _ { 1 2 } , a _ { 2 } } & P _ { a _ { 2 3 } , a _ { 2 } } & & \\ & & - P _ { a _ { 2 3 } , a _ { 3 } } & \ddots & \\ & & & & \ddots & P _ { a _ { k - 1 , k } , a _ { k - 1 } } \\ & & & & & - P _ { a _ { k - 1 , k } , a _ { k } } \end{bmatrix} ( b lank entries are zeros). \quad ( 3 . 3 8 )
```
  FIX: ```
$$
\varepsilon _ { 1 } ^ { U } \coloneqq \begin{bmatrix} P _ { a _ { 1 2 } , a _ { 1 } } & & & \\ - P _ { a _ { 1 2 } , a _ { 2 } } & P _ { a _ { 2 3 } , a _ { 2 } } & & \\ & & - P _ { a _ { 2 3 } , a _ { 3 } } & \ddots & \\ & & & & \ddots & P _ { a _ { k - 1 , k } , a _ { k - 1 } } \\ & & & & & - P _ { a _ { k - 1 , k } , a _ { k } } \end{bmatrix} ( b lank entries are zeros). \quad ( 3 . 3 8 )
$$
```



## REPAIR_PROSE
- RAW: `⇑ I, ⇓ I ). Throughout this subsection, we always assume that if ( x i ,y i ) is the coordinate of a i in G m,n for each i ∈ [ k ] , then i < j implies y i < y j , and the same for a ′ i , b i , and b ′ i . Then we have`
  FIX: `\( \Uparrow I, \Downarrow I \) ). Throughout this subsection, we always assume that if \( ( x_i , y_i ) \) is the coordinate of \( a_i \) in \( G_{m,n} \) for each \( i \in [k] \), then \( i < j \) implies \( y_i < y_j \), and the same for \( a'_i \), \( b_i \), and \( b'_i \). Then we have`
- RAW: `We note that sc ◦ 1 ( I ) ⊆ sc 1 ( I ) and sk ◦ 1 ( I ) ⊆ sk 1 ( I ) .`
  FIX: `We note that \( sc_1^\circ(I) \subseteq sc_1(I) \) and \( sk_1^\circ(I) \subseteq sk_1(I) \).`
- RAW: `With these notations, we have a specialization of Theorem 3.27 . However, before stating this, we give the minimal projective presentations of V I , τ − 1 V I , and the middle term E of the almost split sequence starting from V I without proofs (for the two latter modules, V I is assumed to be non-injective.) because in the general case, we did not give them. We restate ( Asashiba et al. 2022 , Proposition 39) under these notations as follows.`
  FIX: `With these notations, we have a specialization of Theorem 3.27. However, before stating this, we give the minimal projective presentations of \( V_I \), \( \tau^{-1} V_I \), and the middle term \( E \) of the almost split sequence starting from \( V_I \) without proofs (for the two latter modules, \( V_I \) is assumed to be non-injective) because in the general case, we did not give them. We restate (Asashiba et al. 2022, Proposition 39) under these notations as follows.`
- RAW: `Lemma 3.29. Let U be an up-set. Then the interval module V U has the following minimal projective presentation:`
  FIX: `Lemma 3.29. Let \( U \) be an up-set. Then the interval module \( V_U \) has the following minimal projective presentation:`
- RAW: `where ε U 0 = ρ U 1 a a ∈ sc( U ) and`
  FIX: `where \( \varepsilon_0^U = [ \rho_{1a}^U ]_{a \in sc(U)} \) and`
- RAW: `Remark 3.30. We note the reader here that some columns are missing compared with ( 3.15 ) because the above projective presentation is minimal in the 2D-grid setting and the missing columns are eliminated by a sequence of fundamental column operations. We refer the reader to ( Asashiba et al. 2024 , Remark 5.27, Lemma 5.28) for the detailed explanations.`
  FIX: `Remark 3.30. We note the reader here that some columns are missing compared with (3.15) because the above projective presentation is minimal in the 2D-grid setting and the missing columns are eliminated by a sequence of fundamental column operations. We refer the reader to (Asashiba et al. 2024, Remark 5.27, Lemma 5.28) for the detailed explanations.`
- RAW: `This together with the presentation of the up-set ⇑ I gives the following (see ( Asashiba et al. 2022 , Proposition 41)).`
  FIX: `This together with the presentation of the up-set \( \Uparrow I \) gives the following (see (Asashiba et al. 2022, Proposition 41)).`
