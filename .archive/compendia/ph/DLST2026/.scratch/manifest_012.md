# Manifest: Page 012

## REPAIR_MATH
- RAW: ```
A fence in a poset ( X, ≤ ) is a sequence x 0 ,x 1 ,...,x n ⊂ X such that for every i ∈ { 1 , 2 ,...n } either x i − 1 ≤ x i or x i − 1 ≥ x i .
```
  FIX: ```
A fence in a poset \( (X, \leq) \) is a sequence \( x_0, x_1, \dots, x_n \subset X \) such that for every \( i \in \{ 1, 2, \dots, n \} \) either \( x_{i-1} \leq x_i \) or \( x_{i-1} \geq x_i \).
```

- RAW: ```
3.4. Finite topological spaces. Let ( X, T ) be a finite topological space satisfying the T 0 separation axiom. For a subset A ⊂ X we denote its closure by cl A . Since X is finite, there exists a minimal open set in T containing A , which we denote by opn A . We define the mouth of A as mo A : = cl A \ A . A set A is said to be locally closed if mo A is closed.
```
  FIX: ```
3.4. Finite topological spaces. Let \( (X, \mathcal{T}) \) be a finite topological space satisfying the \( T_0 \) separation axiom. For a subset \( A \subset X \) we denote its closure by \( \mathrm{cl} A \). Since \( X \) is finite, there exists a minimal open set in \( \mathcal{T} \) containing \( A \), which we denote by \( \mathrm{opn} A \). We define the mouth of \( A \) as \( \mathrm{mo} A \coloneqq \mathrm{cl} A \setminus A \). A set \( A \) is said to be locally closed if \( \mathrm{mo} A \) is closed.
```

- RAW: ```
Proposition 3.1. [ 24 , Problem 2.7.1] Let A ⊂ X . Then, the following conditions are equivalent:
```
  FIX: ```
Proposition 3.1. [ 24 , Problem 2.7.1] Let \( A \subset X \). Then, the following conditions are equivalent:
```

- RAW: ```
- (1) A is locally closed,
- (2) A is a difference of two closed sets,
- (3) A is an intersection of an open and closed set.
```
  FIX: ```
- (1) \( A \) is locally closed,
- (2) \( A \) is a difference of two closed sets,
- (3) \( A \) is an intersection of an open and closed set.
```

- RAW: ```
The following theorem allows us to identify a finite T 0 topological space with a finite partial order. In particular, open sets translate into upper sets, closed sets into down sets, and locally closed sets into convex sets.
```
  FIX: ```
The following theorem allows us to identify a finite \( T_0 \) topological space with a finite partial order. In particular, open sets translate into upper sets, closed sets into down sets, and locally closed sets into convex sets.
```

- RAW: ```
Theorem 3.2 (Alexandrov Theorem [ 1 ]) . Let ( X, ≤ ) be a finite, partially ordered set. The family of all upper sets of ( X, ≤ ) forms a T 0 topology T ≤ on X . Conversely, a T 0 finite topological space ( X, T ) induces a partial order ( X, ≤ T ), where x ≤ T y whenever x ∈ cl y . In particular T ≡ T ≤ T and ≤≡≤ T ≤ . Moreover, continuous maps can be identified with order-preserving maps.
```
  FIX: ```
Theorem 3.2 (Alexandrov Theorem [ 1 ]). Let \( (X, \leq) \) be a finite, partially ordered set. The family of all upper sets of \( (X, \leq) \) forms a \( T_0 \) topology \( \mathcal{T}_{\leq} \) on \( X \). Conversely, a \( T_0 \) finite topological space \( (X, \mathcal{T}) \) induces a partial order \( (X, \leq_{\mathcal{T}}) \), where \( x \leq_{\mathcal{T}} y \) whenever \( x \in \mathrm{cl} y \). In particular \( \mathcal{T} \equiv \mathcal{T}_{\leq_{\mathcal{T}}} \) and \( {\leq} \equiv {\leq_{\mathcal{T}_{\leq}}} \). Moreover, continuous maps can be identified with order-preserving maps.
```

