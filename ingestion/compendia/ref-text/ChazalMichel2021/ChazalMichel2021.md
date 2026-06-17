[Page 1]

# An introduction to Topological Data Analysis: fundamental and practical aspects for data scientists

Frédéric Chazal and Bertrand Michel

February 26, 2021

# Abstract

Topological Data Analysis ( tda ) is a recent and fast growing ﬁeld providing a set of new topological and geometric tools to infer relevant features for possibly complex data. This paper is a brief introduction, through a few selected topics, to basic fundamental and practical aspects of tda for non experts.

# 1 Introduction and motivation

Topological Data Analysis ( tda ) is a recent ﬁeld that emerged from various works in applied (algebraic) topology and computational geometry during the ﬁrst decade of the century. Although one can trace back geometric approaches for data analysis quite far in the past, tda really started as a ﬁeld with the pioneering works of Edelsbrunner et al. (2002) and Zomorodian and Carlsson (2005) in persistent homology and was popularized in a landmark paper in 2009 Carlsson (2009). tda is mainly motivated by the idea that topology and geometry provide a powerful approach to infer robust qualitative, and sometimes quantitative, information about the structure of data see, e.g. Chazal (2017).

tda aims at providing well-founded mathematical, statistical and algorithmic methods to infer, analyze and exploit the complex topological and geometric structures underlying data that are often represented as point clouds in Euclidean or more general metric spaces. During the last few years, a considerable eﬀort has been made to provide robust and eﬃcient data structures and algorithms for tda that are now implemented and available and easy to use through standard libraries such as the Gudhi library 1 (C++ and Python) Maria et al. (2014) and its R software interface Fasy et al. (2014a), Dionysus 2 , PHAT 3 , DIPHA 4 , or Giotto 5 . Although it is still rapidly evolving, tda now provides a set of mature and eﬃcient tools that can be used in combination or complementary to other data sciences tools.

The tda pipeline. tda has recently known developments in various directions and application ﬁelds. There now exist a large variety of methods inspired by topological and geometric approaches. Providing a complete overview of all these existing approaches is beyond the scope of this introductory survey. However, many standard ones rely on the following basic pipeline that will serve as the backbone of this paper:

1. The input is assumed to be a ﬁnite set of points coming with a notion of distance or similarity between them. This distance can be induced by the metric in the ambient space (e.g. the Euclidean metric when the data are embedded in R d ) or come as an intrinsic

1 https://gudhi.inria.fr/ 2

http://www.mrzv.org/software/dionysus/ 3

https://bitbucket.org/phat-code/phat 4

https://github.com/DIPHA/dipha 5

https://giotto-ai.github.io/gtda-docs/0.4.0/library.html

[Page 2]

metric deﬁned by a pairwise distance matrix. The deﬁnition of the metric on the data is usually given as an input or guided by the application. It is however important to notice that the choice of the metric may be critical to reveal interesting topological and geometric features of the data.

- 2. A “continuous” shape is built on top of the data in order to highlight the underlying topology or geometry. This is often a simplicial complex or a nested family of simplicial complexes, called a ﬁltration, that reﬂects the structure of the data at diﬀerent scales. Simplicial complexes can be seen as higher dimensional generalizations of neighboring graphs that are classically built on top of data in many standard data analysis or learning algorithms. The challenge here is to deﬁne such structures that are proven to reﬂect relevant information about the structure of data and that can be eﬀectively constructed and manipulated in practice.
- 3. Topological or geometric information is extracted from the structures built on top of the data. This may either results in a full reconstruction, typically a triangulation, of the shape underlying the data from which topological/geometric features can be easily extracted or, in crude summaries or approximations from which the extraction of relevant information requires speciﬁc methods, such as e.g. persistent homology. Beyond the identiﬁcation of interesting topological/geometric information and its visualization and interpretation, the challenge at this step is to show its relevance, in particular its stability with respect to perturbations or presence of noise in the input data. For that purpose, understanding the statistical behavior of the inferred features is also an important question.
- 4. The extracted topological and geometric information provides new families of features and descriptors of the data. They can be used to better understand the data in particular through visualizationor they can be combined with other kinds of features for further analysis and machine learning tasks. These information can also be used to design well-suited data analysis and machine learning models. Showing the added-value and the complementarity (with respect to other features) of the information provided by tda tools is an important question at this step.


tda and statistics. Until quite recently, the theoretical aspects of TDA and topological inference mostly relied on deterministic approaches. These deterministic approaches do not take into account the random nature of data and the intrinsic variability of the topological quantity they infer. Consequently, most of the corresponding methods remain exploratory, without being able to eﬃciently distinguish between information and what is sometimes called the "topological noise".

A statistical approach to TDA means that we consider data as generated from an unknown distribution, but also that the inferred topological features by TDA methods are seen as estimators of topological quantities describing an underlying object. Under this approach, the unknown object usually corresponds to the support of the data distribution (or part of it). The main goals of a statistical approach to topological data analysis can be summarized as the following list of problems:

Topic 1: proving consistency and studying the convergence rates of TDA methods.

Topic 2: providing conﬁdence regions for topological features and discussing the signiﬁcance of the estimated topological quantities.

Topic 3: selecting relevant scales at which the topological phenomenon should be considered, as a function of observed data.

Topic 4: dealing with outliers and providing robust methods for TDA.

[Page 3]

Applications of tda in data science. On the application side, many recent promising and successful results have demonstrated the interest of topological and geometric approaches in an increasing number of ﬁelds such has, e.g., material science Kramar et al. (2013); Nakamura et al. (2015) 3D shape analysis Skraba et al. (2010); Turner et al. (2014b), image analysis Qaiser et al. (2019); Rieck et al. (2020), multivariate time series analysis Khasawneh and Munch (2016); Seversky et al. (2016); Umeda (2017), medicine Dindin et al. (2020), biology Yao et al. (2009) , genomic Carrière and Rabadán (2020) chemistry Lee et al. (2017) or sensor networks De Silva and Ghrist (2007) to name a few. It is beyond the scope to give an exhaustive list of applications of tda . On another hand, most of the successes of tda result from its combination with other analysis or learning techniques see Section 6.5 for a discussion and references. So, clarifying the position and complementarity of tda with respect to other approaches and tools in data science is also an important question and an active research domain.

The overall objective of this survey paper is two-fold. First, it intends to provide data scientists with a brief and comprehensive introduction to the mathematical and statistical foundations of tda . For that purpose, the focus is put on a few selected, but fundamental, tools and topics: simplicial complexes (Section 2) and their use for exploratory topological data analysis (Section 3), geometric inference (Section 4) and persistent homology theory (Section 5) that play a central role in tda . Second, this paper also aims at demonstrating how, thanks to the recent progress of software, tda tools can be easily applied in data science. In particular, we show how the Python version of the Gudhi library allows to easily implement and use the tda tools presented in this paper (Section 7). Our goal is to quickly provide the data scientist with a few basic keys and relevant references to get a clear understanding of the basics of tda to be able to start to use tda methods and software for his own problems and data.

# 2 Metric spaces, covers and simplicial complexes

As topological and geometric features are usually associated to continuous spaces, data represented as ﬁnite sets of observations, do not directly reveal any topological information per se. A natural way to highlight some topological structure out of data is to “connect” data points that are close to each other in order to exhibit a global continuous shape underlying the data. Quantifying the notion of closeness between data points is usually done using a distance (or a dissimilarity measure), and it often turns out to be convenient in tda to consider data sets as discrete metric spaces or as samples of metric spaces.

Metric spaces. Recall that a metric space ( M,ρ ) is a set M with a function ρ : M × M → R + , called a distance, such that for any x,y,z ∈ M :

- i) ρ ( x,y ) ≥ 0 and ρ ( x,y ) = 0 if and only if x = y ,
- ii) ρ ( x,y ) = ρ ( y,x ) and,
- iii) ρ ( x,z ) ≤ ρ ( x,y ) + ρ ( y,z ) .


Given a a metric space ( M,ρ ) , the set K ( M ) of its compact subsets can be endowed with the socalled Hausdorﬀ distance : given two compact subsets A,B ⊆ M the Hausdorﬀ distance d H ( A,B ) between A and B is deﬁned as the smallest non negative number δ such that for any a ∈ A there exists b ∈ B such that ρ ( a,b ) ≤ δ and for any b ∈ B , there exists a ∈ A such that ρ ( a,b ) ≤ δ see Figure 1. In other words, if for any compact subset C ⊆ M , we denote by d ( .,C ) : M → R + the distance function to C deﬁned by d ( x,C ) := inf c ∈ C ρ ( x,c ) for any x ∈ M , then one can prove that the Hausdorﬀ distance between A and B is deﬁned by any of the two following equalities:

$$
d _ { H } ( A , B ) \ & = \ \max _ { b \in B } \{ \sup _ { a \in A } d ( b , A ) , \sup _ { a \in A } d ( a , B ) \} \\ & = \ \sup _ { x \in M } \left | d ( x , A ) - d ( x , B ) \right | = \| d ( . , A ) - d ( . , B ) \| _ { \infty }
$$

[Page 4]

![In the image there are two triangles, one of which is a right triangle with one angle measuring 90 degrees. The two triangles are labeled as ABC and BAD. The lengths of the two sides of the ABC triangle are 2 and 10, and the length of the hypotenuse of the BAD triangle is 10. The lengths of the two segments of the ABC triangle are 2 and 10, and the length of the hypotenuse of the BAD triangle is 10. The lengths of the two segments of the ABC triangle are 2 and 10, and the length of the hypotenuse of the BAD triangle is 10. The lengths of the two segments of the ABC triangle are 2 and 10, and the length of the hypotenuse of the BAD triangle is 10. The lengths of the two segments of the ABC triangle are 2 and 10, and the length](<ChazalMichel2021/imageFile1.png>)

A

B

B

Figure 1: Right: the Hausdorﬀ distance between two subsets A and B of the plane. In this example, d H ( A,B ) is the distance between the point a in A which is the farthest from B and its nearest neighbor b on B . Left: The Gromov-Hausdorﬀ distance between A and B . A can been rotated this is an isometric embedding of A in the plane to reduce its Hausdorﬀ distance to B . As a consequence, d GH ( A,B ) ≤ d H ( A,B ) .

It is a basic and classical result that the Hausdorﬀ distance is indeed a distance on the set of compact subsets of a metric space. From a tda perspective it provides a convenient way to quantify the proximity between diﬀerent data sets issued from the same ambient metric space. However, it sometimes occurs in that one has to compare data set that are not sampled from the same ambient space. Fortunately, the notion of Hausdorﬀ distance can be generalized to the comparison of any pair of compact metric spaces, giving rise to the notion of Gromov-Hausdorﬀ distance .

Two compact metric spaces ( M 1 ,ρ 1 ) and ( M 2 ,ρ 2 ) are isometric if there exists a bijection φ : M 1 → M 2 that preserves distances, i.e. ρ 2 ( φ ( x ) ,φ ( y )) = ρ 1 ( x,y ) for any x,y ∈ M 1 . The Gromov-Hausdorﬀ distance measures how far two metric space are from being isometric.

Deﬁnition 1. The Gromov-Haudorﬀ distance d GH ( M 1 ,M 2 ) between two compact metric spaces is the inﬁmum of the real numbers r ≥ 0 such that there exists a metric space ( M,ρ ) and two compact subspaces C 1 ,C 2 ⊂ M that are isometric to M 1 and M 2 and such that d H ( C 1 ,C 2 ) ≤ r .

The Gromov-Hausdorﬀ distance will be used later, in Section 5, for the study of stability properties persistence diagrams.

Connecting pairs of nearby data points by edges leads to the standard notion of neighboring graph from which the connectivity of the data can be analyzed, e.g. using some clustering algorithms. To go beyond connectivity, a central idea in TDA is to build higher dimensional equivalent of neighboring graphs by not only connecting pairs but also ( k + 1) -uple of nearby data points. The resulting objects, called simplicial complexes, allow to identify new topological features such as cycles, voids and their higher dimensional counterpart.

Geometric and abstract simplicial complexes. Simplicial complexes can be seen as higher dimensional generalization of graphs. They are mathematical objects that are both topological and combinatorial, a property making them particularly useful for tda . d

[Page 5]

- i ) any face of a simplex of K is a simplex of K ,
- ii ) the intersection of any two simplices of K is either empty or a common face of both. d


The union of the simplices of K is a subset of R called the underlying space of K that inherits from the topology of R d . So, K can also be seen as a topological space through its underlying space. Notice that once its vertices are known, K is fully characterized by the combinatorial description of a collection of simplices satisfying some incidence rules. ˜

Given a set V , an abstract simplicial complex with vertex set V is a set K of ﬁnite subsets of V such that the elements of V belongs to ˜ K and for any σ ∈ ˜ K any subset of σ belongs to ˜ K . The elements of ˜ K are called the faces or the simplices of ˜ K . The dimension of an abstract simplex is just its cardinality minus 1 and the dimension of ˜ K is the largest dimension of its simplices. Notice that simplicial complexes of dimension 1 are graphs.

The combinatorial description of any geometric simplicial K obviously gives rise to an abstract simplicial complex ˜ K . The converse is also true: one can always associate to an abstract simplicial complex ˜ K , a topological space | ˜ K | such that if K is a geometric complex whose combinatorial description is the same as ˜ K , then the underlying space of K is homeomorphic to | ˜ K | . Such a K is called a geometric realization of ˜ K . As a consequence, abstract simplicial complexes can be seen as topological spaces and geometric complexes can be seen as geometric realizations of their underlying combinatorial structure. So, one can consider simplicial complexes at the same time as combinatorial objects that are well-suited for eﬀective computations and as topological spaces from which topological properties can be inferred.

Building simplicial complexes from data. Given a data set, or more generally a topological or metric space, there exist many ways to build simplicial complexes. We present here a few classical examples that are widely used in practice.

A ﬁrst example, is an immediate extension of the notion of α -neighboring graph. Assume that we are given a set of points X in a metric space ( M,ρ ) and a real number α ≥ 0 . The Vietoris-Rips complex Rips α ( X ) is the set of simplices [ x 0 ,...,x k ] such that d X ( x i ,x j ) ≤ α for all ( i,j ) . It follows immediately from the deﬁnition that this is an abstract simplicial complex. However, in general, even when X is a ﬁnite subset of R d , Rips α ( X ) does not admit a geometric realization in R d ; in particular, it can be of dimension higher than d .

Closely related to the Vietoris-Rips complex is the Čech complex Cech α ( X ) that is deﬁned as the set of simplices [ x 0 ,...,x k ] such that the k + 1 closed balls B ( x i ,α ) have a non-empty intersection. Notice that these two complexes are related by

$$
R i p s _ { \alpha } ( \mathbb { X } ) \subseteq C e c h _ { \alpha } ( \mathbb { X } ) \subseteq R i p s _ { 2 \alpha } ( \mathbb { X } )
$$

and that, if X ⊂ R d then Cech α ( X ) and Rips 2 α ( X ) have the same 1 -dimensional skeleton, i.e. the same set of vertices and edges.

The nerve theorem. The Čech complex is a particular case of a family of complexes associated to covers. Given a cover U = ( U i ) i ∈ I of M , i.e. a family of sets U i such that M = ∪ i ∈ I U i , the nerve of U is the abstract simplicial complex C ( U ) whose vertices are the U i ’s and such that

$$
\sigma = [ U _ { i _ { 0 } } , \cdots , U _ { i _ { k } } ] \in C ( \mathcal { U } ) \text { if and only if } \bigcap _ { j = 0 } ^ { k } U _ { i _ { j } } \neq \emptyset .
$$

glyph[negationslash]

[Page 6]

![In this image there are two blue geometric shapes.](<ChazalMichel2021/imageFile2.png>)

7

Figure 2: The Čech complex Cech α ( X ) (left) and the and Vietoris-Rips Rips 2 α ( X ) (right) of a ﬁnite point cloud in the plane R 2 . The bottom part of Cech α ( X ) is the union of two adjacent triangles, while the bottom part of Rips 2 α ( X ) is the tetrahedron spanned by the four vertices and all its faces. The dimension of the Čech complex is 2 . The dimension of the Vietoris-Rips complex is 3 . Notice that this later is thus not embedded in R 2 .

A fundamental theorem in algebraic topology, relates, under some assumptions, the topology of the nerve of a cover to the topology of the union of the sets of the cover. To be formally stated, this result, known as the Nerve Theorem, requires to introduce a few notions.

