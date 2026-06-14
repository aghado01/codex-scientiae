[Page 46]

Similarly, the Yoneda embedding Y A : A → prj( A op ) , x  → P ′ x : = A (,x ) extends to an equivalence P ′ : A → prj A op , ( x i ) i ∈ [ m ]  → i ∈ [ m ] P ′ x i .

Definition 4.5. Let I be an interval of P . Choose any choice maps c : sc( ⇑ I ) → sc( I ) and d : sk( ⇓ I ) → sk( I ) , and set ε 1 : = ε 1 ( c ) , π 1 : = π 1 ( d ) as in Propositions 3.18 and 3.23 . Choose also any ( b,a ) ∈ sk( I ) × sc( I ) such that b ≥ a , and set λ : = λ ( b,a ) as in Proposition 3.24 . Then by Corollary 4.4 , there exists a unique triple ( g 1 , g 2 , g 3 ) of morphisms in k [ P ] such that

$$
P ( g _ { 1 } ) = ^ { t } \varepsilon _ { 1 } , \, P ( g _ { 2 } ) = ^ { t } \pi _ { 1 } , \, \text { and } \, P ( g _ { 3 } ) = ^ { t } \lambda .
$$

We set

$$
g ( c , d , ( b , a ) ) \colon = \left [ \frac { g _ { 1 } } { g _ { 3 } } \Big | _ { g _ { 2 } } \right ] .
$$

3 The following are the explicit forms of g 1 , g 2 , g 3 :

$$
g _ { 1 } \colon = \begin{bmatrix} \hat { p } _ { a , a _ { c } } \end{bmatrix} _ { ( a _ { c } , a ) \in \text{sc} _ { 1 } ( I ) \times \text{sc} ( I ) }
$$

with the entries given by

$$
\tilde { p } _ { a , a _ { c } } \colon = \begin{cases} p _ { c , a } & ( a = \underline { a } ) , \\ - p _ { c , a } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{cases}
$$

for all a c ∈ sc 1 ( I ) and a ∈ sc( I ) ; and

$$
g _ { 2 } \coloneqq \left [ \left [ \delta _ { b , d ( b ^ { \prime } ) } p _ { d ( b ^ { \prime } ) , b ^ { \prime } } \right ] _ { ( b , b ^ { \prime } ) \in \text {sk} ( I ) \times \text {sk} ( \downarrow I ) } , \, \left [ \hat { p } _ { b , b _ { d } } \right ] _ { ( b _ { d } , b ) \in \text {sk} ( I ) \times \text {sk} _ { 1 } ( I ) } \right ] ,
$$

with the entries given by

$$
\hat { p } _ { b , b _ { a } } \coloneqq \begin{cases} p _ { b , d } & ( b = \underline { b } ) , \\ - p _ { b , d } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{cases}
$$

for all b ∈ sk( I ) and b d ∈ sk 1 ( I ) ; and g 3 is the block matrix with the size sk( I ) × sc( I ) , the ( b,a ) -entry of g 3 , given by p b,a , is the only non-zero entry.

Notation 4.6. Let B be a linear category, W a B -module, and m,n positive integers, and consider a morphism g = g ji ( j,i ) ∈ [ n ] × [ m ] : ( x i ) i ∈ [ m ] → ( y j ) j ∈ [ n ] in B . Then by applying the convention in Proposition 4.3 in the case where C = mod k , we write

$$
W ( g ) \coloneqq \hat { W } ( g ) = \left [ W ( g _ { i j } ) \right ] _ { j , i } \colon \bigoplus _ { i \in [ m ] } W ( x _ { i } ) \to \bigoplus _ { j \in [ n ] } W ( y _ { j } ) .
$$

By Definition 4.5 and Notation 4.6 , Theorem 3.27 can be restated as follows.