- RAW: ```
4.1. Elementary notions. Let X be a finite topological space; in particular X can be a simplicial or a regular CW-complex. A multivector field V on X is a partition of X into locally closed subsets, called multivectors . Since V is a partition, every x ∈ X belongs to a unique multivector V ∈ V ; we denote it by [ x ] V . A multivector V is called regular if the relative homology group H (cl V, mo V ) is 0, otherwise V is critical . A set A ⊂ X is called V -compatible if it is a union of multivectors in V .
```
  FIX: ```
4.1. Elementary notions. Let \( X \) be a finite topological space; in particular \( X \) can be a simplicial or a regular CW-complex. A multivector field \( \mathcal{V} \) on \( X \) is a partition of \( X \) into locally closed subsets, called multivectors. Since \( \mathcal{V} \) is a partition, every \( x \in X \) belongs to a unique multivector \( V \in \mathcal{V} \); we denote it by \( [x]_{\mathcal{V}} \). A multivector \( V \) is called regular if the relative homology group \( H(\mathrm{cl} V, \mathrm{mo} V) \) is 0, otherwise \( V \) is critical. A set \( A \subset X \) is called \( \mathcal{V} \)-compatible if it is a union of multivectors in \( \mathcal{V} \).
```

- RAW: ```
A multivector field V induces a multivalued map F V : X ⊸ X defined as
```
  FIX: ```
A multivector field \( \mathcal{V} \) induces a multivalued map \( F_{\mathcal{V}} \colon X \multimap X \) defined as
```

- RAW: ```
$$
F _ { \mathcal { V } } ( x ) \coloneqq c l \, x \cup [ x ] _ { \mathcal { V } } .
$$
```
  FIX: ```
$$
F_{\mathcal{V}}(x) \coloneqq \mathrm{cl} \, x \cup [x]_{\mathcal{V}}.
$$
```

- RAW: ```
The map F V can be viewed as a digraph G V with nodes given by X and the set of edges consisting of pairs ( x,y ) ∈ X × X such that y ∈ F V ( x ). A solution is a path in G V , which we represent as a map ρ : I → X , where I is an interval in Z .
```
  FIX: ```
The map \( F_{\mathcal{V}} \) can be viewed as a digraph \( G_{\mathcal{V}} \) with nodes given by \( X \) and the set of edges consisting of pairs \( (x, y) \in X \times X \) such that \( y \in F_{\mathcal{V}}(x) \). A solution is a path in \( G_{\mathcal{V}} \), which we represent as a map \( \rho \colon I \to X \), where \( I \) is an interval in \( \mathbb{Z} \).
```

- RAW: ```
Example 4.1. Figure 9 shows an example of a multivector field V on a simplicial complex, consisting of ten multivectors: { abc } , { a,ab } , { b,bd } , { bc,bcd } , { c,ac } , { d,cd } , { df,def } , { e,ce,de,cde } , { ef } , and { f } . The three singleton multivectors are critical and the rest are regular. Singleton { f } models an attracting equilibrium; { ef } a saddle; and { abc } a repelling equilibrium. In particular,
```
  FIX: ```
Example 4.1. Figure 9 shows an example of a multivector field \( \mathcal{V} \) on a simplicial complex, consisting of ten multivectors: \( \{ abc \} \), \( \{ a, ab \} \), \( \{ b, bd \} \), \( \{ bc, bcd \} \), \( \{ c, ac \} \), \( \{ d, cd \} \), \( \{ df, def \} \), \( \{ e, ce, de, cde \} \), \( \{ ef \} \), and \( \{ f \} \). The three singleton multivectors are critical and the rest are regular. Singleton \( \{ f \} \) models an attracting equilibrium; \( \{ ef \} \) a saddle; and \( \{ abc \} \) a repelling equilibrium. In particular,
```

