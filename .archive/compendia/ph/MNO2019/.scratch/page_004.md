[Page 4]

This paper is organized as follows. Section 2 provides a brief overview of persistence diagrams and general point processes. Our methods are presented in Section 3. In particular, Subsection 3.1 establishes the Bayesian framework for persistence diagrams, while Subsection 3.2 contains the derivation of a closed form for a posterior distribution based on a Gaussian mixture model. A classiﬁcation algorithm with Bayes factors is discussed in Section 4. To assess the capability of our algorithm, we investigate its performance on materials data in Subsection 4.1. Finally, we end with discussions and conclusions in Section 5.

## 2 Background

We begin by discussing preliminary deﬁnitions essential for building our model. In Subsection 2.1, we brieﬂy review simplicial complexes and provide a formal deﬁnition for persistence diagrams (PDs). Pertinent deﬁnitions and theorems from point processes (PPs) are discussed in Subsection 2.2 .

## 2.1 Persistence Diagrams

We start by discussing simplices and simplicial complexes, intermediary structures for constructing PDs.

Deﬁnition 2.1. A -dimensional collection of data { v 0 ,...,v n } ⊂ R \ { 0 } is said to be geometrically independent if for any set t i ∈ R with n i =0 t i = 0, the equation n i =0 t i v i = 0 implies that t i = 0 for all i ∈ { 0 ,...,n } .

Deﬁnition 2.2. A k − simplex, is a collection of k + 1 geometrically independent elements along with their convex hull: [ v 0 ,...,v k ] =     k i =0 α i v i |   k i =0 α i = 1   . We say that the vertices v 0 ,...,v n span the k − dimensional simplex, [ v 0 ,...,v k ]. The faces of a k − simplex [ v 0 ,...,v k ], are the ( k − 1) − simplices spanned by subsets of { v 0 ,...,v k } .

Deﬁnition 2.3. A simplicial complex S is a collection of simplices satisfying two conditions: (i) if ξ ∈ S , then all faces of ξ are also in S , and (ii) the intersection of two simplices in S is either empty or contained in S .

Given a point cloud X , our goal is to construct a sequence of simplicial complexes that reasonably approximates the underlying shape of the data. We accomplish this by using the Vietoris-Rips ﬁltration.

Deﬁnition 2.4. Let X = { x i } L i =0 be a point cloud in R and r > 0. The Vietoris-Rips complex of X is deﬁned to be the simplicial complex V r ( X ) satisfying [ x i 1 ,...,x i l ] ∈ V r ( X ) if and only if diam( x i 1 ,...,x i l ) < r . Given a nondecreasing sequence { r n } ∈ R + ∪ { 0 } with r 0 = 0, we denote its Vietoris-Rips ﬁltration by {V r n ( X ) } n ∈ N .

A persistence diagram D is a multiset of points in W := W × { 0 , 1 ,..., − 1 } , where W := { ( b,d ) ∈ R 2 | d ≥ b ≥ 0 } and each element ( b,d,k ) represents a homological feature of dimension k that appears at scale b during a Vietoris-Rips ﬁltration and disappears at scale d . Intuitively speaking, the feature ( b,d,k ) is a k − dimensional hole lasting for duration d − b . Namely, features with k = 0 correspond to connected components, k = 1 to loops, and k = 2 to voids. An example of a PD is shown in Figure 2.

## 2.2 Poisson Point Processes

This section contains basic deﬁnitions and fundamental theorems from PPs, primarily Poisson PPs. Detailed treatments of Poisson PPs can be found in [15] and references therein. For the remainder of this section, we take X and X to be a Polish space and its Borel σ -algebra, respectively.
