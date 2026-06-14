[Page 6]

We now give some precise deﬁnitions.

Deﬁnition 2.1. Let k be a nonnegative integer. Given f : M → R and a ≤ b ∈ R the inclusion of sublevel sets i b a : M f ≤ a ֒ → M f ≤ b induces a map on homology

$$
H _ { k } ( i _ { a } ^ { b } ) \colon H _ { k } ( \mathbb { M } _ { f \leq a } ) \to H _ { k } ( \mathbb { M } _ { f \leq b } ) . \\
$$

The image of H k ( i b a ) is the persistent homology group from a to b . Let β b a be its dimension. This counts the independent homology classes which are born by time a and die after time b .

Call a real number a a homological critical value of f if for all sufﬁciently small ǫ > 0 the map H k ( i a + ǫ a − ǫ ) is not an isomorphism. Call f tame if it has ﬁnitely many homological critical values, and for each a ∈ R , H k ( M f ≤ a ) is ﬁnite dimensional. In particular, any Morse function on a compact manifold is tame.

Assume that f is tame. Choose ǫ smaller than the distance between any two homological critical values. For each pair of homological critical values a < b , we deﬁne their multiplicity µ b a which we interpret as the number of independent homology classes that are born at a and die at b . We count the homology classes born by time a + ǫ that die after time b − ǫ . Among these subtract those born by a − ǫ and subtract those that die after b + ǫ . This double counts those born by a − ǫ that die after b + ǫ , so we add them back. That is,

$$
\mu _ { a } ^ { b } = \beta _ { a + \epsilon } ^ { b - \epsilon } - \beta _ { a - \epsilon } ^ { b - \epsilon } - \beta _ { a + \epsilon } ^ { b + \epsilon } + \beta _ { a - \epsilon } ^ { b + \epsilon } . \\ \\
$$

The persistent homology of f may be encoded as follows. The reduced persistence diagram of f , ¯ D ( f ), is the multiset of pairs ( a, b ) together with their multiplicities µ b a . We call this a diagram since it is convenient to plot these points on the plane. We will see that it is useful to add homology classes which are born and die at the same time. Let the persistence diagram of f , D ( f ), be given by the union of ¯ D ( f ) and { ( a, a ) } a ∈ R where each ( a, a ) has inﬁnite multiplicity.

2.2. Bottleneck distance. Cohen–Steiner, Edelsbrunner and Harer [6] introduced the following metric on the space of persistence diagrams. This metric is called the bottleneck distance and it bounds the Hausdorﬀ distance. It is given by

$$
d _ { B } ( \mathcal { D } ( f ) , \mathcal { D } ( g ) ) = \inf _ { \gamma } \sup _ { p \in \mathcal { D } ( f ) } \| p - \gamma ( p ) \| _ { \infty } ,
$$