Two topological spaces X and Y are usually considered as being the same from a topological point of view if they are homeomorphic , i.e. if there exist two continuous bijective maps f : X → Y and g : Y → X such that f ◦ g and g ◦ f are the identity map of Y and X respectively. In many cases, asking X and Y to be homeomorphic turns out to be a too strong requirement to ensure that X and Y share the same topological features of interest for tda . Two continuous maps f 0 ,f 1 : X → Y are said to be homotopic is there exists a continuous map H : X × [0 , 1] → Y such that for any x ∈ X , H ( x, 0) = f 0 ( x ) and H ( x, 1) = g ( x ) . The spaces X and Y are then said to be homotopy equivalent if there exist two maps f : X → Y and g : Y → X such that f ◦ g and g ◦ f are homotopic to the identity map of Y and X respectively. The maps f and g are then called homotopy equivalent . The notion of homotopy equivalence is weaker than the notion of homeomorphism: if X and Y are homeomorphic then they are obviously homotopy equivalent, the converse being not true. However, spaces that are homotopy equivalent still share many topological invariant, in particular they have the same homology see Section 4.

A space is said to be contractible if it is homotopy equivalent to a point. Basic examples of contractible spaces are the balls and, more generally, the convex sets in R d . Open covers whose all elements and their intersections are contractible have the remarkable following property.

Theorem 1 (Nerve theorem) . Let U = ( U i ) i ∈ I be a cover of a topological space X by open sets such that the intersection of any subcollection of the U i ’s is either empty or contractible. Then, X and the nerve C ( U ) are homotopy equivalent.

It is easy to verify that convex subsets of Euclidean spaces are contractible. As a consequence, if U = ( U i ) i ∈ I is a collection of convex subsets of R d then C ( U ) and ∪ i ∈ I U i are homotopy equivalent. In particular, if X is a set of points in R d , then the Čech complex Cech α ( X ) is homotopy equivalent to the union of balls ∪ x ∈ X B ( x,α ) .

The Nerve Theorem plays a fundamental role in tda : it provide a way to encode the topology of continuous spaces into abstract combinatorial structures that are well-suited for the design of effective data structures and algorithms.

[Page 7]

U2

