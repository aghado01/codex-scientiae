# Manifest: Page 003

## REPAIR_MATH
- RAW: ```
I = ( - \infty , a _ { 1 } ) , \, ( a _ { 1 } , a _ { 2 } ) , \dots , ( a _ { n - 1 } , a _ { n } ) , \, ( a _ { n } , \infty )
```
  FIX: ```
$$
I = ( - \infty , a _ { 1 } ) , \, ( a _ { 1 } , a _ { 2 } ) , \dots , ( a _ { n - 1 } , a _ { n } ) , \, ( a _ { n } , \infty )
$$
```
- RAW: ```
\mathbb { Y } _ { 0 } \stackrel { f _ { 0 } } { \rightarrow } \mathbb { Z } _ { 1 } \stackrel { g _ { 1 } } { \leftarrow } \mathbb { Y } _ { 1 } \stackrel { f _ { 1 } } { \rightarrow } \mathbb { Z } _ { 2 } \stackrel { g _ { 2 } } { \rightarrow } \dots \stackrel { f _ { n - 1 } } { \rightarrow } \mathbb { Z } _ { n - 1 } \stackrel { g _ { n } } { \leftarrow } \mathbb { Y } _ { n }
```
  FIX: ```
$$
\mathbb { Y } _ { 0 } \stackrel { f _ { 0 } } { \rightarrow } \mathbb { Z } _ { 1 } \stackrel { g _ { 1 } } { \leftarrow } \mathbb { Y } _ { 1 } \stackrel { f _ { 1 } } { \rightarrow } \mathbb { Z } _ { 2 } \stackrel { g _ { 2 } } { \rightarrow } \dots \stackrel { f _ { n - 1 } } { \rightarrow } \mathbb { Z } _ { n - 1 } \stackrel { g _ { n } } { \leftarrow } \mathbb { Y } _ { n }
$$
```
- RAW: ```
\mathbb { Y } _ { 0 } \times ( - \infty , a _ { 1 } ] \cup _ { f _ { 0 } } \mathbb { Z } _ { 1 } \cup _ { g _ { 1 } } \dots , \cup _ { f _ { n - 1 } } \mathbb { Z } _ { n } \cup _ { g _ { n } } \mathbb { Y } _ { n } \times [ a _ { n } , \infty ) \quad \stackrel { \text {which} } { \text {is} } \text {last}
```
  FIX: ```
$$
\mathbb { Y } _ { 0 } \times ( - \infty , a _ { 1 } ] \cup _ { f _ { 0 } } \mathbb { Z } _ { 1 } \cup _ { g _ { 1 } } \dots , \cup _ { f _ { n - 1 } } \mathbb { Z } _ { n } \cup _ { g _ { n } } \mathbb { Y } _ { n } \times [ a _ { n } , \infty ) \quad \stackrel { \text {which} } { \text {is} } \text {last}
$$
```
- RAW: ```
- \infty < s _ { 0 } < a _ { 1 } < s _ { 1 } < a _ { 2 } < \cdots < s _ { n - 1 } < a _ { n } < s _ { n } < \infty
```
  FIX: ```
$$
- \infty < s _ { 0 } < a _ { 1 } < s _ { 1 } < a _ { 2 } < \cdots < s _ { n - 1 } < a _ { n } < s _ { n } < \infty
$$
```
- RAW: ```
\mathcal { X } \colon \ \mathbb { X } _ { 0 } ^ { 0 } \to \mathbb { X } _ { 0 } ^ { 1 } \leftarrow \mathbb { X } _ { 1 } ^ { 1 } \to \mathbb { X } _ { 1 } ^ { 2 } \leftarrow \cdots \to \mathbb { X } _ { n - 1 } ^ { n } \leftarrow \mathbb { X } _ { n } ^ { n } ,
```
  FIX: ```
$$
\mathcal { X } \colon \ \mathbb { X } _ { 0 } ^ { 0 } \to \mathbb { X } _ { 0 } ^ { 1 } \leftarrow \mathbb { X } _ { 1 } ^ { 1 } \to \mathbb { X } _ { 1 } ^ { 2 } \leftarrow \cdots \to \mathbb { X } _ { n - 1 } ^ { n } \leftarrow \mathbb { X } _ { n } ^ { n } ,
$$
```
- RAW: ```
\begin{array} { r l r l } { \mathbb { X } _ { 0 } ^ { 0 } } & { \mathbb { X } _ { 1 } ^ { 1 } } & { \cdots } & { \mathbb { X } _ { n - 1 } ^ { n - 1 } } & { \mathbb { X } _ { n } ^ { n } } \\ { ( - \infty , a _ { 1 } ) } & { ( a _ { 1 } , a _ { 2 } ) } & { \cdots } & { ( a _ { n - 1 } , a _ { n } ) } & { ( a _ { n } , \infty ) } \end{array}
```
  FIX: ```
$$
\begin{array} { r l r l } { \mathbb { X } _ { 0 } ^ { 0 } } & { \mathbb { X } _ { 1 } ^ { 1 } } & { \cdots } & { \mathbb { X } _ { n - 1 } ^ { n - 1 } } & { \mathbb { X } _ { n } ^ { n } } \\ { ( - \infty , a _ { 1 } ) } & { ( a _ { 1 } , a _ { 2 } ) } & { \cdots } & { ( a _ { n - 1 } , a _ { n } ) } & { ( a _ { n } , \infty ) } \end{array}
$$
```
- RAW: ```
\begin{array} { r l r l } { j } & { c r i c a l d v a c h o w h s a l o n o w s . } \\ & { [ \mathbb { X } _ { i - 1 , \mathbb { X } _ { j - 1 } } ^ { i } ] \, \leftrightarrow \, [ a _ { i } , a _ { j } ] \quad f o r $ 1 \leq i \leq j \leq n , } \\ & { [ \mathbb { X } _ { i - 1 , \mathbb { X } _ { j - 1 } } ^ { i } ] \, \leftrightarrow \, [ a _ { i } , a _ { j } ) \quad f o r $ 1 \leq i < j \leq n + 1 , } \\ & { [ \mathbb { X } _ { i , \mathbb { X } _ { j - 1 } } ^ { i } ] \, \leftrightarrow \, ( a _ { i } , a _ { j } ) \quad f o r $ 0 \leq i < j \leq n , } \\ & { [ \mathbb { X } _ { i , \mathbb { X } _ { j - 1 } } ^ { i } ] \, \leftrightarrow \, ( a _ { i } , a _ { j } ) \quad f o r $ 0 \leq i < j \leq n + 1 . } \end{array}
```
  FIX: ```
$$
\begin{aligned}
{[ \mathbb{X}_{i-1}^i, \mathbb{X}_{j-1}^j ]} &\leftrightarrow [a_i, a_j] \quad &\text{for } 1 \leq i \leq j \leq n, \\
{[ \mathbb{X}_{i-1}^i, \mathbb{X}_j^j )} &\leftrightarrow [a_i, a_j) \quad &\text{for } 1 \leq i < j \leq n+1, \\
{( \mathbb{X}_i^i, \mathbb{X}_{j-1}^j ]} &\leftrightarrow (a_i, a_j] \quad &\text{for } 0 \leq i < j \leq n, \\
{( \mathbb{X}_i^i, \mathbb{X}_j^j )} &\leftrightarrow (a_i, a_j) \quad &\text{for } 0 \leq i < j \leq n+1.
\end{aligned}
$$
```

