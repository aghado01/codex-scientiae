# Persistent Homology and Similarity Filtration with Time Skeletons

## Contents

- [Abstract](#abstract)
- [1 Introduction](#1-introduction)
- [2 Persistent Homology](#2-persistent-homology)
- [2.1 Group Theory](#21-group-theory)
- [2.2 Simplicial Homology](#22-simplicial-homology)
- [2.3 Persistent Homology](#23-persistent-homology)
- [3 A Natural Language Processing Application](#3-a-natural-language-processing-application)
- [3.1 On Nursery Rhymes and Other Stories](#31-on-nursery-rhymes-and-other-stories)
- [3.2 On Child and Adolescent Writing](#32-on-child-and-adolescent-writing)
- [4 Discussion: Merely Counting Repeats?](#4-discussion-merely-counting-repeats)
- [References](references/SIFTS2013.md)

**Original Title**: _An Introduction and a New Text Representation for Natural Language Processing_

Xiaojin Zhu

## Abstract

Persistent homology is a mathematical tool from topological data analysis. It performs multi-scale analysis on a set of points and identifies clusters, holes, and voids therein. These latter topological structures complement standard feature representations, making persistent homology an attractive feature extractor for artificial intelligence. Research on persistent homology for AI is in its infancy, and is currently hindered by two issues: the lack of an accessible introduction to AI researchers, and the paucity of applications. In response, the first part of this paper presents a tutorial on persistent homology specifically aimed at a broader audience without sacrificing mathematical rigor. The second part contains one of the first applications of persistent homology to natural language processing. Specifically, our Similarity Filtration with Time Skeleton (SIFTS) algorithm identifies holes that can be interpreted as semantic “tie-backs” in a text document, providing a new document structure representation. We illustrate our algorithm on documents ranging from nursery rhymes to novels, and on a corpus with child and adolescent writings.

## 1 Introduction

Imagine dividing a document into smaller units such as paragraphs. A paragraph can be represented by a point in some space, for example, as the bag-of-words vector in R d where d is the vocabulary size. All paragraphs in the document form a point cloud in this space. Now let us “connect the dots” by linking the point for the first paragraph to the second, the second to the third, and so on. What does the curve look like? Certain structures of the curve capture information relevant to Natural Language Processing (NLP). For instance, a good essay may have a conclusion paragraph that “ties back” to the introduction paragraph. Thus the starting point and the ending point of the curve may be close in the space. If we further connect all points within some small diameter, the curve may become a loop with a hole in the middle. In contrast, an essay without any tying back may not contain holes, no matter how large is.

There has been geometric methods for visualizing documents and information flow, e.g. based on differential geometry [ Lebanon et al., 2007; Lebanon, 2006; Gous, 1999; Hall and Hofmann, 2000 ]. In contrast, we introduce an algebraic method based on persistent homology. As a branch of topological data analysis, persistent homology has the advantage of capturing novel invariant structural features of documents. Intuitively, persistent homology can identify clusters (0-th order holes), holes (1st order, as in our loopy curve), voids (2nd order holes, the inside of a balloon), and so on in a point cloud. Considering the importance of clustering today, the value of these higher order structures is tantalizing. Indeed, in the last few years persistent homology has found applications in data analysis, including neuroscience [ Singh et al., 2008 ], bioinformatics [ Kasson et al., 2007 ], sensor networks [ de Silva and Ghrist, 2007a; de Silva and Ghrist, 2007b ], medical imaging [ Chung et al., 2009 ], shape analysis [ Gamble and Heo, 2010 ], and computer vision [ Freedman and Chen, 2011 ].

Unfortunately, existing homology literature requires advanced mathematical background not easily accessible to a broader audience. Our first contribution is an accessible yet rigorous tutorial that contains many unpublished materials. Although a tutorial is unconventional in a technical paper, we feel that there is value to the AI community as it paves the way to further interdisciplinary research. Our second contribution is a novel text representation using persistent homology. It formalizes the curve-and-loop intuition based on Vietoris-Rips filtration over semantic similarity. We hope this paper inspires future innovations on topology and AI.

## 2 Persistent Homology

We aim for mathematical rigor and intuition, but have to sacrifice completeness. Readers can follow up with [ Singh et al., 2008; Giblin, 2010; Freedman and Chen, 2011; Zomorodian, 2001; Rote and Vegter, 2006; Edelsbrunner and Harer, 2010; Hatcher, 2001; Carlsson, 2009; Edelsbrunner and Harer, 2007; Balakrishnan et al., 2012; 2013 ] for detailed treatment.

Persistent homology finds “holes” by identifying equivalent cycles: Consider the following space in yellow with a small white hole. Imagine the blue cycle as a rubber band. It can be stretched and bent within the space into the green cycle, but not the red one without tearing itself.

![image 1](SIFTS/imageFile1.png)

There are two equivalent classes of rubber bands: some surround the hole and others do not. Conversely, two equivalent classes indicate one hole. To formalize this idea, we need to introduce some algebraic concepts.

## 2.1 Group Theory

Definition 1. A group $G,_$ is a set $G$ with a binary operation $_$ such that (1. associative) $a_(b_c) = (a_b)_c$ for all $a,b,c \in G$. (2. identity) $\exists e \in G$ so that $e_a = a_e = a$ for all $a \in G$. (3. inverse) $\forall a \in G$, $\exists a^{-1} \in G$ where $a_a^{-1} = a^{-1}_a = e$. For example, integer addition $Z, +$, real number addition

$R, +$ are groups with identity $0$ and $a$'s inverse $-a$. Positive real numbers and multiplication is a group $R^+, \times$ with identity $1$ and $a$'s inverse $\frac{1}{a}$. However, $R, \times$ is not a group since $0 \in R$ does not have an inverse under $\times$. Real numbers except 0 is again a group $R \setminus \{0 \}, \times$. $Z\_2$ is the only group (up to element renaming) of size two:

| $+_2$ | $0$ | $1$ |
| --- | --- | --- |
| $0$ | $0$ | $1$ |
| $1$ | $1$ | $0$ |

We can think of $+\_2$ as the XOR function or mod-2 addition. For any set $A = \{a_1,...,a_n \}$, its power set forms a group $2^A, +\_2$ where $+\_2$ is the symmetric difference: $B +\_2 C = ( B \cup C ) \setminus ( B \cap C )$. The identity is the empty set $\emptyset$, and the inverse of any $B \subseteq A$ is $B$ itself.

Definition 2. A group $G$ is abelian if the operation $_$ is commutative: $\forall a, b \in G, a_b = b \* a$.

non-abelian groups, consider $n \times n$ invertible matrices under matrix multiplication.

Definition 3. A subset $H \subseteq G$ of a group $G,_$ is a subgroup of $G$ if $H,_$ is itself a group. $\{e \}$ is the trivial subgroup of any group $G$ (we often omit

the operation when it is clear). $R^+, \times$ is a subgroup of $R \setminus \{0\}, \times$ by restricting multiplication to positive numbers. Note however multiplication on negative numbers $R^-, \times$ is not a subgroup because the result is not in $R^-$. Definition 4. Given a subgroup $H$ of an abelian group $G$, for

any $a \in G$, the set $a_H = \{a_h \mid h \in H \}$ is the coset of $H$ represented by $a$.

Consider $H = R^+$ and $G = R \setminus \{0 \}$. Then $3.14 \times R^+$ is a coset which is the same as $R^+$. In fact for any $a > 0$, $a \times R^+ = R^+$, i.e., many different $a$'s represent the same coset. On the other hand, $-1 \times R^+ = R^-$, so $R^-$ is a coset represented by $-1$ (or any negative number, for that matter). Since $R^-$ is not a group, we see the cosets do not have to be subgroups. Also note that the two cosets, $R^+$ and $R^-$, have equal size and partition $G$. This fact will be important for counting cycles for homology later.

We now consider mappings from one group $G, \*$ to another $G', \cdot$.

Definition 5. A map $\phi : G \to G'$ is a homomorphism if $\phi(a \* b) = \phi(a) \phi(b)$ for $\forall a,b \in G$. For example, the groups $R^+, \times$ and $Z\_2, +\_2$ do not look

similar at all. But there is a trivial homomorphism $\phi(a) = 0, \forall a \in R^+$. Note the last 0 is in $Z\_2$. This simply says that we map all positive real numbers to the "0" in mod-2 addition. Obviously $0 = \phi(a \times b) = \phi(a) +\_2 \phi(b) = 0 +\_2 0 = 0$ for $\forall a,b \in R^+$. As another example, consider the group of (somewhat arti-

ficial) negation in natural language: $G_N = \{\sqcup, \text{not} \}$ with the following operation, where $\sqcup$ stands for whitespace:

| $*$ | $\sqcup$ | $\text{not}$ |
| --- | --- | --- |
| $\sqcup$ | $\sqcup$ | $\text{not}$ |
| $\text{not}$ | $\text{not}$ | $\sqcup$ |

i.e., single negation stays while double negation cancels. There is a homomorphism between $G_N$ and $Z\_2$: $\phi(\sqcup) = 0, \phi(\text{not}) = 1$. In fact, $G_N$ and $Z\_2$ are identical up to renaming. There is a name for such homomorphisms:

Definition 6. A homomorphism that is a one-to-one correspondence is called an isomorphism.

Definition 7. The kernel of a homomorphism $\phi : G \to G'$ is $\ker \phi = \{a \in G \mid \phi(a) = e' \}$. In other words, the kernel is the elements that map to identity.

Theorem 1. For any homomorphism $\phi : G \to G'$, $\ker \phi$ is a subgroup of $G$.

![image 2](SIFTS/imageFile2.png)

$\ker \phi$

Because $\ker \phi$ is a subgroup (depicted as the blue square above), we can partition $G$ into cosets of the form $a \* \ker \phi$ for $a \in G$. These cosets are the white or blue squares. For example, $\phi : R \setminus \{0 \}, \times \to G_N$ with $\phi(a) = \sqcup$ if $a > 0$ and "not" if $a < 0$, then $\ker \phi = R^+$ is one coset and $R^-$ is the only other coset.

We need one more piece of definition. Let $H,_$ be a subgroup of an abelian group $G,_$. We can introduce a new binary operation not on the elements of $G$ but on the cosets of $H$: $(a_H) \cdot (b_H) = (a_b)_H, \forall a,b \in G$. The operation is well-defined and does not depend on the particular choice of representer.

Definition 8. The cosets $\{a \* H \mid a \in G \}$ under the operation $\cdot$ form a group, called the quotient group $G/H$.

It is useful to think of quotient groups as "higher level" groups defined on the squares in the previous picture. $\ker \phi$ (the blue square) is a subgroup of $G$. The elements of the quotient group $G / \ker \phi$ are the cosets of $\ker \phi$, i.e. all the squares. In a previous example $G = R \setminus \{0 \}$ and $\ker \phi = R^+$, and there were two cosets: $R^+$ and $R^-$. Thus the quotient group $(R \setminus \{0 \}) / R^+$ is a small group with those two cosets as elements. Furthermore, note $R^- \cdot R^- = (-1 \times R^+) \cdot (-1 \times R^+) = (-1 \times -1) \times R^+ = 1 \times R^+ = R^+$. Therefore, this quotient group $(R \setminus \{0 \}) / R^+$ is isomorphic to $Z\_2$.

Definition 9. Let S $\subset$ G. The subgroup generated by S, S, is the subgroup of all elements of G that can expressed as the finite operation of elements in S and their inverses.

For example, Z is itself the subgroup generated by { 1 }, the group of even integers is the subgroup of Z generated by { 2 }. Definition 10. The rank of a group G is the size of the small-

Definition 10. The rank of a group G is the size of the smallest subset that generates G.

For example, rank( Z ) = 1 since Z = { 1 }. rank( Z $\times$ Z ) = 2 since Z $\times$ Z = { (0, 1), (1, 0) }. Note there is no one-element basis for Z $\times$ Z. Group theory is important because when counting “holes”

in homology, G will be the group of cycles (the rubber bands). The blue square will be the subgroup of “uninteresting rubber bands” that do not surround holes, similar to the earlier blue and green rubber bands. The quotient group “all rubber bands”/“uninteresting rubber bands” will identify holes. However, the rubber bands are continuous and difficult to compute. We first need to discretize the space into a simpler structure called simplicial complex.

## 2.2 Simplicial Homology

The building blocks of our discrete space are simplices.

Definition 11. A p -simplex $\sigma$ is the convex hull of p + 1 affinely independent points x 0,x 1,...,x p $\in$ R d. We denote $\sigma$ = conv { x 0,...,x p }. The dimension of $\sigma$ is p. Affinely independent means the p vectors x i x 0 for i =

− 1...p are linearly independent, i.e., they are in general position. The convex hull is simply the solid polyhedron determined by the p +1 vertices. A 0-simplex is a vertex, 1-simplex an edge, 2-simplex a triangle, and 3-simplex a tetrahedron:

![image 3](SIFTS/imageFile3.png)

Definition 12. A face of $\sigma$ is conv S where S $\subset$ { x 0,...,x p } is a subset of the p + 1 vertices.

For example, a tetrahedron has four triangle faces corresponding to the four subsets S obtained by removing one vertex at a time from $\sigma$. These four triangle faces are 2 -simplices themselves. It also has six edge faces and four singleton vertex faces.

Our space of interest is properly arranged simplices:

Definition 13. A simplicial complex K is a finite collection of simplices such that $\sigma \in$ K and τ being a face of $\sigma$ implies τ $\in$ K, and $\sigma$,$\sigma \in$ K implies $\sigma$ ∩ $\sigma$ is either empty or a face of both $\sigma$ and $\sigma$.

The intuition of simplicial complex is that if a simplex is in K, all its faces need to be in K, too. In addition, the simplices have to be glued together along whole faces or be separate. The figure on the left is a simplicial complex, while the one on the right is not:

![image 4](SIFTS/imageFile4.png)

Simplicial complex plays the role of the yellow space in the rubber band example. We next introduce the discrete version of the rubber bands.

Definition 14. A p -chain is a subset of p -simplices in a simplicial complex K.

For example, let K be a tetrahedron. By definition the four triangle faces (i.e., 2-simplices) are in K, too. A 2chain is a subset of these four triangles, e.g., all four triangle, the bottom triangle face only, or the empty set. There are 2 4 distinct 2-chains. Similarly, by definition all six edges of the tetrahedron are in K, too. Thus, there are 2 6 distinct 1-chains. Despite the name “chain,” a p -chain does not have to be connected. The figure below shows a 2chain on the left and a 1-chain (the blue edges) on the right:

![image 5](SIFTS/imageFile5.png)

Recall for any set A, its power set forms a group 2 A, + 2. Definition 15. The set of p -chains of a simplicial complex K

Definition 15. The set of p -chains of a simplicial complex K form a p -chain group C p.

When adding two p -chains we get another p chain with duplicate p -simplices cancel out. We have a separate chain group for each dimension p. Below is an example of 1 -chain addition:

![image 6](SIFTS/imageFile6.png)

-

=

Definition 16. The boundary of a p -simplex is the set of ( p − 1) -simplices faces.

The boundary of a tetrahedron is the set of four triangles faces; the boundary of a triangle is its three edges; the boundary of an edge is its two vertices.

Definition 17. The boundary of a p -chain is the + 2 sum of the boundaries of its simplices. Taking the boundary is a group homomorphism $\partial$ p from C p to C p − 1.

Note faces shared by an even number of p -simplices in the chain will cancel out:

![image 7](SIFTS/imageFile7.png)

-

=

We have finally reached our discrete p -dimensional rubber bands: the p -cycles.

Definition 18. A p -cycle c is a p -chain with empty boundary: $\partial$ p c = 0 (the identity in C p − 1 ).

The figure below shows a 1 -cycle in blue on the left, and a 1 -chain on the right that is not a cycle because it has the red boundary vertices.

![image 8](SIFTS/imageFile8.png)

Let Z p be all the p -cycles, i.e., all the “rubber bands.” Since $\partial$ p Z p = 0, by definition 7 Z p is the kernel ker $\partial$ p, which is a subgroup of C p.

We now identify the “uninteresting rubber bands.” It may not be obvious but the boundary of any higher order ( p + 1) -chain is always a p -cycle. For example, the left figure below shows a simplicial complex containing a ( p + 1) = 2 chain (the yellow tri-

![image 9](SIFTS/imageFile9.png)

c c c

Theorem 2. For every p and every ( p + 1) -chain c, $\partial$ p ( $\partial$ p +1 c ) = 0.

Definition 19. A p -boundary-cycle is a p -cycle that is also the boundary of some ( p + 1) -chain.

Let B p = $\partial$ p +1 C p +1, namely all the p -boundary-cycles. B p are the uninteresting rubber bands. In the example above, B 1 = { 0,c 1 }, none surrounding any holes. It is easy to see that B p is a group, therefore a subgroup of Z p (all rubber bands).

Are there “interesting rubber bands”? In other words, do we have anything in Z p besides B p ? It depends on the structure of the simplicial complex. In the example above, the 1 -cycles c 2 and c 3 (red) are not in B 1 since the rectangle does not contain any 2 -simplices. These are interesting because they surround the hole in the rectangle. In fact, we can drag the rubber band c 2 over the yellow triangle and turn it into c 3. Formally, we do this by c 3 = c 2 + c 1. Intuitively, c 2 and c 3 are equivalent in the hole they surround. More generally, such equivalence class is obtained by c + B p : we are allowed to drag a p -cycle rubber band c over any ( p + 1) -simplices without changing the holes (or the lack thereof) it surrounds.

Returning to the example, we now see all the 1-cycles for this simplicial complex: Z 1 = { 0,c 1,c 2,c 3 }. The uninteresting ones are B 1 = { 0,c 1 }, a subgroup of Z 1. The interesting ones are c 2 + B 1 = c 3 + B 1 = { c 2,c 3 } : this should remind us of cosets and quotient group.

Definition 20. The p -th homology group is the quotient group H p = Z p /B p. The p -th Betti number is its rank: $\beta$ p = rank( H p ).

We have arrived at the core of homology. In our example, H 1 = { 0,c 1,c 2,c 3 } / { 0,c 1 } which is isomorphic to Z 2. The first Betti number is $\beta$ 1 = rank( Z 2 ) = 1, indicating one independent 1st-order hole not filled in by triangles.

In general, $\beta$ p is the number of independent p -th holes. For example, a tetrahedron has $\beta$ 0 = 1 since the shape is connected, $\beta$ 1 = $\beta$ 2 = 0 since there is no holes or voids. A hollow tetrahedron has $\beta$ 0 = 1,$\beta$ 1 = 0,$\beta$ 2 = 1 because of the void. Further removing the four triangle faces but keeping the six edges, the skeleton has $\beta$ 0 = 1, $\beta$ 1 = 3 (there are 4 triangular holes but one is the sum of the other three), $\beta$ 2 = 0 (no more void). Finally removing the edges but keeping the four vertices, $\beta$ 0 = 4 (4 connected components each a single vertex) and $\beta$ 1 = $\beta$ 2 = 0.

## 2.3 Persistent Homology

Usually we are given data as a point cloud x 1,...,x n $\in$ R d. Where does the simplicial complex come from in the first place? One way to create it is to examine all subsets of points. If any subset of p + 1 points are “close enough,” we add a p simplex $\sigma$ with those points as vertices to the complex:

Definition 21. A Vietoris-Rips complex of diameter is the simplicial complex V R ( ) = { $\sigma$ | diam( $\sigma$ ) $\leq$ }.

Here diam( $\sigma$ ) is the largest distance between two points in $\sigma$. Note if $\sigma \in$ V R ( ), all its faces are, too. The following figure shows four points (0,0), (0,1), (2,1), (2,0) and the VietorisRips complex with different. V R ( √ 5) is a flat tetrahedron.

![image 10](SIFTS/imageFile10.png)

VR(1)

VR(2)

VR( 5)

A natural question is what best to use for any data set. Persistent homology examines all ’s to see how the system of holes change.

Definition 22. An increasing sequence of produces a filtration, i.e., a sequence of increasing simplicial complexes V R ( 1 ) $\subseteq$ V R ( 2 ) $\subseteq$ ..., with the property that a simplex enters the sequence no earlier than all its faces.

Persistent homology tracks homology classes along the filtration: at what value of does a hole appear, and how long does it persist till it is filled in? A convenient way to visualize persistent homology is the barcode plot shown below. The x -axis is. Each horizontal bar represents the birth–death of a separate homology class. Longer bars correspond to more robust topological structure in the data.

![image 11](SIFTS/imageFile11.png)

barcode (dimension 0)

0.5

1.5 1)

2.5

barcode (dimension 1)

0.5

1.5

2.5

The top panel shows H 0 (0-th order holes or clusters). At = 0 there are four bars for the four disconnected vertices in V R (0). The Betti number at any given is the number of bars above it, in this case $\beta$ 0 = 4. At = 1 two edges appear in V R (1), reducing the number of connected components to two. This is why the top two bars die and $\beta$ 0 reduces to 2. At = 2, V R (2) forms a rectangle and becomes fully connected, so one more bar dies and $\beta$ 0 = 1 thereafter. The remaining bar represents the one vertex that grabs everything to eventually become the fully connected component. It never dies (represented by the arrow at the end of the bar). We note that the clusters are precisely those obtained from hierarchical clustering with single-linkage.

The bottom panel shows H 1 (1st order holes). In the example above, a homology class corresponding to the hole is born at = 2 when the rectangle becomes connected. It persists until = √ 5 and dies because the Vietoris-Rips complex becomes the solid tetrahedron. This is represented by the single short bar. The Betti number is $\beta$ 1 = 1 in the interval [2, √ 5) and 0 otherwise.

## 3 A Natural Language Processing Application

We all have the intuition that some documents tell a straight story while others twist and turn. We hope persistent homology captures such structures. We assume that a document has been divided into small units x 1,...,x n. We are given a distance function D ( x i,x j ) $\geq$ 0 so that similar units have small

Similarity Filtration (SIF). SIF is a simple method to compute persistent homology by creating a Vietoris-Rips complex over x 1,...,x n, where the diameter measures the similarity between text units:

1. $ D\_{\max} = \max D(x_i, x_j), \forall i,j = 1 \dots n $ 2. FOR $ m = 0, 1, \dots, M $ 3. Add $ VR*{\frac{m}{M} D*{\max}} $ to the filtration 4. END

5. Compute persistent homology on the filtration

The growing diameter corresponds to allowing looser tiebacks: more dissimilar text units are linked together to form simplices in the Vietoris-Rips complex. Note the order of $ x_1 \dots x_n $ is ignored. Similarity Filtration with Time Skeleton (SIFTS). We

may be more interested in the flow of the document. Recall we “connect the dots” in the introduction. This prompts us to add “time edges” $ (x*i, x*{i+1}), i = 1 \dots n - 1 $ to the simplicial complex before any similarity filtration. These edges form a “time skeleton” by connecting units in document order. The SIFTS algorithm implements time skeleton by adding the following preprocessing step before the SIF algorithm in section 3:

$$
0. \ D ( x_{i}, x_{i + 1} ) = 0 \text{for} i = 1, \dots, n - 1 \\ \intertext{s u l l} x_{i}, x_{i + 1}, x_{i + 2}, x_{i + 3}, \dots, x_{i + 5}, x_{i + 6}, x_{i + 7}, \dots, x_{i + 9}
$$

The key difference between SIF and SIFTS is that a time-skeleton edge can be arbitrarily long as measured by $ D() $. By adding the time skeleton upfront, we enable “tie-back” holes in SIFTS. This is illustrated by the toy document $ (0, 0), (1, 0), (2, 0), (-\frac{1}{2}, 0) $ below, with the Vietoris-Rips complex $ VR(0.5) $:

![image 12](SIFTS/imageFile12.png)

SIF sees the Vietoris-Rips complex on the left as four vertices and an edge between $(0, 0), (-\frac{1}{2}, 0)$. Even though the edge represents a tie-back between the first and last units, no hole has formed. In contrast, SIFTS sees the combined complex on the right with time skeleton in red. The similarity and time edges together form a hole (i.e., $\beta_1 = 1$). The complete barcodes for SIF and SIFTS are presented below. SIF detects no hole at all ($\beta_1 = 0$ always): as $\epsilon$ increase the filtration fills the complex with solid triangles, preventing holes. The hole detected by SIFTS persists until $\epsilon$ is large enough to cover $(1, 0)$ and $(-\frac{1}{2}, 0)$. Also note SIFTS complex is trivially connected by the time skeleton, hence $\beta_0 = 1$ always.

![image 13](SIFTS/imageFile13.png)

## 3.1 On Nursery Rhymes and Other Stories

We now illustrate persistent homology as computed by SIF and SIFTS on a few nursery rhymes. Nursery rhymes are repetitive and familiar, ideal for homology examples. Each unit is a sentence. We perform minimum tokenization by case-folding and punctuation removal only. The distance D () is the Euclidean distance between sentence-level bag-ofwords count vectors. All filtrations has M = 100 steps.

Figure 1(a) shows Itsy Bitsy Spider. Its homology is strikingly similar to the previous toy document, as the spider climbed up the water spout in both the 1st and the 4th sentences. This hole is detected by SIFTS but not SIF.

Figure 1(b) shows Row Row Row Your Boat. Its four sentences are distinct from each other, forming a “linear progression.” Both SIF and SIFTS give $\beta_1 = 0$: there is no hole.

Figure 1(c) shows London Bridge is Falling Down. The lyric has $n = 48$ sentences; The sentence “My fair Lady” repeats 12 times. With the time skeleton, SIFTS therefore detects 11 independent holes ($\beta_1 = 11$) right away in $VR(0)$. These holes are not detected by SIF. Both SIF and SIFTS detect more holes later, some are caused by the near-repetition “Build it up with X and Y ”, where $X, Y$ vary from wood and clay to silver and gold.

We now move on to longer documents. Here and in next section, the text units are natural paragraphs (or chapters for Alice ). We perform Penn Treebank tokenization, case-folding, punctuation removal, and SMART stopword removal [ Salton, 1971 ]. Each text unit is converted to a tf.idf vector, where idf is computed within the document. We compute the cosine similarity then take the angular distance:

$$
t, \quad D ( x_{i}, x_{j} ) = \cos^{- 1} \left ( \frac{x_{i}^{\top} x_{j}}{\| x_{i} \| \cdot \| x_{j} \|} \right ). \\ F i gure \, I ( d e f ) \, \text{show the barcodes on}
$$

 $\cdot$ Figure 1(d,e,f) show the barcodes on three stories. In general, SIFTS detects more holes and detects them earlier than SIF. The homology classes that persist the longest tend to be reappearance of salient words. For example, in Red-Cap the first SIFTS hole is between the sentences “The better to see you with, my dear” and “The better to eat you with!”

## 3.2 On Child and Adolescent Writing

As a real world example, we quantitatively study whether children’s writing become structurally richer as they grow up. Specifically, our hypothesis is that older writers have more 1homology groups than younger writers.

We use the LUCY corpus which contains roughly matched child and adolescent writing [ Sampson, 2003 ]. We merge the F,H,K,M groups (ages 9–12, 150 essays) to form a childwriting set. We use the E group (undergraduates, 48 essays) as the adolescent-writing set. The main differences between the two sets are age and average article length (child=11.6 sentences, adolescent=25.8 sentences), see LUCY documentation for other minor differences.

We compute each essay’s SIFTS barcode. To facilitate comparison, we extract two summary statistics. The first is $|H_1|$, the total number of 1st-order persistent homology classes (holes) over the whole $\epsilon$ range. This is obtained by counting the number of bars. Note $|H_1| \ge \beta_1$ since the Betti number is for a specific $\epsilon$. The second is $\epsilon^\*$, the smallest

![This is an image of a graph. There are five categories on the x-axis, which are named as follows: (a) Itsy Bitsy Spider, (b) Row Row Your Boat, (c) London Bridge, (d) The Emperor's New Clothes, and (e) Alice in Wonderland. There are five categories on the y-axis, which are named as follows: (a) Little Red-Cap, (b) Row Row Your Boat, (c) London Bridge, (d) The Emperor's New Clothes, and (e) Alice in Wonderland. There are five categories on the x-axis, which are named as follows: (a) The Emperor's New Clothes, (b) Little Red-Cap, (c) London Bridge, (d) The Emperor's New Clothes, and (e) Alice in Wonderland. There are five categories on the y-axis, which are named as follows: (](SIFTS/imageFile14.png)

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)

1 2 3 SIFTS (dimension 1)

2 4 SIF (dimension 1)

2 4 SIFTS (dimension 1)

1 2 3 SIF (dimension 1)

2 4 SIF (dimension 1)

2 4 SIFTS (dimension 1)

(a) Itsy Bitsy Spider

(b) Row Row Row Your Boat

(c) London Bridge

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)

0.5

1.5

0.5

1.5

0.5

1.5

0.5

1.5

0.5

1.5

0.5

1.5

0.5 1 SIF (dimension 1)

0.5 1 SIFTS (dimension 1)

0.5 1 SIF (dimension 1)

0.5 1 SIFTS (dimension 1)

0.5 1 SIF (dimension 1)

0.5 1 SIFTS (dimension 1)

0.5

1.5

0.5

1.5

0.5

1.5

0.5

1.5

0.5

1.5

0.5

1.5

(d) The Emperor’s New Clothes

(e) Little Red-Cap

(f) Alice in Wonderland

Figure 1: Persistent homology on nursery rhymes and other stories

| 1.38 (.01) | | ---------- |

Table 1: Statistics on child vs. adolescent writing. Entries significantly different from child are marked by ∗

when the first hole in H 1 forms. If there is no hole we set ∗ = $\pi$/ 2, the largest angular distance possible.

The first two columns in Table 1 show a marked difference between child vs. adolescent writing. Only 87% of child essays have holes while all adolescent essays do ( p = 0. 01, Fisher’s test). The average child essay has 3 holes while adolescent has 17.6 ( p = 10 − 55, t -test). First hole appears earlier in adolescent ( p = 0. 01, t -test).

One has reason to suspect that the homology differs solely because adolescent essays are about twice as long. We thus create a third “adolescent truncated” data set, where we keep the first 11 sentences in each adolescent essay to match child writing. This perhaps removed many later tie-backs in the essays. The third column in Table 1, however, still shows some differences compared to child writing: more truncated adolescent essays contain holes ( p = 0. 03, Fisher’s test). On average a truncated essay has one more hole ( p = 0. 03, t test). But the first-birth ∗ is no longer significantly different ( p = 0. 2, t -test).

We conclude that persistent homology detects significant differences between child and adolescent writing using only structural features. The point is not that classifying the two classes requires such sophisticated machinery – simpler features such as word usage probably suffice. Rather, our experiment shows that there is useful information in homology. Incorporating such information into existing text representation for NLP tasks such as discourse structure modeling or parsing can potentially enhance these tasks. This remains future work.

## 4 Discussion: Merely Counting Repeats?

Our nursery rhyme examples may give the impression that persistent homology computed by SIFTS is simply finding repeated ( -close) text units. After all, in a document x 1 x 2 x 3 where x 1,x 2,x 3 are within of each other and represents long sequence of mutually dissimilar units, SIFTS will identify exactly two independent holes: x 1 x 2 where x 2 ties back to x 1, and similarly x 2 x 3. k such repeats of x will generate k − 1 holes. It seems one can just count k the number of repeats to get the Betti number $\beta$ 1 = k − 1. This impression is incomplete. Consider the document

x 1 x 2 x 3 y z x 4 depicted on left, where y and z are distant. The SIFTS time skeleton is in red. There are k = 4 repeats of x but $\beta$ 1 = 1 not 3, since the x ’s form a 3-simplex (yellow).

![image 15](SIFTS/imageFile15.png)

Perhaps such problem can be dealt with by preprocessing, where one merges contiguous units within ? Surely with x 1 x 2 x 3 merged into a super unit x, we can using counting again to detect two repeats x,x 4 and correctly infer one hole. However, consider another document x 1 x 2...x 13 on the right, where all contiguous unit pairs are within (the short diagonal length). The preprocessing will merge all units into a single super unit, thus incorrectly predicting 0 holes. In contrast, SIFTS can correctly identify the two holes. Homology is not just counting repeated text units.

The barcodes in this paper were computed with the javaPlex software [ Tausz et al., 2011 ]. Our data and SIF, SIFTS code is online at http://pages.cs.wisc.edu/ ∼ jerryzhu/publications.html.