![The image consists of a diagram involving a triangle and a line segment. The diagram includes the following elements: 1. **Triangle**: The triangle is labeled as U3 and has vertices labeled as A, B, and C. 2. **Line Segment**: The line segment from vertex A to vertex C is labeled as U. 3. **Points on the Line Segment**: There are two points on the line segment: - Point A is located on the line segment from vertex A to vertex C. - Point B is located on the line segment from vertex A to vertex C. 4. **Triangle**: The triangle is labeled as U3. 5. **Angles**: The angles at the vertices of the triangle are labeled as U1, U2, and U3. ### Analysis and Description: #### Points on the Line Segment: - **Point A**: Located on the line](<ChazalMichel2021/imageFile3.png>)

U2

U1

U3

U1

U3

Figure 3: The nerve of a cover of a set of sampled points in the plane.

# 3 Using covers and nerves for exploratory data analysis and visualization: the Mapper algorithm

Using the nerve of covers as a way to summarize, visualize and explore data is a natural idea that was ﬁrst proposed for tda in Singh et al. (2007), giving rise to the so-called Mapper algorithm.

Deﬁnition 2. Let f : X → R d , d ≥ 1 , be a continuous real valued function and let U = ( U i ) i ∈ I be a cover of R d . The pull back cover of X induced by ( f, U ) is the collection of open sets ( f − 1 ( U i )) i ∈ I . The reﬁned pull back is the collection of connected components of the open sets f − 1 ( U i ) , i ∈ I .

The idea of the Mapper algorithm is, given a data set X and well-chosen real valued function f : X → R d , to summarize X through the nerve of the reﬁned pull back of a cover U of f ( X ) , see Figure 4(a) . For well-chosen covers U (see below), this nerve is a graph providing an easy and convenient way to visualize the summary of the data. It is described in Algorithm 1 and illustrated on a simple example in Figure 4(b).

The Mapper algorithm is very simple but it raises several questions about the various choices that are left to the user and that we brieﬂy discuss in the following.

# Algorithm 1 The Mapper algorithm

Input: A data set X with a metric or a dissimilarity measure between data points, a function f : X → R (or R d ), and a cover U of f ( X ) . 1

for each U ∈ U , decompose f − ( U ) into clusters C U, 1 , ··· ,C U,k U .

Compute the nerve of the cover of X deﬁned by the C U, 1 , ··· ,C U,k U , U ∈ U

Output: a simplicial complex, the nerve (often a graph for well-chosen covers → easy to visualize):

- a vertex v U,i for each cluster C U,i ,
- an edge between v U,i and v U   ,j iﬀ C U,i ∩ C U   ,j   = ∅


glyph[negationslash]

The choice of f . The choice of the function f , sometimes called the ﬁlter or lens function, strongly depends on the features of the data that one expect to highlight. The following ones are among the ones more or less classically encountered in the literature:

[Page 8]

![The image is a geometric figure consisting of a circle and several geometric shapes. Here is a detailed description of the image: ### Description of the Image: #### Circle: - The circle is a closed, closed circle. - The center of the circle is marked with a point labeled as u. - The radius of the circle is represented by the line segment u. - The diameter of the circle is represented by the line segment u. - The center of the circle is marked by a point labeled as f. - The radius of the circle is represented by the line segment f. - The diameter of the circle is represented by the line segment f. - The center of the circle is marked by a point labeled as u. - The radius of the circle is represented by the line segment u. - The diameter of the circle is represented by the line segment u. - The center of](<ChazalMichel2021/imageFile4.png>)

(b)

Figure 4: (a) The reﬁned pull back cover of the height function on a surface in R 3 and its nerve. (b) The mapper algorithm on a point cloud sampled around a circle.

- Density estimates: the mapper complex may help to understand the structure and connectivity of high density areas (clusters).
- PCA coordinates or coordinates functions obtained from a non linear dimensionality reduction (NLDR) technique, eigenfunctions of graph laplacians,... may help to reveal and understand some ambiguity in the use of non linear dimensionality reductions.
- The centrality function f ( x ) =   y ∈ X d ( x,y ) and the eccentricity function f ( x ) = max y ∈ X d ( x,y ) , appears sometimes to be good choices that do not require any speciﬁc knowledge about the data.
- For data that are sampled around 1-dimensional ﬁlamentary structures, the distance function to a given point allows to recover the underlying topology of the ﬁlamentary structures Chazal et al. (2015c).


[Page 9]

The choice of the cover U . When f is a real valued function, a standard choice is to take U to be a set of regularly spaced intervals of equal length r > 0 covering the set f ( X ) . The real r is sometimes called the resolution of the cover and the percentage g of overlap between two consecutive intervals is called the the gain of the cover. Note that if the gain g is chosen below 50% , then every point of the real line is covered by at most 2 open sets of U and the output nerve is a graph. It is important to notice that the output of the Mapper is very sensitive to the choice of U and small changes in the resolution and gain parameters may results in very large changes in the output, making the method very unstable. A classical strategy consists in exploring some range of parameters and select the ones that turn out to provide the most informative output from the user perspective.

The choice of the clusters. The Mapper algorithm requires to cluster the preimage of the open sets U ∈ U . There are two strategies to compute the clusters. A ﬁrst strategy consists in applying, for each U ∈ U , a cluster algorithm, chosen by the user, to the premimage f − 1 ( U ) . A second, more global, strategy consists in building a neighboring graph on top of the data set X , e.g. k-NN graph or ε -graph, and, for each U ∈ U , taking the connected components of the subgraph with vertex set f − 1 ( U ) .

Theoretical and statistical aspects of Mapper. Based on the results on stability and the structure of Mapper proposed in Carrière and Oudot (2015), advances towards a statistically wellfounded version of Mapper have been obtained recently in Carriere et al. (2018). Unsurprisingly, the convergence of Mapper depends on both the sampling of the data and the regularity of the ﬁlter function. Moreover, subsampling strategies can be proposed to select a complex in a Rips ﬁltration at a convenient scale, as well as the resolution and the gain for deﬁning the Mapper graph. The case of stochastic and multivariate ﬁlters has also been studied in Carrière and Michel (2019). An alternative description of the probabilistic convergence of Mapper, in term of categoriﬁcation, has also been proposed in Brown et al. (2020). Other approaches have been proposed to study and deal with the instabilities of the Mapper algorithm in Dey et al. (2016, 2017).

Data Analysis with Mapper. As an exploratory data analysis tool, Mapper has been successfully used for clustering and feature selection. The idea is to identify speciﬁc structures in the Mapper graph (or complex), in particular loops and ﬂares. These structures are then used to identify interesting clusters or to select features or variable that best discriminate the data in these structures. Applications on real data, illustrating these techniques, may be found, for example, in Carrière and Rabadán (2020); Lum et al. (2013); Yao et al. (2009).

# 4 Geometric reconstruction and homology inference

Another way to build covers and use their nerves to exhibit the topological structure of data is to consider union of balls centered on the data points. In this section, we assume that X n = { x 0 , ··· ,x n } is a subset of R d sampled i.i.d. according to a probability measure µ with compact support M ⊂ R d . The general strategy to infer topological information about M from µ proceeds in two steps that are discussed in the following of this section:

- 1. X n is covered by a union of balls of ﬁxed radius centered on the x i ’s. Under some regularity assumptions on M , one can relate the topology of this union of balls to the one of M ;
- 2. From a practical and algorithmic perspective, topological features of M are inferred from the nerve of the union of balls, using the Nerve Theorem.


[Page 10]

In this framework, it is indeed possible to compare spaces through isotopy equivalence , a stronger notion than homeomorphism: X ⊆ R d and Y ⊆ R d are said to be (ambient) isotopic if there exists a continuous family of homeomorphisms H : [0 , 1] × R d → R d , H continuous, such that for any t ∈ [0 , 1] , H t = H ( t,. ) : R d → R d is an homeomorphism, H 0 is the identity map in R d and H 1 ( X ) = Y . Obviously, if X and Y are isotopic, then they are homeomorphic. The converse is not true: a knotted and an unknotted circles in R 3 are not homeomorphic (notice that although this claim seems rather intuitive, its formal proof requires the use of some non obvious algebraic topology tools).

# 4.1 Distance-like functions and reconstruction

Given a compact subset K of R d , and a non negative real number r , the union of balls of radius r centered on K , K r = ∪ x ∈ K B ( x,r ) , called the r -oﬀset of K , is the r -sublevel set of the distance function d K : R d → R deﬁned by d K ( x ) = inf y ∈ K   x − y   ; in other words, K r = d − 1 k ([0 ,r ]) . This remark allows to use diﬀerential properties of distance functions and to compare the topology of the oﬀsets of compact sets that are close to each other with respect to the Hausdorﬀ distance.

Deﬁnition 3 (Hausdorﬀ distance in R d ) . The Hausdorﬀ distance between two compact subsets K,K   of R d is deﬁned by

$$
d _ { H } ( K , K ^ { \prime } ) = \| d _ { K } - d _ { K ^ { \prime } } \| _ { \infty } = \sup _ { x \in \mathbb { R } ^ { d } } | d _ { K } ( x ) - d _ { K ^ { \prime } } ( x ) | .
$$

In our setting, the considered compact sets are the data set X n and of the support M of the measure µ . When M is a smooth compact submanifold, under mild conditions on d H ( X n ,M ) , for some well-chosen r , the oﬀsets of X n are homotopy equivalent to M , Chazal and Lieutier (2008a); Niyogi et al. (2008) see Figure 5 for an illustration. These results extend to larger classes of compact sets and leads to stronger results on the inference of the isotopy type of the oﬀsets of M , Chazal et al. (2009c,d). They also lead to results on the estimation of other geometric and diﬀerential quantities such as normals Chazal et al. (2009c), curvatures Chazal et al. (2008) or boundary measures Chazal et al. (2010) under assumptions on the Haussdorﬀ distance between the underlying shape and the data sample.

![In this image, we can see a diagram. In the diagram, we can see a doughnut.](<ChazalMichel2021/imageFile5.png>)

0

Xn

Xn

Figure 5: The example of a point cloud X n sampled on the surface of a torus in R 3 (top left) and its oﬀsets for diﬀerent values of radii r 1 < r 2 < r 3 . For well chosen values of the radius (e.g. r 1 and r 2 ), the oﬀsets are clearly homotopy equivalent to a torus.

[Page 11]

These results rely on the 1 -semiconcavity of the squared distance function d 2 K , i.e. the convexity of the function x →   x   2 − d 2 K ( x ) , and can be naturally stated in the following general framework.

Deﬁnition 4. A function φ : R d → R + is distance-like if it is proper (the pre-image of any compact set in R is a compact set in R d ) and x →   x   2 − φ 2 ( x ) is convex.

Thanks to its semiconcavity, a distance-like function φ have a well-deﬁned, but not continuous, gradient ∇ φ : R d → R d that can be integrated into a continuous ﬂow (Petrunin, 2007) that allows to track the evolution of the topology of its sublevel sets and to compare it to the one of the sublevel sets of close distance-like functions.

Deﬁnition 5. Let φ be a distance-like function and let φ r = φ − 1 ([0 ,r ]) be the r -sublevel set of φ .

- • A point x ∈ R d is called α -critical if  ∇ x φ   ≤ α . The corresponding value r = φ ( x ) is also said to be α -critical .
- • The weak feature size of φ at r is the minimum r   > 0 such that φ does not have any critical value between r and r + r   . We denote it by wfs φ ( r ) . For any 0 < α < 1 , the α -reach of φ is the maximum r such that φ − 1 ((0 ,r ]) does not contain any α -critical point.


The weak feature size wfs φ ( r ) (resp. α -reach) measures the regularity of φ around its r -level sets (resp. O -level set). When φ = d K is the distance function to a compact set K ⊂ R d , the 1 -reach coincides with the classical reach from geometric measure theory Federer (1959). Its estimation from random samples has been studied in Aamari et al. (2019). An important property of a distance-like function φ is the topology of their sublevel sets φ r can only change when r crosses a 0 -critical value.

Lemma 1 (Isotopy Lemma Grove (1993)) . Let φ be a distance-like function and r 1 < r 2 be two positive numbers such that φ has no 0 -critical point, i.e. points x such that ∇ φ ( x ) = 0 , in the subset φ − 1 ([ r 1 ,r 2 ]) . Then all the sublevel sets φ − 1 ([0 ,r ]) are isotopic for r ∈ [ r 1 ,r 2 ] .

As an immediate consequence of the Isotopy Lemma, all the sublevel sets of φ between r and r + wfs φ ( r ) have the same topology. Now the following reconstruction theorem from Chazal et al. (2011b) provides a connection between the topology of the sublevel sets of close distance-like functions.

Theorem 2 (Reconstruction Theorem) . Let φ,ψ be two distance-like functions such that   φ − ψ   ∞ < ε , with reach α ( φ ) ≥ R for some positive ε and α . Then, for every r ∈ [4 ε/α 2 ,R − 3 ε ] and every η ∈ (0 ,R ) , the sublevel sets ψ r and φ η are homotopy equivalent when

$$
\varepsilon \leq \frac { R } { 5 + 4 / \alpha ^ { 2 } } .
$$

Under similar but slightly more technical conditions the Reconstruction Theorem can be extended to prove that the sublevel sets are indeed homeomorphic and even isotopic Chazal et al. (2009c, 2008).

Coming back to our setting, and taking for φ = d M and ψ = d X n the distance functions to the support M of the measure µ and to the data set X n , the condition reach α ( d M ) ≥ R can be interpreted as regularity condition on M 6 . The Reconstruction Theorem combined with the Nerve Theorem tell that, for well-chosen values of r,η , the η -oﬀsets of M are homotopy equivalent to the nerve of the union of balls of radius r centered on X n , i.e the Cech complex Cech r ( X n ) .

From a statistical perspective, the main advantage of these results involving Hausdorﬀ distance is that the estimation of the considered topological quantities boil down to support estimation questions that have been widely studied see Section 4.3.

6 As an example, if M is a smooth compact submanifold then reach 0 ( φ ) is always positive and known as the reach of M Federer (1959).

[Page 12]

# 4.2 Homology inference

The above results provide a mathematically well-founded framework to infer the topology of shapes from a simplicial complex built on top of an approximating ﬁnite sample. However, from a more practical perspective it raises raise two issues. First, the Reconstruction Theorem requires a regularity assumption through the α -reach condition that may not always be satisﬁed and, the choice of a radius r for the ball used to build the Čech complex Cech r ( X n ) . Second, Cech r ( X n ) provides a topologically faithfull summary of the data, through a simplicial complex that is usually not well-suited for further data processing. One often needs easier to handle topological descriptors, in particular numerical ones, that can be easily computed from the complex. This second issue is addressed by considering the homology of the considered simplicial complexes in the next paragraph, while the ﬁrst issue will be addressed in the next section with the introduction of persistent homology.

Homology in a nutshell. Homology is a classical concept in algebraic topology providing a powerful tool to formalize and handle the notion of topological features of a topological space or of a simplicial complex in an algebraic way. For any dimension k , the k -dimensional “holes” are represented by a vector space H k whose dimension is intuitively the number of such independent features. For example the 0-dimensional homology group H 0 represents the connected components of the complex, the 1 -dimensional homology group H 1 represents the 1-dimensional loops, the 2 -dimensional homology group H 2 represents the 2-dimensional cavities,...

To avoid technical subtleties and diﬃculties, we restrict the introduction of homology to the minimum that is necessary to understand its usage in the following of the paper. In particular we restrict to homology with coeﬃcients in Z 2 , i.e. the ﬁeld with two elements 0 and 1 such that 1 + 1 = 0 , that turns out to be geometrically a little bit more intuitive. However, all the notions and results presented in the sequel naturally extend to homology with coeﬃcient in any ﬁeld. We refer the reader to Hatcher (2001) for a complete and comprehensible introduction to homology and to Ghrist (2017) for a recent concise and very good introduction to applied algebraic topology and its connections to data analysis.

Let K be a (ﬁnite) simplicial complex and let k be a non negative integer. The space of k -chains on K , C k ( K ) is the set whose elements are the formal (ﬁnite) sums of k -simplices of K . More precisely, if { σ 1 , ··· σ p } is the set of k -simplices of K , then any k -chain can be written as

$$
c = \sum _ { i = 1 } ^ { p } \varepsilon _ { i } \sigma _ { i } \text { with } \varepsilon _ { i } \in \mathbb { Z } _ { 2 } .
$$

If c   =   p i =1 ε   i σ i is another k -chain and λ ∈ Z 2 , the sum c + c   is deﬁned as c + c   =   p i =1 ( ε i + ε   i ) σ i and the product λ.c is deﬁned as λ.c =   p i =1 ( λ.ε i ) σ i , making C k ( K ) a vector space with coeﬃcients in Z 2 . Since we are considering coeﬃcient in Z 2 , geometrically a k -chain can be seen as a ﬁnite collection of k -simplices and the sum of two k -chains as the symmetric diﬀerence of the two corresponding collections 7 .

The boundary of a k -simplex σ = [ v 0 , ··· ,v k ] is the ( k − 1) -chain

$$
\partial _ { k } ( \sigma ) = \sum _ { i = 0 } ^ { k } ( - 1 ) ^ { i } [ v _ { 0 } , \cdots , \hat { v } _ { i } , \cdots , v _ { k } ]
$$

where [ v 0 , ··· , ˆ v i , ··· ,v k ] is the ( k − 1) -simplex spanned by all the vertices except v i 8 . As the k -simplices form a basis of C k ( K ) , ∂ k extends as a linear map from C k ( K ) to C k − 1 ( K ) called the boundary operator . The kernel Z k ( K ) = { c ∈ C k ( K ) : ∂ k = 0 } of ∂ k is called the space of k -cycles of K and the image B k ( K ) = { c ∈ C k ( K ) : ∃ c   ∈ C k +1 ( K ) ,∂ k +1 ( c   ) = c } of ∂ k +1 is

7 Recall that the symmetric diﬀerence of two sets A and B is the set A ∆ B = ( A \ B ) ∪ ( B \ A ) . 8 i

Notice that as we are considering coeﬃcients in Z 2 , here − 1 = 1 and thus ( − 1) = 1 for any i .

[Page 13]

$$
\partial _ { k - 1 } \circ \partial _ { k } \equiv 0 \ \text { for any } \ k \geq 1 .
$$

In other words, any k -boundary is a k -cycle, i.e. B k ( K ) ⊆ Z k ( K ) ⊆ C k ( K ) . These notions are illustrated on Figure 6.

![The image consists of a geometric figure with various points and lines. Here is a detailed description of the image: The diagram consists of a polygon with 12 vertices. Each vertex is connected to 4 other vertices. The vertices are arranged in a 4-gon. The vertices are connected by lines, which are represented by dots. The lines are drawn in blue and orange colors. The polygon is a diamond shape, with each vertex connected to 4 other vertices. The vertices are connected by lines, which are represented by dots. The lines are drawn in blue and orange colors. The polygon is a diamond shape, with each vertex connected to 4 other vertices. The vertices are connected by lines, which are represented by dots. The lines are drawn in blue and orange colors. The polygon is a diamond shape, with each vertex connected to 4 other vertices. The vertices are connected by lines, which are represented by dots. The lines are drawn](<ChazalMichel2021/imageFile6.png>)

C4

C3

C1

C2

Figure 6: Some examples of chains, cycles and boundaries on a 2 -dimensional complex K : c 1 ,c 2 and c 4 are 1 -cycles; c 3 si a 1 -chain but not a 1 -cycle; c 4 is the 1 -boundary, namely the boundary of the 2 -chain obtained as the sum of the two triangles surrounded by c 4 ; The cycles c 1 and c 2 span the same element in H 1 ( K ) as their diﬀerence is the 2 -chain represented by the union of the triangles surrounded by the union of c 1 and c 2 .

Deﬁnition 6 (Simplicial homology group and Betti numbers) . The k th (simplicial) homology group of K is the quotient vector space

$$
H _ { k } ( K ) = Z _ { k } ( K ) / B _ { k } ( K ) .
$$

The k th Betti number of K is the dimension β k ( K ) = dim H k ( K ) of the vector space H k ( K ) .

Two cycles c,c   ∈ Z k ( K ) are said to be homologous if they diﬀer by a boundary, i.e. is there exists a ( k +1) -chain d such that c   = c + ∂ k +1 ( d ) . Two such cycles give rise to the same element of H k . In other words, the elements of H k ( K ) are the equivalence classes of homologous cycles.

Simplicial homology groups and Betti numbers are topological invariants: if K,K   are two simplicial complexes whose geometric realizations are homotopy equivalent, then their homology groups are isomorphic and their Betti numbers are the same.

Singular homology is another notion of homology that allows to consider larger classes of topological spaces. It is deﬁned for any topological space X similarly to simplicial homology except that the notion of simplex is replaced by the notion of singular simplex which is just any continuous map σ : ∆ k → X where ∆ k is the standard k -dimensional simplex. The space of k chains is the vector space spanned by the k -dimensional singular simplices and the boundary of a simplex σ is deﬁned as the (alternated) sum of the restriction of σ to the ( k − 1) -dimensional faces of ∆ k . A remarkable fact about singular homology it that it coincides with simplicial homology

[Page 14]

![The image is a diagram of a geometric figure. It consists of a circle, a triangle, and a square. The circle is the largest circle in the diagram, and it is positioned at the top center of the diagram. The triangle is positioned at the bottom center of the diagram, and it is a right triangle. The square is positioned at the top center of the diagram, and it is a square with four equal sides. The diagram is labeled with the following text: - **O** is the center of the circle. - **∆** is the triangle. - **∆** is the square. - **∆** is the circle. - **∆** is the square. - **∆** is the circle. - **∆** is the square. - **∆** is the circle. - **∆** is the square. - **∆** is the circle.](<ChazalMichel2021/imageFile7.png>)

Two dimensional torus: ßo = 1,

ß1 = 2, ß2 = 1, ß3 = 0

Figure 7: The Betti numbers of the circle (top left), the 2-dimensional sphere (top right) and the 2-dimensional torus (bottom). The blue curves on the torus represent two independent cycles whose homology class is a basis of its 1-dimensional homology group.

whenever X is homeomorphic to the geometric realization of a simplicial complex. This allows us, in the sequel of this paper, to indiﬀerently talk about simplicial or singular homology for topological spaces and simplicial complexes.

Observing, that if f : X → Y is a continuous map, then for any singular simplex σ : ∆ k → X in X , f ◦ σ : ∆ k → Y is a singular simplex in Y , one easily deduces that continuous maps between topological spaces canonically induce homomorphisms between their homology groups. In particular, if f is an homeomorphism or an homotopy equivalence, then it induces an isomorphism between H k ( X ) and H k ( Y ) for any non negative integer k . As an example, it follows from the Nerve Theorem that for any set of points X ⊂ R d and any r > 0 the r -oﬀset X r and the Čech complex Cech r ( X ) have isomorphic homology groups and the same Betti numbers.

As a consequence, the Reconstruction Theorem 2 leads to the following result on the estimation of Betti numbers.

Theorem 3. Let M ⊂ R d be a compact set such that reach α ( d M ) ≥ R > 0 for some α ∈ (0 , 1) and let X be a ﬁnite set of point such that d H ( M, X ) = ε < R 5+4 /α 2 . Then, for every r ∈ [4 ε/α 2 ,R − 3 ε ] and every η ∈ (0 ,R ) , the Betti numbers of Cech r ( X ) are the same as the ones of M η .

In particular, if M is a smooth m -dimensional submanifold of R d , then β k (Cech r ( X )) = β k ( M ) for any k = 0 , ··· ,m .

From a practical perspective, this result raises three diﬃculties: ﬁrst, the regularity assumption involving the α -reach of M may be too restrictive; second, the computation of the nerve of an union of balls requires they use of a tricky predicate testing the emptiness of a ﬁnite union of balls; third the estimation of the Betti numbers relies on the scale parameter r whose choice may be a problem.

To overcome these issues, Chazal and Oudot (2008) establishes the following result that oﬀers a solution to the two ﬁrst problems.

Theorem 4. Let M ⊂ R d be a compact set such that wfs( M ) = wfs d M (0) ≥ R > 0 and let X be a ﬁnite set of point such that d H ( M, X ) = ε < 1 9 wfs( M ) . Then for any r ∈ [2 ε, 1 4 (wfs( M ) − ε )]

[Page 15]

and any η ∈ (0 ,R ) ,

$$
\beta _ { k } ( X ^ { \eta } ) = \text {rk} \left ( H _ { k } ( \text {Rips} _ { r } ( \mathbb { X } ) ) \rightarrow H _ { k } ( \text {Rips} _ { 4 r } ( \mathbb { X } ) ) \right )
$$

where rk ( H k (Rips r ( X )) → H k (Rips 4 r ( X ))) denotes the rank of the homomorphism induced by the (continuous) canonical inclusion Rips r ( X )   → Rips 4 r ( X ) .

Although this result leaves the question of the choice of the scale parameter r open, it is proven in Chazal and Oudot (2008) that a multiscale strategy whose description is beyond the scope of this paper provides some help to identify the relevant scales at which Theorem 4 can be applied.

# 4.3 Statistical aspects of Homology inference

According to the stability results presented in the previous section, a statistical approach to topological inference is strongly related to the problem of distribution support estimation and level sets estimation under the Hausdorﬀ metric. A large number of methods and results are available for estimating the support of a distribution in statistics. For instance, the Devroye and Wise estimator (Devroye and Wise, 1980) deﬁned on a sample X n is also a particular oﬀset of X n . The convergence rates of both X n and the Devroye and Wise estimator to the support of the distribution for the Hausdorﬀ distance is studied in Cuevas and Rodríguez-Casal (2004) in R d . More recently, the minimax rates of convergence of manifold estimation for the Hausdorﬀ metric, which is particularly relevant for topological inference, has been studied in Genovese et al. (2012). There is also a large literature about level sets estimation in various metrics (see for instance Cadre, 2006; Polonik, 1995; Tsybakov et al., 1997) and more particularly for the Hausdorﬀ metric in Chen et al. (2015). All these works about support and level sets estimation shine light on the statistical analysis of topological inference procedures.

In the paper Niyogi et al. (2008), it is shown that the homotopy type of Riemannian manifolds with reach larger than a given constant can be recovered with high probability from oﬀsets of a sample on (or close to) the manifold. This paper was probably the ﬁrst attempt to consider the topological inference problem in terms of probability. The result of Niyogi et al. (2008) is derived from a retract contraction argument and on tight bounds over the packing number of the manifold in order to control the Hausdorﬀ distance between the manifold and the observed point cloud. The homology inference in the noisy case, in the sense the distribution of the observation is concentrated around the manifold, is also studied in Niyogi et al. (2008, 2011). The assumption that the geometric object is a smooth Riemannian manifold is only used in the paper to control in probability the Hausdorﬀ distance between the sample and the manifold, and is not actually necessary for the "topological part" of the result. Regarding the topological results, these are similar to those of Chazal et al. (2009d); Chazal and Lieutier (2008b) in the particular framework of Riemannian manifolds. Starting from the result of Niyogi et al. (2008), the minimax rates of convergence of the homology type have been studied by Balakrishna et al. (2012) under various models, for Riemannian manifolds with reach larger than a constant. In contrast, a statistical version of Chazal et al. (2009d) has not yet been proposed.

More recently, following the ideas of Niyogi et al. (2008), Bobrowski et al. (2014) have proposed a robust homology estimator for the level sets of both density and regression functions, by considering the inclusion map between nested pairs of estimated level sets (in the spirit of Theorem 4 above) obtained with a plug-in approach from a kernel estimator.

# 4.4 Going beyond Hausdorﬀ distance : distance to measure

It is well known that distance-based methods in tda may fail completely in the presence of outliers. Indeed, adding even a single outlier to the point cloud can change the distance function dramatically, see Figure 8 for an illustration. To answer this drawback, Chazal et al. (2011b) have introduced an alternative distance function which is robust to noise, the distance-to-a-measure .

[Page 16]

![In this image we can see a blue color geometric shape.](<ChazalMichel2021/imageFile8.png>)

Figure 8: The eﬀect of outliers on the sublevel sets of distance functions. Adding just a few outliers to a point cloud may dramatically change its distance function and the topology of its oﬀsets.

Given a probability distribution P in R d and a real parameter 0 ≤ u ≤ 1 , the notion of distance to the support of P may be generalized as the function

$$
\delta _ { P , u } \colon x \in \mathbb { R } ^ { d } \mapsto \inf \{ t > 0 \, ; \, P ( B ( x , t ) ) \geq u \} ,
$$

where B ( x,t ) is the closed Euclidean ball of center x and radius t . To avoid issues due to discontinuities of the map P → δ P,u , the distance-to-measure function (DTM) with parameter m ∈ [0 , 1] and power r ≥ 1 is deﬁned by

$$
d _ { P , m , r } ( x ) \colon x \in \mathbb { R } ^ { d } \mapsto \left ( \frac { 1 } { m } \int _ { 0 } ^ { m } \delta _ { P , u } ^ { r } ( x ) d u \right ) ^ { 1 / r } .
$$

A nice property of the DTM proved in Chazal et al. (2011b) is its stability with respect to perturbations of P in the Wasserstein metric. More precisely, the map P → d P,m,r is m − 1 r Lipschitz, i.e. if P and ˜ P are two probability distributions on R d , then

$$
\| d _ { P , m , r } - d _ { \tilde { P } , m , r } \| _ { \infty } \leq m ^ { - \frac { 1 } { r } } W _ { r } ( P , \tilde { P } )
$$

where W r is the Wasserstein distance for the Euclidean metric on R d , with exponent r 9 . This property implies that the DTM associated to close distributions in the Wasserstein metric have close sublevel sets. Moreover, when r = 2 , the function d 2 P,m, 2 is semiconcave ensuring strong regularity properties on the geometry of its sublevel sets. Using these properties, Chazal et al. (2011b) show that, under general assumptions, if ˜ P is a probability distribution approximating P , then the sublevel sets of d ˜ P,m, 2 provide a topologically correct approximation of the support of P .

In practice, the measure P is usually only known through a ﬁnite set of observations X n = { X 1 ,...,X n } sampled from P , raising the question of the approximation of the DTM. A natural idea to estimate the DTM from X n is to plug the empirical measure P n instead of P in the deﬁnition of the DTM. This "plug-in strategy" corresponds to computing the distance to the

[Page 17]

$$
d _ { P _ { n } , k / n , r } ^ { r } ( x ) \colon = \frac { 1 } { k } \sum _ { j = 1 } ^ { k } \| x - \mathbb { X } _ { n } \| _ { ( j ) } ^ { r } \, ,
$$

where   x − X n   ( j ) denotes the distance between x and its j -th neighbor in { X 1 ,...,X n } . This quantity can be easily computed in practice since it only requires the distances between x and the sample points. The convergence of the DTEM to the DTM has been studied in Chazal et al. (2014a) and Chazal et al. (2016b).

The introduction of DTM has motivated further works and applications in various directions such as topological data analysis (Buchet et al., 2015a), GPS traces analysis (Chazal et al., 2011a), density estimation (Biau et al., 2011), hypothesis testing Brécheteau et al. (2019), clustering (Chazal et al., 2013b) just to name a few. Approximations, generalizations and variants of the DTM have also been considered in (Brécheteau et al., 2020; Buchet et al., 2015b; Guibas et al., 2013; Phillips et al., 2014).

# 5 Persistent homology

Persistent homology is a powerful tool to compute, study and encode eﬃciently multiscale topological features of nested families of simplicial complexes and topological spaces. It does not only provide eﬃcient algorithms to compute the Betti numbers of each complex in the considered families, as required for homology inference in the previous section, but also encodes the evolution of the homology groups of the nested complexes across the scales. Ideas and preliminary results underlying persistent homology theory trace back to the 20th century, in particular in Barannikov (1994); Frosini (1992); Robins (1999). It started to know an important development in its modern form after the seminal works of Edelsbrunner et al. (2002) and Zomorodian and Carlsson (2005).

# 5.1 Filtrations

A ﬁltration of a simplicial complex K is a nested family of subcomplexes ( K r ) r ∈ T , where T ⊆ R , such that for any r,r   ∈ T , if r ≤ r   then K r ⊆ K r   , and K = ∪ r ∈ T K r . The subset T may be either ﬁnite or inﬁnite. More generally, a ﬁltration of a topological space M is a nested family of subspaces ( M r ) r ∈ T , where T ⊆ R , such that for any r,r   ∈ T , if r ≤ r   then M r ⊆ M r   and, M = ∪ r ∈ T M r . For example, if f : M → R is a function, then the family M r = f − 1 (( −∞ ,r ]) , r ∈ R deﬁnes a ﬁltration called the sublevel set ﬁltration of f .

In practical situations, the parameter r ∈ T can often be interpreted as a scale parameter and ﬁltrations classically used in TDA often belong to one of the two following families.

Filtrations built on top of data. Given a subset X of a compact metric space ( M,ρ ) , the families of Rips-Vietoris complexes (Rips r ( X )) r ∈ R and and Čech complexes (Cech r ( X )) r ∈ R are ﬁltrations 10 . Here, the parameter r can be interpreted as a resolution at which one considers the data set X . For example, if X is a point cloud in R d , thanks to the Nerve theorem, the ﬁltration (Cech r ( X )) r ∈ R encodes the topology of the whole family of unions of balls X r = ∪ x ∈ X B ( x,r ) , as r goes from 0 to + ∞ . As the notion of ﬁltration is quite ﬂexible, many other ﬁltrations have been considered in the literature and can be constructed on top of data, such as e.g. the so called witness complex popularized in tda by De Silva and Carlsson (2004), the weighted Rips ﬁltrations Buchet et al. (2015b), or the so-called DTM-ﬁltrations Anai et al. (2020) that allow to handle data corrupted by noise and outliers.

[Page 18]

Sublevel sets ﬁltrations. Functions deﬁned on the vertices of a simplicial complex give rise to another important example of ﬁltration: let K be a simplicial complex with vertex set V and f : V → R . Then f can be extended to all simplices of K by f ([ v 0 , ··· ,v k ]) = max { f ( v i ) : i = 1 , ··· ,k } for any simplex σ = [ v 0 , ··· ,v k ] ∈ K and the family of subcomplexes K r = { σ ∈ K : f ( σ ) ≤ r } deﬁnes a ﬁltration call the sublevel set ﬁltration of f . Similarly, one can deﬁne the upperlevel set ﬁltration of f .

In practice, even if the index set is inﬁnite, all the considered ﬁltrations are built on ﬁnite sets and are indeed ﬁnite. For example, when X is ﬁnite, the Vietoris-Rips complex Rips r ( X ) changes only at a ﬁnite number of indices r . This allows to easily handle them from an algorithmic perspective.

# 5.2 Starting with a few examples

Given a ﬁltration Filt = ( F r ) r ∈ T of a simplicial complex or a topological space, the homology of F r changes as r increases: new connected components can appear, existing component can merge, loops and cavities can appear or be ﬁlled, etc... Persistent homology tracks these changes, identiﬁes the appearing features and associates a life time to them. The resulting information is encoded as a set of intervals called a barcode or, equivalently, as a multiset of points in R 2 where the coordinate of each point is the starting and end point of the corresponding interval.

Before giving formal deﬁnitions, we introduce and illustrate persistent homology on a few simple examples.

Example 1. Let f : [0 , 1] → R be the function of Figure 9(a) and let ( F r = f − 1 (( −∞ ,r ])) r ∈ R be the sublevel set ﬁltration of f . All the sublevel sets of f are either empty or a union of intervals, so the only non trivial topological information they carry is their 0 -dimensional homology, i.e. their number of connected components. For r < a 1 , F r is empty, but at r = a 1 a ﬁrst connected component appears in F a 1 . Persistent homology thus registers a 1 as the birth time of a connected component and start to keep track of it by creating an interval starting at a 1 . Then, F r remains connected until r reaches the value a 2 where a second connected component appears. Persistent homology starts to keep track of this new connected component by creating a second interval starting at a 2 . Similarly, when r reaches a 3 , a new connected component appears and persistent homology creates a new interval starting at a 3 . When r reaches a 4 , the two connected components created at a 1 and a 3 merges together to give a single larger component. At this step, persistent homology follows the rule that this is the most recently appeared component in the ﬁltration that dies: the interval started at a 3 is thus ended at a 4 and a ﬁrst persistence interval encoding the lifespan of the component born at a 3 is created. When r reaches a 5 , as in the previous case, the component born at a 2 dies and the persistent interval ( a 2 ,a 5 ) is created. The interval created at a 1 remains until the end of the ﬁltration giving rise to the persistent interval ( a 1 ,a 6 ) if the ﬁltration is stopped at a 6 , or ( a 1 , + ∞ ) if r goes to + ∞ (notice that in this later case, the ﬁltration remains constant for r > a 6 ). The obtained set of intervals encoding the span life of the diﬀerent homological features encountered along the ﬁltration is called the persistence barcode of f . Each interval ( a,a   ) can be represented by the point of coordinates ( a,a   ) in R 2 plane. The resulting set of points is called the persistence diagram of f . Notice that a function may have several copies of the same interval in its persistence barcode. As a consequence, the persistence diagram of f is indeed a multi-set where each point has an integer valued multiplicity. Last, for technical reasons that will become clear in the next section, one adds to the persistence all the points of the diagonal ∆ = { ( b,d ) : b = d } with an inﬁnite multiplicity.

Example 2. Let now f : M → R be the function of Figure 9(b) where M is a 2-dimensional surface homeomorphic to a torus, and let ( F r = f -1 (( -∞ , r ])) r ∈ R be the sublevel set filtration of f . The 0 -dimensional persistent homology is computed as in the previous example, giving rise to the red bars in the barcode. Now, the sublevel sets also carry 1 -dimensional homological features. When r goes through the height a 1 , the sublevel sets F r that were homeomorphic to two discs become homeomorphic to the disjoint union of a disc and an annulus, creating a first cycle homologous to σ 1 on Figure 9(b). A interval (in blue) representing the birth of this new 1 -cycle is thus started at a 1 . Similarly, when r goes through the height a 2 a second cycle, homologous to σ 2 is created, giving rise to the start of a new persistent interval. These two created cycles are never filled (indeed they span H 1 ( M ) ) and the corresponding intervals remains until the end of the filtration. When r reaches a 3 , a new cycle is created that is filled and thus dies at a 4 , giving rise to the persistence interval ( a 3 , a 4 ) . So, now, the sublevel set filtration of f gives rise to two barcodes, one for 0 -dimensional homology (in red) and one for 1 -dimensional homology (in blue). As previously, these two barcodes can equivalently be represented as diagrams in the plane.

[Page 19]

![The image is a graph depicting the relationship between two variables, specifically death and birth rate. The x-axis represents the age, while the y-axis represents the birth rate. The graph consists of two lines, labeled as death and birth. The graph shows a positive correlation between the two variables, indicating that as the age increases, the birth rate also increases. The graph shows the following data points: - The x-axis is labeled age, and the y-axis is labeled birth rate. - The graph shows a positive correlation between the two variables, with a positive correlation coefficient of 0.95. The graph also includes the following data points: - The x-axis is labeled age, and the y-axis is labeled death. - The graph shows a positive correlation between the two variables, with a positive correlation coefficient of 0.95. The graph also includes the following data points](<ChazalMichel2021/imageFile9.png>)

death

06

05

04

03

02

01

0

01

02 03

I

birth

04

@;

M

b)

Figure 9: (a) Example 1: The persistence barcode and the persistence diagram of a function f : [0 , 1] → R . (b) Example 2: the persistence barcode and the persistence diagram of the height function (projection on the z -axis) deﬁned on a surface in R 3 .

[Page 20]

Example 3. In this last example we consider the ﬁltration given by a union of growing balls centered on the ﬁnite set of points C in Figure 10. Notice that this is the sublevel set ﬁltration of the distance function to C , and thanks to the Nerve Theorem, this ﬁltration is homotopy equivalent to the Čech ﬁltration built on top of C . Figure 10 shows several level sets of the ﬁltration:

- a) For the radius r = 0 , the union of balls is reduced to the initial ﬁnite set of point, each of them corresponding to a 0 -dimensional feature, i.e. a connected component; an interval is created for the birth for each of these features at r = 0 .
- b) Some of the balls started to overlap resulting in the death of some connected components that get merged together; the persistence diagram keeps track of these deaths, putting an end point to the corresponding intervals as they disappear.
- c) New components have merged giving rise to a single connected component and, so, all the intervals associated to a 0 -dimensional feature have been ended, except the one corresponding to the remaining components; two new 1 -dimensional features, have appeared resulting in two new intervals (in blue) starting at their birth scale.
- d) One of the two 1-dimensional cycles has been ﬁlled, resulting in its death in the ﬁltration and the end of the corresponding blue interval.
- e) all the 1 -dimensional features have died, it only remains the long (and never dying) red interval. As in the previous examples, the ﬁnal barcode can also be equivalently represented as a persistence diagram where every interval ( a,b ) is represented by the the point of coordinate ( a,b ) in R 2 . Intuitively the longer is an interval in the barcode or, equivalently the farther from the diagonal is the corresponding point in the diagram, the more persistent, and thus relevant, is the corresponding homological feature across the ﬁltration. Notice also that for a given radius r , the k -th Betti number of the corresponding union of balls is equal of the number of persistence intervals corresponding to k -dimensional homological features and containing r . So, the persistence diagram can be seen as a multiscale topological signature encoding the homology of the union of balls for all radii as well as its evolution across the values of r .


