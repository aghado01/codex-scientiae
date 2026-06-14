# Manifest: Page 007

## REPAIR_PROSE
- RAW: `diﬃcult`
  FIX: `difficult`
- RAW: `diﬀerent`
  FIX: `different`
- RAW: `ﬁnding`
  FIX: `finding`
- RAW: `diﬀer`
  FIX: `differ`
- RAW: `ﬁeld`
  FIX: `field`
- RAW: `ﬁltration`
  FIX: `filtration`
- RAW: `deﬁned`
  FIX: `defined`
- RAW: `brieﬂy`
  FIX: `briefly`
- RAW: `ﬁltered`
  FIX: `filtered`
- RAW: `ﬁxed`
  FIX: `fixed`
- RAW: `diﬀerence`
  FIX: `difference`

## REPAIR_MATH
- RAW: `functions f : X → R and g : X → R with δ = f − g ∞ , let DgmZZ p ( f ) and DgmZZ p ( g ) be the p -dimensional persistence diagrams of the levelset zigzags of f and g .`
  FIX: `functions \( f : X \to \mathbb{R} \) and \( g : X \to \mathbb{R} \) with \( \delta = \lVert f - g \rVert_\infty \), let \( \text{DgmZZ}_p(f) \) and \( \text{DgmZZ}_p(g) \) be the \( p \)-dimensional persistence diagrams of the levelset zigzags of \( f \) and \( g \).`
- RAW: `where arrows ↔ represent inclusions of either the form K i ⊂ K i +1 or K i ⊃ K i +1 .`
  FIX: `where arrows \( \leftrightarrow \) represent inclusions of either the form \( K_i \subset K_{i+1} \) or \( K_i \supset K_{i+1} \).`
- RAW: `either K i +1 = K i ∪ σ i +1 or K i = K i +1 ∪ σ i +1 .`
  FIX: `either \( K_{i+1} = K_i \cup \sigma_{i+1} \) or \( K_i = K_{i+1} \cup \sigma_{i+1} \).`
- RAW: `homology groups over a ﬁeld k`
  FIX: `homology groups over a ﬁeld \( k \)`
- RAW: `maintaining the right ﬁltration R and the birth vector b as`
  FIX: `maintaining the right ﬁltration \( \mathcal{R} \) and the birth vector \( b \) as`
- RAW: `For n = 1, R n = (0 , H ( K 1 )) , b n = (1). Given the right ﬁltration R i = ( R 0 i , R 1 i , . . . , R i i ) and the birth vector b i = ( b 1 i , b 2 i , . . . , b i i ), we extend them to the right ﬁltration R i +1 and vector b i +1 .`
  FIX: `For \( n = 1 \), \( \mathcal{R}_n = (0, H(K_1)) \), \( b_n = (1) \). Given the right ﬁltration \( \mathcal{R}_i = (R_i^0, R_i^1, \dots, R_i^i) \) and the birth vector \( b_i = (b_i^1, b_i^2, \dots, b_i^i) \), we extend them to the right ﬁltration \( \mathcal{R}_{i+1} \) and vector \( b_{i+1} \).`
- RAW: `We observe that f i ( R 0 i ) = 0, g − 1 i ( R 0 i ) = Ker g i , g − 1 i ( R i i ) = H ( K i +1 ).`
  FIX: `We observe that \( f_i(R_i^0) = 0 \), \( g_i^{-1}(R_i^0) = \ker g_i \), \( g_i^{-1}(R_i^i) = H(K_{i+1}) \).`
- RAW: `Denoting by dim the sequence of dimensions of the quotients R j +1 i / R j i of a ﬁltered vector space R i , dim( R i ) = (dim( R 0 i ) , dim( R 1 i / R 0 i ) , dim( R 2 i / R 1 i ) , . . . ), we write`
  FIX: `Denoting by \( \dim \) the sequence of dimensions of the quotients \( R_i^{j+1} / R_i^j \) of a ﬁltered vector space \( \mathcal{R}_i \), \( \dim(\mathcal{R}_i) = (\dim(R_i^0), \dim(R_i^1 / R_i^0), \dim(R_i^2 / R_i^1), \dots) \), we write`
- RAW: `in case of map f i ; and`
  FIX: `in case of map \( f_i \); and`
- RAW: `in case of map g i . The persistence intervals of the zigzag module are intervals ( b i ( k ) , i ) counted with multiplicity c k i [3].`
  FIX: `in case of map \( g_i \). The persistence intervals of the zigzag module are intervals \( (b_i(k), i) \) counted with multiplicity \( c_i^k \) [3].`
- RAW: `the right ﬁltration R i and the birth vector b i . At stage i of the algorithm, we want to update our representation of the two objects, and output intervals that terminate at i .`
  FIX: `the right ﬁltration \( \mathcal{R}_i \) and the birth vector \( b_i \). At stage \( i \) of the algorithm, we want to update our representation of the two objects, and output intervals that terminate at \( i \).`
