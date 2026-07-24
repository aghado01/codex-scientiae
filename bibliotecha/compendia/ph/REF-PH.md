# PERSISTENT HOMOLOGY

## Contents

- [1. Filtrations](#1-filtrations)
- [2. Starting with a Few Examples](#2-starting-with-a-few-examples)
- [3. Persistent Modules and Persistence Diagrams](#3-persistent-modules-and-persistence-diagrams)
- [4. Metrics on the Space of Persistence Diagrams](#4-metrics-on-the-space-of-persistence-diagrams)
- [5. Stability](#5-stability)
  - [5.1. A General Result](#51-a-general-result)
  - [5.2. Stability for Functions](#52-stability-for-functions)
  - [5.3. Stability for Spaces](#53-stability-for-spaces)
- [6. Rates of Convergence for Random Point Clouds](#6-rates-of-convergence-for-random-point-clouds)
  - [6.1. Minimax Upper Bound](#61-minimax-upper-bound)
- [7. Persistence Landscapes](#7-persistence-landscapes)
  - [7.1. Construction](#71-construction)
  - [7.2. Stability](#72-stability)
  - [7.3. Central Tendency for Persistent Homology](#73-central-tendency-for-persistent-homology)
- [8. Further Sources](#8-further-sources)
- [References](references/REF-PH.md)

|1.|Filtrations| |1|
|---|---|---|---|
|2.|Starting with a Few Examples| |2| |3.|and Persistence Diagrams| |6| |4.|Space of Persistence Diagrams| |8| |5.|Stability| |9| |5.1.| |A General Result|9| |5.2.| |Stability for Functions|10| |5.3.| |Stability for Spaces|11| |6. Rates of Convergence for Random Point Clouds| | |13| |6.1.| |Minimax Upper Bound|13| |6.2.| |Minimax Lower Bound|15| |7. Persistence Landscapes| | |16| |7.1.| |Construction|16| |7.2.| |Stability|17| |7.3.| |Central Tendency for Persistent Homology|17| |8. Further Sources| | |19| |References| | |19|

Persistent homology is a powerful tool to compute, study and encode efficiently multiscale topological features of nested families of simplicial complexes and topological spaces. It does not only provide efficient algorithms to compute the Betti numbers of each complex in the considered families, as required for homology inference in the previous section, but also encodes the evolution of the homology groups of the nested complexes across the scales.

## 1. Filtrations

Definition 1.1 (Filtration). A filtration of a simplicial complex K is a nested family of subcomplexes ( K r ) r $\in$ T, where T $\subset$ R, such that for any r,r $\in$ T, if r r then K r $\subset$ K r, and K = ∪ r $\in$ T K r.

More generally, a filtration of a topological space M is a nested family of subspaces ( M r ) r $\in$ T, where T $\subset$ R, such that for any r,r $\in$ T, if r r then M r $\subset$ M r and, M = ∪ r $\in$ T M r. For example, if f : M $\to$ R is a function, then the family M r = f − 1 (( −∞,r ]), r $\in$ R defines a filtration called the sublevel set filtration of f.

Remark 1.2. (i) The subset T may be either finite or infinite.

(ii) In practical situations, the parameter r $\in$ T can often be interpreted as a scale parameter and filtrations classically used in TDA often belong to one of the two following families.

Example 1.3 (Filtrations Built on Top of Data). Given a subset X of a compact metric space ( M,$\rho$ ), the families of Rips-Vietoris complexes (Rips( X,r )) r $\in$ R and and ˇ Cech complexes ( ˇ Cech( X,r )) r $\in$ R are filtrations 1. Here, the parameter r can be interpreted as a resolution at which one considers the data set X. d

In particular, if X is a point cloud in R, thanks to the Nerve theorem, the filtration ( ˇ Cech( X,r )) r $\in$ R encodes the topology of the whole family of unions of balls X r = ∪ x $\in$ X B( x,r ), as r goes from 0 to + ∞.

Example 1.4 (Sublevel Sets Filtrations). Functions defined on the vertices of a simplicial complex give rise to another important example of filtration: let K be a simplicial complex with vertex set V and f : V $\to$ R. Then f can be extended to all simplices of K by f ([ v 0, $\cdot \cdot \cdot$ ,v k ]) = max 1 i k f ( v i ) for any simplex $\sigma$ = [ v 0, $\cdot \cdot \cdot$ ,v k ] $\in$ K. The family of subcomplexes K r = { $\sigma \in$ K| f ( $\sigma$ ) r } defines a filtration call the sublevel set filtration of f. Similarly, one can define the upperlevel set filtration of f.

In practice, even if the index set is infinite, all the considered filtrations are built on finite sets and are indeed finite. For example, when X is finite, the Vietoris-Rips complex Rips( X,r ) changes only at a finite number of indices r. This allows to easily handle them from an algorithmic perspective.

## 2. Starting with a Few Examples

Given a filtration Filt = ( F r ) r $\in$ T of a simplicial complex or a topological space, the homology of F r changes as r increases: new connected components can appear, existing component can merge, loops and cavities can appear or be filled, etc. Persistent homology tracks these changes, identifies the appearing features and associates a life time to them. The resulting information is encoded as a set of intervals called a barcode or, equivalently, as a multiset of points in R 2 where the coordinate of each point is the starting and end point of the corresponding interval.

Before giving formal definitions, we introduce and illustrate persistent homology on three simple examples.

Example 2.1 (Smooth Real Function). Let f : [0, 1] $\to$ R be the function of Figure 1 and let ( F r = f − 1 (( −∞,r ])) r $\in$ R be the sublevel set filtration of f.

( a 1 ) All the sublevel sets of f are either empty or a union of interval, so the only non trivial topological information they carry is their 0-dimensional homology, i.e. their number of connected components. For r < a 1, F r is empty, but at r = a 1 a first connected component appears in F a 1. Persistent homology thus registers a 1 as the birth time of a connected component and start to keep track of it by creating an interval starting at a 1.

( a 2 ) Then, F r remains connected until r reaches the value a 2 where a second connected component appears. Persistent homology starts to keep track of this new connected component by creating a second interval starting at a 2.

1 we take here the convention that for r < 0, Rips( X, r ) = ˇ Cech( X, r ) = ∅

death

![In this image there is a graph.](<PH-REF/imageFile1.png>)

birth

Figure 1. The persistence barcode and the persistence diagram of a function f : [0, 1] $\to$ R.

( a 3 ) Similarly, when r reaches a 3, a new connected component appears and persistent homology creates a new interval starting at a 3.

( a 4 ) When r reaches a 4, the two connected components created at a 1 and a 3 merges together to give a single larger component. At this step, persistent homology follows the rule that this is the most recently appeared component in the filtration that dies: the interval started at a 3 is thus ended at a 4 and a first persistence interval encoding the lifespan of the component born at a 3 is created.

( a 5 ) When r reaches a 5, as in the previous case, the component born at a 2 dies and the persistent interval ( a 2,a 5 ) is created.

( a 6 ) The interval created at a 1 remains until the end of the filtration giving rise to the persistent interval ( a 1,a 6 ) if the filtration is stopped at a 6, or ( a 1, + ∞ ) if r goes to + ∞ (notice that in this later case, the filtration remains constant for r > a 6 ).

The obtained set of intervals encoding the span life of the different homological features encountered along the filtration is called the persistence barcode of f. Each interval ( a,a ) can be represented by the point of coordinates ( a,a ) in R 2 plane. The resulting set of points is called the persistence diagram of f. Notice that a function may have several copies of the same interval in its persistence barcode. As a consequence, the persistence diagram of f is indeed a multi-set where each point has an integer valued multiplicity. Last, for technical reasons that will become clear in the next section, one adds to the persistence all the points of the diagonal ∆ = { ( b,d ) : b = d } with an infinite multiplicity.

Example 2.2 (Surface in Space). Let now f : M $\to$ R be the function of Figure 2 where M is a 2-dimensional surface homeomorphic to a torus, and let ( F r = f − 1 (( −∞,r ])) r $\in$ R be the sublevel set filtration of f. The 0dimensional persistent homology is computed as in the previous example, giving rise to the red bars in the barcode. Now, the sublevel sets also carry 1-dimensional homological features.

( a 1 ) When r goes through the height a 1, the sublevel sets F r that were homeomorphic to two discs become homeomorphic to the disjoint union of a disc and an annulus, creating a first cycle homologous to $\sigma$ 1 on Figure

Figure 2. The persistence barcode and the persistence diagram of the height function (projection on the z -axis) defined on a surface in R 3.

2. A interval (in blue) representing the birth of this new 1-cycle is thus started at a 1.

( a 2 ) Similarly, when r goes through the height a 2 a second cycle, homologous to $\sigma$ 2 is created, giving rise to the start of a new persistent interval. These two created cycles are never filled (indeed they span H 1 ( M )) and the corresponding intervals remains until the end of the filtration.

( a 3 ) When r reaches a 3, a new cycle $\sigma$ 3 is created.

( a 4 ) This cycle is filled and thus dies at a 4, giving rise to the persistence interval ( a 3,a 4 ).

So, now, the sublevel set filtration of f gives rise to two barcodes, one for 0-dimensional homology (in red) and one for 1-dimensional homology (in blue). As previously, these two barcodes can equivalently be represented as diagrams in the plane.

Example 2.3 (Offsets of a Point Cloud). In this last example we consider the filtration given by a union of growing balls centered on the finite set of points P, as pictured below. Notice that this is the sublevel set filtration of the distance function to P, that is ( F r = d − 1 P (( −∞,r ])) r $\in$ R. Thanks to the Nerve Theorem, this filtration is homotopy equivalent to the ˇ Cech filtration built on top of P.

![image 1](<PH-REF/imageFile1.png>)

b)

a)

- a) For the radius r = 0, the union of balls is reduced to the initial finite set of point, each of them corresponding to a 0-dimensional feature, i.e. a connected component; an interval is created for the birth for each of these features at r = 0.
- b) Some of the balls started to overlap resulting in the death of some connected components that get merged together; the persistence diagram keeps track of these deaths, putting an end point to the corresponding intervals as they disappear.

![The image consists of a graph with two main components. The graph is titled C and has a horizontal axis labeled d and a vertical axis labeled c. The graph is divided into two parts, each with a different color. The first part of the graph is colored yellow and has a small blue dot at the top. The second part of the graph is colored red and has a small blue dot at the top. The graph has a horizontal axis labeled d and a vertical axis labeled c. The x-axis is labeled d and the y-axis is labeled c. The graph is divided into two parts, each with a different color. The first part of the graph is colored yellow and has a small blue dot at the top. The second part of the graph is colored red and has a small blue dot at the top. The graph is labeled as C and has a horizontal axis labeled d and a vertical](<PH-REF/imageFile2.png>)

c)

d)

- c) New components have merged giving rise to a single connected component and, so, all the intervals associated to a 0-dimensional feature have been ended, except the one corresponding to the remaining components; two new 1-dimensional features, have appeared resulting in two new intervals (in blue) starting at their birth scale.
- d) One of the two 1-dimensional cycles has been filled, resulting in its death in the filtration and the end of the corresponding blue interval.

![The image is a diagram titled Premium Barbecue. It consists of a series of interconnected nodes and edges, each representing a different type of food item. The nodes are connected by edges, which represent the relationships between the nodes. The nodes are labeled with the following: - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a](<PH-REF/imageFile3.png>)

Persistence barcode

e)

Persistence diagram

e) all the 1-dimensional features have died, it only remains the long (and never dying) red interval. As in the previous examples, the final barcode can also be equivalently represented as a persistence diagram where every interval ( a,b ) is represented by the the point of coordinate ( a,b ) in R 2. Intuitively the longer is an interval in the barcode or, equivalently the farther from the diagonal is the corresponding point in the diagram, the more persistent, and thus relevant, is the corresponding homological feature across the filtration. Notice also that for a given radius r, the k -th Betti number of the corresponding union of balls is equal of the number of persistence intervals corresponding to k -dimensional homological features and containing r. So, the persistence diagram can be seen as a multiscale topological signature encoding the homology of the union of balls for all radii as well as its evolution across the values of r.

## 3. Persistent Modules and Persistence Diagrams

Persistent diagrams can be formally and rigorously defined in a purely algebraic way. This requires some care and we only give here the basic necessary notions, leaving aside technical subtleties and difficulties.

Definition 3.1 (Persistence Module). A persistence module V over a subset T $\subset$ R of the real numbers is an indexed family of vector spaces ( V r | r $\in$ T ) and a doubly-indexed family of linear maps ( v r s : V r $\to$ V s | r s ) which satisfy the composition law v s t ◦ v r s = v r t whenever r s t, and where v r r is the identity map on V r.

Example 3.2. Let Filt = ( F r ) r $\in$ T be a filtration of a simplicial complex or a topological space. Given an integer k 0 and considering the homology groups H k ( F r ) we obtain a family of vector spaces, and the inclusions i r s : F r $\to$ F s,for r s, induce linear maps ( i r s ) ∗ : H k ( F r ) $\to$ H k ( F s ) at the homology level. Furthermore, these maps satisfy ( i r t ) ∗ = ( i s t ◦ i r s ) ∗ = ( i s t ) ∗ ◦ ( i r s ) ∗ for all r s t.

In many cases, a persistence module can be decomposed into a direct sum of intervals modules I ( b,d ) of the form

$$
\cdots \to 0 \to \cdots \to 0 \to Z_{2} \to \cdots \to Z_{2} \to 0 \to \cdots
$$

where the maps Z 2 $\to$ Z 2 are identity maps while all the other maps are 0. Denoting b (resp. d ) the infimum (resp. supremum) of the interval of indices corresponding to non zero vector spaces, such a module can be interpreted as a feature that appears in the filtration at index b and disappear at index d. When a persistence module V can be decomposed as a direct sum of interval modules, one can show that this decomposition is unique up to reordering the intervals (see [CdSGO16, Theorem 2.7]). As a consequence, the set of resulting intervals is independent of the decomposition of V and is called the persistence barcode of V.

Remark 3.3. As in the examples of the previous section, each interval ( b,d ) in the barcode can be represented as the point of coordinates ( b,d ) in the plane R 2. The disjoint union of these points, together with the diagonal ∆ = { b = d } is a multi-set called the persistence diagram of V.

The following result gives sufficient conditions for a persistence module to be decomposable as a direct sum of interval modules.

Theorem 3.4. Let V be a persistence module indexed by T $\subset$ R. If T is a finite set or if all the vector spaces V r are finite-dimensional, then V is decomposable as a direct sum of interval modules.

$$
P r o f. \, S e e \, [ C d S G O 1 6, \, Theorem \, 2. 8 ].
$$

As both conditions above are satisfied for the persistent homology of filtrations of finite simplicial complexes, an immediate consequence of this result is that the persistence diagrams of such filtrations are always welldefined.

Unfortunately, Theorem 3.4 is not sufficient for our purposes of general data analysis. Indeed, there exist compact sets whose offsets do not induce pointwise finite-dimensional persistence modules, such as X = { 0 } ∪ n 1

![image 6](<PH-REF/imageFile6.png>)

Figure 3. The set X = { 0 } ∪ n 1 { 1 /n } is compact, but $\beta$ 0 ( X ) = ∞ and its offsets ( X r ) r 0 are naturally indexed by the infinite set T = R.

{ 1 /n } (see Figure 3). However, it is possible to show that persistence diagrams can be defined as soon as the following simple condition is satisfied.

Definition 3.5 (q-tameness). A persistence module V indexed by T $\subset$ R is q-tame if for any r < s in T, the rank of the linear map v r s : V r $\to$ V s is finite.

Theorem 3.6 ([CdSGO16]). If V is a q-tame persistence module, then it has a well-defined persistence diagram.

Remark 3.7. (i) Theorem 3.6 is pretty strong, since its shows that the diagram is well-defined, even though V may not be interval-decomposable.

- (ii) Such a persistence diagram dgm( V ) is the union of the points of the diagonal ∆ of R 2, counted with infinite multiplicity, and a multi-set above the diagonal in R 2 that is locally finite. Here, by locally finite we mean that for any rectangle R with sides parallel to the coordinate axes that does not intersect ∆, the number of points of dgm( V ), counted with multiplicity, contained in R is finite.
- (iii) (Insights on q-tameness) One can check [CdSGO16, Corollary 2.2] that the number of points in any rectangle [ a,b ] $\times$ [ c,d ] above the diagonal ( a b c d ) corresponds to rank( v c b ) − rank( v d b )+rank( v d a ) − rank( v c a ). Letting a $\to$ −∞ and d $\to$ ∞, we get that the number of points in the quadrant ( −∞,b ] $\times$ [ c, ∞ ) is finite whenever c > b, explaining the term q-tame.

The construction of persistence diagrams of q-tame modules is beyond the scope of this lesson but it gives rise to the same notion as in the case of decomposable modules. It can be done either by following the algebraic approach based upon the decomposability properties of modules, or by adopting a measure theoretic approach that allows to define diagrams as integer valued measures on a space of rectangles in the plane. We refer the reader to [CdSGO16] for more information. Although persistence modules encountered in practice are decomposable, the general framework of q-tame persistence module plays a fundamental role in the mathematical and statistical analysis of persistent homology.

“the” persistence diagram dgm(Filt) of the filtration Filt. This notation has to be understood as “dgm k (Filt) for some k ”.

## 4. Metrics on the Space of Persistence Diagrams

To exploit the topological information and topological features inferred from persistent homology, one needs to be able to compare persistence diagrams, i.e. to endow the space of persistence diagrams with a metric structure. Although several metrics can be considered, the most fundamental one is known as the bottleneck distance.

Recall that a persistence diagram is the union of a discrete multi-set in the half-plane above the diagonal ∆ and, for technical reasons that will become clear below, of ∆ where the point of ∆ are counted with infinite multiplicity.

Definition 4.1 (Matching). A matching between two diagrams dgm 1 and dgm 2 is a subset m ⊂ dgm 1 × dgm 2 such that every points in dgm 1 \ ∆ and dgm 2 \ ∆ appears exactly once in m.

In other words, for any p ∈ dgm 1 \ ∆, and for any q ∈ dgm 2 \ ∆, ( { p } × dgm 2 ) ∩ m and (dgm 1 ×{ q } ) ∩ m each contains a single pair, see Figure 4.

Definition 4.2 (Bottleneck Distance). The bottleneck distance between dgm 1 and dgm 2 is then defined by

$$
d_b(\mathrm{dgm}_1, \mathrm{dgm}_2) = \inf_{\text{matching } m} \max_{(p,q) \in m} \| p - q \|_\infty.
$$

![The image presents a graph with two sets of points. The graph is titled d and has a legend in the top right corner. The legend indicates that the points are labeled as follows: - **d(gdm,dgm2)** - **d(gdm,dgm3)** - **d(gdm,dgm4)** The graph is labeled as d and has a scale of range 0 to 100. The x-axis is labeled d and the y-axis is labeled d(gdm,dgm2). The graph shows a trend of increasing values of the function d as the x-axis increases. The points are scattered around the x-axis, with some points closer to the x-axis and others farther away. The graph also includes a scale labeled b with a value of 0 to 100. The](<PH-REF/imageFile7.png>)

=

(dgm

,dgm

)

Figure 4. A perfect matching and the bottleneck distance between a blue and a red diagram. Notice that some points of both diagrams are matched to points of the diagonal.

(ii) The bottleneck metric is a L ∞ -like metric. It turns out to be the natural one to express stability properties of persistence diagrams presented in Section 5, but it suffers from the same drawbacks as the usual L ∞ norms, i.e. it is completely determined by the largest distance among the pairs and do not take into account the closeness of the remaining pairs of points. A variant, to overcome this issue, the so-called Wasserstein distance between diagrams is sometimes considered. Given p 1, it is defined by

$$
W_{p} ( d g m_{1}, d g m_{2} )^{p} = \inf_{\text{matching}} \sum_{( p, q ) \in m} \| p - q \|_{\infty}^{p}.
$$

Useful stability results for persistence in the metric W p exist among the literature, but they rely on assumptions that make them consequences of the stability results in the bottleneck metric.

## 5. Stability

### 5.1. A General Result

A fundamental property of persistence homology is that persistence diagrams of filtrations built on top of data sets turn out to be very stable with respect to some perturbations of the data. To formalize and quantify such stability properties, we first need to precise the notion of perturbation that are allowed.

Rather than working directly with filtrations built on top of data sets, it turns out to be more convenient to define a notion of proximity between persistence module from which we will derive a general stability result for persistent homology. Then, most of the stability results for specific filtrations will appear as a consequence of this general theorem. To avoid technical discussions, from now on we assume, without loss of generality, that the considered persistence modules are indexed by R.

Definition 5.1 (Homomorphism of Persistence Modules). Let V, W be two persistence modules indexed by R. Given $\delta \in$ R, a homomorphism of degree $\delta$ between V and W is a collection $\Phi$ of linear maps $\varphi$ r : V r $\to$ W r + $\delta$, for all r $\in$ R such that the following diagram commutes:

![image 8](<PH-REF/imageFile8.png>)

/

/

"

"

"

"

/

/

+

+

+

+

$$
T h a t \text{is, for all} r \leqslant s, \, \phi_{s} \circ v_{s}^{r} = w_{s + \delta}^{r + \delta} \circ \phi_{r}.
$$

An important example of homomorphism of degree $\delta$ is the shift endomorphism 1 $\delta$ V which consists of the families of linear maps $\varphi$ r = v r r + $\delta$. Notice also that homomorphisms of persistence modules can naturally be composed: the composition of a homomorphism Ψ of degree $\delta$ between U and V and a homomorphism $\Phi$ of degree $\delta$ between V and W naturally gives rise to a homomorphism $\Phi$Ψ of degree $\delta$ + $\delta$ between U and W.

Definition 5.2. Let $\delta$ 0. Two persistence modules V, W are $\delta$ -interleaved if there exists two homomorphism of degree $\delta$, $\Phi$, from V to W and Ψ, from W to V such that Ψ$\Phi$ = 1 2 $\delta$ V and $\Phi$Ψ = 1 2 $\delta$ W.

![image 9](<PH-REF/imageFile9.png>)

-

+

+

+

/

/

/

/

+

-

=

=

=

=

-

+

-

-

!

!

!

!

-

+

/

/

/

/

+

-

-

+

Although it does not define a metric on the space of persistence modules, the notion of closeness between two persistence modules may be defined as the smallest non negative $\delta$ such that they are $\delta$ -interleaved. Moreover, it allows to formalize the following fundamental result.

Theorem 5.3 (Stability of Persistence). Let V and W be two q-tame persistence modules. If V and W are $\delta$ -interleaved for some $\delta$ 0, then

$$
d_{b} ( d g m ( V ), d g m ( W ) ) \leqslant \delta.
$$

Proof.

$$
\begin{aligned}
P r o f. \, \text{See} [ \text{CdSGO116} ]. & & \Box
\end{aligned}
$$

Remark 5.4. One can actually show that there is an isometry between q-tame persistence modules a purely algebraic construction —, and persistence diagrams points above the diagonal [CdSGO16]. Indeed, defining the interleaving distance as

$$
d_{i} ( V, W ) = \inf \left \{\delta > 0 | V \text{and} W \text{are} \delta \text{-interleaved} \right \},
$$

we have, for all q-tame persistence modules V and W,

$$
d_{b} ( d g m ( V ), d g m ( W ) ) = d_{i} ( V, W ).
$$

### 5.2. Stability for Functions

Although purely algebraic and rather abstract, this result is an efficient tool to easily establish concrete stability results such as the following.

Definition 5.5 (q-Tame Function). Let f : M $\to$ R be a real-valued functions defined on a topological space M. We say that f is q-tame if the sublevel sets filtrations of f induces a q-tame module at the homology level.

Proposition 5.6. If f : M $\to$ R is continuous and M is finitely triangulable (i.e. homeomorphic to a finite simplicial complex), then f is q-tame.

Proof. Fpr simplicity, let us write M r = f − 1 (( −∞,r ]), for r $\in$ R. For all b < c, we must show that H ( M b ) $\to$ H ( M c ) has finite rank. Begin with any finite triangulation of M, and subdivide it repeatedly until no simplex meets both f − 1 ( b ) and f − 1 ( c ). If we define K to be the union of the closed simplices which meet M b, then we have

$$
M_{b} \subset \mathcal{K} \subset M_{c},
$$

and hence the factorization

$$
H ( M_{b} ) \rightarrow H ( \mathcal{K} ) \rightarrow H ( M_{c} ).
$$

Since K is (a geometric realization of) a finite simplicial complex, H ( K ) is finite dimensional and so H ( M b ) $\to$ H ( M c ) has finite rank.

Theorem 5.7. Let f,g : M $\to$ R be q-tame. Then for any integer k,

$$
d_{b} ( d g m_{k} ( f ), d g m_{k} ( g ) ) \leqslant \| f - g \|_{\infty} = \sup_{x \in M} | f ( x ) - g ( x ) |
$$

where dgm k ( f ) (resp. dgm k ( g ) ) is the persistence diagram of the persistence module ( H k ( f − 1 ( −∞,r ])) | r $\in$ R ) (resp. ( H k ( g − 1 ( −∞,r ])) | r $\in$ R ) ) where the linear maps are the one induced by the canonical inclusion maps between sublevel sets.

Proof. Denoting $\delta$ = f − g ∞ we have that for any r $\in$ R, f − 1 ( −∞,r ]) $\subset$ g − 1 ( −∞,r + $\delta$ ]) and g − 1 ( −∞,r ]) $\subset$ f − 1 ( −∞,r + $\delta$ ]). This interleaving between the sublevel sets of f induces a $\delta$ -interleaving between the persistence modules at the homology level and the result follows from the direct application of Theorem 5.3.

