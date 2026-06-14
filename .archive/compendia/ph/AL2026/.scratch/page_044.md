[Page 44]

Note that if \( l = 0 \), then \( x = () \), and we have

\[
( \bigoplus B ) ( ( ) , y ) = \{ J _ { m , 0 } \} ,
\]

where we set \( J _ { m , 0 } \coloneqq ( m , 0 , () ) \); if \( m = 0 \), then \( y = () \), and we have

\[
( \bigoplus B ) ( x , ( ) ) = \{ J _ { 0 , l } \} ,
\]

where we set \( J _ { 0 , l } \coloneqq ( 0 , l , () ) \). In particular, we have \( ( \bigoplus B ) ( () , () ) = \{ J _ { 0 , 0 } \} \), where \( J _ { 0 , 0 } = ( 0 , 0 , () ) \). The matrices \( J _ { m , 0 } \), \( J _ { 0 , l } \), \( J _ { 0 , 0 } \) are called the empty matrices of size \( ( m , 0 ) \), \( ( 0 , l ) \), \( ( 0 , 0 ) \), respectively. We give a structure of a vector space to \( ( \bigoplus B ) ( x , y ) \) by the usual addition and scalar multiplication of matrices. In particular, if \( l = 0 \) or \( m = 0 \), then \( ( \bigoplus B ) ( x , y ) \) becomes a trivial vector space.

Composition. For any \( x , y , z \in ( \bigoplus B ) _ 0 \) with \( x = ( x _ i ) _ { i \in [ l ] } \), \( y = ( y _ j ) _ { j \in [ m ] } \), \( z = ( z _ k ) _ { k \in [ n ] } \), the composition

\[
( \bigoplus B ) ( y , z ) \times ( \bigoplus B ) ( x , y ) \to ( \bigoplus B ) ( x , z ) , \ ( \beta , \alpha ) \mapsto \beta \cdot \alpha
\]

is defined by the usual matrix multiplication

\[
[ \beta _ { k j } ] _ { ( k , j ) \in [ n ] \times [ m ] } \cdot [ \alpha _ { j i } ] _ { ( j , i ) \in [ m ] \times [ l ] } \coloneqq [ \sum _ { j \in [ m ] } \beta _ { k j } \alpha _ { j i } ] _ { ( k , i ) \in [ n ] \times [ l ] }
\]

for all \( \alpha = [ \alpha _ { j i } ] _ { ( j , i ) \in [ m ] \times [ l ] } \) and \( \beta = [ \beta _ { k j } ] _ { ( k , j ) \in [ n ] \times [ m ] } \). In particular, if \( l = 0 \), then \( \beta \cdot J _ { m , 0 } = J _ { n , 0 } \); if \( m = 0 \), then \( J _ { n , 0 } \cdot J _ { 0 , l } = ( l , n , ( 0 ) _ { ( k , i ) \in [ n ] \times [ l ] } ) = 0 _ { n , l } \); and if \( n = 0 \), then \( J _ { 0 , m } \cdot \alpha = J _ { 0 , l } \). Thus if morphisms \( \beta \), \( \alpha \) have size \( ( k , p ) \), \( ( q , l ) \) with \( k , l , p , q \ge 0 \), respectively, and the composite \( \beta \cdot \alpha \) is defined, then \( p = q \), and the size of \( \beta \cdot \alpha \) is \( ( k , l ) \) as in the case of usual matrix multiplication.

As easily seen, \( \bigoplus B \) is a linear category. Note that equalities (4.53) and (4.54) show that \( () \) is a zero object in \( \bigoplus B \). Moreover, we have

\[
\begin{align*}
( x _ { i } ) _ { i \in [ m ] } & \simeq ( x _ { 1 } ) \oplus \dots \oplus ( x _ { m } ) , \\
( x _ { i } ) _ { i \in [ m ] } \oplus ( y _ { j } ) _ { j \in [ n ] } & \simeq ( x _ { 1 } , \dots , x _ { n } , y _ { 1 } , \dots , y _ { n } ) , \text { and } \\
( x _ { 1 } ) \oplus \dots \oplus ( x _ { m } ) & \simeq ( x _ { 1 } \oplus \dots \oplus x _ { m } ) \text { if } x _ { 1 } \oplus \dots \oplus x _ { m } \text { exists in } B
\end{align*}
\]

for all \( x _ 1 , \dots , x _ m , y _ 1 , \dots , y _ n \in B _ 0 \). Thus \( B \) turns out to be an additive category.

We regard \( B \) as a full subcategory of \( \bigoplus B \) by the embedding \( ( f \colon x \to y ) \mapsto ( f \colon ( x ) \to ( y ) ) \) for all morphisms \( f \) in \( B \). In the sequel, we will frequently consider the case where \( B = k [ S ] \) for a finite poset \( S \).

Note that if \( B \) is additive, then we have an equivalence \( \eta _ B \colon \bigoplus B \to B \) that sends \( ( x _ i ) _ { i \in [ m ] } \) to \( \bigoplus _ { i \in [ m ] } x _ i \), and each morphism

\[
[ \alpha _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } \colon ( x _ { i } ) _ { i \in [ m ] } \to ( y _ { j } ) _ { j \in [ n ] }
\]
