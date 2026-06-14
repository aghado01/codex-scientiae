[Page 43]

The source code implementing the computational procedures used in this study is publicly available via a GitHub repository at https://github.com/Enhao-Liu/interval-replacement.

# 4 Essential cover

In the previous section, Theorem 3.27 provides a general and explicit formula for computing the interval multiplicity in theory, taking the persistence module as the input. Nevertheless, the persistence module is usually latent in practical analysis and hard to obtain in most situations. Thus, how to compute some algebraically defined invariants (for example, the interval rank invariant and interval multiplicity) directly from the given filtration over \( P \), without computing the persistent homology in advance, becomes a critical problem to be solved from the TDA perspective. This is also the key step to bringing our theory to the ground of applications. For this reason, we will introduce a potential technique in this section to achieve the purpose.

We first introduce the following notion to consider matrices with entries morphisms in a linear category in a natural way.

Definition 4.1. (1) For each linear category \( B \), a linear category \( \bigoplus B \), called the formal additive hull of \( B \), is defined as follows:

Objects. The set of objects is given by

\[
( \bigoplus B ) _ { 0 } \colon = \{ ( x _ { i } ) _ { i \in [ l ] } = ( x _ { 1 } , \dots , x _ { l } ) \ | \ x _ { 1 } , \dots , x _ { l } \in B _ { 0 } , \, l \geq 0 \} .
\]

Note that if \( l = 0 \) above, then \( [ l ] = \emptyset \), and \( ( x _ { i } ) _ { i \in [ l ] } \) is an empty sequence \( () \). For each \( x = ( x _ { i } ) _ { i \in [ l ] } \in ( \bigoplus B ) _ { 0 } \), we set \( | x | \colon = l \), and call it the size of \( x \).

Morphisms. For any \( x , y \in ( \bigoplus B ) _ { 0 } \) with \( x = ( x _ { i } ) _ { i \in [ l ] } \), \( y = ( y _ { j } ) _ { j \in [ m ] } \) the set of morphisms from \( x \) to \( y \) is defined by setting

\[
( \bigoplus B ) ( x , y ) \colon = \{ \, [ \alpha _ { j i } ] _ { ( j , i ) \in [ m ] \times [ l ] } \, | \, \alpha _ { j i } \in B ( x _ { i } , y _ { j } ) \text { for all } ( j , i ) \in [ m ] \times [ l ] \} ,
\]

where \( [ \alpha _ { j i } ] _ { ( j , i ) \in [ m ] \times [ l ] } \) is a matrix of size \( ( m , l ) \), which is defined to be the triple \( ( m , l , ( \alpha _ { j i } ) _ { ( j , i ) \in [ m ] \times [ l ] } ) \) of integers \( l , m \geq 0 \) and a family of morphisms \( \alpha _ { j i } \in B ( x _ { i } , y _ { j } ) \).
