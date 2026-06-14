[Page 62]

Lemma 5.13. Let \( C,M \in \text{mod}\, A \). Assume that \( M \) has an injective copresentation

$$
0 \to M \xrightarrow { \sigma } \mathbb { Q } ( x ^ { \prime } ) \xrightarrow { \mathbb { Q } ( \alpha ^ { \prime } ) } \mathbb { Q } ( y ^ { \prime } )
$$

for some \( \alpha' : y' \to x' \) in \( A \), where \( x' = (x'_i)_{i \in [m']} \) for some \( m' \). Then we have

$$
\dim H o m _ { A } ( C , M ) = \sum _ { i \in [ m ^ { \prime } ] } \dim C ( x _ { i } ^ { \prime } ) - \text {rank} \, C ( \alpha ^ { \prime } ) .
$$

Proof From ( 5.80 ), we have the following projective presentation of \( DM \):

$$
P ^ { \prime } ( y ^ { \prime } ) \xrightarrow { P ^ { \prime } ( \alpha ^ { \prime } ) } P ^ { \prime } ( x ^ { \prime } ) \xrightarrow { D \sigma } D M \to 0 .
$$

Then by Lemma 2.10, we have

$$
\dim H o p ( D M , D C ) = \sum _ { i \in [ m ^ { \prime } ] } \dim ( D C ) ( x _ { i } ^ { \prime } ) - \text {rank} ( D C ) ( \alpha ^ { \prime } ) ,
$$

which shows ( 5.81 ) because \( \dim \text{Hom}_{A^{\text{op}}} ( DM, DC ) = \dim \text{Hom}_A ( C, M ) \), \( \dim( DC )( x'_i ) = \dim C ( x'_i ) \) for all \( i \in [ m ] \), and \( \dim( DC )( \alpha' ) = \dim C ( \alpha' ) \). □

For convenience, \( \mathbb{Q}( \alpha' ) \) in ( 5.80 ) is called a copresentation matrix of \( M \).

Theorem 5.14. Let \( M \in \text{mod}\, A \) and \( I \) an interval of \( P \), and assume that \( M \) has an injective copresentation ( 5.80 ) for some morphism \( \alpha' : y' \to x' \) in \( A \), where we set \( x' := (x'_i)_{i \in [m']} \), \( y' := (y'_j)_{j \in [n']} \). Case 1:

\( V_I \) is non-injective. In this case, let

$$
0 \to V _ { I } \to E \to \tau ^ { - 1 } V _ { I } \to 0
$$

be an almost split sequence starting from \( V_I \). Then we have the following formula:

$$
d _ { M } ( V _ { I } ) = \text {rank} \, E ( \alpha ^ { \prime } ) - \text {rank} \, V _ { I } ( \alpha ^ { \prime } ) - \text {rank} \, ( \tau ^ { - 1 } V _ { I } ) ( \alpha ^ { \prime } ) .
$$

Case 2: \( V_I \) is injective. In this case, \( I = \downarrow a \) with \( a = \max I \) and \( V_I \cong Q_a \). We may set \( \alpha' = [\alpha'_{ji}]_{(j,i) \in [n'] \times [m']} \), where \( \alpha'_{ji} = a'_{ji} p_{y_j,x_i} \) for some \( a'_{ji} \in k \) and \( \alpha'_{ji} = a'_{ji} = 0 \) unless \( x_i \leq y_j \) for all \( (j,i) \in [n'] \times [m'] \). We set \( n'_{M,I} := \# \{ i \in [m'] \mid x_i = x \} \). Then we have the following formula.

$$
d _ { M } ( V _ { I } ) & = \text {rank} ( V _ { \downarrow b } / V _ { \{ b \} } ) ( \alpha ^ { \prime } ) - \text {rank} \, V _ { \downarrow b } ( \alpha ^ { \prime } ) + \sum _ { i \in [ m ] } \dim V _ { \{ b \} } ( x _ { i } ) \\ & = \text {rank} [ \delta _ { ( a > x _ { i } , y _ { j } ) } a ^ { \prime } _ { j i } ] _ { ( j , i ) \in [ n ^ { \prime } ] \times [ m ^ { \prime } ] } - \text {rank} [ \delta _ { ( a \geq x _ { i } , y _ { j } ) } a ^ { \prime } _ { j i } ] _ { ( j , i ) \in [ n ^ { \prime } ] \times [ m ^ { \prime } ] } + n ^ { \prime } _ { M , I } .
$$

Proof This is proved in the same way as the proof of Theorem 5.1. □