### 5.3. Stability for Spaces

It sometimes occurs in that one has to compare data sets that are not sampled from the same ambient space. Fortunately, the notion of Hausdorff distance can be generalized to the comparison of any pair of compact metric spaces, giving rise to the notion of Gromov-Hausdorff distance.

Two compact metric spaces ( M 1,$\rho$ 1 ) and ( M 2,$\rho$ 2 ) are isometric if there exists a bijection $\varphi$ : M 1 $\to$ M 2 that preserves distances, i.e. $\rho$ 2 ( $\varphi$ ( x ),$\varphi$ ( y )) = $\rho$ 1 ( x,y ) for any x,y $\in$ M 1. The Gromov-Hausdorff distance measures how far two metric space are from being isometric.

Definition 5.8. The Gromov-Haudorff distance d GH ( M 1,M 2 ) between two compact metric spaces is the infimum of the real numbers r 0 such that there exists a metric space ( M,$\rho$ ) and two compact subspaces C 1,C 2 $\subset$ M that are isometric to M 1 and M 2 and such that d H ( C 1,C 2 ) r.

Theorem 5.3 also implies a stability result for the persistence diagrams of filtrations built on top of data.

Theorem 5.9. Let X and Y be two compact metric spaces and let Filt( X ) and Filt( Y ) be the Vietoris-Rips of ˇ Cech filtrations built on top X and Y. Then