## REPAIR_PROSE
- RAW: ```
J J J J J

:

:



t t t






. . . 

. . . 





/

/



/

/



/

/



/

/



/

/



/

/


-






J J J J J

:

:



t t t





Figure 1: Diagram for the Mayer–Vietoris Diamond Principle.
```
  FIX: ```
Figure 1: Diagram for the Mayer–Vietoris Diamond Principle.
```
- RAW: ```
V ) is isomorphic to the kernel of H p ( U ∩ V ) → H p ( U ) ⊕ H p ( V ). Indeed, an isomorphism is given by the connecting homomorphism ∂ of the Mayer–Vietoris theorem.
```
  FIX: ```
\( V \) is isomorphic to the kernel of \( H_p(U \cap V) \to H_p(U) \oplus H_p(V) \). Indeed, an isomorphism is given by the connecting homomorphism \( \partial \) of the Mayer–Vietoris theorem.
```
- RAW: ```
Levelset zigzag. For our principal application, consider a topological space X and a continuous function f : X → R . The function f deﬁnes levelsets X t = f − 1 ( t ) for t ∈ R , and slices X I = f − 1 ( I ) for intervals I ⊂ R . We suppose that ( X , f ) is of Morse type . By this, we mean that there is a ﬁnite set of real-valued indices a 1 < a 2 < · · · < a n called critical values , such that over each open interval
```
  FIX: ```
Levelset zigzag. For our principal application, consider a topological space \( X \) and a continuous function \( f \colon X \to \mathbb{R} \). The function \( f \) deﬁnes levelsets \( X_t = f^{-1}(t) \) for \( t \in \mathbb{R} \), and slices \( X_I = f^{-1}(I) \) for intervals \( I \subset \mathbb{R} \). We suppose that \( (X, f) \) is of Morse type. By this, we mean that there is a ﬁnite set of real-valued indices \( a_1 < a_2 < \dots < a_n \) called critical values, such that over each open interval
```
- RAW: ```
the slice X I is homeomorphic to a product of the form Y × I , with f being the projection onto the factor I . Moreover, each homeomorphism Y × I → X I should extend to a continuous function Y × ¯ I → X ¯ I , where ¯ I is the closure of I ⊂ R . Finally, we assume that each slice X t has ﬁnitely-generated homology.
```
  FIX: ```
the slice \( X_I \) is homeomorphic to a product of the form \( Y \times I \), with \( f \) being the projection onto the factor \( I \). Moreover, each homeomorphism \( Y \times I \to X_I \) should extend to a continuous function \( Y \times \bar{I} \to X_{\bar{I}} \), where \( \bar{I} \) is the closure of \( I \subset \mathbb{R} \). Finally, we assume that each slice \( X_t \) has ﬁnitely-generated homology.
```
- RAW: ```
Example 1. X is a compact manifold and f is a Morse function.
```
  FIX: ```
Example 1. \( X \) is a compact manifold and \( f \) is a Morse function.
```
- RAW: ```
Example 2. X is an open manifold which is compactcylindrical at inﬁnity, and f is a proper Morse function with ﬁnitely many critical points.
```
  FIX: ```
Example 2. \( X \) is an open manifold which is compactcylindrical at inﬁnity, and \( f \) is a proper Morse function with ﬁnitely many critical points.
```
- RAW: ```
/epsilon1




















[

]

[

]









,

,





:

[

]






,




[

]

[

]









,

,





:

[

]






,




Figure 2: Morse function on a 2-manifold with boundary, with levelset zigzag persistence intervals in H 0 and H 1 .
```
  FIX: ```
Figure 2: Morse function on a 2-manifold with boundary, with levelset zigzag persistence intervals in \( H_0 \) and \( H_1 \).
```
- RAW: ```
let X be the telescope
```
  FIX: ```
let \( X \) be the telescope
```
- RAW: ```
constructed by gluing cylinders on the Y i to the spaces Z i , with f deﬁned as the projection onto the interval factor of each cylinder.
```
  FIX: ```
constructed by gluing cylinders on the \( Y_i \) to the spaces \( Z_i \), with \( f \) deﬁned as the projection onto the interval factor of each cylinder.
```
- RAW: ```
Given ( X , f ) of Morse type, select a set of indices s i which satisfy
```
  FIX: ```
Given \( (X, f) \) of Morse type, select a set of indices \( s_i \) which satisfy
```
- RAW: ```
where X j i = X [ s i ,s j ] The levelset zigzag persistence of ( X , f ) is deﬁned to be the zigzag persistence of the above sequence.
```
  FIX: ```
where \( \mathbb{X}_i^j = X_{[s_i, s_j]} \). The levelset zigzag persistence of \( (X, f) \) is deﬁned to be the zigzag persistence of the above sequence.
```
- RAW: ```
This is independent of the choice of intermediate values s i , thanks to the product structure between critical values. To emphasize the dependence on critical values, we adopt the following labelling convention. Each X i i − 1 is labelled by the
```
  FIX: ```
This is independent of the choice of intermediate values \( s_i \), thanks to the product structure between critical values. To emphasize the dependence on critical values, we adopt the following labelling convention. Each \( \mathbb{X}_{i-1}^i \) is labelled by the
```
- RAW: ```
Zigzag persistence intervals of X are then labelled by taking the union of the labels of the terms X i i and X i i − 1 over which they are supported. Thus each persistence interval is labelled by an open, closed or half-open interval of the real line. Practically, we translate between X notation and critical value notation as follows:
```
  FIX: ```
Zigzag persistence intervals of \( \mathcal{X} \) are then labelled by taking the union of the labels of the terms \( \mathbb{X}_i^i \) and \( \mathbb{X}_{i-1}^i \) over which they are supported. Thus each persistence interval is labelled by an open, closed or half-open interval of the real line. Practically, we translate between \( \mathbb{X} \) notation and critical value notation as follows:
```
- RAW: ```
We interpret a 0 = −∞ and a n +1 = + ∞ in this scheme. In this way we get inﬁnite and semi-inﬁnite intervals. These do not occur if X 0 0 = X n n = ∅ , which is the case if X is constructed from a function on a compact space X . Each interval, of any of the four types, may be labelled by
```
  FIX: ```
We interpret \( a_0 = -\infty \) and \( a_{n+1} = +\infty \) in this scheme. In this way we get inﬁnite and semi-inﬁnite intervals. These do not occur if \( \mathbb{X}_0^0 = \mathbb{X}_n^n = \emptyset \), which is the case if \( X \) is constructed from a function on a compact space \( X \). Each interval, of any of the four types, may be labelled by
```
- RAW: ```
the corresponding point ( a i , a j ) ∈ R 2 . The aggregation of these points taken with multiplicity and labelled by type and homological dimension together with all points on the diagonal in every dimension taken with inﬁnite multiplicity is called the levelset zigzag persistence diagram DgmZZ( f ).
```
  FIX: ```
the corresponding point \( (a_i, a_j) \in \mathbb{R}^2 \). The aggregation of these points taken with multiplicity and labelled by type and homological dimension together with all points on the diagonal in every dimension taken with inﬁnite multiplicity is called the levelset zigzag persistence diagram \( \operatorname{DgmZZ}(f) \).
```

