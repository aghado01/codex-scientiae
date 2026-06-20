# Multiparameter persistence

## Contents

- [9.1 Persistence modules indexed by a poset](#91-persistence-modules-indexed-by-a-poset)
- [9.2 Representing persistence modules indexed by posets](#92-representing-persistence-modules-indexed-by-posets)
- [9.2.1 Barcodes?](#921-barcodes)
- [9.2.2 Other representations and visualizations](#922-other-representations-and-visualizations)
- [9.3 Distances and robustness for P -persistence modules](#93-distances-and-robustness-for-p--persistence-modules)
- [9.3.1 Robustness of some bipersistence modules](#931-robustness-of-some-bipersistence-modules)
- [Questions](#questions)
- [References](references/REF-MPH.md)

This chapter closely follows the introductory paper [2] on multiparameter persistence. The interested reader is referred there for a (much) more comprehensive overview of the topic.

As we have seen, the persistence modules arising from the Čech or Vietoris-Rips complexes are stable under small perturbations of the underlying data, but not robust. That is, even a small number of outliers can drastically change the persistence diagram or barcode. We could try to remedy this problem by making these complexes density-aware in some way. For the Vietoris-Rips complex, a typical way to do this is as follows. For a vertex v in a simplicial complex, its degree deg ( v ) is the number of edges ( 1 -simplices) in the complex that contain v. Then. for d 2, the degreed Vietoris-Rips complex is

r d ( X ) : = { 2 r ( X ) : each vertex of has degree at least d }.

Note that vertices corresponding to data points in high-density areas of X will have relatively higher degree, whereas outliers will have relatively lower degree. Thus, for d large enough, we should expect this modification to reduce the impact of outliers. On the other hand, if d is too large, we are ‘throwing away the baby with the bathwater’. So, the question is: how to choose d ? Here, we run into the same issue that originally motivated persistence: there might not be one choice of d that accurately reflects the entire data set. Even if this choice would exist, it might be hard to determine. Instead, we would like to consider all choices of d simultaneously. The solution is to look at persistence w.r.t. both the scale parameter r and the density parameter d at the same time. In this chapter, we formalize such multiparameter persistence, and take a look at the representability and robustness of the resulting multiparameter persistence modules.

## 9.1 Persistence modules indexed by a poset

A persistence module (indexed by ) consists of a family of vectors spaces U a, a 2, together with commuting maps U a ! U b for a 6 b. If we want to define persistence

Definition 9.1. A poset (partially ordered set) is a tuple ( P, ) consisting of a set P and a binary relation on P satisfying

- a a for all a 2 P ;
- a b and b a implies a = b for all a,b 2 P ;

a /precedesequal b and b /precedesequal c implies a /precedesequal c for all a, b, c $\in$ P ;

We will sometimes simply write P if the (partial) ordering is clear from context.

Note that partial orderings allow for elements to be incomparable, i.e., it can happen for a,b 2 P that neither a b nor b a holds. In contrast, under a total ordering all elements in P must be comparable. All the posets we will see in this chapter are constructed from the following examples:

- The reals = (, 6 ) and natural numbers = (, 6 ) with their usual ordering are posets.
- If ( P, ) is a poset, and Q ✓ P, then ( Q, ) is a poset;
- For any poset ( P, ), we have the opposite poset P op = ( P, ⌫ ),

/precedesequal op /followsequal, where

$$
a \preceq b \iff b \preceq a \quad \text{for all a,b\in P}.
$$

- For two posets ( P, P ) and ( Q, Q ) we have the product poset ( P ⇥ Q, ), where

$$
( p, q ) \preceq ( p^{\prime}, q^{\prime} ) \iff p \preceq_{P} p^{\prime} \text{and} q \preceq_{Q} q^{\prime} \quad \text{for all} p, p^{\prime} \in P \text{and} q, q^{\prime} \in Q.
$$

We can now define filtrations and persistence modules indexed by an arbitrary poset, generalizing our definitions from earlier chapters.

Definition 9.2. Let ( P, ) be a poset. A family ( X p ) p 2 P of topological spaces (or simplicial complexes) is called a P -filtration if X p ✓ X p 0 for all p,p 0 2 P with p p 0.

Definition 9.3. Let ( P, ) be a poset, and let be a field. A P -persistence module (over ) consists of

- An -vector space U p for each p 2 P ;
- A linear map u p,p 0 : U p ! U p 0 for each p,p 0 2 P with p p 0, satisfying u p 2,p 3 u p 1,p 2 = u p 1,p 3 for all p 1,p 2,p 3 2 P with p 1 p 2 p 3.

′ ′ ◦ $\in$ /precedesequal /precedesequal

Observation 9.4. If ( X p ) p 2 P is a P -filtration for some poset P, then taking k -dimensional homology gives us a P -persistence module H k ( X p ) (where, as before, the maps u p,p 0 : H k ( X p ) ! H k ( X p 0 ) are induced by the inclusions X p, ! X p 0 ).

We can now give two examples of filtrations indexed by P = ⇥ op, each of which induces a P -persistence module via the observation above. The first one formalizes the discussion at the beginning of the chapter. The second one applies a similar idea to the Čech complex.

Example 9.5. Let X be a finite metric space. Then the family ( r d ( X )) r 2,d 2 defined above is a filtration indexed by ⇥ op. It is called the degree-Rips bifiltration. n

Example 9.6. Let X ✓ be a finite point cloud. For r 2 and d 2, define

$$
\mathcal{M} \mathcal{C}_{d}^{r} = \{x \in R^{n} \colon | B ( x, r ) \cap X | \geqslant d \} \subseteq R^{n}.
$$

Note that, for d = 1, this is just the union-of-balls used to define the Čech complex. The family ( MC r d ( X )) r 2,d 2 is a filtration (of topological spaces) indexed by ⇥ op. It is called the multicover bifiltration.

Both of the filtrations above can also be thought of as indexed over 2 (after a reparameterization). In general, we call an n -filtration (resp. n -persistence module) an n -parameter filtration (resp. n -parameter persistence module). For n > 2, we also say ‘multiparameter’. For n = 2 the terms bifiltration and bipersistence module are common.

## 9.2 Representing persistence modules indexed by posets

## 9.2.1 Barcodes?

Recall that a p.f.d. persistence module indexed by can be uniquely represented by a barcode. In Chapter 6, we saw that this follows from the fact that any such can be decomposed into interval modules in a unique way:

$$
U \cong \bigoplus_{i \in I} I_{\langle a, b \rangle}.
$$

Each interval in this decomposition corresponds to a bar in the barcode of. We could hope a similar statement holds for modules indexed by any poset P. The following definition and theorem should give us some hope:

Definition 9.7. A persistence module is called indecomposable if ⇠ = 1 2 implies that 1 = 0 or 2 = 0.

Exercise 9.8. Show that interval modules (indexed by ) are indecomposable.

Theorem 9.9. Let be a p.f.d. persistence module (indexed by a poset P ). Then, there is a unique decomposition:

$$
U \cong \bigoplus_{i \in I} U_{i}, \\ 1_{i} = 1.
$$

where each persistence module i is indecomposable.

Understanding P -persistence modules thus boils down to understanding indecomposables (indexed by P ). For P =, it turns out that indecomposables are precisely interval modules, leading to Theorem 6.36. However, for general P, the situation is much more complicated. Without going into details: It is not possible to parameterize indecomposables in terms of some nice family of subsets of P. The decomposition of Theorem 9.9 therefore does not lead to a workable notion of barcode in general. In fact, it is not possible to define any reasonable notion of a barcode for P -persistence modules, in the following sense.

Definition 9.10. Let ( P, ) be a poset and let be a P -persistence module. We say a multiset B of subsets of P is a reasonable barcode for if

$$
\ r a n k ( u_{p, p^{\prime}} ) = | \{B \in \mathcal{B} \colon p, p^{\prime} \in B \} | \quad ( \forall p \preceq p^{\prime} ). \\
$$

That is, the rank of the map u p,p 0 : U p ! U p 0 can be computed by counting the number of ‘bars’ that contain both p and p 0.

Exercise 9.11. Show that the usual barcode for a p.f.d. persistence module indexed by is reasonable in the above sense.

Exercise 9.12. For p 2 P, show that dim U p is greater than or equal to the number of bars that contain p in a reasonable barcode for.

Example 9.13. Let P = { 0,1,2 } ⇥ { 0,1,2 } and consider the following persistence module indexed by P :

$$
\begin{aligned}
F & \longrightarrow F \longrightarrow 0 & f & \colon a & \mapsto ( a, 0 ) \\ \text{id} & \widehat{g} & \widehat{\uparrow} & g & \colon ( a, b ) & \mapsto a \\ U & = F \longrightarrow F^{2} & F & \, F \,, & \text{where} & h & \colon ( a, b ) & \mapsto a + b \\ & \widehat{\uparrow} & \widehat{j} & \widehat{\uparrow} & \text{id} & j & \colon a & \mapsto ( 0, a ) \\ & 0 & \longrightarrow F \longrightarrow F \\ \text{We claim} U & \, \text{can not have a reasonable hargcode} \, \text{to see this, sumpose}
\end{aligned}
$$

We claim cannot have a reasonable barcode. To see this, suppose B is a reasonable barcode for. Note that

$$
\begin{aligned}
\ r a n k ( h \circ f ) & = \text{rank} ( g \circ f ) = \text{rank} ( h \circ j ) = 1. \\
\end{aligned}
$$

By the reasonability assumption, there thus must be subsets I,J,K 2 B with

$$
( 0, 1 ), ( 2, 1 ) \in I, \quad ( 0, 1 ), ( 1, 2 ) \in J, \quad ( 1, 0 ), ( 2, 1 ) \in K.
$$

Since dim U 0,1 = dim U 2,1 = 1, we know by Exercise 9.12 that ( 0,1 ) and ( 2,1 ) occur in at most one element of B. But that means that I = J, and I = K, and so in fact I = J = K ◆ { ( 0,1 ), ( 2,1 ), ( 1,2 ) }. Thus, using reasonability again, we find that

$$
\begin{aligned}
\text{rank} ( g \circ j ) & \geqslant 1, \\
\end{aligned}
$$

contradicting the fact that g j = 0.

For completeness, we note that it is possible to have reasonable barcodes for multiparameter persistence modules if we allow ‘bars’ to occur with negative multiplicity. This leads to so-called signed barcodes. Furthermore, there are several special classes of multiparameter persistence modules which do admit an interval decomposition (note that we did not formally define what an interval is in the poset-setting!). This is true in particular for so-called interlevel persistence. We will not discuss this further here.

## 9.2.2 Other representations and visualizations

Even though we cannot hope for a barcode-like representation of multiparameter persistence modules, there are still several useful (partial) representations available. We mention just three of them here:

- The Hilbert-function of a p.f.d. persistence module indexed by P sends p 2 P to dim U p 2. It can be thought of as a ‘homological heatmap’.
- The rank-invariant of sends a pair ( p,p 0 ), p p 0 to the rank rank ( u p,p 0 ) of the map between U p and U 0 p. Note that any two modules with ⇠ = have the same rank invariant. For modules indexed by, this implication also holds in the other direction. However, for general P, there exist nonisomorphic modules with the same rank-invariant;
- Let L : t 7! ta + b be an affine line in 2 with non-negative slope. Then the restriction L of a persistence module indexed by 2 to the line L can be viewed as a persistence module indexed by (with its usual, total ordering). The Fibered Barcode of sends each such line L to the barcode B ( L ). This idea can be extended to lines in n ;

Exercise 9.14. Show that the rank-invariant of an 2 -persistence module can be recovered from its fibered barcode, and vice versa.

The RIVET software package ( rivet.readthedocs.io ) allows you to compute and visualize each of the invariants above for (among others) the degree-Rips bifiltration.

## 9.3 Distances and robustness for P -persistence modules

As we generally do not have barcodes for P -persistence modules, we cannot rely on the Bottleneck distance to compare them. Instead, we work directly with interleaving distance, which is still well-defined. For simplicity, we only consider P = n.

Definition 9.15. Write 1 = ( 1,1,...,1 ) 2 n. Two n -persistence modules, are ✏ -interleaved if there exist two families of linear maps, ' a : U a ! V a + ✏ 1 and

a : V a ! U a + ✏ 1, a 2 n, such that the following diagrams (and their symmetric counterparts obtained by exchanging the role of and ) are commutative:

u a,a 0

-

/epsilon1

v a +

-

/epsilon1

-

/epsilon1

and

-

/epsilon1

u a,a +

-

/epsilon1

-

/epsilon1

-

/epsilon1

-

/epsilon1

The interleaving distance between, is d I (, ) : = inf ✏ > 0 {, are ✏ -interleaved }.

The definition above agrees with our earlier definition of interleaving when n = 1. Contrary to the 1 -dimensional case, computing the interleaving distance for n > 2 is an NP-hard problem (even if the persistence modules, are given to us in a ‘nice’ form). For this reason, the following alternative based on the fibered barcode is sometimes used in practice. It is known to be efficiently computable when n = 2.

Definition 9.16. The matching distance between p.f.d. n -persistence modules, is

$$
d_{\text{match}}(U, V) \coloneqq \sup_{L} \left\{d_{B}(\mathcal{B}(U_L), \mathcal{B}(V_L))\right\},
$$

where the supremum is taken over all lines $L \colon t \mapsto ta + b$ with $a \nparallel 1$, $b \in \mathbb{R}^n$.

Theorem 9.17 (see [3]). For any two p.f.d. n -persistence modules,

$$
d_{\text{match}} ( U, V ) \leqslant d_{I} ( U, V ).
$$

Exercise 9.18. Prove that d B B ( L ), B ( L ) 6 d I (, ) for all lines L : t 7! t 1 + b.

## 9.3.1 Robustness of some bipersistence modules

Finally, we come back to the primary reason for studying multiparameter persistence: achieving robustness w.r.t. outliers in the data. To state formal guarantees of this form, we need to think about point-cloud data in a more probablistic way. For a finite (multi)set X ✓ n, we write $\mu$ X for the uniform probability measure on X, meaning the measure that assigns probability 1/ | X | to each x 2 X. The following can be thought of as a ‘probabilistic Hausdorff distance’ between point clouds.

Definition 9.19. Let X,Y ✓ n finite. The Prohorov distance 1 between $\mu$ X,$\mu$ Y is

$$
d_{\Pr} ( \mu_{X}, \mu_{Y} ) \coloneqq \supinf_{A} \{\delta \geqslant 0 \colon \mu_{X} ( A ) \leqslant \mu_{Y} ( A^{\delta} ) + \delta \ a n d \ \mu_{Y} ( A ) \leqslant \mu_{X} ( A^{\delta} ) + \delta \},
$$

where A ranges over all closed subsets of n and A : = { y 2 n : dist ( y,A ) 6 }.

1 The Prohorov distance can be defined between any two measures $\mu$, ⌫ on (the same) metric space M.

While the definition of the Prohorov distance appears a bit complicated, the following observation suggests that it captures ‘robustness to outliers’ in a meaningful way.

Exercise 9.20. Let X Y ✓ n, finite, non-empty sets. Show that

$$
d_{\Pr} ( \mu_{X}, \mu_{Y} ) \leqslant \frac{| Y \ \ X |}{| X |}.
$$

As an example, the normalized multicover persistence module turns out to be stable w.r.t. Prohorov distance (i.e., it is robust to outliers).

Definition 9.21. Let X ✓ n be a finite point cloud. For r, ⇢ 2, the sets

$$
\begin{aligned}
\mathcal{NMC}_{\rho}^{r}(X) &\coloneqq \{x \in R^{n} \colon |B(x,r) \cap X| \geqslant \rho |X|\} \\
&= \{x \in R^{n} \colon \mu_{X}(B(x,r) \cap X) \geqslant \rho \}.
\end{aligned}
$$

form a bilfiltration over $\mathbb{R} \times \mathbb{R}^{\mathrm{op}}$ called the normalized multicover bifiltration.

Theorem 9.22 (see [1]). Let X,Y ✓ n finite. For all k > 0, we have

$$
\begin{aligned}
d_{I}\left(H_k(\mathcal{NMC}^r(X)), H_k(\mathcal{NMC}^r(Y))\right) &\leqslant d_{\Pr}(\mu_X, \mu_Y).
\end{aligned}
$$

Proof. Let $\epsilon = d_{\Pr}(\mu_X, \mu_Y)$. We will show that

$$
\mathcal{N M C}_{\rho}^{r} ( X ) \subseteq \mathcal{N M C}_{\rho - \epsilon}^{r + \epsilon} ( Y ) \subseteq \mathcal{N M C}_{\rho - 2 \epsilon}^{r + 2 \epsilon} ( X ) \quad \forall r, \rho \in R.
$$

These inclusions induce the maps

$$
\begin{aligned}
\varphi_{r,\rho} &\colon H_k(\mathcal{NMC}_\rho^r(X)) \to H_k(\mathcal{NMC}_{\rho-\epsilon}^{r+\epsilon}(Y)), \\
\psi_{r+\epsilon,\rho-\epsilon} &\colon H_k(\mathcal{NMC}_{\rho-\epsilon}^{r+\epsilon}(Y)) \to H_k(\mathcal{NMC}_{\rho-2\epsilon}^{r+2\epsilon}(X))
\end{aligned}
$$

required to show that $H_k(\mathcal{NMC}^r(X))$ and $H_k(\mathcal{NMC}^r(Y))$ are $\epsilon$-interleaved.

So, let $r, \rho \geq 0$, and suppose that $x \in \mathcal{NMC}_\rho^r(X)$. By definition, this means that $\mu_X(B(x,r) \cap X) > \rho$. Using the definition of the Prohorov distance, and the triangle inequality, this implies that

$$
\rho \leqslant \mu_X(B(x,r) \cap X) \leqslant \mu_Y(B(x,r)^\epsilon \cap Y) + \epsilon \leqslant \mu_Y(B(x,r+\epsilon) \cap Y) + \epsilon.
$$

That is to say, $\mu_Y(B(x,r+\epsilon) \cap Y) \geqslant \rho - \epsilon$, meaning $x \in \mathcal{NMC}_{\rho-\epsilon}^{r+\epsilon}(Y)$, giving us the first inclusion. The second inclusion follows from an analogous argument, switching the roles of $X$ and $Y$.
There are many similar theorems for other bipersistence modules, including the degree-Rips bifiltration. They are often somewhat hard to state and prove, relying on variants of the Prohorov distance, as well as variants of the interleaving distance [1].
## Questions
- 35. How can we define persistence modules over multiple parameters? Discuss the technical definitions that are needed.
- 36. What are some common bipersistence modules? How do they relate to the (1-parameter) persistence modules of earlier chapters?
- 37. What is a major upside of multiparameter persistence? What is a major downside? Discuss robustness and representability.
- 38. How can we visualize multiparameter persistence modules?
