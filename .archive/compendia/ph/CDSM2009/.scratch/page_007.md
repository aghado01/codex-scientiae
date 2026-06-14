[Page 7]

It is not difficult to notice that the transformation in terms of critical values between extended and levelset zigzag persistence as stated in Table 1 preserves stability, and we get the following result.

LZZ Stability Theorem . Given two (Morse type) functions f : X → R and g : X → R with δ = f − g ∞ , let DgmZZ p ( f ) and DgmZZ p ( g ) be the p -dimensional persistence diagrams of the levelset zigzags of f and g . Then

$$
$$
d _ { B } ( D g m Z Z _ { p } ( f ) , D g m Z Z _ { p } ( g ) ) \leq \delta .
$$
$$

Proof. As [7] points out, the Stability Theorem for extended persistence can be strengthened to apply to each subdiagram individually,

$$
$$
\begin{array} { r l r } { d _ { B } ( O r d _ { p } ( f ) , O r d _ { p } ( g ) ) } & { \leq } & { \delta , } \\ { d _ { B } ( R e l _ { p } ( f ) , R e l _ { p } ( g ) ) } & { \leq } & { \delta , } \\ { d _ { B } ( E x t _ { p } ( f ) , E x t _ { p } ( g ) ) } & { \leq } & { \delta . } \end{array}
$$
$$

This observation together with the transformation in Table 1 immediately tell us that the pairs in the levelset zigzag corresponding to ordinary and relative subdiagrams are stable. A point in the extended subdiagram could create a problem if it were to switch from Type III to Type IV in Table 1 (i.e. if it were to cross the diagonal) since it would map to a point of different dimension in the level zigzag. However, in this case it would mean that the point was close to the diagonal, and all the involved points (both in the extended persistence and levelset zigzag diagrams) can be paired with the points on the diagonal. Therefore, the transformation from extended to levelset zigzag persistence preserves stability.  

# 4. ALGORITHM

In practice, real-valued functions are represented by functions on simplicial complexes. Therefore, we are interested in finding an algorithm for the following setting. We are given a sequence of simplicial complexes

$$
$$
\emptyset = K _ { 0 } \leftrightarrow K _ { 1 } \leftrightarrow \dots \leftrightarrow K _ { n } ,
$$
$$

where arrows ↔ represent inclusions of either the form K i ⊂ K i +1 or K i ⊃ K i +1 . Furthermore, we assume that every two consecutive complexes differ by a single simplex, i.e. either K i +1 = K i ∪ σ i +1 or K i = K i +1 ∪ σ i +1 . Thus the sequence of complexes represents a sequence of simplex additions and removals. Our goal is to compute zigzag persistence for the sequence of homology groups over a field k

$$
$$
H ( K _ { 0 } ) \leftrightarrow H ( K _ { 1 } ) \leftrightarrow \dots \leftrightarrow H ( K _ { n } ) ,
$$
$$

where the connecting homomorphisms are induced by inclusion.

We adapt the interval decomposition algorithm of [3] to our setting. We proceed by maintaining the right filtration R and the birth vector b as defined in [3]. We briefly review the two concepts, both of which are defined inductively. For n = 1, R n = (0 , H ( K 1 )) , b n = (1). Given the right filtration R i = ( R 0 i , R 1 i , . . . , R i i ) and the birth vector b i = ( b 1 i , b 2 i , . . . , b i i ), we extend them to the right filtration R i +1 and vector b i +1 .

$$
$$
\text {If} \quad H ( K _ { i } ) \stackrel { f _ { i } } { \rightarrow } H ( K _ { i + 1 } ) , \\ \text {then} \quad & \mathcal { R } _ { i + 1 } = \left ( f _ { i } ( R _ { i } ^ { 0 } ) , f _ { i } ( R _ { i } ^ { 1 } ) , \dots , f _ { i } ( R _ { i } ^ { i } ) , H ( K _ { i + 1 } ) \right ) \\ & b _ { i + 1 } = ( b _ { i } ^ { 1 } , \dots , b _ { i } ^ { i } , i + 1 ) .
$$
$$