- RAW: `entries in a ﬁxed ﬁeld k . We represent the right ﬁltration R i using three matrices Z i , B i , and C i . We denote the boundary matrix of complex K i by D i . Matrix Z i forms a basis for the cycles of K i ; matrix B i stores a basis for the linear combinations of the cycles that are boundaries; matrix C i stores the chains whose boundaries are given by the product Z i B i . The matrices are related by the equality Z i B i = D i C i .`
  FIX: `entries in a ﬁxed ﬁeld \( k \). We represent the right ﬁltration \( \mathcal{R}_i \) using three matrices \( Z_i \), \( B_i \), and \( C_i \). We denote the boundary matrix of complex \( K_i \) by \( D_i \). Matrix \( Z_i \) forms a basis for the cycles of \( K_i \); matrix \( B_i \) stores a basis for the linear combinations of the cycles that are boundaries; matrix \( C_i \) stores the chains whose boundaries are given by the product \( Z_i B_i \). The matrices are related by the equality \( Z_i B_i = D_i C_i \).`
- RAW: `We associate with each column of Z i an index idx i . The space spanned by the columns with idx i not exceeding k represents a basis for the subgroups R k i of the homology group R i i = H ( K i ). Denoting this space with Z j i where j = max idx − 1 i ([1 , k ]), we have`
  FIX: `We associate with each column of \( Z_i \) an index \( \text{idx}_i \). The space spanned by the columns with \( \text{idx}_i \) not exceeding \( k \) represents a basis for the subgroups \( R_i^k \) of the homology group \( R_i^i = H(K_i) \). Denoting this space with \( Z_i^j \) where \( j = \max \text{idx}_i^{-1}([1, k]) \), we have`
- RAW: `The rows and columns of the boundary matrix D i as well as the rows of matrices Z i and C i correspond to the individual simplices of the complex K i , and are ordered by their most recent appearance in the zigzag module. For convenience, we make no distinction between a column of matrix Z i or C i and the chain it represents. We say that a simplex σ belongs to the cycle Z i [ j ] if the row of σ in column j of Z i contains a non-zero element. Similar to [9], we denote by low the map from a column of a matrix to the index of the row of the lowest non-zero element in that column, and say that a matrix is reduced if the map is injective. The matrices Z i and B i remain reduced throughout the algorithm.`
  FIX: `The rows and columns of the boundary matrix \( D_i \) as well as the rows of matrices \( Z_i \) and \( C_i \) correspond to the individual simplices of the complex \( K_i \), and are ordered by their most recent appearance in the zigzag module. For convenience, we make no distinction between a column of matrix \( Z_i \) or \( C_i \) and the chain it represents. We say that a simplex \( \sigma \) belongs to the cycle \( Z_i[j] \) if the row of \( \sigma \) in column \( j \) of \( Z_i \) contains a non-zero element. Similar to [9], we denote by \( \text{low} \) the map from a column of a matrix to the index of the row of the lowest non-zero element in that column, and say that a matrix is reduced if the map is injective. The matrices \( Z_i \) and \( B_i \) remain reduced throughout the algorithm.`
- RAW: `In notation of [9] matrices Z i and C i correspond to matrix V . The principal diﬀerence from the ordinary persistence computation is that these matrices are no longer guaranteed to be upper triangular.`
  FIX: `In notation of [9] matrices \( Z_i \) and \( C_i \) correspond to matrix \( V \). The principal diﬀerence from the ordinary persistence computation is that these matrices are no longer guaranteed to be upper triangular.`
- RAW: `we add a simplex (function f i ), and remove a simplex (function g i ).`
  FIX: `we add a simplex (function \( f_i \)), and remove a simplex (function \( g_i \)).`
