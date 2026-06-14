[Page 77]

- Conflict of interest: the authors declare that they have no relevant financial or non-financial conflicts of interest with regard to the content of this article.

# Appendix A The salamander lemma

We apply the salamander lemma in this paper, for which we refer the reader to papers Bergman ( 2012 ) and Geraschenko ( 2007 ) by Bergman and Geraschenko, respectively. In particular, we use the notations introduced by Geraschenko. Here we recall some necessary definitions and statements.

Definition A.1. A double complex in an abelian category A is a complex of complexes, i.e., a family X = ( X i,j ,d H i,j ,d V i,j ) ( i,j ) ∈ Z 2 of objects X i,j and morphisms d H i,j : X i,j → X i,j +1 , d V i,j : X i,j → X i +1 ,j , which satisfy the zero relations d H i,j +1 d H i,j = 0 , d V i +1 ,j d V i,j = 0 , and the full commutativity relations ( d D i,j : =) d V i,j +1 d H i,j = d H i +1 ,j d V i,j for all i,j ∈ Z . We usually draw d H i,j from the left to the right, and d V i,j downward in the diagram as in

$$
X _ { i - 1 , j - 1 } \underbrace { X _ { i - 1 , j } } _ { d _ { i - 1 , j - 1 } } \left | \downarrow d _ { i - 1 , j } ^ { V } \right | \\ X _ { i , j - 1 } \underbrace { \frac { d _ { i , j - 1 } ^ { H } } { X _ { i , j } } \rightarrow X _ { i , j } } _ { \downarrow d _ { i , j } ^ { V } } \rightarrow X _ { i , j + 1 } \cdot \\ X _ { i + 1 , j } \underbrace { X _ { i + 1 , j + 1 } } _ { X _ { i + 1 , j } }
$$

When we have a finite double complex, then we always extend it by adding zeros. Here we define four homologies at A : = X i,j for each ( i,j ) ∈ Z 2 :

$$
\ = A \coloneqq \ker d _ { i , j } ^ { H } / \text { Im } d _ { i , j - 1 } ^ { H } , \, A ^ { \| } \coloneqq \ker d _ { i , j } ^ { V } / \text { Im } d _ { i - 1 , j } ^ { V } , \\ \Box _ { A } \colon = ( \ker d _ { i , j } ^ { H } \cap \ker d _ { i , j } ^ { V } ) / \text { Im } d _ { i - 1 , d - 1 } ^ { D } , \, A _ { \Box } \coloneqq \ker d _ { i , j } ^ { D } / ( \text {Im } d _ { i - 1 , j } ^ { H } + \text {Im } d _ { i , j - 1 } ^ { V } ) ,
$$

which are called the horizontal homology , the vertical homology , the receptor and the donor , respectively.

Inclusion morphisms induce canonical morphisms

$$
\begin{array} { r l } { \Box _ { A } \longrightarrow A ^ { \| } } \\ { \downarrow } \\ { = A \longrightarrow A _ { \Box } } \end{array}
$$

which are called intramural morphisms, and a horizontal arrow (or a vertical arrow) A → B in the double complex induces a canonical morphism A □ → □ B , called an extramural morphism.

Proposition A.2 (The salamander lemma) . Let C f −→ A g −→ B h −→ D be a path in a double complex, where both f and h are horizontal (resp. vertical) and g is a vertical