# 5.3 Persistent modules and persistence diagrams

Persistent diagrams can be formally and rigorously deﬁned in a purely algebraic way. This requires some care and we only give here the basic necessary notions, leaving aside technical subtelties and diﬃculties. We refer the readers interested in a detailed exposition to Chazal et al. (2016a).

Let Filt = ( F r ) r ∈ T be a ﬁltration of a simplicial complex or a topological space. Given a non negative integer k and considering the homology groups H k ( F r ) we obtain a sequence of vector spaces where the inclusions F r ⊂ F r   , r ≤ r   induce linear maps between H k ( F r ) and H k ( F r   ) . Such a sequence of vector spaces together with the linear maps connecting them is called a persistence module .

[Page 21]

![The image is a bar graph depicting the persistence of a series of events. The graph consists of five horizontal bars, each representing a different event. The bars are color-coded as follows: 1. **A**: This bar is the highest bar, indicating the highest persistence of the event. 2. **B**: This bar is the second-highest bar, indicating the second-highest persistence of the event. 3. **C**: This bar is the third-highest bar, indicating the third-highest persistence of the event. 4. **D**: This bar is the fourth-highest bar, indicating the fourth-highest persistence of the event. 5. **E**: This bar is the lowest bar, indicating the lowest persistence of the event. The x-axis represents the time, ranging from 0 to 1000. The y-axis represents the persistence of the event, ranging from 0 to 1000. The bars](<ChazalMichel2021/imageFile10.png>)

b)

a)

d)

Persistence barcode

diagram

Persistence

Figure 10: The sublevel set ﬁltration of the distance function to a point cloud and the “construction” of its persistence barcode as the radius of balls increases. The blue curves in the unions of balls represent 1 -cycles associated to the blue bars in the barcodes.

[Page 22]

Deﬁnition 7. A persistence module V over a subset T of the real numbers R is an indexed family of vector spaces ( V r | r ∈ T ) and a doubly-indexed family of linear maps ( v r s : V r → V s | r ≤ s ) which satisfy the composition law v s t ◦ v r s = v r t whenever r ≤ s ≤ t , and where v r r is the identity map on V r .

In many cases, a persistence module can be decomposed into a direct sum of intervals modules I ( b,d ) of the form

$$
\cdots \to 0 \to \cdots \to 0 \to \mathbb { Z } _ { 2 } \to \cdots \to \mathbb { Z } _ { 2 } \to 0 \to \cdots
$$

where the maps Z 2 → Z 2 are identity maps while all the other maps are 0 . Denoting b (resp. d ) the inﬁmum (resp. supremum) of the interval of indices corresponding to non zero vector spaces, such a module can be interpreted as a feature that appears in the ﬁltration at index b and disappear at index d . When a persistence module V can be decomposed as a direct sum of interval modules, one can show that this decomposition is unique up to reordering the intervals (see (Chazal et al., 2016a, Theorem 2.7)). As a consequence, the set of resulting intervals is independent of the decomposition of V and is called the persistence barcode of V . As in the examples of the previous section, each interval ( b,d ) in the barcode can be represented as the point of coordinates ( b,d ) in the plane R 2 . The disjoint union of these points, together with the diagonale ∆ = { x = y } is a multi-set called the the persistence diagram of V .

The following result, from (Chazal et al., 2016a, Theorem 2.8), gives some necessary conditions for a persistence module to be decomposable as a direct sum of interval modules.

Theorem 5. Let V be a persistence module indexed by T ⊂ R . If T is a ﬁnite set or if all the vector spaces V r are ﬁnite-dimensional, then V is decomposable as a direct sum of interval modules. Moreover, for any s,t ∈ T , s ≤ t , the number β s t of intervals starting before s and ending after t is equal to the rank of the linear map v s t and is called the ( s,t ) -persistent Betti number of the ﬁltration.

As both conditions above are satisﬁed for the persistent homology of ﬁltrations of ﬁnite simplicial complexes, an immediate consequence of this result is that the persistence diagrams of such ﬁltrations are always well-deﬁned.

Indeed, it is possible to show that persistence diagrams can be deﬁned as soon as the following simple condition is satisﬁed.

Deﬁnition 8. A persistence module V indexed by T ⊂ R is q-tame if for any r < s in T , the rank of the linear map v r s : V r → V s is ﬁnite.

Theorem 6 (Chazal et al. (2009a, 2016a)) . If V is a q-tame persistence module, then it has a well-deﬁned persistence diagram. Such a persistence diagram dgm( V ) is the union of the points of the diagonal ∆ of R 2 , counted with inﬁnite multiplicity, and a multi-set above the diagonal in R 2 that is locally ﬁnite. Here, by locally ﬁnite we mean that for any rectangle R with sides parallel to the coordinate axes that does not intersect ∆ , the number of points of dgm( V ) , counted with multiplicity, contained in R is ﬁnite. Also, the part of the diagram made of the points with inﬁnite second coordinate is called the essential part of the diagram.

The construction of persistence diagrams of q-tame modules is beyond the scope of this paper but it gives rise to the same notion as in the case of decomposable modules. It can be done either by following the algebraic approach based upon the decomposability properties of modules, or by adopting a measure theoretic approach that allows to deﬁne diagrams as integer valued measures on a space of rectangles in the plane. We refer the reader to Chazal et al. (2016a) for more informations.

Although persistence modules encountered in practice are decomposable, the general framework of q-tame persistence module plays a fundamental role in the mathematical and statistical analysis of persistent homology. In particular, it is needed to ensure the existence of limit diagrams when convergence properties are studied see Section 6.

[Page 23]

A ﬁltration Filt = ( F r ) r ∈ T of a simplicial complex or of a topological space is said to be tame if for any integer k , the persistence module ( H k ( F r ) | r ∈ T ) is q -tame. Notice that the ﬁltrations of ﬁnite simplicial complexes are always tame. As a consequence, for any integer k a persistence diagram denoted dgm k (Filt) is associated to the ﬁltration Filt . When k is not explicitly speciﬁed and when there is no ambiguity, it is usual to drop the index k in the notation and to talk about “the” persistence diagram dgm(Filt) of the ﬁltration Filt . This notation has to be understood as “ dgm k (Filt) for some k ”.

# 5.4 Persistence landscapes

The persistence landscape introduced in Bubenik (2015) is an alternative representation of persistence diagrams. This approach aims at representing the topological information encoded in persistence diagrams as elements of an Hilbert space, for which statistical learning methods can be directly applied. The persistence landscape is a collection of continuous, piecewise linear functions λ : N × R → R that summarizes a persistence diagram dgm .