$$
d_{b} \left ( d g m ( F i l t ( X ) ), d g m ( F i l t ( Y ) ) \right ) \leqslant 2 \, d_{G H} ( X, Y ),
$$

where dgm(Filt( X )) and dgm(Filt( Y )) denote the persistence diagram of the filtrations Filt( X ) and Filt( X ).

Proof. See [CdSO14, Theorem 5.2].

glyph[square]

Remark 5.10. (i) This bound is worst-case tight. Indeed, take X = { 0, 1 } $\subset$ R and Y = { 0, 1 + 2 $\varepsilon$ }, for $\varepsilon$ > 0 (see Figure 6a). Then d GH ( X, Y ) = $\varepsilon$, dgm 0 (Filt( X )) = { (0, ∞ ), (0, 1) } and dgm 0 (Filt( Y )) = { (0, ∞ ), (0, 1 + 2 $\varepsilon$ ) }, so that

d b (dgm 0 (Filt( X )), dgm 0 (Filt( Y ))) = $\varepsilon$ = 2d GH ( X, Y ).

![image 10](<PH-REF/imageFile10.png>)

(

A,B )

)

Figure 5. The Gromov-Hausdorff distance between A,B $\subset$ R 2. A can been rotated this is an isometric embedding of A in the plane to reduce its Hausdorff distance to B. As a consequence, d GH ( A,B ) < d H ( A,B ) in this case.

