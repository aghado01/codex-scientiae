[Page 20]

such a $B$ always exists, that is, $B = S$ ). Then, the sequence

$$
( P , E ) \ & \supset ( \text {pf} _ { \nu } ( \text {cl} \, B , P ) , E \cap \text {pf} _ { \nu } ( \text {mo} \, B , P ) ) \\ & \quad \subset ( \text {pf} _ { \nu } ( \text {cl} \, B , P ) , \text {pf} _ { \nu } ( \text {mo} \, B , P ) ) \ \supset \ ( \text {cl} \, B , \text {mo} \, B )
$$

consists of index pairs ([ 20 , Theorems 10 and 15]) and the inclusions induce isomorphisms in homology (Theorem 4.22 ). Symmetrically, we construct another sequence connecting $(\text{cl} \, B, \text{mo} \, B)$ with $(P', E')$ and concatenate them to obtain a filtration from $(P, E)$ to $(P', E')$ as we schematically present in diagram (4.5), which we call the connecting sequence.

$$
( 4 . 5 )
$$

4.4. Combinatorial continuation. Let $V$ and $V'$ be two multivector fields on $X$. Whenever $V \sqsubseteq V'$ we say that $V$ is a refinement of $V'$, and symmetrically, $V'$ is a coarsening of $V$.

We denote the collection of all possible multivector fields on $X$ by $\text{MVF}(X)$. The pair $(\text{MVF}(X), \sqsubseteq)$ forms a partial order, and therefore, by Theorem 3.2, we can interpret it as a finite topological space where upper sets correspond to open sets. In particular, the minimal open set containing $V \in \text{MVF}(X)$ consists of all its refinements; we denote it $\text{opn}_\sqsubseteq V$.$^2$

An example of the $\text{MVF}(X)$ is presented in Figure 12 . For the sake of clarity, we restrict the example to multivector fields with multivectors that are connected. The dynamical interpretation of a disconnected multivector is unclear, however none of our proofs require that property.

Note that in finite setting, the $\text{opn}_\sqsubseteq V$ is the best possible approximation of an "$\epsilon$-neighborhood". Therefore, we can think of a multivector field $V' \in \text{opn}_\sqsubseteq V$ as a combinatorial perturbation of $V$. Hence, with the use of Proposition 4.3 , we mimic the stability of an isolating block present in the continuous theory of flows (see [ 34 , Proposition 1.1]).

Proposition 4.24 (Stability of an isolating block) . Let $V \in \text{MVF}(X)$. An isolating block $N$ for $V$ is also an isolating block for every $V' \in \text{opn}_\sqsubseteq V$.

We call a fence of multivector fields $V = \{V_\lambda\}_\lambda = V_0, V_1, \dots, V_T \subset \text{MVF}(X)$, that is a sequence such that $V_\lambda \sqsubseteq V_{\lambda+1}$ or $V_\lambda \sqsupseteq V_{\lambda+1}$ for all $\lambda \in [0, T-1]_\mathbb{Z}$, a ( continuously ) parameterized combinatorial multivector field . We leave it as an exercise to the reader that one can indeed construct a continuous map $V(\lambda) : [0, 1] \to \text{MVF}(X)$$^3$ generating the sequence. This leads to the definition of a combinatorial continuation of an isolated invariant set.

$^2$ Note that $V \sqsubseteq V'$ implies that $V$ is higher in the poset (i.e. $V \ge V'$), which might appear counterintuitive. However, we follow the standard convention in the multivector fields literature, where open sets are identified with upper sets, a choice that makes multivectors, when drawn on a simplicial complex, geometrically resemble continuous isolating blocks.

$^3$ Continuous with respect to the standard topology on the real interval, and the finite topology on $\text{MVF}(X)$ induced by relation $\sqsubseteq$.