![The image depicts a geometric diagram with several lines and points. Here's a detailed description of the objects and their relationships: 1. **Lines and Points**: - There are two lines labeled as d and d+b. These lines are parallel to each other. - The point a is located on the line d and is located at a distance of 2 units from the point a. - The point b is located on the line d and is located at a distance of 2 units from the point a. 2. **Geometric Relationships**: - The line d is parallel to the line d+b. This means that the points a and b are the same distance from the point d on the line d. - The point a is located on the line d and is located at a distance of 2 units from the point](<ChazalMichel2021/imageFile11.png>)

d+b

d+b

Figure 11: An example of persistence landscape (right) associated to a persistence diagram (left). The ﬁrst landscape is in blue, the second one in red and the last one in orange. All the other landscapes are zero.

A birth-death pair p = ( b,d ) ∈ dgm is transformed into the point   b + d 2 , d − b 2   , see Figure 11. Remember that the points with inﬁnite persistence have been simply discarded in this deﬁnition. The landscape is then deﬁned by considering the set of functions created by tenting the features of the rotated persistence diagram as follows:

$$
\Lambda _ { p } ( t ) = \begin{cases} t - b & t \in [ b , \frac { b + d } { 2 } ] \\ d - t & t \in ( \frac { b + d } { 2 } , d ] \\ 0 & \text {otherwise} . \end{cases}
$$

The persistence landscape λ dgm of dgm is a summary of the arrangement of piecewise linear curves obtained by overlaying the graphs of the functions { Λ p } p ∈ dgm . Formally, the persistence landscape of dgm is the collection of functions

$$
\lambda _ { d g m } ( k , t ) = \underset { r \in d g m } { \max } \ \Lambda _ { r } ( t ) , \ \ t \in [ 0 , T ] , k \in \mathbb { N } ,
$$

where kmax is the k th largest value in the set; in particular, 1 max is the usual maximum function. Given k ∈ N , the function λ dgm ( k,. ) : R → R is called the k -th landscape of dgm . It is not diﬃcult to see that the map that associate to each persistence diagram its corresponding landscape is injective. In other words, formally no information is lost when a persistence diagram is represented through its persistence landscape.

The advantage of the persistence landscape representation is two-fold. First, persistence diagrams are mapped as elements of a functional space, opening the door to the use of a broad variety of statistical and data analysis tools for further processing of topological features - see, e.g. Bubenik (2015); Chazal et al. (2015b) and Section 6.3.1. Second, and fundamental from a theoretical perspective, the persistence landscapes share the same stability properties as persistence diagrams - see Section 5.7.

[Page 24]

# 5.5 Linear representations of persistence homology

A persistence diagram without its essential part can be represented as a discrete measure on ∆ + = { p = ( b,d ) , b < d < ∞} . With a slight abuse of notation, we can write :

$$
\text {dgm} = \sum _ { p \in \text {dgm} } \delta _ { p } ,
$$

where the features are counted with multiplicity and where δ ( b,d ) denotes the Dirac measure in p = ( b,d ) . Most of the persistence-based descriptors that have been proposed to analyze persistence can be expressed as linear transformations of the persistence diagram, seen as a point process

$$
\Psi ( d g m ) = \sum _ { p \in d g m } f ( p ) ,
$$

for some function f deﬁned on ∆ and taking values in a Banach space.

In most cases, we want these transformations to apply independently at each homological dimension. For k ∈ N a given homological dimension we then consider some linear transformation of the persistence diagram restricted to the topological features of dimension k :

$$
\Psi _ { k } ( d g m _ { k } ) = \sum _ { p \in d g m _ { k } } f _ { k } ( p ) ,
$$

where dgm k is the persistence diagram of the topological features of dimension k and where f k is deﬁned on ∆ and takes values in a Banach space.

Betti curve. The simplest way to represent persistence homology is the Betti function or Betti curve. The Betti curve of homological dimension k is deﬁned as

$$
\beta _ { k } ( t ) = \sum _ { ( b , d ) \in \text {dgm} } w ( b , d ) 1 _ { t \in [ b , d ] }
$$

where w is a weight function deﬁned on ∆ . In other words, the Betti curve is the number of barcodes at time m . This descriptor is a linear representation of persistence homology by taking f in (5) such that f ( b,d )( t ) = w ( b,d ) 1 t ∈ [ b,d ] . A typical choice for the weigh function is a increasing function of the persistence w ( b,d ) = ˜ w ( d − b ) where ˜ w is an increasing function deﬁned on R + . One of the ﬁrst applications of Betti curves can be found in Umeda (2017).

Persistence surface. Persistence surface (also called persistence images) is obtained by making the convolution of a diagram with a kernel. It has been introduced in Adams et al. (2017). For K : R 2 → R a kernel and H a 2 × 2 bandwidth matrix (e.g. a symmetric positive deﬁnite matrix), let for u ∈ R 2 1 / 2 1 / 2

$$
K _ { H } ( u ) = \det ( H ) ^ { - 1 / 2 } K ( H ^ { - 1 / 2 } u ) .
$$

Let w : R 2 → R + a weight function deﬁned on ∆ . One deﬁnes the persistence surface of homological dimension k associated to a diagram dgm , with kernel K and bandwidth matrix H by: 2

$$
\forall u \in \mathbb { R } ^ { 2 } , \, \rho _ { k } ( d g m ) ( u ) = \sum _ { p \in d g m _ { k } } w ( r ) K _ { H } ( u - p ) .
$$

[Page 25]

Other linear representations of persistence. Many other linear representations of persistence have been proposed in the literature, such as e. g., the persistence silhouette (Chazal et al., 2015b), the accumulated persistence function (Biscio and Møller, 2019) and variants of the persistence surface (Chen et al., 2017; Kusano et al., 2016; Reininghaus et al., 2015).

Considering persistence diagrams as discrete measure and their vectorizations as linear representation is an approach that also proven fruitful to study distributions of diagrams Divol and Chazal (2020) and the metric structure of the space of persistence diagrams Divol and Lacombe (2020) see Sections 5.6 and 6.3.

# 5.6 Metrics on the space of persistence diagrams

To exploit the topological information and topological features inferred from persistent homology, one needs to be able to compare persistence diagrams, i.e. to endow the space of persistence diagrams with a metric structure. Although several metrics can be considered, the most fundamental one is known as the bottleneck distance .

Recall that a persistence diagram is the union of a discrete multi-set in the half-plane above the diagonal ∆ and, for technical reasons that will become clear below, of ∆ where the point of ∆ are counted with inﬁnite multiplicity. A matching see Figure 12 between two diagrams dgm 1 and dgm 2 is a subset m ⊆ dgm 1 × dgm 2 such that every points in dgm 1 \ ∆ and dgm 2 \ ∆ appears exactly once in m . In other words, for any p ∈ dgm 1 \ ∆ , and for any q ∈ dgm 2 \ ∆ , ( { p } × dgm 2 ) ∩ m and (dgm 1 ×{ q } ) ∩ m each contains a single pair. The Bottleneck distance between dgm 1 and dgm 2 is then deﬁned by

$$
d b (dgm 1 , dgm 2 ) = inf matching m max ( p,q ) ∈ m ‖ p - q ‖ ∞ .
$$

d+b

![The image is a graph titled d_{(d,gm2)} = inf_m(p_q) = max_lp - q_lp with two sets of points. The graph is a line graph with two sets of points, labeled as d_{(d,gm2)} and d_{max_lp,gm2}}. The x-axis is labeled d_{(d,gm2)} and the y-axis is labeled d_{max_lp,gm2}}. The points are represented by blue dots and are connected by a line. The line is drawn from the point d_{(d,gm2)} to the point d_{max_lp,gm2}}. The points are connected by a line that is not perfectly straight. The line is drawn from the point d_{(d,gm2)} to the point](<ChazalMichel2021/imageFile12.png>)

d

dB(dgm1,dgm2)

b

Figure 12: A perfect matching and the Bottleneck distance between a blue and a red diagram. Notice that some points of both diagrams are matched to points of the diagonal.

The practical computation of the bottleneck distance boils down to the computation of a perfect matching in a bipartite graph for which classical algorithms can be used.

[Page 26]

variant, to overcome this issue, the so-called Wasserstein distance between diagrams is sometimes considered. Given p ≥ 1 , it is deﬁned by

$$
W _ { p } ( d g m _ { 1 } , d g m _ { 2 } ) ^ { p } = \inf _ { \text {matching} } \sum _ { ( p , q ) \in m } \| p - q \| _ { \infty } ^ { p } .
$$

Useful stability results for persistence in the W p metric exist among the literature, in particular Cohen-Steiner et al. (2010), but they rely on assumptions that make them consequences of the stability results in the bottleneck metric. A general study of the space of persistence diagrams endowed with W p metrics has been considered in Divol and Lacombe (2020) where they propose a general framework, based upon optimal partial transport, in which many important properties of persistence diagrams can be proven in a natural way.

# 5.7 Stability properties of persistence diagrams

A fundamental property of persistence homology is that persistence diagrams of ﬁltrations built on top of data sets turn out to be very stable with respect to some perturbations of the data. To formalize and quantify such stability properties, we ﬁrst need to precise the notion of perturbation that are allowed.

Rather than working directly with ﬁltrations built on top of data sets, it turns out to be more convenient to deﬁne a notion of proximity between persistence module from which we will derive a general stability result for persistent homology. Then, most of the stability results for speciﬁc ﬁltrations will appear as a consequence of this general theorem. To avoid technical discussions, from now on we assume, without loss of generality, that the considered persistence modules are indexed by R .

Deﬁnition 9. Let V , W be two persistence modules indexed by R . Given δ ∈ R , a homomorphism of degree δ between V and W is a collection Φ of linear maps φ r : V r → W r + δ , for all r ∈ R such that for any r ≤ s , φ s ◦ v r s = w r + δ s + δ ◦ φ r .

An important example of homomorphism of degree δ is the shift endomorphism 1 δ V which consists of the families of linear maps ( v r r + δ ) . Notice also that homomorphisms of modules can naturally be composed: the composition of a homomorphism Ψ of degree δ between U and V and a homomorphism Φ of degree δ   between V and W naturally gives rise to a homomorphism ΦΨ of degree δ + δ   between U and W .

Deﬁnition 10. Let δ ≥ 0 . Two persistence modules V , W are δ -interleaved if there exists two homomorphism of degree δ , Φ , from V to W and Ψ , from W to V such that ΨΦ = 1 2 δ V and ΦΨ = 1 2 δ W .

Although it does not deﬁne a metric on the space of persistence modules, the notion of closeness between two persistence module may be deﬁned as the smallest non negative δ such that they are δ -interleaved. Moreover, it allows to formalize the following fundamental theorem Chazal et al. (2009a, 2016a).

Theorem 7 (Stability of persistence) . Let V and W be two q-tame persistence modules. If V and W are δ -interleaved for some δ ≥ 0 , then

$$
d _ { b } ( d g m ( \mathbb { V } ) , d g m ( \mathbb { W } ) ) \leq \delta .
$$

Although purely algebraic and rather abstract, this result is a eﬃcient tool to easily establish concrete stability results in TDA. For example we can easily recover the ﬁrst persistence stability result that appeared in the literature (Cohen-Steiner et al., 2005).

[Page 27]

Theorem 8. Let f,g : M → R be two real-valued functions deﬁned on a topological space M that are q -tame, i.e. such that the sublevel sets ﬁltrations of f and g induce q -tame modules at the homology level. Then for any integer k ,

$$
d _ { b } ( d g m _ { k } ( f ) , d g m _ { k } ( g ) ) \leq \| f - g \| _ { \infty } = \sup _ { x \in M } | f ( x ) - g ( x ) |
$$

where dgm k ( f ) (resp. dgm k ( g ) ) is the persistence diagram of the persistence module ( H k ( f − 1 ( −∞ ,r ])) | r ∈ R ) (resp. ( H k ( g − 1 ( −∞ ,r ])) | r ∈ R ) ) where the linear maps are the one induced by the canonical inclusion maps between sublevel sets.

Proof. Denoting δ =   f − g   ∞ we have that for any r ∈ R , f − 1 ( −∞ ,r ]) ⊆ g − 1 ( −∞ ,r + δ ]) and g − 1 ( −∞ ,r ]) ⊆ f − 1 ( −∞ ,r + δ ]) . This interleaving between the sublevel sets of f induces a δ -interleaving between the persistence modules at the homology level and the result follows from the direct application of Theorem 7.

Theorem 7 also implies a stability result for the persistence diagrams of ﬁltrations built on top of data.

Theorem 9. Let X and Y be two compact metric spaces and let Filt( X ) and Filt( Y ) be the Vietoris-Rips of Čech ﬁltrations built on top X and Y . Then

$$
d _ { b } \left ( \text {dgm} ( \text {Filt} ( \mathbb { X } ) ) , \text {dgm} ( \text {Filt} ( \mathbb { Y } ) ) \right ) \leq 2 d _ { G H } ( \mathbb { X } , \mathbb { Y } )
$$

where dgm(Filt( X )) and dgm(Filt( Y )) denote the persistence diagram of the ﬁltrations Filt( X ) and Filt( X ) .

As we already noticed in the Example 3 of Section 5.2, the persistence diagrams can be interpreted as multiscale topological features of X and Y . In addition, Theorem 9 tells us that these features are robust with respect to perturbations of the data in the Gromov-Hausdorﬀ metric. They can be used as discriminative features for classiﬁcation or other tasks see, for example, Chazal et al. (2009b) for an application to non rigid 3D shapes classiﬁcation.

We now give similar results for the alternative persistence homology representations introduced before. From the deﬁnition of persistence landscape we immediately observe that λ ( k, · ) is one-Lipschitz and thus similar stability properties are satisﬁed for the landscapes as for persistence diagrams.

Proposition 1 (Stability of persistence landscapes Bubenik (2015). ) . Let dgm and dgm   be two persistence diagrams (without their essential parts). For any t ∈ R and any k ∈ N , we have: (i) λ ( k,t ) ≥ λ ( k + 1 ,t ) ≥ 0 . (ii) | λ ( k,t ) − λ   ( k,t ) | ≤ d b (dgm , dgm   )) .

A large class of linear representations are continuous with respect to the Wasserstein metric W s in the space of persistence diagrams and with respect to the Banach norm of the linear representation of persistence. Generally speaking, it is not always possible to upper bound the modulus of continuity of the linear representation operator. However, in the case where s = 1 it is even possible to show a stability result if the weight function take small values for points close to the diagonal, see Divol and Lacombe (2020); Hofer et al. (2019b).

Stability versus discriminative capacity of persistence representations. The results of Divol and Lacombe (2020) show that continuity and stability is only possible with weigh functions taking small values for points close to the diagonal. However, in general there is no speciﬁc reason to consider that points close to the diagonal are less important than others, given a learning task. In a machine learning perspective, it is also relevant to design linear representation with general weigh functions, although it would be more diﬃcult to prove consistency of the

[Page 28]

# 6 Statistical aspects of persistent homology

Persistence homology by itself does not take into account the random nature of data and the intrinsic variability of the topological quantity they infer. We now present a statistical approach to persistent homology, in the sense that data is considered as generated from an unknown distribution. We start with several consistency results for persistent homology inference.

# 6.1 Consistency results for persistent homology

Assume that we observe n points ( X 1 ,...,X n ) in a metric space ( M,ρ ) drawn i.i.d. from an unknown probability measure µ whose support is a compact set denoted X µ . The GromovHausdorﬀ distance allows us to compare X µ with compact metric spaces not necessarily embedded in M . In the following, an estimator   X of X µ is a function of X 1 ...,X n that takes values in the set of compact metric spaces.

Let Filt( X µ ) and Filt(   X ) be two ﬁltrations deﬁned on X µ and   X . Starting from Theorem 9; an natural strategy for estimating the persistent homology of Filt( X µ ) consists in estimating the support X µ . Note that in some cases the space M can be unknown and the observations X 1 ...,X n are then only known through their pairwise distances ρ ( X i ,X j ) , i,j = 1 , ··· ,n . The use of the Gromov-Hausdorﬀ distance allows us to consider this set of observations as an abstract metric space of cardinality n , independently of the way it is embedded in M . This general framework includes the more standard approach consisting in estimating the support with respect to the Hausdorﬀ distance by restraining the values of   X to the compact sets included in M .

The ﬁnite set X n := { X 1 ,...,X n } is a natural estimator of the support X µ . In several contexts discussed in the following, X n shows optimal rates of convergence to X µ with respect to the Hausdorﬀ distance. For some constants a,b > 0 , we say that µ satisﬁes the ( a,b ) -standard assumption if for any x ∈ X µ and any r > 0 ,

$$
\mu ( B ( x , r ) ) \geq \min ( a r ^ { b } , 1 ) .
$$

This assumption has been widely used in the literature of set estimation under Hausdorﬀ distance (Cuevas and Rodríguez-Casal, 2004; Singh et al., 2009). Under this assumption, it can be easily derived that the rate of convergence of dgm(Filt( X n )) to dgm(Filt( X µ )) for the bottleneck metric is upper bounded by O   log n n   1 /b . More precisely, this rate upper bounds the minimax rate of convergence over the set of probability measures on the metric space ( M,ρ ) satisfying the ( a,b ) standard assumption on M .

Theorem 10. [Chazal et al. (2014b)] For some positive constants a and b , let

$$
\mathcal { P } \coloneqq \left \{ \mu \ o n \ M \ | \ \mathbb { X } _ { \mu } \ i s \ c o m p a c t \ a n d \ \forall x \in \mathbb { X } _ { \mu } , \forall r > 0 , \, \mu \left ( B ( x , r ) \right ) \geq \min \left ( 1 , a r ^ { b } \right ) \right \} .
$$