![The image depicts a geometric figure consisting of a triangle and a line segment. The triangle is positioned at the bottom of the image, with the line segment extending upwards and to the right. The line segment is labeled as x and is positioned at the top of the image. The triangle is a right-angled triangle, meaning that the right angle is at the top of the triangle. The base of the triangle is labeled as y and is located at the bottom of the image. The height of the triangle is labeled as y and is located at the top of the image. The line segment x is positioned at the top of the image, and the line segment y is positioned at the bottom of the image. The line segment x is a straight line, while the line segment y is a curved line. The image is a simple geometric figure, with no additional objects or details. The line segments and their](<PH-REF/imageFile11.png>)

=

=

=

1 + 2 $\varepsilon$

=

(a)

(b)

Figure 6. Discussion on the tightness of Theorem 5.9.

(ii) In general, this is only an upper bound. Indeed, write

$$
X = \{( 0, 0 ), ( 1, 0 ), ( 1 / 2, \sqrt{3} / 2 ) \} \subset R^{2}
$$

\text { and } Y = \{ - 1, 0, 1 \} \ ( \text {see Figure 6b} ). \text { Then } d _ { G H } ( X, Y ) = 1 / 2, \text { while}
$$
\deg_{0} ( F i l t ( X ) ) = \{( 0, \infty ), ( 0, 1 ), ( 0, 1 ) \} = \deg_{0} ( F i l t ( Y ) ),
$$

