[Page 5]

## 2. Topological Data Analysis Background

The topological background discussed here builds toward the deﬁnition of persistence diagrams, the pertinent objects in this work. We begin by brieﬂy discussing simplicial complexes and homology, an algebraic descriptor for coarse shape in topological spaces. In turn, persistent homology, and its summary, persistence diagrams, are techniques for bringing the power and convenience of homology to describe subspace ﬁltrations of topological spaces. The reader should refer to (Edelsbrunner and Harer, 2010), for example, for a rigorous treatment of persistent homology. We ﬁrst consider topological spaces of discernible dimension, called manifolds.

Deﬁnition 1 A topological space X is called a k -dimensional manifold if every point x ∈ X has a neighborhood which is homeomorphic to an open neighborhood in k -dimensional Euclidean space.

We generalize the ﬁxed-dimension notion of a manifold in order to deﬁne simplicial homology for simplicial complexes. We then discuss the ˇ Cech construction which is used to associate simplicial complexes to datasets.

Deﬁnition 2 A k -simplex is a collection of k +1 linearly independent vertices along with all convex combinations of these vertices: ( v 0 ,...,v k ) = k i =0 α i v i : k i =0 α i = 1 and α i ≥ 0 ∀ i . Topologically, a k -simplex is treated as a k -dimensional manifold (with boundary). An oriented simplex is typically described by a list of its vertices, such as ( v 0 ,v 1 ,v 2 ) . The faces of a simplex consist of all the simplices built from a subset of its vertex set; for example, the edge ( v 1 ,v 2 ) and vertex ( v 2 ) are both faces of the triangle ( v 0 ,v 1 ,v 2 ) .

Deﬁnition 3 A simplicial complex K is a collection of simplices wherein (i) if σ ∈ K , then all its faces are also in K , and (ii) the intersection of any pair of simplices in K is another simplex in K .

A simplicial complex is realized by the union of all its simplices; some examples are shown in Fig. 1. Conditions (i) and (ii) in Def. 3 establish a unique topology on the realization of a simplicial complex which restricts to the subspace topology on each open simplex. For ﬁnite simplicial complexes realized in R , this topology is also consistent with the Euclidean subspace topology.

Given a simplicial complex, we are interested in describing its global topology and local geometry through homological features. For our purposes, it suﬃces to deﬁne k − dimensional homological features of simplicial complexes as k − dimensional holes, so that, for example, 0 − dimensional homological features are connected components, 1 − dimensional homological features are loops, and 2 − dimensional homological features are voids. N

We wish to extend the notion of homology for a discrete set of data x = { x i } i =1 within a metric space ( X,d X ). Treating the set itself as a simplicial complex, its homology yields only the cardinality of the data points. So, we use the metric to obtain more information. Here we denote by B ( x 0 ,r 0 ) a metric ball centered at x 0 of radius r 0 . Fix a radius r > 0 and consider the collection of neighborhoods U = { U i } = { B ( x i ,r ) } along with its union U r = ∪ i B ( x i ,r ). The ﬁltration of sets {U r } r ∈ R + naturally yields information about the arrangement within X of the dataset x at various