Then, it holds

$$
\sup _ { \mu \in \mathcal { P } } \mathbb { E } \left [ d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \mathbb { X } _ { n } ) ) ) \right ] \leq C \left ( \frac { \log n } { n } \right ) ^ { 1 / b }
$$

where the constant C only depends on a and b .

[Page 29]

Under additional technical assumptions, the corresponding lower bound can be shown (up to a logarithmic term), see Chazal et al. (2014b). By applying stability results, similar consistency results can be easily derived under alternative generative models as soon as a consistent estimator of the support under Hausdorﬀ metric is known. For instance, from the results of Genovese et al. (2012) about Hausdorﬀ support estimation under additive noise, it can be deduced that the minimax convergence rates for the persistence diagram estimation is faster than (log n ) − 1 / 2 . Moreover, as soon as a stability result is available for some given representation of persistence, similar consistency results can be directly derived from the consistency for persistence diagrams.

Estimation of the persistent homology of functions. Theorem 7 opens the door to the estimation of the persistent homology of functions deﬁned on R d , on a submanifold of R d or more generally on a metric space. The persistent homology of regression functions has also been studied in Bubenik et al. (2010). The alternative approach of Bobrowski et al. (2014) which is based on the inclusion map between nested pairs of estimated level sets can be applied with kernel density and regression kernel estimators to estimate persistence homology of density functions and regression functions. Another direction of research on this topic concerns various versions of robust TDA. One solution is to study the persistent homology of the upper level sets of density estimators (Fasy et al., 2014b). A diﬀerent approach, more closely related to the distance function, but robust to noise, consists in studying the persistent homology of the sub level sets of the distance to measure deﬁned in Section 4.4 (Chazal et al., 2014a).

# 6.2 Statistic of persistent homology computed on a point cloud

For many applications, in particular when the support of the point cloud is not drawn on or close to a geometric shape, persistence diagrams can be quite complex to analyze. In particular, many topological features are closed to the diagonal. Since they correspond to topological structures that die very soon after they appear in the ﬁltration, these points are generally considered as noise, see Figure 13 for an illustration. Conﬁdence regions of persistence diagram are rigorous answers to the problem of distinguishing between signal and noise in these representations.

The stability results given in Section 5.7 motivate the use of the bottleneck distance to deﬁne conﬁdence regions. However alternative distances in the spirit of Wasserstein distances can be proposed too. When estimating a persistence diagram dgm with an estimator   dgm , we typically look for some value η α such that

$$
P ( d _ { b } ( d g m , d g m ) \geq \eta _ { \alpha } ) \leq \alpha ,
$$

  for α ∈ (0 , 1) . Let B α be the closed ball of radius α for the bottleneck distance and centered at   dgm in the space of persistence diagrams. Following Fasy et al. (2014b), we can visualize the signatures of the points belonging to this ball in various ways. One ﬁrst option is to center a box of side length 2 α at each point of the persistence diagram   dgm . An alternative solution is to visualize the conﬁdence set by adding a band at (vertical) distance η α / 2 from the diagonal (the bottleneck distance being deﬁned for the   ∞ norm), see Figure 13 for an illustration. The points outside the band are then considered as signiﬁcant topological features, see Fasy et al. (2014b) for more details.

Several methods have been proposed in Fasy et al. (2014b) to estimate η α in diﬀerent frameworks. These methods mainly rely from stability results for persistence diagrams: conﬁdence sets for diagrams can be derived from conﬁdence sets in the sample space.

Subsampling approach. This method is based on a conﬁdence region for the support K of the distribution of the sample in Hausdorﬀ distance. Let ˜ X b be a subsample of size b drawn from the sample ˜ X n , where b = o ( n/logn ) . Let q b (1 − α ) be the quantile of of the distribution of Haus   ˜ X b , X n   . Take ˆ η α := 2ˆ q b (1 − α ) where ˆ q b is an estimation q b (1 − α ) using a standard

[Page 30]

$$
P \left ( d _ { b } \left ( d g m \left ( F i l t ( K ) \right ) , d g m \left ( F i l t ( \mathbb { X } _ { n } ) \right ) \right ) > \hat { \eta } _ { \alpha } \right ) & \quad \leq \quad P \left ( \text {Haus} \left ( K , \mathbb { X } _ { n } \right ) > \hat { \eta } _ { \alpha } \right ) \\ & \quad \leq \quad \alpha + O \left ( \frac { b } { n } \right ) ^ { 1 / 4 } .
$$

Bottleneck Bootstrap. The stability results often leads to conservative conﬁdence sets. An alternative strategy is the bottleneck bootstrap introduced in Chazal et al. (2016b). We consider the general setting where a persistence diagram   dgm is deﬁned from the observation ( X 1 ,...,X n ) in a metric space. This persistence diagram corresponds to the estimation of an underlying persistence diagram dgm , which can be related for instance to the support of the measure, or to the sublevel sets of a function related to this distribution (for instance a density function when the X i ’s are in R d ). Let ( X ∗ 1 ,...,X ∗ n ) be a sample from the empirical measure deﬁned from the observations ( X 1 ,...,X n ) . Let also   dgm ∗ be the persistence diagram derived from this sample. We then can take for η α the quantity ˆ η α deﬁned by

$$
P ( d _ { b } ( \widehat { d g m } ^ { * } , \widehat { d g m } ) > \hat { \eta } _ { \alpha } | \, X _ { 1 } , \dots , X _ { n } ) = \alpha .
$$

Note that ˆ η α can be easily estimated with Monte Carlo procedures. It has been shown in Chazal et al. (2016b) that the bottleneck bootstrap is valid when computing the sublevel sets of a density estimator.

Bootstrapping Persistent Betti numbers. As already mentioned, conﬁdence regions based on stability properties of persistence may lead to very conservative conﬁdence regions. Based on the concepts of stabilizing statistics Penrose and Yukich (2001), asymptotic normality for persistent Betti numbers has been shown recently by Krebs and Polonik (2019); Roycraft et al. (2020), under very mild conditions on the ﬁltration and the distribution of sample cloud. In addition, bootstrap procedures are also shown to be valid in this framework. More precisely, a smoothed bootstrap procedure together with a convenient rescaling of the point cloud seems to be a promising approach for boostrapping TDA features from point cloud data.

# 6.3 Statistic for a family of persistent diagrams or other representations

Up to now in this section, we were only considering statistics based on one single observed persistence diagram. We now consider a new framework where several persistence diagrams (or other representations) are available and we are interested in providing central tendency, conﬁdence regions and hypothesis tests for topological descriptors built on this family.

# 6.3.1 Central tendency for persistent homology

Mean and expectations of distributions of diagrams. The space of persistence diagrams being a general metric space but not an Hilbert space, the deﬁnition of a mean persistence diagram is not obvious and unique. One ﬁrst natural approach to deﬁne a central tendency in this context is to consider Fréchet means of distributions of diagrams. Their existence has been proved in Mileyko et al. (2011) and they have also been characterized in Turner et al. (2014a). However they are may not be unique and they turn out to be diﬃcult to compute in practice. To partly overcome these problems, diﬀerent approaches have been recently proposed based on numerical optimal transport Lacombe et al. (2018) or linear representations and kernel based methods Divol and Chazal (2020).

[Page 31]

Topological signatures from subsamples Central tendency properties of persistent homology can also be used to compute topological signatures for very large data sets, as an alternative approach to overcome the prohibitive cost of persistence computations. Given a large point cloud, the idea is to extract many subsamples, to compute the persistence landscape for each subsample and then to combine the information.

For any positive integer m , let X = { x 1 , ··· ,x m } be a sample of m points drawn from a measure µ in a metric space M and which support is denoted X µ . We assume that the diameter of X µ is ﬁnite and upper bounded by T 2 , where T is the same constant as in the deﬁnition of persistence landscapes in Section 5.4. For ease of exposition, we focus on the case k = 1 , and set λ ( t ) = λ (1 ,t ) . However, the results we present in this section hold for k > 1 . The corresponding persistence landscape (associated to the persistence diagram of the Čech or Rips-Vietoris ﬁltration) is λ X and we denote by Ψ m µ the measure induced by µ ⊗ m on the space of persistence landscapes. Note that the persistence landscape λ X can be seen as a single draw from the measure Ψ m µ . The point-wise expectations of the (random) persistence landscape under this measure is deﬁned by E Ψ m µ [ λ X ( t )] ,t ∈ [0 ,T ] . The average landscape E Ψ m µ [ λ X ] has a natural empirical counterpart, which can be used as its unbiased estimator. Let S m 1 ,...,S m   be   independent samples of size m from µ ⊗ m . We deﬁne the empirical average landscape as

$$
\overline { \lambda _ { \ell } ^ { m } } ( t ) = \frac { 1 } { b } \sum _ { i = 1 } ^ { b } \lambda _ { S _ { i } ^ { m } } ( t ) , \quad \text {for all } t \in [ 0 , T ] ,
$$

and propose to use λ m   to estimate λ X µ . Note that computing the persistent homology of X n is O (exp( n )) , whereas computing the average landscape is O ( b exp( m )) .

Another motivation for this subsampling approach is that it can be also applied when µ is a discrete measure with support X N = { x 1 ,...,x N } lying in a metric space M . This framework can be very common in practice, when a continuous (but unknown measure) is approximated by a discrete uniform measure µ N on X N .

The average landscape E Ψ m µ [ λ X ] is an interesting quantity on its own, since it carries some stable topological information about the underlying measure µ , from which the data are generated.

Theorem 11. [Chazal et al. (2015a)] Let X ∼ µ ⊗ m and Y ∼ ν ⊗ m , where µ and ν are two probability measures on M . For any p ≥ 1 we have

$$
\left \| \mathbb { E } _ { \Psi _ { \mu } ^ { m } } [ \lambda _ { X } ] - \mathbb { E } _ { \Psi _ { \nu } ^ { m } } [ \lambda _ { Y } ] \right \| _ { \infty } \leq 2 \, m ^ { \frac { 1 } { p } } W _ { p } ( \mu , \nu ) ,
$$

where W p is the p th Wasserstein distance on M .

The result of Theorem 11 is useful for two reasons. First, it tells us that for a ﬁxed m , the expected "topological behavior" of a set of m points carries some stable information about the underlying measure from which the data are generated. Second, it provides a lower bound for the Wasserstein distance between two measures, based on the topological signature of samples of m points.

# 6.3.2 Asymptotic normality

As in the previous section, we consider several persistence diagrams (or other representations). The next step after giving central tendency descriptors of persistence homology is to provide asymptotic normality results for these quantities together with bootstrap procedures to derive conﬁdence regions. It is of course easier to show such results for functional representations of persistence. In Chazal et al. (2013a, 2015b), following this strategy conﬁdence bands for landscapes are proposed from the observation of landscapes λ 1 ,...,λ N drawn i.i.d. from a random distribution in the space of landscapes. The asymptotic validity as well as the uniform

[Page 32]

# 6.4 Other statistical approaches to TDA

Statistical approaches for tda are knowing an increasing interest and many others have been proposed in the recent years or are still subject to active research activities, as illustrated in the following non-exhaustive list of examples.

Hypothesis testing. Several methods have been proposed for hypothesis testing procedures for persistent homology, mostly based on permutation strategies and for two sample testing. Robinson and Turner (2017) focuses on pairwise distances of persistence diagrams whereas Berry et al. (2020) study more general functional summaries. Hypothesis tests based on kernel approaches have been proposed in Kusano (2019). A two-stage hypothesis test of ﬁltering and testing for persistent images is also presented inMoon and Lazar (2020).

Persistence Homology Transform. The representations introduced before are all transformations derived from the persistence diagram computed from a ﬁxed ﬁltration built over a data set. The Persistence Homology Transform introduced in Curry et al. (2018); Turner et al. (2014b) to study shapes in R d , takes a diﬀerent path by looking at the persistence homology of the sublevel set ﬁltration induced by the projection of the considered shape to each direction in R d . It comes with several interesting properties, in particular the Persistence Homology Transform is a suﬃcient statistic for distributions deﬁned on the set of geometric and ﬁnite simplicial complexes embedded in R d .

Bayesian statistics for TDA. A Bayesian approach to persistence diagram inference has been proposed in Maroulas et al. (2020) by viewing a persistence diagram as a sample from a point process. This Bayesian method computes the point process posterior intensity based on a Gaussian mixture intensity for the prior.

# 6.5 Persistent homology and machine learning

Using tda and more speciﬁcally persistent homology for machine learning is a subject that attracts a lot of information and generated an intense research activity. Although the recent progress in this area goes far beyond the scope of this paper, we brieﬂy introduce the main research directions with a few reference to help the newcomer to the ﬁeld to get started.

tda for exploratory data analysis and descriptive statistics. In some domains, tda can be fruitfully used as a tool for exploratory analysis and visualization. For example, the Mapper algorithm provides a powerful approach to explore and vizualize the global topological structure of complex data sets. In some cases, persistence diagrams obtained from data can be directly interpreted and exploited for better understanding of the phenomena from which the data have been generated. This is, for example, the case in the study of force ﬁelds in granular media (Kramar et al., 2013) or of atomic structures in glass (Nakamura et al., 2015) in material science, in the study of the evolution of convection patterns in ﬂuid dynamics (Kramár et al., 2016), in machining monitoring (Khasawneh and Munch, 2016) or in the analysis of nanoporous structures in chemistry (Lee et al., 2017) where topological features can be rather clearly related to speciﬁc geometric structures and patterns in the considered data.

[Page 33]

Persistent homology for feature engineering. There are many other cases where persistence features cannot be easily or directly interpreted but present valuable information for further processing. However, the highly non linear nature of diagrams prevents them to be immediately used as standard features in machine learning algorithms.

Persistence landscapes and linear representations of persistence diagrams oﬀer a ﬁrst option to convert persistence diagrams into elements of a vector space that can be directly used as features in classical machine learning pipelines. This approach has been used, for example, for protein binding (Kovacev-Nikolic et al., 2016), object recognition (Li et al., 2014) or time-series analysis. In the same vein, the construction of kernels for persistence diagrams that preserve their stability properties has recently attracted some attention. Most of them have been obtained by considering diagrams as discrete measures in R 2 . Convolving a symmetrized (with respect to the diagonal) version of persistence diagrams with a 2D Gaussian distribution, Reininghaus et al. (2015) introduce a multi-scale kernel and apply it to shape classiﬁcation and texture recognition problems. Considering Wasserstein distance between projections of persistence diagrams on lines, Carriere and Oudot (2017) build another kernel and test its performance on several benchmarks. Other kernels, still obtained by considering persistence diagrams as measures, have also been proposed in Kusano et al. (2017).

Various other vector summaries of persistence diagrams have been proposed and then used as features for diﬀerent problems. For example, basic summaries are considered in Bonis et al. (2016) and combined with quantization and pooling methods to address non rigid shape analysis problems; Betti curves extracted from persistence diagrams are used with 1-dimensional Convolutional Neural Networks (CNN) to analyze time dependent data and recognize human activities from inertial sensors in Dindin et al. (2020); Umeda (2017); persistence images are introduced in Adams et al. (2017) and are considered to address some inverse problems using linear machine learning models in Obayashi and Hiraoka (2017).

The above mentioned kernels and vector summaries of persistence diagrams are built independently of the considered data analysis or learning task. Moreover, it appears that in many cases the relevant topological information is not carried by the whole persistence diagrams but is concentrated in some localized regions that may not be obvious to identify. This usually makes the choice of a relevant kernel or vector summary very diﬃcult for the user. To overcome this issue, various authors have proposed learning approaches that allows to learn the relevant topological features for a given task. In this direction, Hofer et al. (2017) proposes a deep learning approach to learn parameters of persistence images representations of persistence diagrams while Kim et al. (2020) introduce a neural network layer for persistence landscapes. In Carrière et al. (2020), the authors introduce a general neural network layer for persistence diagrams that can be either used to learn an appropriate vectorization or directly integrated in a deep neural network architecture. Other methods, inspired from k-means, propose unsupervised methods to vectorize persistence diagrams Royer et al. (2021); Zieliński et al. (2010), some of them coming with theoretical guarantees Chazal et al. (2020).

Persistent homology for machine learning architecture optimization and model selection. More recently, tda has found new developments in machine learning where persistent homology is no longer used for feature engineering but as a tool to design, improve or select models see, e.g. Carlsson and Gabrielsson (2020); Chen et al. (2019); Gabrielsson and Carlsson (2019); Hofer et al. (2019a); Moor et al. (2020); Ramamurthy et al. (2019); Rieck et al. (2019). Many of these tools rely on the introduction of loss or regularization functions depending on persistent homology features, raising the problem of their optimization. Building on the powerful tools provided by software libraries such as PyTorch or TensorFlow, practical methods allowing to encode and optimize a large family of persistence-based functions have been proposed and experimented Brüel-Gabrielsson et al. (2019); Poulenard et al. (2018). A general framework for persistence-based function optimization based on stochastic subgradient descent algorithms with