$$
$$
\text {If} \quad H ( K _ { i } ) \stackrel { g _ { i } } { \leftarrow } H ( K _ { i + 1 } ) , \\ \text {then} \quad & R _ { i + 1 } = ( 0 , g _ { i } ^ { - 1 } ( R ^ { 0 } _ { i } ) , g _ { i } ^ { - 1 } ( R ^ { 1 } _ { i } ) , \dots , g _ { i } ^ { - 1 } ( R ^ { i } _ { i } ) ) \\ & b _ { i + 1 } = ( i + 1 , b _ { i } ^ { 1 } , \dots , b _ { i } ^ { i } ) .
$$
$$

We observe that f i ( R 0 i ) = 0, g − 1 i ( R 0 i ) = Ker g i , g − 1 i ( R i i ) = H ( K i +1 ).

Denoting by dim the sequence of dimensions of the quotients R j +1 i / R j i of a filtered vector space R i , dim( R i ) = (dim( R 0 i ) , dim( R 1 i / R 0 i ) , dim( R 2 i / R 1 i ) , . . . ), we write

$$
$$
( c _ { i } ^ { 0 } , \dots , c _ { i } ^ { i } ) = \dim ( \mathcal { R } _ { i } \cap K e r \, f _ { i } ) ,
$$
$$

in case of map f i ; and

$$
$$
( c _ { i } ^ { 0 } , \dots , c _ { i } ^ { i } ) = \dim ( C o k \, g _ { i } ) = \dim ( \mathcal { R } _ { i } ) - \dim ( \mathcal { R } _ { i } \cap \text {Im} \, g _ { i } ) ,
$$
$$

in case of map g i . The persistence intervals of the zigzag module are intervals ( b i ( k ) , i ) counted with multiplicity c k i [3].

To construct an algorithm for a sequence of homology groups, we maintain a representation of the right filtration R i and the birth vector b i . At stage i of the algorithm, we want to update our representation of the two objects, and output intervals that terminate at i .

Henceforth we work with matrices with entries in a fixed field k . We represent the right filtration R i using three matrices Z i , B i , and C i . We denote the boundary matrix of complex K i by D i . Matrix Z i forms a basis for the cycles of K i ; matrix B i stores a basis for the linear combinations of the cycles that are boundaries; matrix C i stores the chains whose boundaries are given by the product Z i B i . The matrices are related by the equality Z i B i = D i C i .

We associate with each column of Z i an index idx i . The space spanned by the columns with idx i not exceeding k represents a basis for the subgroups R k i of the homology group R i i = H ( K i ). Denoting this space with Z j i where j = max idx − 1 i ([1 , k ]), we have

$$
$$
R _ { i } ^ { k } = \span \left ( \{ z + B \ | \ z \in Z _ { i } ^ { j } \text { and } B = \span ( Z _ { i } B _ { i } ) \} \right ) .
$$
$$

This index is a purely analytical tool; it is not necessary to maintain it explicitly during the actual computation.

The rows and columns of the boundary matrix D i as well as the rows of matrices Z i and C i correspond to the individual simplices of the complex K i , and are ordered by their most recent appearance in the zigzag module. For convenience, we make no distinction between a column of matrix Z i or C i and the chain it represents. We say that a simplex σ belongs to the cycle Z i [ j ] if the row of σ in column j of Z i contains a non-zero element. Similar to [9], we denote by low the map from a column of a matrix to the index of the row of the lowest non-zero element in that column, and say that a matrix is reduced if the map is injective. The matrices Z i and B i remain reduced throughout the algorithm.

In notation of [9] matrices Z i and C i correspond to matrix V . The principal difference from the ordinary persistence computation is that these matrices are no longer guaranteed to be upper triangular.

We describe what happens in case we add a simplex (function f i ), and remove a simplex (function g i ).
