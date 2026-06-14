[Page 17]

Deﬁnition 7.1 (Landscape of a Diagram) . The persistence landscape of a diagram dgm is the collection of functions, indexed by k ∈ N , and deﬁned by

$$
\lambda _ { d g m } ( k , t ) = \kmax _ { p \in d g m } \Lambda _ { p } ( t ) , \ \ t \in [ 0 , T ] ,
$$

where kmax is the k th largest value in the set; in particular, 1max is the usual maximum function.

Given k ∈ N , the function λ dgm ( k,. ) : R → R is called the k -th landscape of dgm. It is not diﬃcult to see that the map that associate to each persistence diagram its corresponding landscape is injective. In other words, formally no information is lost when a persistence diagram is represented through its persistence landscape.

The advantage of the persistence landscape representation is two-fold:

- (i) Persistence diagrams are represented as elements of a function space, opening the door to the use of a broad variety of statistical and data analysis tools for further processing of topological features.
- (ii) Second, and fundamental from a theoretical perspective, the persistence landscapes share the same stability properties as persistence diagrams (see Section 5).


Proposition 7.2 (Basic Properties of Landscapes) . For all k 0 ,

(i) λ dgm ( k, · ) λ dgm ( k + 1 , · ) 0 , (ii) λ dgm ( k, · ) is 1 -Lipschitz.

Proof.

$$
P r o f . \, \text { See [Bub1 5, Lemma 4].} & . & \Box
$$

7.2. Stability. From the deﬁnition of persistence landscape, we immediately observe that λ ( k, · ) is one-Lipschitz and thus similar stability properties are satisﬁed for the landscapes as for persistence diagrams.

Theorem 7.3 (Stability of Landscapes) . Let dgm 1 and dgm 2 be two q-tame diagrams. Then for all k 0 ,

$$
\left \| \lambda _ { d g m _ { 1 } } ( k , \cdot ) - \lambda _ { d g m _ { 2 } } ( k , \cdot ) \right \| _ { \infty } \leqslant d _ { b } ( d g m _ { 1 } , d g m _ { 2 } ) .
$$

Proof.

$$
P r o f . \, \text { See [Bub1 5, Theorem 17].} & & \Box
$$

Remark 7.4. In particular, Theorem 7.3 allows to derive a stability result for landscapes associated to:

- (i) ﬁltrations of functions, from Theorem 5.7;
- (ii) Rips and ˇ Cech ﬁltrations of a metric space, from Theorem 5.9.


7.3. Central Tendency for Persistent Homology. The space of persistence diagrams being not an Hilbert space, the deﬁnition of a mean persistence diagram is not obvious and unique. One ﬁrst approach to deﬁne a central tendency in this context is to deﬁne a Fr´echet mean in this context. Indeed it has been proved in [TMMH14] that the space of persistence diagrams is a Polish space. However they are may not be unique and there are very diﬃcult to compute in practice. To overcome the problem of computational costs, sampling strategies can be proposed to compute topological signatures based on persistence landscapes. Given a large point cloud, the