- RAW: ```
d _ { B } ( D g m Z Z _ { p } ( f ) , D g m Z Z _ { p } ( g ) ) \leq \delta .
```
  FIX: ```
\[
d _ { B } ( D g m Z Z _ { p } ( f ) , D g m Z Z _ { p } ( g ) ) \leq \delta .
\]
```
- RAW: ```
\begin{array} { r l r } { d _ { B } ( O r d _ { p } ( f ) , O r d _ { p } ( g ) ) } & { \leq } & { \delta , } \\ { d _ { B } ( R e l _ { p } ( f ) , R e l _ { p } ( g ) ) } & { \leq } & { \delta , } \\ { d _ { B } ( E x t _ { p } ( f ) , E x t _ { p } ( g ) ) } & { \leq } & { \delta . } \end{array}
```
  FIX: ```
\[
\begin{array} { r l r } { d _ { B } ( O r d _ { p } ( f ) , O r d _ { p } ( g ) ) } & { \leq } & { \delta , } \\ { d _ { B } ( R e l _ { p } ( f ) , R e l _ { p } ( g ) ) } & { \leq } & { \delta , } \\ { d _ { B } ( E x t _ { p } ( f ) , E x t _ { p } ( g ) ) } & { \leq } & { \delta . } \end{array}
\]
```
- RAW: ```
\emptyset = K _ { 0 } \leftrightarrow K _ { 1 } \leftrightarrow \dots \leftrightarrow K _ { n } ,
```
  FIX: ```
\[
\emptyset = K _ { 0 } \leftrightarrow K _ { 1 } \leftrightarrow \dots \leftrightarrow K _ { n } ,
\]
```
- RAW: ```
H ( K _ { 0 } ) \leftrightarrow H ( K _ { 1 } ) \leftrightarrow \dots \leftrightarrow H ( K _ { n } ) ,
```
  FIX: ```
\[
H ( K _ { 0 } ) \leftrightarrow H ( K _ { 1 } ) \leftrightarrow \dots \leftrightarrow H ( K _ { n } ) ,
\]
```
- RAW: ```
\text {If} \quad H ( K _ { i } ) \stackrel { f _ { i } } { \rightarrow } H ( K _ { i + 1 } ) , \\ \text {then} \quad & \mathcal { R } _ { i + 1 } = \left ( f _ { i } ( R _ { i } ^ { 0 } ) , f _ { i } ( R _ { i } ^ { 1 } ) , \dots , f _ { i } ( R _ { i } ^ { i } ) , H ( K _ { i + 1 } ) \right ) \\ & b _ { i + 1 } = ( b _ { i } ^ { 1 } , \dots , b _ { i } ^ { i } , i + 1 ) .
```
  FIX: ```
\[
\text {If} \quad H ( K _ { i } ) \stackrel { f _ { i } } { \rightarrow } H ( K _ { i + 1 } ) , \\ \text {then} \quad & \mathcal { R } _ { i + 1 } = \left ( f _ { i } ( R _ { i } ^ { 0 } ) , f _ { i } ( R _ { i } ^ { 1 } ) , \dots , f _ { i } ( R _ { i } ^ { i } ) , H ( K _ { i + 1 } ) \right ) \\ & b _ { i + 1 } = ( b _ { i } ^ { 1 } , \dots , b _ { i } ^ { i } , i + 1 ) .
\]
```
- RAW: ```
\text {If} \quad H ( K _ { i } ) \stackrel { g _ { i } } { \leftarrow } H ( K _ { i + 1 } ) , \\ \text {then} \quad & R _ { i + 1 } = ( 0 , g _ { i } ^ { - 1 } ( R ^ { 0 } _ { i } ) , g _ { i } ^ { - 1 } ( R ^ { 1 } _ { i } ) , \dots , g _ { i } ^ { - 1 } ( R ^ { i } _ { i } ) ) \\ & b _ { i + 1 } = ( i + 1 , b _ { i } ^ { 1 } , \dots , b _ { i } ^ { i } ) .
```
  FIX: ```
\[
\text {If} \quad H ( K _ { i } ) \stackrel { g _ { i } } { \leftarrow } H ( K _ { i + 1 } ) , \\ \text {then} \quad & R _ { i + 1 } = ( 0 , g _ { i } ^ { - 1 } ( R ^ { 0 } _ { i } ) , g _ { i } ^ { - 1 } ( R ^ { 1 } _ { i } ) , \dots , g _ { i } ^ { - 1 } ( R ^ { i } _ { i } ) ) \\ & b _ { i + 1 } = ( i + 1 , b _ { i } ^ { 1 } , \dots , b _ { i } ^ { i } ) .
\]
```
- RAW: ```
( c _ { i } ^ { 0 } , \dots , c _ { i } ^ { i } ) = \dim ( \mathcal { R } _ { i } \cap K e r \, f _ { i } ) ,
```
  FIX: ```
\[
( c _ { i } ^ { 0 } , \dots , c _ { i } ^ { i } ) = \dim ( \mathcal { R } _ { i } \cap K e r \, f _ { i } ) ,
\]
```
- RAW: ```
( c _ { i } ^ { 0 } , \dots , c _ { i } ^ { i } ) = \dim ( C o k \, g _ { i } ) = \dim ( \mathcal { R } _ { i } ) - \dim ( \mathcal { R } _ { i } \cap \text {Im} \, g _ { i } ) ,
```
  FIX: ```
\[
( c _ { i } ^ { 0 } , \dots , c _ { i } ^ { i } ) = \dim ( C o k \, g _ { i } ) = \dim ( \mathcal { R } _ { i } ) - \dim ( \mathcal { R } _ { i } \cap \text {Im} \, g _ { i } ) ,
\]
```
- RAW: ```
R _ { i } ^ { k } = \span \left ( \{ z + B \ | \ z \in Z _ { i } ^ { j } \text { and } B = \span ( Z _ { i } B _ { i } ) \} \right ) .
```
  FIX: ```
\[
R _ { i } ^ { k } = \span \left ( \{ z + B \ | \ z \in Z _ { i } ^ { j } \text { and } B = \span ( Z _ { i } B _ { i } ) \} \right ) .
\]
```