[Page 34]

# 7 tda for data sciences with the GUDHI library

In this section we illustrate TDA methods with the Python library Gudhi 11 (Maria et al., 2014) together with popular libraries as numpy (Walt et al., 2011), scikit-learn (Pedregosa et al., 2011), pandas (McKinney et al., 2010). More illustrations with python notebooks can be found in the Tutorial Github page 12 of Gudhi.

# 7.1 Bootstrap and comparison of protein binding conﬁgurations

This example is borrowed from Kovacev-Nikolic et al. (2016). In this paper, persistent homology is used to analyze protein binding and more precisely it compares closed and open forms of the maltose-binding protein (MBP), a large biomolecule consisting of 370 amino acid residues. The analysis is not based on geometric distances in R 3 but on a metric of dynamical distances deﬁned by

$$
D _ { i j } = 1 - | C _ { i j } | ,
$$

where C is the correlation matrices between residues. The data can be download at this link 13 .

1 import numpy as np 2 import gudhi as gd 3 import pandas as pd 4 import seaborn as sns 5 6 corr_protein = pd . read_csv ( "mypath/1 anf . corr_1 . txt " , 7 header=None , 8 delim_whitespace=True) 9 dist_protein_1 = 1− np . abs ( corr_protein_1 . values ) 10 rips_complex_1= gd . RipsComplex ( distance_matrix=dist_protein_1 , 11 max_edge_length=1.1) 12 simplex_tree_1 = rips_complex_1 . create_simplex_tree (max_dimension=2) 13 diag_1 = simplex_tree_1 . persistence () 14 gd . plot_persistence_diagram ( diag_1 )

For comparing persistence diagrams, we use the bottleneck distance. The block of statements given below computes persistence intervals and computes the bottleneck distance for 0-homology and 1-homology:

1 interv0_1 = simplex_tree_1 . persistence_intervals_in_dimension (0) 2 interv0_2 = simplex_tree_2 . persistence_intervals_in_dimension (0) 3 bot0 = gd . bottleneck_distance ( interv0_1 , interv0_2 ) 4 5 interv1_1 = simplex_tree_1 . persistence_intervals_in_dimension (1) 6 interv1_2 = simplex_tree_2 . persistence_intervals_in_dimension (1) 7 bot1 = gd . bottleneck_distance ( interv1_1 , interv1_2 )

In this way, we can compute the matrix of bottleneck distances between the fourteen MPB. Finally, we apply a multidimensional scaling method to ﬁnd a conﬁguration in R 2 which almost match with the bottleneck distances, see Figure 13(c). We use the scikit-learn library for the MDS:

1 import matplotlib . pyplot as plt 2 from sklearn import manifold

11 http://gudhi.gforge.inria.fr/python/latest/ 12 https://github.com/GUDHI/TDA-tutorial 13 https://www.researchgate.net/publication/301543862_corr

[Page 35]

![The image is a scatter plot with four different categories labeled Birth, Persistence, Dropped, and Dropped. The x-axis represents the Birth category, and the y-axis represents the Dropped. The plot is titled Persistence. The scatter plot is visually represented with four different colored lines. The first line is red, the second line is green, the third line is orange, and the fourth line is blue. The red line is the highest line in the plot, and it is located at the top of the plot. The green line is the second-highest line, and it is located at the bottom of the plot. The orange line is the third-highest line, and it is located at the middle of the plot. The blue line is the lowest line, and it is located at the bottom of the plot. Each of the four lines in the scatter plot is labeled with a different color.](<ChazalMichel2021/imageFile13.png>)

Persistence diagram

Persistence diagram

0.8

1.0

0.7

0.8

0.6

0.5

0.6

0.4

0.4

0.3

0.2

0.0

0.0

00

01

02

0.3

04

05

0.6

0.7

00

0 2

0.6

Birth

Birth

(b)

(a)

Persistence diagram

0.8

0.7

dosed

0.20

0.6

0.15

05

0.10

0.4

0.05

0.3

0.00

0.1

00

0.2

0.3

04

0.5

0.6

0.7

40.10

40.05

0.15

Birth

~0.20

0.00

0.05

(d)

(c)

Figure 13: (a) and (b) two persistence diagrams for two conﬁgurations of MBP. (c) MDS conﬁguration for the matrix of bottleneck distances. (d) Persistence diagram and conﬁdence region for the persistence diagram of a MBP.

3 4 mds = manifold .MDS(n_components=2, d i s s i m i l a r i t y= " precomputed " ) 5 config = mds. f i t (M) . embedding_ 6 7 plt . scatter ( config [ 0 : 7 , 0 ] , config [ 0 : 7 , 1] , color= ’ red ’ , label= " closed " ) 8 plt . scatter ( config [ 7 : l , 0 ] , config [ 7 : l , 1] , color= ’ blue ’ , label= " red " ) 9 plt . legend ( loc =1)

We now deﬁne a conﬁdence band for a diagram using the bottleneck bootstrap approach. We resample over the lines (and columns) of the matrix of distances and we compute the bottleneck distance between the original persistence diagram and the bootstrapped persistence diagram. We repeat the procedure many times and ﬁnally we estimate the quantile 95 % of this collection of bottleneck distances. We take the value of the quantile to deﬁne a conﬁdence band on the original diagram (see Figure 13(d)). However, such a procedure should be considered with caution because as far as we know the validity of the bottleneck bootstrap has not been proved in this framework.

[Page 36]

# 7.2 Classiﬁcation for sensor data

In this experiment, the 3d acceleration of 3 walkers (A, B and C) have been recorded from the sensor of a smart phone 14 . Persistence homology is not sensitive to the choice of axes and so no preprocessing is necessary to align the 3 times series according to the same axis. From these three times series, we have picked at random sequences of 8 seconds in the complete time series, that is 200 consecutive points of acceleration in R 3 . For each walker, we extract 100 time series in this way. The next block of statements computes the persistence for the alpha complex ﬁltration for data_A_sample , one of the 100 times series of acceleration of Walker A.

1 alpha_complex_sample = gd . AlphaComplex( points = data_A_sample) 2 simplex_tree_sample = alpha_complex_sample . create_simplex_tree (max_alpha_square =0.3) 3 diag_Alpha = simplex_tree_sample . persistence ()

From diag_Alpha we can then easily compute and plot the persistence landscapes, see Figure 14(a). For all the 300 times series, we compute the persistence landscapes for dimension 0 and 1 and we compute the three ﬁrst landscapes for the 2 dimensions. Moreover, each persistence landscape is discretized on 1000 points. Each time series is thus described by 6000 topological variables. To predict the walker from these features, we use a random forest (Breiman, 2001), which is known to be an eﬃcient in such an high dimensional setting. We split the data into train and test samples at random several times. We ﬁnally obtain an averaged classiﬁcation error around 0.95. We can also visualize the most important variables in the Random Forest, see Figure 14(b).

