[Page 33]

## 5.1 Markov random ﬁelds

A random ﬁeld is a collection of random variables \( X_v \) that are indexed by the spatial degree of freedom \( v \). For simplicity, we will assume in the sequel that \( v \in \mathbb{Z}^d \) (but see section 6.3 below) and that each \( X_v \) takes values in a ﬁnite set \( E \).

In the following, we deﬁne for any \( V \subseteq \mathbb{Z}^d \)

$$
V ^ { c } \coloneqq \mathbb { Z } ^ { d } V , \quad \partial V \coloneqq \{ w \in V ^ { c } \colon \| v - w \| = 1 \text { for some } v \in V \} , \quad X _ { V } \coloneqq ( X _ { v } ) _ { v \in V } .
$$

If \( V \) is a ﬁnite subset of \( \mathbb{Z}^d \), we will write \( V \subset\subset \mathbb{Z}^d \). We now recall a basic deﬁnition.

Deﬁnition 5.1. \( X = (X_v)_{v \in \mathbb{Z}^d} \) is called a Markov random ﬁeld if it possesses the (local) Markov property, that is, \( \mathbf{P}[X_V \in \cdot \mid X_{V^c}] \) depends only on \( X_{\partial V} \) for every \( V \subset\subset \mathbb{Z}^d \).

Just as Markov chains are deﬁned by transition probabilities, Markov random ﬁelds are deﬁned by a family of local transition kernels called a speciﬁcation [22, Chapter 1].

Deﬁnition 5.2. A family \( \gamma = (\gamma_V)_{V \subset\subset \mathbb{Z}^d} \) of transition kernels on \( E^{\mathbb{Z}^d} \) such that

- 1. \( \gamma_V(x,A) \) is a function of \( x_{\partial V} \) for every \( A \in \sigma\{X_V\} \) and \( V \subset\subset \mathbb{Z}^d \),
- 2. \( \gamma_V(x,A) = 1_A(x) \) for every \( A \in \sigma\{X_{V^c}\} \) and \( V \subset\subset \mathbb{Z}^d \),
- 3. \( \gamma_V \gamma_W = \gamma_V \) for every \( W \subset V \subset\subset \mathbb{Z}^d \),


is called a speciﬁcation. A Markov random ﬁeld \( X \) is said to be speciﬁed by \( \gamma \) if we have \( \mathbf{P}(X \in A \mid X_{V^c}) = \gamma_V(X,A) \) for every measurable set \( A \) and \( V \subset\subset \mathbb{Z}^d \). The family of all laws of Markov random ﬁelds speciﬁed by \( \gamma \) is denoted \( \mathcal{G}(\gamma) \).

Example 5.3. Standard constructions of Markov random ﬁelds arise in statistical mechanics in the following manner. Let \( \psi_v \colon E \to \mathbb{R} \) and \( \varphi_{\{v,w\}} \colon E \times E \to \mathbb{R} \) for \( v,w \in \mathbb{Z}^d \) with \( \|v - w\| = 1 \) be given potential functions, and let

$$
\gamma _ { V } ( x , A ) = \frac { 1 } { Z } \sum _ { x _ { V } \in E ^ { V } } 1 _ { A } ( x ) \, \exp \left ( \sum _ { \{ v , w \} \subset V \cup \partial V \colon \| v - w \| = 1 } \varphi _ { \{ v , w \} } ( x _ { v } , x _ { w } ) + \sum _ { v \in V } \psi _ { v } ( x _ { v } ) \right )
$$

where \( Z \) is the appropriate normalization factor. It is easily veriﬁed that \( \gamma = (\gamma_V)_{V \subset\subset \mathbb{Z}^d} \) deﬁnes a speciﬁcation. The potentials \( \psi_v \) and \( \varphi_{\{v,w\}} \) describe the local external and interaction forces between diﬀerent sites, and are deﬁned directly in terms of the physical parameters of the problem. For example, if \( E = \{-1, 1\} \), \( \varphi_{\{v,w\}}(\sigma_v, \sigma_w) = \beta J \sigma_v \sigma_w \), and \( \psi_v(\sigma) = \beta \mu \sigma \) with \( \beta, J > 0 \) and \( \mu \in \mathbb{R} \), this is the well known ferromagnetic Ising model with inverse temperature \( \beta \), interaction strength \( J \) and magnetic ﬁeld strength \( \mu \). The construction in terms of potentials will be inessential in the sequel, however.

Given a specification \( \gamma \), there always exists a random field in \( \mathcal{G}(\gamma) \) under our assumptions. However, just as a Markov chain with given transition probabilities may admit more than one stationary distribution, the random field associated to a given specification need not be unique. In fact, the structure of the set \( \mathcal{G}(\gamma) \) is closely related to the spatial mixing properties of the associated random fields, as is shown by the following result [22, section 4.4, Proposition 7.11, Theorem 7.7]. To interpret the notion of extremality that arises here, note that if \( \mathbf{P} \) and \( \mathbf{Q} \) are the laws of two random fields in \( \mathcal{G}(\gamma) \), then \( \lambda \mathbf{P} + (1 - \lambda) \mathbf{Q} \) is also in \( \mathcal{G}(\gamma) \) for \( 0 \le \lambda \le 1 \) [22, Chapter 7]; thus \( \mathcal{G}(\gamma) \) is a convex set, and a random field is called extremal if it is an extreme point of this set.
