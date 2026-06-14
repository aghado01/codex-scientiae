[Page 59]

Notation 5.10. Let α : ( x i ) i ∈ [ m ] → ( y j ) j ∈ [ n ] be a morphism in A . Then there exists a unique matrix [ a ji ] ( j,i ) ∈ [ n ] × [ m ] over k such that

$$
\alpha \coloneqq [ a _ { j i } p _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } ,
$$

where a ji = 0 unless x i ≤ y j in P . In this case, for each u ∈ P , we also have

$$
P ( \alpha ) & = t ^ { \ } [ a _ { j i } P _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } , \\ P ^ { \prime } ( \alpha ) & = [ a _ { j i } P ^ { \prime } ( p _ { y _ { j } , x _ { i } } ) ( u ) ] _ { ( j , i ) \in [ n ] \times [ m ] } , \\ P _ { u } ^ { \prime } ( \alpha ) & = t ^ { \ } [ a _ { j i } P _ { u } ^ { \prime } ( p _ { y _ { j } , x _ { i } } ) ] _ { ( j , i ) \in [ n ] \times [ m ] } .
$$

We then set

$$
\text {Mat} ( \alpha ) \colon = [ a _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } , \quad \text {Mat} ( P ( \alpha ) ) \colon = ^ { t } [ a _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } , \\ \text {Mat} ( P ^ { \prime } ( \alpha ) ( u ) ) \colon = [ a _ { j i } ^ { \prime } ] _ { ( j , i ) \in [ n ] \times [ m ] } , \quad \text {Mat} ( P _ { u } ^ { \prime } ( \alpha ) ) \colon = ^ { t } [ a _ { j i } ^ { \prime \prime } ] _ { ( j , i ) \in [ n ] \times [ m ] } ,
$$

where

$$
a _ { j i } ^ { \prime } \colon = \begin{cases} a _ { j i } & \text {if } P ^ { \prime } ( p _ { y _ { j } , x _ { i } } ) ( u ) \neq 0 , \\ 0 & \text {otherwise} \end{cases} , \quad a _ { j i } ^ { \prime \prime } \colon = \begin{cases} a _ { j i } & \text {if } P _ { u } ^ { \prime } ( p _ { y _ { j } , x _ { i } } ) \neq 0 , \\ 0 & \text {otherwise} \end{cases}
$$



for all ( j,i ) ∈ [ n ] × [ m ] , and call each of them the coefficient matrix of α , P ( α ) , P ′ ( α )( u ) , and P ′ u ( α ) , respectively.

Proposition 5.11. Let P = ( P , ≤ ) be a poset, I an interval of P , and M ∈ mod A . Suppose that P ( α ) is a presentation matrix of M for some morphism α : ( x i ) i ∈ [ m ] → ( y j ) j ∈ [ n ] in A as in Theorem 5.1 , and g t : ( z j ) j ∈ [ s ] → ( w i ) i ∈ [ r ] ( t = 1 , 2 , 3) is a nonzero block of the multiplicity matrix for I . Set the coefficient matrices of g t and of P ( α ) as follows:

$$
z _ { 1 } & = \cdots \quad z _ { s } & y _ { 1 } & \cdots \quad y _ { n } \\ \quad & w _ { 1 } \left [ g _ { t } ^ { ( 1 ) } \left | \cdots \right | g _ { t } ^ { ( s ) } \right ] , \text { and } \text {Mat} ( P ( \alpha ) ) \coloneqq \colon \begin{array} { c } x _ { 1 } \\ x _ { 1 } \\ a ^ { ( 1 ) } \end{array} \left | \cdots \right | a ^ { ( n ) } \right ] \\ \intertext { a s r o w v e c tors s o n s i s t i n g o f c u m m v e c t o r s }
$$

as row vectors consisting of column vectors. m

Then P ′ ( g t ) ( x i ) i ∈ [ m ] = i =1 P ′ ( g t )( x i ) is a diagonal block matrix, where for each i ∈ [ m ] , the i th block P ′ ( g t )( x i ) has the following coefficient matrix:

$$
\left \lceil \delta _ { ( x _ { i } \leq z _ { 1 } ) } \cdot g _ { t } ^ { ( 1 ) } \right \rceil \cdots \left | \delta _ { ( x _ { i } \leq z _ { s } ) } \cdot g _ { t } ^ { ( s ) } \right \rceil .
$$
