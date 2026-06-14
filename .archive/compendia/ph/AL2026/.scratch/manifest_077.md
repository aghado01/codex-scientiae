# Manifest: Page 077

## REPAIR_PROSE
- RAW: `Definition A.1. A double complex in an abelian category A is a complex of complexes, i.e., a family X = ( X i,j ,d H i,j ,d V i,j ) ( i,j ) ∈ Z 2 of objects X i,j and morphisms d H i,j : X i,j → X i,j +1 , d V i,j : X i,j → X i +1 ,j , which satisfy the zero relations d H i,j +1 d H i,j = 0 , d V i +1 ,j d V i,j = 0 , and the full commutativity relations ( d D i,j : =) d V i,j +1 d H i,j = d H i +1 ,j d V i,j for all i,j ∈ Z . We usually draw d H i,j from the left to the right, and d V i,j downward in the diagram as in`
  FIX: `Definition A.1. A double complex in an abelian category \( \mathcal{A} \) is a complex of complexes, i.e., a family \( X = (X_{i,j}, d^H_{i,j}, d^V_{i,j})_{(i,j) \in \mathbb{Z}^2} \) of objects \( X_{i,j} \) and morphisms \( d^H_{i,j} \colon X_{i,j} \to X_{i,j+1} \), \( d^V_{i,j} \colon X_{i,j} \to X_{i+1,j} \), which satisfy the zero relations \( d^H_{i,j+1} d^H_{i,j} = 0 \), \( d^V_{i+1,j} d^V_{i,j} = 0 \), and the full commutativity relations \( (d^D_{i,j} \coloneqq) d^V_{i,j+1} d^H_{i,j} = d^H_{i+1,j} d^V_{i,j} \) for all \( i,j \in \mathbb{Z} \). We usually draw \( d^H_{i,j} \) from the left to the right, and \( d^V_{i,j} \) downward in the diagram as in`
- RAW: `When we have a finite double complex, then we always extend it by adding zeros. Here we define four homologies at A : = X i,j for each ( i,j ) ∈ Z 2 :`
  FIX: `When we have a finite double complex, then we always extend it by adding zeros. Here we define four homologies at \( A \coloneqq X_{i,j} \) for each \( (i,j) \in \mathbb{Z}^2 \):`
- RAW: `which are called intramural morphisms, and a horizontal arrow (or a vertical arrow) A → B in the double complex induces a canonical morphism A □ → □ B , called an extramural morphism.`
  FIX: `which are called intramural morphisms, and a horizontal arrow (or a vertical arrow) \( A \to B \) in the double complex induces a canonical morphism \( A_\Box \to \Box_B \), called an extramural morphism.`
- RAW: `Proposition A.2 (The salamander lemma) . Let C f −→ A g −→ B h −→ D be a path in a double complex, where both f and h are horizontal (resp. vertical) and g is a vertical`
  FIX: `Proposition A.2 (The salamander lemma). Let \( C \xrightarrow{f} A \xrightarrow{g} B \xrightarrow{h} D \) be a path in a double complex, where both \( f \) and \( h \) are horizontal (resp. vertical) and \( g \) is a vertical`

## REPAIR_MATH
- RAW: ```
X _ { i - 1 , j - 1 } \underbrace { X _ { i - 1 , j } } _ { d _ { i - 1 , j - 1 } } \left | \downarrow d _ { i - 1 , j } ^ { V } \right | \\ X _ { i , j - 1 } \underbrace { \frac { d _ { i , j - 1 } ^ { H } } { X _ { i , j } } \rightarrow X _ { i , j } } _ { \downarrow d _ { i , j } ^ { V } } \rightarrow X _ { i , j + 1 } \cdot \\ X _ { i + 1 , j } \underbrace { X _ { i + 1 , j + 1 } } _ { X _ { i + 1 , j } }
```
  FIX: ```
$$
X _ { i - 1 , j - 1 } \underbrace { X _ { i - 1 , j } } _ { d _ { i - 1 , j - 1 } } \left | \downarrow d _ { i - 1 , j } ^ { V } \right | \\ X _ { i , j - 1 } \underbrace { \frac { d _ { i , j - 1 } ^ { H } } { X _ { i , j } } \rightarrow X _ { i , j } } _ { \downarrow d _ { i , j } ^ { V } } \rightarrow X _ { i , j + 1 } \cdot \\ X _ { i + 1 , j } \underbrace { X _ { i + 1 , j + 1 } } _ { X _ { i + 1 , j } }
$$
```
- RAW: ```
\ = A \coloneqq \ker d _ { i , j } ^ { H } / \text { Im } d _ { i , j - 1 } ^ { H } , \, A ^ { \| } \coloneqq \ker d _ { i , j } ^ { V } / \text { Im } d _ { i - 1 , j } ^ { V } , \\ \Box _ { A } \colon = ( \ker d _ { i , j } ^ { H } \cap \ker d _ { i , j } ^ { V } ) / \text { Im } d _ { i - 1 , d - 1 } ^ { D } , \, A _ { \Box } \coloneqq \ker d _ { i , j } ^ { D } / ( \text {Im } d _ { i - 1 , j } ^ { H } + \text {Im } d _ { i , j - 1 } ^ { V } ) ,
```
  FIX: ```
$$
\ = A \coloneqq \ker d _ { i , j } ^ { H } / \text { Im } d _ { i , j - 1 } ^ { H } , \, A ^ { \| } \coloneqq \ker d _ { i , j } ^ { V } / \text { Im } d _ { i - 1 , j } ^ { V } , \\ \Box _ { A } \colon = ( \ker d _ { i , j } ^ { H } \cap \ker d _ { i , j } ^ { V } ) / \text { Im } d _ { i - 1 , d - 1 } ^ { D } , \, A _ { \Box } \coloneqq \ker d _ { i , j } ^ { D } / ( \text {Im } d _ { i - 1 , j } ^ { H } + \text {Im } d _ { i , j - 1 } ^ { V } ) ,
$$
```
- RAW: ```
\begin{array} { r l } { \Box _ { A } \longrightarrow A ^ { \| } } \\ { \downarrow } \\ { = A \longrightarrow A _ { \Box } } \end{array}
```
  FIX: ```
$$
\begin{array} { r l } { \Box _ { A } \longrightarrow A ^ { \| } } \\ { \downarrow } \\ { = A \longrightarrow A _ { \Box } } \end{array}
$$
```