so that

$$
d_{b} \left ( d g m_{0} ( F i l t ( X ) ), d g m_{0} ( F i l t ( Y ) ) \right ) = 0.
$$

- (iii) The proofs never use the triangle inequality! The previous approach and results easily extend to other settings like, e.g. spaces endowed with a similarity measure.
- (iv) As we already noticed in Example 2.3, the persistence diagrams can be interpreted as multiscale topological features of X and Y. In addition, Theorem 5.9 tells us that these features are robust with respect to perturbations of the data in the Gromov-Hausdorff metric.

## 6. Rates of Convergence for Random Point Clouds

Persistence homology by itself does not take into account the random nature of data and the intrinsic variability of the topological quantity they infer. We now present a statistical approach to persistent homology, which means that we consider data as generated from an unknown distribution.

### 6.1. Minimax Upper Bound

Assume that we observe an i.i.d. n -sample X n = { X 1,...,X n } in a metric space ( M,$\rho$ ) drawn from an unknown probability measure $\mu$, whose support is a compact set denoted by X $\mu$.

Let Filt( X $\mu$ ) and Filt( X ) be two filtrations defined on X $\mu$ and X. Starting from Theorem 5.9, a natural strategy for estimating the persistent homology of Filt( X $\mu$ ) is to consider that of Filt( X ), where X is an estimator of X $\mu$, meaning that d GH ( X $\mu$, X ) is small.

Remark 6.1. Note that in some cases the space M can be unknown and the observations X 1...,X n are then only known through their pairwise distances ( $\rho$ ( X i,X j )) 1 i,j n. The use of the Gromov-Hausdorff distance allows us to consider this set of observations as an abstract metric space of cardinality n, independently of the way it is embedded in M.

Definition 6.2 (( a,b )-Standard Measure). The distribution $\mu$ is said to be ( a,b ) -standard if for all x $\in$ supp( $\mu$ ) and all r 0,

$$
\mu \left ( B ( x, r ) \right ) \geqslant \min ( a r^{b}, 1 ).
$$

The finite set X n := { X 1,...,X n } is a natural estimator of the support X $\mu$. In several contexts discussed in the following, X n shows optimal rates of convergence to X $\mu$ with respect to the Hausdorff distance. A slight variant of this assumption has already been used in the previous lessons.

Definition 6.3 (Statistical Model). We let P M,a,b denote the set of Borel probability distributions $\mu$ over ( M,$\rho$ ) such that

– X $\mu$ = supp $\mu$ is compact;

$\mu$ is ( a,b )-standard.

