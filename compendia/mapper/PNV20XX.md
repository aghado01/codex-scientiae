# PERSISTENT NERVES REVISITED

NICHOLAS J. CAVANNA AND DONALD R. SHEEHY

## Contents

- [Introduction](#introduction)
- [Background](#background)
- [Results](#results)
- [References](references/PNV20XX.md)

## Introduction

The nerve of a cover is a simplicial complex corresponding to the collection of intersections of a cover of a nice topological space. Nerves show up all over computational geometry and topology as they provide a discrete representation of a continuous space. In fact if one has a good cover of a space, then the nerve has the same homotopy type, and thus homology, as the space. Nerves are used in surface reconstruction, homology inference, and homological sensor networks.

The Persistent Nerve Lemma, introduced by Chazal and Oudut [ 2 ], implies that given a growing collection of covers, e.g. convex sets, of sufficiently nice growing topological spaces, the persistent homology of the spaces they cover is the same as that of the nerve of the covers, and furthermore, the maps between the spaces commute. This result has played a big part in the results on persistent homology and topological data analysis. The hypothesis of the lemma is the covers have contractible intersections.

Other researchers have worked within this setting altering the original assumption of good covers. Botnan and Spreemann [ 1 ] assumed knowledge of the interleaving between two cover filtrations to bound the bottleneck distance between the persistence diagrams of the filtrations of the nerves and the spaces. Govc and Skraba [ 3 ] bounded the bottleneck distance between the nerve and space persistence diagrams for simplicial complexes, given that the homology of the k -intersections of the filtrations cover elements are $\varepsilon$ -interleaved with 0 , where the cover filtration is defined by the cover’s intersection with each step in the filtered simplicial complex.

We consider a more general cover assumptionthat we have an arbitrary cover filtration of a simplicial filtration where the inclusion of any intersection of covers included into the next has the homology of a point. Our main result is that

## Background

Let $\mathcal{U} = \{U_1, \dots, U_n\}$ be a set of filtrations, where $U_i = (U^\alpha_i)_{\alpha \geq 0}$. For each $\alpha \geq 0$, we denote $\mathcal{U}^\alpha = \{U^\alpha_1, \dots, U^\alpha_n\}$, and we note this is a cover of the space $W^\alpha = \bigcup_{i \in [n]} U^\alpha_i$, a simplicial complex. For $v \subseteq [n]$, let $U^\alpha_v = \bigcap_{i \in v} U^\alpha_i$. So $U_v \colon= (U^\alpha_v)_{\alpha \geq 0}$ is also a filtration.

The nerve of a collection of sets $\mathcal{U}$ is defined as $\operatorname{Nerve} U^\alpha \colon= \{v \subseteq [n] \mid U^\alpha_v \neq \emptyset\}$ and is a simplicial complex. The nerve filtration is defined as $\operatorname{Nerve} U \colon= (\operatorname{Nerve} U^\alpha)_{\alpha \geq 0}$. When we consider the collection of spaces that each $U^\alpha$ covers, we get the union filtration, $W \colon= (W^\alpha)_{\alpha \geq 0}$. The sets of $U^\alpha$ form a good cover of $W^\alpha$ if for all subsets $v \subseteq [n]$, we have $U^\alpha_v$ is empty or contractible. For filtrations, we say $\mathcal{U}$ is a good cover of $W$ if $U^\alpha$ is a good cover of $W^\alpha$ for all $\alpha \geq 0$. The Persistent Nerve Lemma implies that if $\mathcal{U}$ is a good cover of $W$, then $\operatorname{Pers}(\operatorname{Nerve} U) = \operatorname{Pers}(W).

We now will define the structure that will provide the link between the nerve filtration and the union filtration. From $U \alpha$ , there is a corresponding commutative diagram $D U \alpha$ , where the spaces are the nonempty sets $U \alpha v$ for $v \subseteq [ n ]$ and there is an inclusion map $U \alpha v 0 \to U \alpha v 1$ whenever $v 1 \subset v 0$ . Let Flag( n ) $\alpha$ be the set of ordered sequences of the form $\sigma = ( v 0 ,...,v k ), k \leq n$ , where $v i \subseteq [ n ].$ This can be interpreted as an ordering on the barycentric decomposition of Nerve $U \alpha$ . This is an abstract simplicial complex. We define the homotopy colimit of $D U \alpha$ as

\operatorname{hocolim} \ D \mathcal{U}^{\alpha} \colon = \bigcup_{\sigma \in \text{Flag} ( n )^{\alpha}} U_{v_{0}}^{\alpha} \times \sigma .

The homotopy colimit yields another filtration, $B = ( B \alpha ) \alpha \geq 0$ , where $B \alpha =$ hocolim $D U \alpha$ . Note that hocolim $D U \alpha \subseteq W \alpha \times$ Flag( n ) $\alpha$ , and thus there are natural projections into $W \alpha$ and Nerve $U \alpha$ from $B \alpha$ for each $\alpha$ . The projection map $b \alpha : B \alpha \to W \alpha$ is a homotopy equivalence for any cover of a paracompact space e.g. simplicial complexes, and by its naturality, we have $\operatorname{Pers}(B) = \operatorname{Pers}(W)$. The homotopy colimit $\operatorname{hocolim} D U^{\alpha}$ is also known as the Mayer-Vietoris blowup complex.



We use the following notation, in relation to $\sigma = ( v 0 ,...,v k ), a k$ -simplex of $N \alpha$ . Let $\sigma i = ( v 0 ,...,v i )$ and $¯ \sigma i = ( v i ,...,v k ).$ By our $\varepsilon$ -goodness assumption we have maps on the chains $c_{v} : C * ( U \alpha v ) \to C *$ +1 $( U \alpha + \varepsilon v )$ that are chain homotopies between the identity map and the map to a fixed point x v . By composition, we obtain a map for all $k \geq 0 , c \alpha : C k : ( B \alpha ) \to C k$ +1 $( W \alpha + t ),$ where $t = ( k +1 ) \varepsilon$ . This maps acts on $\tau \times \sigma \in C * ( B \alpha ),$ as follows.

c^{\alpha} ( \tau \times \sigma ) \colon = ( c_{v_{k}} \circ \dots \circ c_{v_{0}} ) ( \tau ) .

We now define the map $q^\alpha ( \sigma ) \colon= c^\alpha ( x_{v_0} \times \bar{\sigma}_1 )$. Composing the aforementioned we get a map $a^\alpha = q^\alpha \circ p^\alpha \colon C_*(B^\alpha) \to C_*(W^{\alpha+t})$, and we have that $c^\alpha$ is a chain homotopy between $a^\alpha$ and $b^\alpha$. The key ingredient to this construction is that given a chain map $f \colon C_*(B^\alpha) \to C_*(W^{\alpha+t})$, we can "lift" this to a chain map $\bar{f} \colon C_*(B^\alpha) \to C_*(B^{\alpha+t})$ as follows.

## Results

We do not assume that the cover is good. Rather, given a cover $\mathcal{U}$, we say it is $\varepsilon$-good if for all $v \subseteq [n]$, and for all $\alpha \geq 0$, the inclusions $U^\alpha_v \to U^{\alpha+\varepsilon}_v$ have the homology of a point, so any nontrivial topology of $U^\alpha_v$ dies at $U^{\alpha+\varepsilon}_v$. Note that when $\varepsilon = 0$, we have the exact hypothesis of the Persistent Nerve Lemma. Our main result is the following.

\bar{f} ( \tau \times \sigma ) \colon = \sum_{i = 0}^{k} f ( \tau \times \sigma_{i} ) \times \bar{\sigma}_{i} . \\

This lifting operation also preserves chain homotopies on the new spaces. Thus we have a chain homotopy $\bar{c}^\alpha$ between $\bar{a}^\alpha$ and $\bar{b}^\alpha$. By defining a lift of $q^\alpha$ as $\bar{q}^\alpha(\sigma) \colon= \sum_{i=0}^k q^\alpha(\sigma_i) \times \bar{\sigma}_i$, we get our desired maps. Note that in the construction, $t = ( k + 1 ) \varepsilon$ , leading to the bound in the main theorem.

**Theorem 1.** *If $\mathcal{U} = \{U_1, \dots, U_n\}$ is a set of filtrations that is an $\varepsilon$-good cover of the simplicial filtration $W = \bigcup_{i=1}^n U_i$, then*

d_{B} ( \operatorname{Pers}_{r} ( \mathcal{W} ) , \operatorname{Pers}_{r} ( \operatorname{Nerve} \mathcal{U} ) ) \leq ( r + 1 ) \varepsilon

Thus the bottleneck distance of the persistence diagrams for the r -th persistent homology of the simplicial filtration and the nerve filtration is bounded above $( r +1 ) \varepsilon$ . Furthermore, the bottleneck distance is upper-bounded by $( D + 1 ) \varepsilon$ , where D is the maximal dimension of the nerve.Since the maps ¯ a and p ◦ ¯ q are natural by construction, they commute with the shift homomorphisms at the homology level, and thus induce the interleaving homomorphisms between N and B , implying our result. An overview of the proof is as follows. One has the equality Pers( W ) $=$ Pers( B ), and thus one must find an interleaving between the chains of $N \alpha$ and $B \alpha$ to prove the theorem, where $N \alpha$ is the barycentric subdivision of Nerve $U \alpha$ . Define $N = ( N \alpha ) \alpha \geq 0$ . Since $N \alpha$ is homeomorphic to Nerve $U \alpha$ , for all $\alpha$ , it follows that Pers( N ) $=$ Pers(Nerve U ). For each vertex v of $N \alpha$ , there is a corresponding nonempty set $U \alpha v$ . There exists a projection $p \alpha : B \alpha \to N \alpha$ , which we use to define a map $¯ q \alpha$ from $N \alpha$ to $B \alpha + t$ , where t is a function of $\varepsilon$ , such that $p \alpha + t ◦ ¯ q \alpha$ commutes with $N \alpha \to N \alpha + t$ and $¯ q \alpha ◦ p \alpha$ is chain homotopic to the inclusion $b \alpha : B \alpha \to B \alpha + t$ .

