[Page 3]



![image 2](<CDSM2009/imageFile2.png>)


Figure 1: Diagram for the Mayer–Vietoris Diamond Principle.

$ V $ is isomorphic to the kernel of $ H_p(U \cap V) \to H_p(U) \oplus H_p(V) $. Indeed, an isomorphism is given by the connecting homomorphism $ \partial $ of the Mayer–Vietoris theorem.

Levelset zigzag. For our principal application, consider a topological space $ X $ and a continuous function $ f \colon X \to \mathbb{R} $. The function $ f $ defines levelsets $ X_t = f^{-1}(t) $ for $ t \in \mathbb{R} $, and slices $ X_I = f^{-1}(I) $ for intervals $ I \subset \mathbb{R} $. We suppose that $ (X, f) $ is of Morse type. By this, we mean that there is a finite set of real-valued indices $ a_1 < a_2 < \dots < a_n $ called critical values, such that over each open interval

$$
$$
I = ( - \infty , a _ { 1 } ) , \, ( a _ { 1 } , a _ { 2 } ) , \dots , ( a _ { n - 1 } , a _ { n } ) , \, ( a _ { n } , \infty )
$$
$$

the slice $ X_I $ is homeomorphic to a product of the form $ Y \times I $, with $ f $ being the projection onto the factor $ I $. Moreover, each homeomorphism $ Y \times I \to X_I $ should extend to a continuous function $ Y \times \bar{I} \to X_{\bar{I}} $, where $ \bar{I} $ is the closure of $ I \subset \mathbb{R} $. Finally, we assume that each slice $ X_t $ has finitely-generated homology.

Example 1. $ X $ is a compact manifold and $ f $ is a Morse function.

Example 2. $ X $ is an open manifold which is compactcylindrical at infinity, and $ f $ is a proper Morse function with finitely many critical points.

![In this image, we can see a diagram with some text and numbers.](<CDSM2009/imageFile3.png>)






Figure 2: Morse function on a 2-manifold with boundary, with levelset zigzag persistence intervals in $ H_0 $ and $ H_1 $.

Example 3. Given an arbitrary zigzag diagram of spaces of the form

$$
$$
\mathbb { Y } _ { 0 } \stackrel { f _ { 0 } } { \rightarrow } \mathbb { Z } _ { 1 } \stackrel { g _ { 1 } } { \leftarrow } \mathbb { Y } _ { 1 } \stackrel { f _ { 1 } } { \rightarrow } \mathbb { Z } _ { 2 } \stackrel { g _ { 2 } } { \rightarrow } \dots \stackrel { f _ { n - 1 } } { \rightarrow } \mathbb { Z } _ { n - 1 } \stackrel { g _ { n } } { \leftarrow } \mathbb { Y } _ { n }
$$
$$

let $ X $ be the telescope

$$
$$
\mathbb { Y } _ { 0 } \times ( - \infty , a _ { 1 } ] \cup _ { f _ { 0 } } \mathbb { Z } _ { 1 } \cup _ { g _ { 1 } } \dots , \cup _ { f _ { n - 1 } } \mathbb { Z } _ { n } \cup _ { g _ { n } } \mathbb { Y } _ { n } \times [ a _ { n } , \infty ) \quad \stackrel { \text {which} } { \text {is} } \text {last}
$$
$$

constructed by gluing cylinders on the $ Y_i $ to the spaces $ Z_i $, with $ f $ defined as the projection onto the interval factor of each cylinder.

Given $ (X, f) $ of Morse type, select a set of indices $ s_i $ which satisfy

$$
$$
- \infty < s _ { 0 } < a _ { 1 } < s _ { 1 } < a _ { 2 } < \cdots < s _ { n - 1 } < a _ { n } < s _ { n } < \infty
$$
$$

and construct the diagram

$$
$$
\mathcal { X } \colon \ \mathbb { X } _ { 0 } ^ { 0 } \to \mathbb { X } _ { 0 } ^ { 1 } \leftarrow \mathbb { X } _ { 1 } ^ { 1 } \to \mathbb { X } _ { 1 } ^ { 2 } \leftarrow \cdots \to \mathbb { X } _ { n - 1 } ^ { n } \leftarrow \mathbb { X } _ { n } ^ { n } ,
$$
$$

where $ \mathbb{X}_i^j = X_{[s_i, s_j]} $. The levelset zigzag persistence of $ (X, f) $ is defined to be the zigzag persistence of the above sequence.

This is independent of the choice of intermediate values $ s_i $, thanks to the product structure between critical values. To emphasize the dependence on critical values, we adopt the following labelling convention. Each $ \mathbb{X}_{i-1}^i $ is labelled by the

$$
$$
\begin{array} { r l r l } { \mathbb { X } _ { 0 } ^ { 0 } } & { \mathbb { X } _ { 1 } ^ { 1 } } & { \cdots } & { \mathbb { X } _ { n - 1 } ^ { n - 1 } } & { \mathbb { X } _ { n } ^ { n } } \\ { ( - \infty , a _ { 1 } ) } & { ( a _ { 1 } , a _ { 2 } ) } & { \cdots } & { ( a _ { n - 1 } , a _ { n } ) } & { ( a _ { n } , \infty ) } \end{array}
$$
$$

Zigzag persistence intervals of $ \mathcal{X} $ are then labelled by taking the union of the labels of the terms $ \mathbb{X}_i^i $ and $ \mathbb{X}_{i-1}^i $ over which they are supported. Thus each persistence interval is labelled by an open, closed or half-open interval of the real line. Practically, we translate between $ \mathbb{X} $ notation and critical value notation as follows:

$$
$$
\begin{aligned}
{[ \mathbb{X}_{i-1}^i, \mathbb{X}_{j-1}^j ]} &\leftrightarrow [a_i, a_j] \quad &\text{for } 1 \leq i \leq j \leq n, \\
{[ \mathbb{X}_{i-1}^i, \mathbb{X}_j^j )} &\leftrightarrow [a_i, a_j) \quad &\text{for } 1 \leq i < j \leq n+1, \\
{( \mathbb{X}_i^i, \mathbb{X}_{j-1}^j ]} &\leftrightarrow (a_i, a_j] \quad &\text{for } 0 \leq i < j \leq n, \\
{( \mathbb{X}_i^i, \mathbb{X}_j^j )} &\leftrightarrow (a_i, a_j) \quad &\text{for } 0 \leq i < j \leq n+1.
\end{aligned}
$$
$$

We interpret $ a_0 = -\infty $ and $ a_{n+1} = +\infty $ in this scheme. In this way we get infinite and semi-infinite intervals. These do not occur if $ \mathbb{X}_0^0 = \mathbb{X}_n^n = \emptyset $, which is the case if $ X $ is constructed from a function on a compact space $ X $. Each interval, of any of the four types, may be labelled by

the corresponding point $ (a_i, a_j) \in \mathbb{R}^2 $. The aggregation of these points taken with multiplicity and labelled by type and homological dimension together with all points on the diagonal in every dimension taken with infinite multiplicity is called the levelset zigzag persistence diagram $ \operatorname{DgmZZ}(f) $.