-$\mu$ is ( a, b

The following result gives an upper bound for the rate of convergence of persistence diagrams for ( a,b )-standard measures.

Theorem 6.4. If $\mu$ is ( a,b ) -standard on ( M,$\rho$ ), then :

- (i) For all $\varepsilon$ > 0,

$$
P \left ( d_{b} \left ( d g m ( F i l t ( X_{\mu} ) ), d g m ( F i l t ( X_{n} ) ) \right ) > \varepsilon \right ) \leqslant \min \left ( \frac{2^{b}}{a \varepsilon^{b}} \exp ( - n a \varepsilon^{b} ), 1 \right ).
$$

- (ii) For n large enough,

$$
\sup_{\mu \in \mathcal{P}_{M, a, b}} E_{\mu} \left [ d_{b} ( d g m ( F i l t ( X_{\mu} ) ), d g m ( F i l t ( X_{n} ) ) ) \right ] \leqslant C_{a, b} \left ( \frac{\log n}{n} \right )^{1 / b}.
$$

Proof. To get (i), we apply the stability of persistence for spaces Theorem 5.9 to get

$$
\begin{aligned}
P \left( d_b \left( \mathrm{dgm}(\mathrm{Filt}(X_\mu)), \mathrm{dgm}(\mathrm{Filt}(\widehat{X}_n)) \right) > \varepsilon \right)
&\leq P \left( d_{GH}(X_\mu, X_n) > \varepsilon/2 \right) \\
&\leq P \left( d_H(X_\mu, X_n) > \varepsilon/2 \right) \\
&\leq \min \left( \frac{2^b}{a \varepsilon^b} \exp(- n a \varepsilon^b), 1 \right),
\end{aligned}
$$

where the last inequality follows from a packing argument, as already detailed in the previous lessons. Moving to the proof of (ii), we use Fubini’s theorem to write

$$
E_{\mu^{n}} \left [ d_{b} ( d g m ( F i l t ( X_{\mu} ) ), d g m ( F i l t ( X_{n} ) ) ) \right ] \\ = \int_{0}^{\infty} P \left ( d_{b} ( d g m ( F i l t ( X_{\mu} ) ), d g m ( F i l t ( X_{n} ) ) ) > \varepsilon \right ) d \varepsilon.
$$

Let $\varepsilon$ n = 4 log n an 1 /b. By bounding the probability inside this integral by one on [0,$\varepsilon$ n ], we get

$$
\text{on} [ 0, \varepsilon_{n} ], \text{we get} \\ E_{\mu^{n}} \left [ d_{b} ( d g m ( F i l t ( X_{\mu} ) ), d g m ( F i l t ( \widehat{X}_{n} ) ) ) \right ] \\ \leqslant \varepsilon_{n} + \int_{\varepsilon_{n}}^{\infty} \frac{8^{b}}{a} \exp ( - n a \varepsilon^{b} / 4^{b} ) d \varepsilon \\ \leqslant \varepsilon_{n} + \frac{4 n 2^{b}}{b} ( n a )^{- 1 / b} \int_{\log n}^{\infty} u^{1 / b - 2} \exp ( - u ) d u. \\ \text{now distinguish two cases.}
$$

We now distinguish two cases.

If b glyph[greaterorequalslant] 1 2 : then u 1 /b -2 glyph[lessorequalslant] (log n ) 1 /b -2 for all u glyph[greaterorequalslant] log n and then

$$
\begin{aligned}
E \left [ d_{b} ( d g m ( \text{Filt} ( X_{\mu} ) ), d g m ( \text{Filt} ( \widehat{X}_{n} ) ) ) \right ] & \leqslant \varepsilon_{n} + 4 \frac{2^{b}}{b} \left ( \frac{\log n}{n} \right )^{1 / b} ( \log n )^{- 2} \\ & \leqslant C_{a, b} \left ( \frac{\log n}{n} \right )^{1 / b},
\end{aligned}
$$

where C a,b only depends only a and b.

If 0 < b < 1 2 : we let p := 1 /b and u n := log n. Using iterated integrations by parts yields

$$
\begin{aligned}
\int_{u_n}^{\infty} u^{1/b - 2} \exp(-u)\, du
&= u_n^{1/b - 2} \exp(-u_n) + \left(\frac{1}{b} - 2\right) u_n^{1/b - 3} \exp(-u_n) + \cdots \\
&\quad + \prod_{i=2}^{p} \left(\frac{1}{b} - i\right) u_n^{1/b - p} \exp(-u_n)
+ \int_{\log n}^{\infty} u^{1/b - p - 1} \exp(-u)\, du \\
&\leqslant C_{a,b}' \frac{(\log n)^{1/b - 2}}{n},
\end{aligned}
$$

where $C_{a,b}'$ depends only on $a$ and $b$.

where C a,b only depends only a and b.

Thus, the expected loss bound holds for all b > 0, yielding the result.

glyph[square]

**6.2. Minimax Lower Bound.** Let us recall Le Cam’s Lemma.

Lemma 6.5 (Le Cam). Let Q be a set of probability distributions, and $\theta$ : Q $\to$ Θ be a parameter of interest, where (Θ, ) is a metric space. Then for all Q,Q $\in$ Q,

$$
\inf_{\hat{\theta}} \sup_{Q \in \mathcal{Q}} E_{Q^{n}} \ell ( \theta ( Q ), \hat{\theta}_{n} ) \geq \frac{1}{2} \ell \left ( \theta ( Q ), \theta ( Q^{\prime} ) \right ) \left ( 1 - T V ( Q, Q^{\prime} ) \right )^{n},
$$

where ˆ $\theta$ n = ˆ $\theta$ n ( X 1,...,X n ) ranges among all the measurable maps ˆ $\theta$ n : X n $\to$ Θ based on an i.i.d. n -sample.

Theorem 6.6. Assume that there exists a non isolated point x in M and consider any sequence ( x n ) n ∈ ( M \ { x } ) N such that ρ ( x,x n ) ( an ) − 1 /b. Then for all estimator dgm n = dgm n ( X 1,...,X n ),

$$
\liminf_{n \to \infty} \rho ( x, x_{n} )^{- 1} \sup_{\mu \in \mathcal{P}_{M, a, b}} E_{\mu^{n}} \left [ d_{b} ( d g m ( \text{Filt} ( X_{\mu} ) ), \widehat{d g m}_{n} ) \right ] \geqslant e^{- 1} / 4.
$$

Remark 6.7. Consequently, the estimator dgm(Filt( X n )) is minimax optimal on the space P M,a,b up to a logarithmic term as soon as we can find a non-isolated point in M and a sequence ( x n ) in M such that $\rho$ ( x n,x ) ∼ ( an ) − 1 /b. This is obviously the case for the Euclidean space R d.

Proof. We will apply Le Cam’s lemma with model Q = P M,a,b, parameter of interest $\theta$ ( $\mu$ ) = dgm(Filt( X $\mu$ )) in the space Θ of persistence diagrams of q-tame modules endowed with distance = d b.

To prove the lower bound, it will be sufficient to consider two Dirac distributions. We let $\mu$ 0 = $\delta$ x be the Dirac distribution on X 0 := { x }. It is clear that $\mu$ 0 $\in$ P M,a,b. Let $\mu$ 1,n be the distribution 1 n $\delta$ x n + (1 − 1 n ) $\mu$ 0. The support of $\mu$ 1,n is denoted X 1,n := { x,x n }. Note that for all n 2 and r $\rho$ ( x,x n ),

$$
\mu_{1, n} \left ( B ( x, r ) \right ) = 1 - \frac{1}{n} \geqslant \frac{1}{2} \geqslant \frac{1}{2 \rho ( x, x_{n} )^{b}} r^{b} \geqslant a r^{b}
$$

and

$$
\mu_{1, n} \left ( B ( x_{n}, r ) \right ) = \frac{1}{n} = \frac{1}{n \rho ( x, x_{n} )^{b}} r^{b} \geqslant a r^{b}.
$$

Moreover, for r > $\rho$ ( x,x n ), $\mu$ 1,n (B( x,r )) = $\mu$ 1,n (B( x n,r )) = 1. Thus, for all r > 0 and x $\in$ X 1,n,

$$
\mu_{1, n} \left ( B ( x, r ) \right ) \geqslant \min \{a r^{b}, 1 \},
$$

meaning that $\mu$ 1,n belongs to P M,a,b.

The probability measure $\mu$ 0 is absolutely continuous with respect to $\mu$ 1,n and the density of $\mu$ 0 with respect to $\mu$ 1,n is p 0,n := n n − 1 { x }. Then

$$
\text{the probability measure} \mu_{0} \text{is absolutely continuous with respect to} \\ \text{the density of} \mu_{0} \text{with respect to} \mu_{1, n} \text{is} p_{0, n} \colon = \frac{n}{n - 1} I_{\{x \}}. \text{Then} \\ \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \text{} \
$$

so that (1 -TV( $\mu$ 0, $\mu$ 1,n )) n = ( 1 -1 n ) n $\to$ e -1 as n goes to infinity.

It remains to compute d b (dgm(Filt( X 0 )), dgm(Filt( X 1,n ))). For both X 0 and X 1,n, notice that the diagrams induced by the Rips and ˇ Cech filtrations are equal and that these diagrams are non-trivial only for the 0-dimensional homology. Furthermore, dgm 0 (Filt( X 0 )) is the singleton { (0, + ∞ ) }. On the other hand, dgm 0 (Filt( X 1,n )) = { (0, ∞ ), (0, $\rho$ ( x, x n )) }. Thus,

$$
\begin{aligned}
d_{b} ( d g m ( F i l t ( X_{0} ) ), d g m ( F i l t ( X_{1, n} ) ) ) & = \min_{p \in \Delta} \| p - ( 0, \rho ( x, x_{n} ) ) \
\end{aligned}
$$

| _ { \infty }
$$
\begin{aligned}
\\ & = \frac{\rho ( x, x_{n} )}{2}.
\end{aligned}
$$

| _ { \infty }
$$
^{2}
$$

The proof is then complete using Le Cam’s lemma (Lemma 6.5).

## 7. Persistence Landscapes

Persistence landscapes have been introduced in [Bub15] as an alternative representation of persistence diagrams. This approach aims at representing the topological information encoded in persistence diagrams as elements of an Hilbert space, for which statistical learning methods can be directly applied.

### 7.1. Construction

The persistence landscape is a collection of continuous, piecewise linear functions $\lambda$ : N $\times$ R $\to$ R that summarizes a persistence diagram dgm (see Figure 7). The landscape is defined by considering the set of tent functions at each point p = ( x,y ) = $\alpha$ birth + $\alpha$ death 2, $\alpha$ death − $\alpha$ birth 2 representing a birth-death pair ( $\alpha$ birth,$\alpha$ death ) $\in$ dgm as follows:

![The image is a diagram, which consists of a graph with two axes labeled as x and y. The graph is a line graph, and it is drawn with a dashed line. The x-axis is labeled as x and the y-axis is labeled as y. The graph has two points labeled as A and B. Point A is located at the left side of the graph, and point B is located at the right side of the graph. The graph is connected by a dashed line, which is labeled as t. The dashed line is drawn from point A to point B.](<PH-REF/imageFile12.png>)

$$
\Lambda_p(t) = \begin{cases}
t - x + y & t \in [x-y,\, x], \\
x + y - t & t \in \left(x,\, x+y\right], \\
0 & \text{otherwise},
\end{cases}
= \begin{cases}
t - \alpha_{\mathrm{birth}} & t \in \left[\alpha_{\mathrm{birth}},\, \alpha_{\mathrm{birth}} + \tfrac{\alpha_{\mathrm{death}}}{2}\right], \\
\alpha_{\mathrm{death}} - t & t \in \left(\alpha_{\mathrm{birth}} + \tfrac{\alpha_{\mathrm{death}}}{2},\, \alpha_{\mathrm{death}}\right], \\
0 & \text{otherwise}.
\end{cases}
$$

Figure 7. An example of persistence landscape (right) associated to a persistence diagram (left). The first landscape is in blue, the second one in red and the last one in orange. All the other landscapes are zero.

The persistence landscape of dgm is a summary of the arrangement of the tents display obtained by overlaying the graphs of the functions { $\Lambda$ p } p $\in$ dgm.

Definition 7.1 (Landscape of a Diagram). The persistence landscape of a diagram dgm is the collection of functions, indexed by k $\in$ N, and defined by

$$
\lambda_{d g m} ( k, t ) = \kmax_{p \in d g m} \Lambda_{p} ( t ), \ \ t \in [ 0, T ],
$$

where kmax is the k th largest value in the set; in particular, 1max is the usual maximum function.

Given k $\in$ N, the function $\lambda$ dgm ( k,. ) : R $\to$ R is called the k -th landscape of dgm. It is not difficult to see that the map that associate to each persistence diagram its corresponding landscape is injective. In other words, formally no information is lost when a persistence diagram is represented through its persistence landscape.

The advantage of the persistence landscape representation is two-fold:

- (i) Persistence diagrams are represented as elements of a function space, opening the door to the use of a broad variety of statistical and data analysis tools for further processing of topological features.
- (ii) Second, and fundamental from a theoretical perspective, the persistence landscapes share the same stability properties as persistence diagrams (see Section 5).

Proposition 7.2 (Basic Properties of Landscapes). For all k 0,

(i) $\lambda$ dgm ( k, $\cdot$ ) $\lambda$ dgm ( k + 1, $\cdot$ ) 0, (ii) $\lambda$ dgm ( k, $\cdot$ ) is 1 -Lipschitz.

Proof.

$$
\begin{aligned}
P r o f. \, \text{See [Bub1 5, Lemma 4].} &. & \Box
\end{aligned}
$$

### 7.2. Stability

From the definition of persistence landscape, we immediately observe that $\lambda$ ( k, $\cdot$ ) is one-Lipschitz and thus similar stability properties are satisfied for the landscapes as for persistence diagrams.

Theorem 7.3 (Stability of Landscapes). Let dgm 1 and dgm 2 be two q-tame diagrams. Then for all k 0,

$$
\left \| \lambda_{d g m_{1}} ( k, \cdot ) - \lambda_{d g m_{2}} ( k, \cdot ) \right \|_{\infty} \leqslant d_{b} ( d g m_{1}, d g m_{2} ).
$$

Proof.

$$
\begin{aligned}
P r o f. \, \text{See [Bub1 5, Theorem 17].} & & \Box
\end{aligned}
$$

Remark 7.4. In particular, Theorem 7.3 allows to derive a stability result for landscapes associated to:

- (i) filtrations of functions, from Theorem 5.7;
- (ii) Rips and ˇ Cech filtrations of a metric space, from Theorem 5.9.

### 7.3. Central Tendency for Persistent Homology

The space of persistence diagrams being not an Hilbert space, the definition of a mean persistence diagram is not obvious and unique. One first approach to define a central tendency in this context is to define a Fréchet mean in this context. Indeed it has been proved in [TMMH14] that the space of persistence diagrams is a Polish space. However they are may not be unique and there are very difficult to compute in practice. To overcome the problem of computational costs, sampling strategies can be proposed to compute topological signatures based on persistence landscapes. Given a large point cloud, the

idea is to extract many subsamples, to compute the landscape for each subsample and then to combine the information. T

We assume that the diameter of M is finite and upper bounded by 2, where T is the same constant as in the definition of persistence landscapes in Section 7.1. For ease of exposition, we focus on the case k = 1, and set $\lambda$ ( t ) = $\lambda$ (1,t ). However, the results we present in this section hold for k > 1.

For any positive integer m, let X = { x 1, $\cdot \cdot \cdot$ ,x m } $\subset$ X $\mu$ be a sample of m points from $\mu$. The corresponding persistence landscape is $\lambda$ X and we denote by Ψ m $\mu$ the measure induced by $\mu \otimes$ m on the space of persistence landscapes. Note that the persistence landscape $\lambda$ X can be seen as a single draw from the measure Ψ m $\mu$. The point-wise expectations of the (random) persistence landscape under this measure is defined by E Ψ m $\mu$ [ $\lambda$ X ( t )],t $\in$ [0,T ]. The average landscape E Ψ m $\mu$ [ $\lambda$ X ] has a natural empirical counterpart, which can be used as its unbiased estimator. Let S m 1,...,S m be independent samples of size m from $\mu \otimes$ m. We define the empirical average landscape as

$$
\overline{\lambda_{\ell}^{m}} ( t ) = \frac{1}{b} \sum_{i = 1}^{b} \lambda_{S_{i}^{m}} ( t ), \quad \text{for all} t \in [ 0, T ],
$$

and propose to use $\lambda$ m to estimate $\lambda$ X $\mu$.

Remark 7.5. (i) Note that computing the persistent homology of X n is O (exp( n )), whereas computing the average landscape is O ( b exp( m )).

(ii) Another motivation for this subsampling approach is that it can be also applied when $\mu$ is a discrete measure with support X N = { x 1,...,x N } $\subset$ M. This framework can be very common in practice, when a continuous (but unknown measure) is approximated by a discrete uniform measure $\mu$ N on X N.

The average landscape E Ψ m $\mu$ [ $\lambda$ X ] is an interesting quantity on its own, since it carries some stable topological information about the underlying measure $\mu$, from which the data are generated. In particular, we can compare the average landscapes corresponding to two measures that are close to each other in the Wasserstein metric. The average behavior of the landscapes of sets of m points sampled according to any measure $\mu$ is stable with respect to the Wasserstein distance:

Theorem 7.6. Let X ∼ $\mu \otimes$ m and Y ∼ $\nu \otimes$ m, where $\mu$ and $\nu$ are two probability measures on M. For any p 1 we have

$$
\left \| E_{\Psi_{\mu}^{m}} [ \lambda_{X} ] - E_{\Psi_{\nu}^{m}} [ \lambda_{Y} ] \right \|_{\infty} \leqslant 2 m^{\frac{1}{p}} \ W_{p} ( \mu, \nu ),
$$

 where W p stands for the p th Wasserstein distance on M, defined by

$$
W_{p} ( \mu, \nu ) = \inf_{\pi \in \Pi ( \mu, \nu )} \left ( \int_{M \times M} \rho ( x, y )^{p} \pi ( d x, d y ) \right )^{\frac{1}{\frac{p}{p}}},
$$

where Π( $\mu$,$\nu$ ) is the set of probability measures on M $\times$ M with marginal distributions $\mu$ and $\nu$,

$$
\begin{aligned}
\text{See} [ \text{CFL}^{+} 1 5, \text{Thereom 5} ] & & \Box
\end{aligned}
$$

Proof. See [CFL +

Remark 7.7. (i) For measures that are not defined on the same metric space, the inequality of Theorem 7.6 can be extended, to the condition of using the so-called Gromov-Wasserstein metric, and writes as

$$
\left \| E_{\Psi_{\mu}^{m}} [ \lambda_{X} ] - E_{\Psi_{\nu}^{m}} [ \lambda_{Y} ] \right \|_{\infty} \leqslant 2 m^{\frac{1}{p}} G W_{\rho, p} ( \mu, \nu ).
$$

 (ii) The result of Theorem 7.6 is useful for two reasons. First, it tells us that for a fixed m, the expected ”topological behavior” of a set of m points carries some stable information about the underlying measure from which the data are generated. Second, it provides a lower bound for the Wasserstein distance between two measures, based on the topological signature of samples of m points.

## 8. Further Sources

These notes mainly follow [CM17], [BCY18] and [CGLM15].
