# Manifest: Page 033

## REPAIR_MATH
- RAW: ```
V ^ { c } \coloneqq \mathbb { Z } ^ { d } V , \quad \partial V \coloneqq \{ w \in V ^ { c } \colon \| v - w \| = 1 \text { for some } v \in V \} , \quad X _ { V } \coloneqq ( X _ { v } ) _ { v \in V } .
```
  FIX: ```
$$
V ^ { c } \coloneqq \mathbb { Z } ^ { d } V , \quad \partial V \coloneqq \{ w \in V ^ { c } \colon \| v - w \| = 1 \text { for some } v \in V \} , \quad X _ { V } \coloneqq ( X _ { v } ) _ { v \in V } .
$$
```
- RAW: ```
\gamma _ { V } ( x , A ) = \frac { 1 } { Z } \sum _ { x _ { V } \in E ^ { V } } 1 _ { A } ( x ) \, \exp \left ( \sum _ { \{ v , w \} \subset V \cup \partial V \colon \| v - w \| = 1 } \varphi _ { \{ v , w \} } ( x _ { v } , x _ { w } ) + \sum _ { v \in V } \psi _ { v } ( x _ { v } ) \right )
```
  FIX: ```
$$
\gamma _ { V } ( x , A ) = \frac { 1 } { Z } \sum _ { x _ { V } \in E ^ { V } } 1 _ { A } ( x ) \, \exp \left ( \sum _ { \{ v , w \} \subset V \cup \partial V \colon \| v - w \| = 1 } \varphi _ { \{ v , w \} } ( x _ { v } , x _ { w } ) + \sum _ { v \in V } \psi _ { v } ( x _ { v } ) \right )
$$
```
- RAW: ```
A random ﬁeld is a collection of random variables X v that are indexed by the spatial degree of freedom v . For simplicity, we will assume in the sequel that v ∈ Z d (but see section 6.3 below) and that each X v takes values in a ﬁnite set E . d
```
  FIX: ```
A random ﬁeld is a collection of random variables \( X_v \) that are indexed by the spatial degree of freedom \( v \). For simplicity, we will assume in the sequel that \( v \in \mathbb{Z}^d \) (but see section 6.3 below) and that each \( X_v \) takes values in a ﬁnite set \( E \).
```
- RAW: ```
In the following, we deﬁne for any V ⊆ Z
```
  FIX: ```
In the following, we deﬁne for any \( V \subseteq \mathbb{Z}^d \)
```
- RAW: ```
If V is a ﬁnite subset of Z d , we will write V ⊂⊂ Z d . We now recall a basic deﬁnition.
```
  FIX: ```
If \( V \) is a ﬁnite subset of \( \mathbb{Z}^d \), we will write \( V \subset\subset \mathbb{Z}^d \). We now recall a basic deﬁnition.
```
- RAW: ```
Deﬁnition 5.1. X = ( X v ) v ∈ Z d is called a Markov random ﬁeld if it possesses the (local) Markov property, that is, P [ X V ∈ ·| X V c ] depends only on X ∂V for every V ⊂⊂ Z d .
```
  FIX: ```
Deﬁnition 5.1. \( X = (X_v)_{v \in \mathbb{Z}^d} \) is called a Markov random ﬁeld if it possesses the (local) Markov property, that is, \( \mathbf{P}[X_V \in \cdot \mid X_{V^c}] \) depends only on \( X_{\partial V} \) for every \( V \subset\subset \mathbb{Z}^d \).
```
- RAW: ```
Deﬁnition 5.2. A family γ = ( γ V ) V ⊂⊂ Z d of transition kernels on E Z d such that
```
  FIX: ```
Deﬁnition 5.2. A family \( \gamma = (\gamma_V)_{V \subset\subset \mathbb{Z}^d} \) of transition kernels on \( E^{\mathbb{Z}^d} \) such that
```
- RAW: ```
- 1. γ V ( x,A ) is a function of x ∂V for every A ∈ σ { X V } and V ⊂⊂ Z d ,
```
  FIX: ```
- 1. \( \gamma_V(x,A) \) is a function of \( x_{\partial V} \) for every \( A \in \sigma\{X_V\} \) and \( V \subset\subset \mathbb{Z}^d \),
```
- RAW: ```
- 2. γ V ( x,A ) = 1 A ( x ) for every A ∈ σ { X V c } and V ⊂⊂ Z d ,
```
  FIX: ```
- 2. \( \gamma_V(x,A) = 1_A(x) \) for every \( A \in \sigma\{X_{V^c}\} \) and \( V \subset\subset \mathbb{Z}^d \),
```
- RAW: ```
- 3. γ V γ W = γ V for every W ⊂ V ⊂⊂ Z d ,
```
  FIX: ```
- 3. \( \gamma_V \gamma_W = \gamma_V \) for every \( W \subset V \subset\subset \mathbb{Z}^d \),
```
- RAW: ```
is called a speciﬁcation . A Markov random ﬁeld X is said to be speciﬁed by γ if we have P ( X ∈ A | X V c ) = γ V ( X,A ) for every measurable set A and V ⊂⊂ Z d . The family of all laws of Markov random ﬁelds speciﬁed by γ is denoted G ( γ ).
```
  FIX: ```
is called a speciﬁcation. A Markov random ﬁeld \( X \) is said to be speciﬁed by \( \gamma \) if we have \( \mathbf{P}(X \in A \mid X_{V^c}) = \gamma_V(X,A) \) for every measurable set \( A \) and \( V \subset\subset \mathbb{Z}^d \). The family of all laws of Markov random ﬁelds speciﬁed by \( \gamma \) is denoted \( \mathcal{G}(\gamma) \).
```
- RAW: ```
Example 5.3. Standard constructions of Markov random ﬁelds arise in statistical mechanics in the following manner. Let ψ v : E → R and ϕ { v,w } : E × E → R for v,w ∈ Z d with v − w = 1 be given potential functions, and let
```
  FIX: ```
Example 5.3. Standard constructions of Markov random ﬁelds arise in statistical mechanics in the following manner. Let \( \psi_v \colon E \to \mathbb{R} \) and \( \varphi_{\{v,w\}} \colon E \times E \to \mathbb{R} \) for \( v,w \in \mathbb{Z}^d \) with \( \|v - w\| = 1 \) be given potential functions, and let
```
- RAW: ```
where Z is the appropriate normalization factor. It is easily veriﬁed that γ = ( γ V ) V ⊂⊂ Z d deﬁnes a speciﬁcation. The potentials ψ v and ϕ { v,w } describe the local external and interaction forces between diﬀerent sites, and are deﬁned directly in terms of the physical parameters of the problem. For example, if E = {− 1 , 1 } , ϕ { v,w } ( σ,σ ) = βJσσ , and ψ v ( σ ) = βµσ with β,J > 0 and µ ∈ R , this is the well known ferromagnetic Ising model with inverse temperature β , interaction strength J and magnetic ﬁeld strength µ . The construction in terms of potentials will be inessential in the sequel, however.
```
  FIX: ```
where \( Z \) is the appropriate normalization factor. It is easily veriﬁed that \( \gamma = (\gamma_V)_{V \subset\subset \mathbb{Z}^d} \) deﬁnes a speciﬁcation. The potentials \( \psi_v \) and \( \varphi_{\{v,w\}} \) describe the local external and interaction forces between diﬀerent sites, and are deﬁned directly in terms of the physical parameters of the problem. For example, if \( E = \{-1, 1\} \), \( \varphi_{\{v,w\}}(\sigma_v, \sigma_w) = \beta J \sigma_v \sigma_w \), and \( \psi_v(\sigma) = \beta \mu \sigma \) with \( \beta, J > 0 \) and \( \mu \in \mathbb{R} \), this is the well known ferromagnetic Ising model with inverse temperature \( \beta \), interaction strength \( J \) and magnetic ﬁeld strength \( \mu \). The construction in terms of potentials will be inessential in the sequel, however.
```
- RAW: ```
Given a specification γ , there always exists a random field in G ( γ ) under our assumptions. However, just as a Markov chain with given transition probabilities may admit more than one stationary distribution, the random field associated to a given specification need not be unique. In fact, the structure of the set G ( γ ) is closely related to the spatial mixing properties of the associated random fields, as is shown by the following result [22, section 4.4, Proposition 7.11, Theorem 7.7]. To interpret the notion of extremality that arises here, note that if P and Q are the laws of two random fields in G ( γ ), then λ P + (1 -λ ) Q is also in G ( γ ) for 0 ≤ λ ≤ 1 [22, Chapter 7]; thus G ( γ ) is a convex set, and a random field is called extremal if it is an extreme point of this set.
```
  FIX: ```
Given a specification \( \gamma \), there always exists a random field in \( \mathcal{G}(\gamma) \) under our assumptions. However, just as a Markov chain with given transition probabilities may admit more than one stationary distribution, the random field associated to a given specification need not be unique. In fact, the structure of the set \( \mathcal{G}(\gamma) \) is closely related to the spatial mixing properties of the associated random fields, as is shown by the following result [22, section 4.4, Proposition 7.11, Theorem 7.7]. To interpret the notion of extremality that arises here, note that if \( \mathbf{P} \) and \( \mathbf{Q} \) are the laws of two random fields in \( \mathcal{G}(\gamma) \), then \( \lambda \mathbf{P} + (1 - \lambda) \mathbf{Q} \) is also in \( \mathcal{G}(\gamma) \) for \( 0 \le \lambda \le 1 \) [22, Chapter 7]; thus \( \mathcal{G}(\gamma) \) is a convex set, and a random field is called extremal if it is an extreme point of this set.
```