![The image is a bar chart titled Bars with a legend at the top. The chart is divided into two sections, each representing a different category. The x-axis is labeled a and the y-axis is labeled b. The bars are color-coded to represent the values of the categories. ### Description of the Bar Chart: - **Axes**: - The x-axis is labeled a and the y-axis is labeled b. - The y-axis is labeled b and the x-axis is labeled a. - **Bars**: - The chart has four distinct bars. - The first bar is colored orange, the second bar is colored green, the third bar is colored blue, and the fourth bar is colored black. - **Bars Color Coding**: - The orange bar represents the value of the category a, the green bar represents the value of](<ChazalMichel2021/imageFile14.png>)

0040

0035

0020

0030

0025

0015

0020

0010

0015

0010

0005

0.005

0000

0000

005

0 10

0 15

0 20

4000

000

0 30

2000

3000

(a)

(b)

Figure 14: (a)The three ﬁrst landscapes for 0-homology of the alpha shape ﬁltration deﬁned for a time series of acceleration of Walker A. (b) Variable importances of the landscapes coeﬃcients for the classiﬁcation of Walkers. The 3 000 ﬁrst coeﬃcients correspond to the three landscapes of dimension 0 and the 3 000 last coeﬃcients to the three landscapes of dimension 1. There are 1000 coeﬃcients per landscape. Note that the ﬁrst landscape of dimension 0 is always the same using the Rips complex (a trivial landscape) and consequently the corresponding coeﬃcients have a zero importance value.

Acknowledgements This work was partly supported by the French ANR chair in Artiﬁcial Intelligence TopAI. We thank the authors of Kovacev-Nikolic et al. (2016) for making their data available.

14 The dataset can be download at this link http://bertrand.michel.perso.math.cnrs.fr/Enseignements/ TDA/data_acc

[Page 37]

# References

Aamari, E., Kim, J., Chazal, F., Michel, B., Rinaldo, A., Wasserman, L., et al. (2019). Estimating the reach of a manifold. Electronic journal of statistics , 13(1):1359–1399.

Adams, H., Emerson, T., Kirby, M., Neville, R., Peterson, C., Shipman, P., Chepushtanova, S., Hanson, E., Motta, F., and Ziegelmeier, L. (2017). Persistence images: a stable vector representation of persistent homology. Journal of Machine Learning Research , 18(8):1–35.

Anai, H., Chazal, F., Glisse, M., Ike, Y., Inakoshi, H., Tinarrage, R., and Umeda, Y. (2020). Dtm-based ﬁltrations. In Topological Data Analysis , pages 33–66. Springer.

Balakrishna, S., Rinaldo, A., Sheehy, D., Singh, A., and Wasserman, L. A. (2012). Minimax rates for homology inference. Journal of Machine Learning Research Proceedings Track , 22:64–72.

Barannikov, S. (1994). The framed morse complex and its invariants. In Adv. Soviet Math. , volume 21, pages 93–115. Amer. Math. Soc., Providence, RI.

Berry, E., Chen, Y.-C., Cisewski-Kehe, J., and Fasy, B. T. (2020). Functional summaries of persistence diagrams. Journal of Applied and Computational Topology , 4(2):211–262.

Biau, G., Chazal, F., Cohen-Steiner, D., Devroye, L., and Rodriguez, C. (2011). A weighted k-nearest neighbor density estimate for geometric inference. Electronic Journal of Statistics , 5:204–237.

Biscio, C. A. and Møller, J. (2019). The accumulated persistence function, a new useful functional summary statistic for topological data analysis, with a view to brain artery trees and spatial point process applications. Journal of Computational and Graphical Statistics , pages 1–21.

Bobrowski, O., Mukherjee, S., and Taylor, J. (2014). Topological consistency via kernel estimation. arXiv preprint arXiv:1407.5272 .

Bonis, T., Ovsjanikov, M., Oudot, S., and Chazal, F. (2016). Persistence-based pooling for shape pose recognition. In Computational Topology in Image Context 6th International Workshop, CTIC 2016, Marseille, France, June 15-17, 2016, Proceedings , pages 19–29.

Brécheteau, C. et al. (2019). A statistical test of isomorphism between metric-measure spaces using the distance-to-a-measure signature. Electronic journal of statistics , 13(1):795–849.

Brécheteau, C., Levrard, C., et al. (2020). A k -points-based distance for robust geometric inference. Bernoulli , 26(4):3017–3050.

Breiman, L. (2001). Random forests. Machine learning , 45(1):5–32.

Brown, A., Bobrowski, O., Munch, E., and Wang, B. (2020). Probabilistic convergence and stability of random mapper graphs. Journal of Applied and Computational Topology , pages 1–42.

Brüel-Gabrielsson, R., Nelson, B. J., Dwaraknath, A., Skraba, P., Guibas, L. J., and Carlsson, G. (2019). A topology layer for machine learning. arXiv preprint arXiv:1905.12200 .

Bubenik, P. (2015). Statistical topological data analysis using persistence landscapes. Journal of Machine Learning Research , 16:77–102.

Bubenik, P., Carlsson, G., Kim, P. T., and Luo, Z.-M. (2010). Statistical topology via morse theory persistence and nonparametric estimation. Algebraic methods in statistics and probability II , 516:75–92.

[Page 38]

Buchet, M., Chazal, F., Dey, T. K., Fan, F., Oudot, S. Y., and Wang, Y. (2015a). Topological analysis of scalar ﬁelds with outliers. In Proc. Sympos. on Computational Geometry .

Buchet, M., Chazal, F., Oudot, S., and Sheehy, D. R. (2015b). Eﬃcient and robust persistent homology for measures. In Proceedings of the 26th ACM-SIAM symposium on Discrete algorithms. SIAM . SIAM.

Cadre, B. (2006). Kernel estimation of density level sets. Journal of multivariate analysis , 97(4):999–1023.

Carlsson, G. (2009). Topology and data. AMS Bulletin , 46(2):255–308.

Carlsson, G. and Gabrielsson, R. B. (2020). Topological approaches to deep learning. In Topological Data Analysis , pages 119–146. Springer.

Carriere, M., Chazal, F., Glisse, M., Ike, Y., and Kannan, H. (2020). A note on stochastic subgradient descent for persistence-based functionals: convergence and practical aspects. arXiv preprint arXiv:2010.08356 .

Carrière, M., Chazal, F., Ike, Y., Lacombe, T., Royer, M., and Umeda, Y. (2020). Perslay: a neural network layer for persistence diagrams and new graph topological signatures. In International Conference on Artiﬁcial Intelligence and Statistics , pages 2786–2796. PMLR.

Carrière, M. and Michel, B. (2019). Approximation of reeb spaces with mappers and applications to stochastic ﬁlters. arXiv preprint arXiv:1912.10742 .

Carriere, M., Michel, B., and Oudot, S. (2018). Statistical analysis and parameter selection for mapper. Journal of Machine Learning Research , 19(12).

Carrière, M. and Oudot, S. (2015). Structure and stability of the 1-dimensional mapper. arXiv preprint arXiv:1511.05823 .

Carriere, M. and Oudot, S. (2017). Sliced wasserstein kernel for persistence diagrams. To appear in ICML-17.

Carrière, M. and Rabadán, R. (2020). Topological data analysis of single-cell hi-c contact maps. In Topological Data Analysis , pages 147–162. Springer.

Chazal, F. (2017). High-dimensional topological data analysis. In Handbook of Discrete and Computational Geometry (3rd Ed To appear) , chapter 27. CRC Press.

Chazal, F., Chen, D., Guibas, L., Jiang, X., and Sommer, C. (2011a). Data-driven trajectory smoothing. In Proc. ACM SIGSPATIAL GIS .

Chazal, F., Cohen-Steiner, D., Glisse, M., Guibas, L., and Oudot, S. (2009a). Proximity of persistence modules and their diagrams. In SCG , pages 237–246.

Chazal, F., Cohen-Steiner, D., Guibas, L. J., M’emoli, F., and Oudot, S. Y. (2009b). Gromovhausdorﬀ stable signatures for shapes using persistence. Computer Graphics Forum (proc. SGP 2009) , pages 1393–1403.

Chazal, F., Cohen-Steiner, D., and Lieutier, A. (2009c). Normal cone approximation and oﬀset shape isotopy. Comp. Geom. Theor. Appl. , 42(6-7):566–581.

Chazal, F., Cohen-Steiner, D., and Lieutier, A. (2009d). A sampling theory for compact sets in euclidean space. Discrete & Computational Geometry , 41(3):461–479.

[Page 39]

Chazal, F., Cohen-Steiner, D., Lieutier, A., and Thibert, B. (2008). Stability of Curvature Measures. Computer Graphics Forum (proc. SGP 2009) , pages 1485–1496.

Chazal, F., Cohen-Steiner, D., and Mérigot, Q. (2010). Boundary measures for geometric inference. Found. Comp. Math. , 10:221–240.

Chazal, F., Cohen-Steiner, D., and Mérigot, Q. (2011b). Geometric inference for probability measures. Foundations of Computational Mathematics , 11(6):733–751.

Chazal, F., de Silva, V., Glisse, M., and Oudot, S. (2016a). The structure and stability of persistence modules . SpringerBriefs in Mathematics. Springer.

Chazal, F., Fasy, B. T., Lecci, F., Michel, B., Rinaldo, A., and Wasserman, L. (2014a). Robust topological inference: Distance to a measure and kernel distance. to appear in JMLR .

Chazal, F., Fasy, B. T., Lecci, F., Michel, B., Rinaldo, A., and Wasserman, L. (2015a). Subsampling methods for persistent homology. To appear in Proceedings of the 32 st International Conference on Machine Learning (ICML-15) .

Chazal, F., Fasy, B. T., Lecci, F., Rinaldo, A., Singh, A., and Wasserman, L. (2013a). On the bootstrap for persistence diagrams and landscapes. arXiv preprint arXiv:1311.0376 .

Chazal, F., Fasy, B. T., Lecci, F., Rinaldo, A., and Wasserman, L. (2015b). Stochastic convergence of persistence landscapes and silhouettes. Journal of Computational Geometry , 6(2):140– 161.

Chazal, F., Glisse, M., Labruère, C., and Michel, B. (2014b). Convergence rates for persistence diagram estimation in topological data analysis. To appear in Journal of Machine Learning Research .

Chazal, F., Guibas, L. J., Oudot, S. Y., and Skraba, P. (2013b). Persistence-based clustering in riemannian manifolds. Journal of the ACM (JACM) , 60(6):41.

Chazal, F., Huang, R., and Sun, J. (2015c). Gromov—hausdorﬀ approximation of ﬁlamentary structures using reeb-type graphs. Discrete Comput. Geom. , 53(3):621–649.

Chazal, F., Levrard, C., and Royer, M. (2020). Optimal quantization of the mean measure and application to clustering of measures. arXiv preprint arXiv:2002.01216 .

Chazal, F. and Lieutier, A. (2008a). Smooth manifold reconstruction from noisy and non-uniform approximation with guarantees. Comp. Geom. Theor. Appl. , 40(2):156–170.

Chazal, F. and Lieutier, A. (2008b). Smooth manifold reconstruction from noisy and non uniform approximation with guarantees. Computational Geometry Theory and Applications , 40:156– 170.

Chazal, F., Massart, P., and Michel, B. (2016b). Rates of convergence for robust geometric inference. Electron. J. Statist , 10:2243–2286.

Chazal, F. and Oudot, S. Y. (2008). Towards persistence-based reconstruction in euclidean spaces. In Proceedings of the twenty-fourth annual symposium on Computational geometry , SCG ’08, pages 232–241, New York, NY, USA. ACM.

Chen, C., Ni, X., Bai, Q., and Wang, Y. (2019). A topological regularizer for classiﬁers via persistent homology. In The 22nd International Conference on Artiﬁcial Intelligence and Statistics , pages 2573–2582.

[Page 40]

Chen, Y.-C., Genovese, C. R., and Wasserman, L. (2015). Density level sets: Asymptotics, inference, and visualization. arXiv preprint arXiv:1504.05438 .

Chen, Y.-C., Genovese, C. R., and Wasserman, L. (2017). Density level sets: Asymptotics, inference, and visualization. Journal of the American Statistical Association , 112(520):1684– 1696.

Cohen-Steiner, D., Edelsbrunner, H., and Harer, J. (2005). Stability of persistence diagrams. In SCG , pages 263–271.

Cohen-Steiner, D., Edelsbrunner, H., Harer, J., and Mileyko, Y. (2010). Lipschitz functions have l p-stable persistence. Foundations of computational mathematics , 10(2):127–139.

Cuevas, A. and Rodríguez-Casal, A. (2004). On boundary estimation. Adv. in Appl. Probab. , 36(2):340–354.

Cuevas, A. and Rodríguez-Casal, A. (2004). On boundary estimation. Advances in Applied Probability , pages 340–354.

Curry, J., Mukherjee, S., and Turner, K. (2018). How many directions determine a shape and other suﬃciency results for two topological transforms. arXiv preprint arXiv:1805.09782 .

De Silva, V. and Carlsson, G. (2004). Topological estimation using witness complexes. In Proceedings of the First Eurographics Conference on Point-Based Graphics , SPBG’04, pages 157–166, Aire-la-Ville, Switzerland, Switzerland. Eurographics Association.

De Silva, V. and Ghrist, R. (2007). Homological sensor networks. Notices of the American mathematical society , 54(1).

Devroye, L. and Wise, G. L. (1980). Detection of abnormal behavior via nonparametric estimation of the support. SIAM J. Appl. Math. , 38(3):480–488.

Dey, T. K., Mémoli, F., and Wang, Y. (2016). Multiscale mapper: topological summarization via codomain covers. In Proceedings of the Twenty-Seventh Annual ACM-SIAM Symposium on Discrete Algorithms , pages 997–1013. Society for Industrial and Applied Mathematics.

Dey, T. K., Mémoli, F., and Wang, Y. (2017). Topological analysis of nerves, reeb spaces, mappers, and multiscale mappers. In Proc. Sympos. Comput. Geom. (SoCG) .

Dindin, M., Umeda, Y., and Chazal, F. (2020). Topological data analysis for arrhythmia detection through modular neural networks. In Canadian Conference on Artiﬁcial Intelligence , pages 177–188. Springer.

Divol, V. and Chazal, F. (2020). The density of expected persistence diagrams and its kernel based estimation. Journal of Computational Geometry , 10(2):127–153.

Divol, V. and Lacombe, T. (2020). Understanding the topology and the geometry of the persistence diagram space via optimal partial transport. J Appl. and Comput. Topology .

Edelsbrunner, H., Letscher, D., and Zomorodian, A. (2002). Topological persistence and simpliﬁcation. Discrete Comput. Geom. , 28:511–533.

Fasy, B. T., Kim, J., Lecci, F., and Maria, C. (2014a). Introduction to the r package tda. arXiv preprint arXiv:1411.1830 .

Fasy, B. T., Lecci, F., Rinaldo, A., Wasserman, L., Balakrishnan, S., and Singh, A. (2014b). Conﬁdence sets for persistence diagrams. The Annals of Statistics , 42(6):2301–2339.

[Page 41]

Federer, H. (1959). Curvature measures. Transactions of the American Mathematical Society , pages 418–491.

Frosini, P. (1992). Measuring shapes by size functions. In Intelligent Robots and Computer Vision X: Algorithms and Techniques , volume 1607, pages 122–133. International Society for Optics and Photonics.

Gabrielsson, R. B. and Carlsson, G. (2019). Exposition and interpretation of the topology of neural networks. In 2019 18th IEEE International Conference On Machine Learning And Applications (ICMLA) , pages 1069–1076. IEEE.

Genovese, C. R., Perone-Paciﬁco, M., Verdinelli, I., and Wasserman, L. (2012). Manifold estimation and singular deconvolution under hausdorﬀ loss. Ann. Statist. , 40:941–963.

Ghrist, R. (2017). Homological algebra and data. preprint .

Grove, K. (1993). Critical point theory for distance functions. In Proc. of Symposia in Pure Mathematics , volume 54.

Guibas, L., Morozov, D., and Mérigot, Q. (2013). Witnessed k-distance. Discrete Comput. Geom. , 49:22–45.

Hatcher, A. (2001). Algebraic Topology . Cambridge Univ. Press.

Hofer, C., Kwitt, R., Niethammer, M., and Dixit, M. (2019a). Connectivity-optimized representation learning via persistent homology. In Proceedings of the 36th International Conference on Machine Learning , volume 97 of Proceedings of Machine Learning Research , pages 2751–2760. PMLR.

Hofer, C., Kwitt, R., Niethammer, M., and Uhl, A. (2017). Deep learning with topological signatures. arXiv preprint arXiv:1707.04041 .

Hofer, C. D., Kwitt, R., and Niethammer, M. (2019b). Learning representations of persistence barcodes. Journal of Machine Learning Research , 20(126):1–45.

Khasawneh, F. A. and Munch, E. (2016). Chatter detection in turning using persistent homology. Mechanical Systems and Signal Processing , 70:527–541.

Kim, K., Kim, J., Zaheer, M., Kim, J., Chazal, F., and Wasserman, L. (2020). Pllay: Eﬃcient topological layer based on persistence landscapes. In 34th Conference on Neural Information Processing Systems (NeurIPS 2020) .

Kovacev-Nikolic, V., Bubenik, P., Nikolić, D., and Heo, G. (2016). Using persistent homology and dynamical distances to analyze protein binding. Statistical applications in genetics and molecular biology , 15(1):19–38.

Kramar, M., Goullet, A., Kondic, L., and Mischaikow, K. (2013). Persistence of force networks in compressed granular media. Physical Review E , 87(4):042207.

Kramár, M., Levanger, R., Tithof, J., Suri, B., Xu, M., Paul, M., Schatz, M. F., and Mischaikow, K. (2016). Analysis of kolmogorov ﬂow and rayleigh–bénard convection using persistent homology. Physica D: Nonlinear Phenomena , 334:82–98.

Krebs, J. T. and Polonik, W. (2019). On the asymptotic normality of persistent betti numbers. arXiv preprint arXiv:1903.03280 .

Kusano, G. (2019). On the expectation of a persistence diagram by the persistence weighted kernel. Japan Journal of Industrial and Applied Mathematics , 36(3):861–892.

[Page 42]

Kusano, G., Fukumizu, K., and Hiraoka, Y. (2017). Kernel method for persistence diagrams via kernel embedding and weight factor. arXiv preprint arXiv:1706.03472 .

Kusano, G., Hiraoka, Y., and Fukumizu, K. (2016). Persistence weighted gaussian kernel for topological data analysis. In International Conference on Machine Learning , pages 2004–2013.

Lacombe, T., Cuturi, M., and Oudot, S. (2018). Large scale computation of means and clusters for persistence diagrams using optimal transport. In NeurIPS .

Lee, Y., Barthel, S. D., Dłotko, P., Moosavi, S. M., Hess, K., and Smit, B. (2017). Quantifying similarity of pore-geometry in nanoporous materials. Nature Communications , 8.

Leygonie, J., Oudot, S., and Tillmann, U. (2019). A framework for diﬀerential calculus on persistence barcodes. arXiv preprint arXiv:1910.00960 .

Li, C., Ovsjanikov, M., and Chazal, F. (2014). Persistence-based structural recognition. In Computer Vision and Pattern Recognition (CVPR), 2014 IEEE Conference on , pages 2003– 2010.

Lum, P., Singh, G., Lehman, A., Ishkanov, T., Vejdemo-Johansson, M., Alagappan, M., Carlsson, J., and Carlsson, G. (2013). Extracting insights from the shape of complex data using topology. Scientiﬁc reports , 3.

Maria, C., Boissonnat, J.-D., Glisse, M., and Yvinec, M. (2014). The gudhi library: Simplicial complexes and persistent homology. In International Congress on Mathematical Software , pages 167–174. Springer.

Maroulas, V., Nasrin, F., and Oballe, C. (2020). A bayesian framework for persistent homology. SIAM Journal on Mathematics of Data Science , 2(1):48–74.

McKinney, W. et al. (2010). Data structures for statistical computing in python. In Proceedings of the 9th Python in Science Conference , volume 445, pages 51–56. SciPy Austin, TX.

Mileyko, Y., Mukherjee, S., and Harer, J. (2011). Probability measures on the space of persistence diagrams. Inverse Problems , 27(12):124007.

Moon, C. and Lazar, N. A. (2020). Hypothesis testing for shapes using vectorized persistence diagrams. arXiv preprint arXiv:2006.05466 .

Moor, M., Horn, M., Rieck, B., and Borgwardt, K. (2020). Topological autoencoders. In International Conference on Machine Learning , pages 7045–7054. PMLR.

Nakamura, T., Hiraoka, Y., Hirata, A., Escolar, E. G., and Nishiura, Y. (2015). Persistent homology and many-body atomic structure for medium-range order in the glass. Nanotechnology , 26(30):304001.

Niyogi, P., Smale, S., and Weinberger, S. (2008). Finding the homology of submanifolds with high conﬁdence from random samples. Discrete & Computational Geometry , 39(1-3):419–441.

Niyogi, P., Smale, S., and Weinberger, S. (2011). A topological view of unsupervised learning from noisy data. SIAM Journal on Computing , 40(3):646–663.

Obayashi, I. and Hiraoka, Y. (2017). Persistence diagrams with linear machine learning models. arXiv preprint arXiv:1706.10082 .

Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., Blondel, M., Prettenhofer, P., Weiss, R., Dubourg, V., et al. (2011). Scikit-learn: Machine learning in python. Journal of Machine Learning Research , 12(Oct):2825–2830.

[Page 43]

Penrose, M. D. and Yukich, J. E. (2001). Central limit theorems for some graphs in computational geometry. Annals of Applied probability , pages 1005–1041.

Petrunin, A. (2007). Semiconcave functions in Alexandrov’s geometry. In Surveys in diﬀerential geometry. Vol. XI , pages 137–201. Int. Press, Somerville, MA.

Phillips, J. M., Wang, B., and Zheng, Y. (2014). Geometric inference on kernel density estimates. arXiv preprint 1307.7760 .

Polonik, W. (1995). Measuring mass concentrations and estimating density contour clusters-an excess mass approach. The Annals of Statistics , pages 855–881.

Poulenard, A., Skraba, P., and Ovsjanikov, M. (2018). Topological function optimization for continuous shape matching. In Computer Graphics Forum , volume 37, pages 13–25. Wiley Online Library.

Qaiser, T., Tsang, Y.-W., Taniyama, D., Sakamoto, N., Nakane, K., Epstein, D., and Rajpoot, N. (2019). Fast and accurate tumor segmentation of histology images using persistent homology and deep convolutional features. Medical image analysis , 55:1–14.

Ramamurthy, K. N., Varshney, K., and Mody, K. (2019). Topological data analysis of decision boundaries with application to model selection. In International Conference on Machine Learning , pages 5351–5360. PMLR.

Reininghaus, J., Huber, S., Bauer, U., and Kwitt, R. (2015). A stable multi-scale kernel for topological machine learning. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition , pages 4741–4748.

Rieck, B., Yates, T., Bock, C., Borgwardt, K., Wolf, G., Turk-Browne, N., and Krishnaswamy, S. (2020). Uncovering the topology of time-varying fmri data using cubical persistence. Advances in neural information processing systems , 33.

Rieck, B. A., Togninalli, M., Bock, C., Moor, M., Horn, M., Gumbsch, T., and Borgwardt, K. (2019). Neural persistence: A complexity measure for deep neural networks using algebraic topology. In International Conference on Learning Representations (ICLR 2019) . OpenReview.

Robins, V. (1999). Towards computing homology from ﬁnite approximations. In Topology proceedings , volume 24, pages 503–532.

Robinson, A. and Turner, K. (2017). Hypothesis testing for topological data analysis. Journal of Applied and Computational Topology , 1(2):241–261.

Roycraft, B., Krebs, J., and Polonik, W. (2020). Bootstrapping persistent betti numbers and other stabilizing statistics. arXiv preprint arXiv:2005.01417 .

Royer, M., Chazal, F., Levrard, C., Ike, Y., and Umeda, Y. (2021). Atol: Measure vectorisation for automatic topologically-oriented learning. In International Conference on Artiﬁcial Intelligence and Statistics . PMLR.

Seversky, L. M., Davis, S., and Berger, M. (2016). On time-series topological data analysis: new data and opportunities. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition Workshops , pages 59–67.

Singh, A., Scott, C., and Nowak, R. (2009). Adaptive Hausdorﬀ estimation of density level sets. Ann. Statist. , 37(5B):2760–2782.

Singh, G., Mémoli, F., and Carlsson, G. E. (2007). Topological methods for the analysis of high dimensional data sets and 3d object recognition. In SPBG , pages 91–100. Citeseer.

[Page 44]

Skraba, P., Ovsjanikov, M., Chazal, F., and Guibas, L. (2010). Persistence-based segmentation of deformable shapes. In Computer Vision and Pattern Recognition Workshops (CVPRW), 2010 IEEE Computer Society Conference on , pages 45–52.

Tsybakov, A. B. et al. (1997). On nonparametric estimation of density level sets. The Annals of Statistics , 25(3):948–969.

Turner, K., Mileyko, Y., Mukherjee, S., and Harer, J. (2014a). Fréchet means for distributions of persistence diagrams. Discrete & Computational Geometry , 52(1):44–70.

Turner, K., Mukherjee, S., and Boyer, D. M. (2014b). Persistent homology transform for modeling shapes and surfaces. Information and Inference: A Journal of the IMA , 3(4):310–344.

Umeda, Y. (2017). Time series classiﬁcation via topological data analysis. Transactions of the Japanese Society for Artiﬁcial Intelligence , 32(3):D–G72_1.

Villani, C. (2003). Topics in Optimal Transportation . American Mathematical Society.

Walt, S. v. d., Colbert, S. C., and Varoquaux, G. (2011). The numpy array: a structure for eﬃcient numerical computation. Computing in Science & Engineering , 13(2):22–30.

Yao, Y., Sun, J., Huang, X., Bowman, G. R., Singh, G., Lesnick, M., Guibas, L. J., Pande, V. S., and Carlsson, G. (2009). Topological methods for exploring low-density states in biomolecular folding pathways. The Journal of chemical physics , 130(14):144115.

Zieliński, B., Lipiński, M., Juda, M., Zeppelzauer, M., and Dłotko, P. (2010). Persistence bagof-words for topological data analysis. In Twenty-Eighth International Joint Conference on Artiﬁcial Intelligence, IJCAI-19 .

Zomorodian, A. and Carlsson, G. (2005). Computing persistent homology. Discrete Comput. Geom. , 33(2):249–274.

