[Page 19]

that can be detected by using points and edges– with this construction one is answering the question: are two points connected by a sequence of edges or not? The simplest basis for H 0 ( X ) consists of a choice of vertices in X , one in each path-component of X . Likewise, the simplest basis for H 1 ( X ) consists of loops in X , each of which surrounds a hole in X . For example, if X is a graph, then the space H 1 ( X ) encodes the number and types of cycles in the graph, this space has the structure of a vector space. Let X denote a simplicial complex. Deﬁne for each k ≥ 0, the vector space C k ( X ) to be the vector space whose basis is the set of oriented k -simplices of X ; that is, a k -simplex { v 0 , . . ., v k } together with an order type denoted [ v 0 , . . ., v k ] where a change in orientation corresponds to a change in the sign of the coeﬃcient: [ v 0 , . . ., v i , . . ., v j , . . ., v k ] = − [ v 0 , . . ., v j , . . ., v i , . . ., v k ] if odd permutation is used.

For k larger than the dimension of X , we set C k ( X ) = 0. The boundary map is deﬁned to be the linear transformation ∂ : C k → C k − 1 which acts on basis elements [ v 0 , . . ., v k ] via

$$
( A . 1 ) \quad & \partial [ v _ { 0 } , \dots , v _ { k } ] \coloneqq \sum _ { i = 0 } ^ { k } ( - 1 ) ^ { i } [ v _ { 0 } , \dots , v _ { i - 1 } , v _ { i + 1 } , \dots , v _ { k } ] . \\ \intertext { This gives rise to a chain complex: a sequence of vector spaces and }
$$

This gives rise to a chain complex: a sequence of vector spaces and linear transformations

$$
\cdots \stackrel { \partial } { \to } C _ { k + 1 } \stackrel { \partial } { \to } C _ { k } \stackrel { \partial } { \to } C _ { k - 1 } \cdots \stackrel { \partial } { \to } C _ { 2 } \stackrel { \partial } { \to } C _ { 1 } \stackrel { \partial } { \to } C _ { 0 } \\ \sim \\ C o n s i d o n \, t h o f l o w i n g \, t w o b a n p o o e a \, o f \, C _ { 1 } \, + \, t h o w o l o n \, ( t h o s e a n d o w s )
$$

Consider the following two subspaces of C k : the cycles (those subcomplexes without boundary) and the boundaries (those subcomplexes which are themselves boundaries) formally deﬁned as:

k -cycles: Z k ( X ) = ker( ∂ : C k → C k -1 )

k -boundaries: B k ( X ) = im( ∂ : C k +1 → C k )

A ◦ is, the boundary of a chain has empty boundary. It follows that B k is a subspace of Z k . This has great implications. The k -cycles in X are the basic objects which count the presence of a “hole of dimension k” in X . But, certainly, many of the k -cycles in X are measuring the same hole; still other cycles do not really detect a hole at all – they bound a subcomplex of dimension k + 1 in X . We say that two cycles ζ and η in Z k ( X ) are homologous if their diﬀerence is a boundary:

$$
[ \zeta ] = [ \eta ] \ \leftrightarrow \ \zeta - \eta \in B _ { k } ( X ) .
$$
