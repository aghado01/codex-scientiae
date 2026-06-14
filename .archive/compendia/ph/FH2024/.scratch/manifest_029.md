# Manifest: Page 029

## REPAIR_PROSE
- RAW: ```
Proof: Let L := Γ min and U := Γ max be lower and upper fences of interval I , with Γ min and Γ max as in Subsection 2.4. Let further (lim ←− M | I , ( π M p ) p ∈ I ) , (lim ←− M ∂I , ( π ∂I p ) p ∈ ∂I ) , (lim ←− M | L , ( π L p ) p ∈ L ) and (lim ←− M | U , ( π U p ) p ∈ U ) be the limits of M | I , M ∂I ,M | L and M | U , respectively, and (lim −→ M | I , ( i M p ) p ∈ I ) , (lim −→ M ∂I , ( i ∂I p ) p ∈ ∂I ) , (lim −→ M | L , ( i L p ) p ∈ L ) and (lim −→ M | U , ( i U p ) p ∈ U ) be the colimits of M | I , M ∂I ,M | L and M | U , respectively. Note that L is a lower fence of I and U is an upper fence of I . Keeping in mind the commutative diagram 2.5, but restricted to M | I , it holds
```
  FIX: ```
Proof: Let \( L := \Gamma_{\min} \) and \( U := \Gamma_{\max} \) be lower and upper fences of interval \( I \), with \( \Gamma_{\min} \) and \( \Gamma_{\max} \) as in Subsection 2.4. Let further \( (\lim_{\leftarrow} M|_I, (\pi^M_p)_{p \in I}) \), \( (\lim_{\leftarrow} M_{\partial I}, (\pi^{\partial I}_p)_{p \in \partial I}) \), \( (\lim_{\leftarrow} M|_L, (\pi^L_p)_{p \in L}) \) and \( (\lim_{\leftarrow} M|_U, (\pi^U_p)_{p \in U}) \) be the limits of \( M|_I \), \( M_{\partial I} \), \( M|_L \) and \( M|_U \), respectively, and \( (\lim_{\rightarrow} M|_I, (i^M_p)_{p \in I}) \), \( (\lim_{\rightarrow} M_{\partial I}, (i^{\partial I}_p)_{p \in \partial I}) \), \( (\lim_{\rightarrow} M|_L, (i^L_p)_{p \in L}) \) and \( (\lim_{\rightarrow} M|_U, (i^U_p)_{p \in U}) \) be the colimits of \( M|_I \), \( M_{\partial I} \), \( M|_L \) and \( M|_U \), respectively. Note that \( L \) is a lower fence of \( I \) and \( U \) is an upper fence of \( I \). Keeping in mind the commutative diagram 2.5, but restricted to \( M|_I \), it holds
```

- RAW: ```
where e and h are isomorphisms. We want to prove that the rank of ξ equals the rank of ψ M ∂I . To achieve this we want to show that there exists a surjective linear map f : lim ←− M ∂I → lim ←− M | L and an injective linear map g : lim −→ M | U → lim −→ M ∂I such that ψ M ∂I = g ◦ ξ ◦ f . We define the map f as the canonical section restriction ( v q ) q ∈ ∂I  → ( v q ) q ∈ L . The map g is defined as the canonical map [ v q ]  → [ v q ] for any q ∈ U and v q ∈ M q , which is the universal map from the colimit to the cocone.
```
  FIX: ```
where \( e \) and \( h \) are isomorphisms. We want to prove that the rank of \( \xi \) equals the rank of \( \psi_{M_{\partial I}} \). To achieve this we want to show that there exists a surjective linear map \( f : \lim_{\leftarrow} M_{\partial I} \to \lim_{\leftarrow} M|_L \) and an injective linear map \( g : \lim_{\rightarrow} M|_U \to \lim_{\rightarrow} M_{\partial I} \) such that \( \psi_{M_{\partial I}} = g \circ \xi \circ f \). We define the map \( f \) as the canonical section restriction \( (v_q)_{q \in \partial I} \mapsto (v_q)_{q \in L} \). The map \( g \) is defined as the canonical map \( [v_q] \mapsto [v_q] \) for any \( q \in U \) and \( v_q \in M_q \), which is the universal map from the colimit to the cocone.
```

- RAW: ```
ψ M ∂I = g ◦ ξ ◦ f : Let p ∈ L and q ∈ U with p ≤ q in I (by the definitions of lower and upper fences such a choice exists). Since p and q also lie in ∂I , which is a path, there is a path Γ = ( p,p 1 ,...,p n ,q ) of elements in ∂I . Let further ( v r ) r ∈ ∂I ∈ lim ←− M ∂I . By definition of ψ M ∂I we have that ψ M ∂I (( v r ) r ∈ ∂I ) = [ v q ] ∂I , where [ v q ] ∂I is the equivalence class of v q in lim −→ M ∂I . On the other hand, we have that
```
  FIX: ```
\( \psi_{M_{\partial I}} = g \circ \xi \circ f \): Let \( p \in L \) and \( q \in U \) with \( p \leq q \) in \( I \) (by the definitions of lower and upper fences such a choice exists). Since \( p \) and \( q \) also lie in \( \partial I \), which is a path, there is a path \( \Gamma = (p, p_1, \dots, p_n, q) \) of elements in \( \partial I \). Let further \( (v_r)_{r \in \partial I} \in \lim_{\leftarrow} M_{\partial I} \). By definition of \( \psi_{M_{\partial I}} \) we have that \( \psi_{M_{\partial I}}((v_r)_{r \in \partial I}) = [v_q]_{\partial I} \), where \( [v_q]_{\partial I} \) is the equivalence class of \( v_q \) in \( \lim_{\rightarrow} M_{\partial I} \). On the other hand, we have that
```

- RAW: ```
Now, we define w q := M p ≤ q ( v p ) . Since q ≥ p , there is a path Γ ′ = ( q,p,p 1 ,...,p n ,q ) in P and a section ( w q ,v p ,v p 1 ,...,v p n ,v q ) of M along Γ ′ and hence by Proposition 2.18 it holds that [ w q ] M = [ v q ] M in the colimit of M . In other words, i M q ( w q ) = i M q ( v q ) . This yields
```
  FIX: ```
Now, we define \( w_q := M_{p \leq q}(v_p) \). Since \( q \geq p \), there is a path \( \Gamma' = (q, p, p_1, \dots, p_n, q) \) in \( P \) and a section \( (w_q, v_p, v_{p_1}, \dots, v_{p_n}, v_q) \) of \( M \) along \( \Gamma' \) and hence by Proposition 2.18 it holds that \( [w_q]_M = [v_q]_M \) in the colimit of \( M \). In other words, \( i^M_q(w_q) = i^M_q(v_q) \). This yields
```

- RAW: ```
It remains to show that f is surjective and g is injective.
```
  FIX: ```
It remains to show that \( f \) is surjective and \( g \) is injective.
```

- RAW: ```
Surjectivity of f : Let r ′ : lim ←− M → lim ←− M ∂I be the canonical section restriction map ( v r ) r ∈ P  → ( v r ) r ∈ ∂I . Then, the restriction r : lim ←− M → lim ←− M | L can be seen as composition of two restrictions, i.e. r = f ◦ r ′ . Since r is the inverse of the isomorphism e , r is surjective and so is f .
```
  FIX: ```
Surjectivity of \( f \): Let \( r' : \lim_{\leftarrow} M \to \lim_{\leftarrow} M_{\partial I} \) be the canonical section restriction map \( (v_r)_{r \in P} \mapsto (v_r)_{r \in \partial I} \). Then, the restriction \( r : \lim_{\leftarrow} M \to \lim_{\leftarrow} M|_L \) can be seen as composition of two restrictions, i.e. \( r = f \circ r' \). Since \( r \) is the inverse of the isomorphism \( e \), \( r \) is surjective and so is \( f \).
```

- RAW: ```
Injectivity of g : Let h ′ : lim −→ M ∂I → lim −→ M be the unique map such that i M q ( v q ) = h ′ ◦ i ∂I q ( v q ) for all q ∈ ∂I and v q ∈ M q , which exists by the universal property of lim −→ M ∂I since lim −→ M is in particular a cocone of the diagram M ∂I . Hence, h ′ maps [ v q ] ∂I to [ v q ] M . It holds that h = h ′ ◦ g for the isomorphism h in Diagram B.1. This shows that g is injective. □
```
  FIX: ```
Injectivity of \( g \): Let \( h' : \lim_{\rightarrow} M_{\partial I} \to \lim_{\rightarrow} M \) be the unique map such that \( i^M_q(v_q) = h' \circ i^{\partial I}_q(v_q) \) for all \( q \in \partial I \) and \( v_q \in M_q \), which exists by the universal property of \( \lim_{\rightarrow} M_{\partial I} \) since \( \lim_{\rightarrow} M \) is in particular a cocone of the diagram \( M_{\partial I} \). Hence, \( h' \) maps \( [v_q]_{\partial I} \) to \( [v_q]_M \). It holds that \( h = h' \circ g \) for the isomorphism \( h \) in Diagram B.1. This shows that \( g \) is injective. \square
```

- RAW: ```
Here we summarize a few results from the theory of probability of Banach spaces, as presented in [4]. We assume that B is a real separable Banach space with norm ∥ · ∥ and topological dual space B ∗ . Assume further that V : (Ω , F , P ) → B is a Borel measurable random variable defined on the probability space (Ω , F , P ) . By composition ∥ V ∥ : Ω V → B ∥·∥ → ❘ we obtain a real valued random variable. Furthermore, we obtain a real valued random variable by composition with elements f of the dual space f ( V ) : Ω V → B f → ❘ . Recall that the expected value of a real random variable X : (Ω , F , P ) → ❘ is defined as E ( X ) = ∫ XdP = ∫ Ω X ( ω ) dP ( ω ) . For random variables with values in a Banach space the so-called Pettis integral yields an analogue to the expected value.
```
  FIX: ```
Here we summarize a few results from the theory of probability of Banach spaces, as presented in [4]. We assume that \( B \) is a real separable Banach space with norm \( \| \cdot \| \) and topological dual space \( B^* \). Assume further that \( V : (\Omega, \mathcal{F}, P) \to B \) is a Borel measurable random variable defined on the probability space \( (\Omega, \mathcal{F}, P) \). By composition \( \|V\| : \Omega \xrightarrow{V} B \xrightarrow{\|\cdot\|} \mathbb{R} \) we obtain a real valued random variable. Furthermore, we obtain a real valued random variable by composition with elements \( f \) of the dual space \( f(V) : \Omega \xrightarrow{V} B \xrightarrow{f} \mathbb{R} \). Recall that the expected value of a real random variable \( X : (\Omega, \mathcal{F}, P) \to \mathbb{R} \) is defined as \( \mathbb{E}(X) = \int X \, dP = \int_\Omega X(\omega) \, dP(\omega) \). For random variables with values in a Banach space the so-called Pettis integral yields an analogue to the expected value.
```

## REPAIR_MATH
- RAW: ```
\lim _ { \leftarrow } M | _ { L } \stackrel { \xi } { \longrightarrow } & \underset { \leftarrow } { \lim } M | _ { U } \\ \downarrow & e \quad \underset { \leftarrow } { \lim } \quad \left | _ { h } \\ \lim _ { \leftarrow } M | _ { I } \stackrel { \psi _ { M | I } } { \longrightarrow } & \underset { \rightarrow } { \lim } M | _ { I } ,
```
  FIX: ```
$$
\lim _ { \leftarrow } M | _ { L } \stackrel { \xi } { \longrightarrow } & \underset { \leftarrow } { \lim } M | _ { U } \\ \downarrow & e \quad \underset { \leftarrow } { \lim } \quad \left | _ { h } \\ \lim _ { \leftarrow } M | _ { I } \stackrel { \psi _ { M | I } } { \longrightarrow } & \underset { \rightarrow } { \lim } M | _ { I } ,
$$
```
- RAW: ```
g \circ \xi \circ f ( ( v _ { r } ) _ { r \in \partial I } ) & = g \circ h ^ { - 1 } \circ \psi _ { M } \circ e \circ f ( ( v _ { r } ) _ { r \in \partial I } ) = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } \circ \pi _ { p } ^ { M } \circ e \circ f ( ( v _ { r } ) _ { r \in \partial I } ) \\ & = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } \circ \pi _ { p } ^ { L } \circ f ( ( v _ { r } ) _ { r \in \partial I } ) = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } \circ \pi _ { p } ^ { L } ( ( v _ { r } ) _ { r \in L } ) \\ & = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } ( v _ { p } ) = g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( M _ { p \leq q } ( v _ { p } ) ) .
```
  FIX: ```
$$
g \circ \xi \circ f ( ( v _ { r } ) _ { r \in \partial I } ) & = g \circ h ^ { - 1 } \circ \psi _ { M } \circ e \circ f ( ( v _ { r } ) _ { r \in \partial I } ) = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } \circ \pi _ { p } ^ { M } \circ e \circ f ( ( v _ { r } ) _ { r \in \partial I } ) \\ & = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } \circ \pi _ { p } ^ { L } \circ f ( ( v _ { r } ) _ { r \in \partial I } ) = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } \circ \pi _ { p } ^ { L } ( ( v _ { r } ) _ { r \in L } ) \\ & = g \circ h ^ { - 1 } \circ i _ { p } ^ { M } ( v _ { p } ) = g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( M _ { p \leq q } ( v _ { p } ) ) .
$$
```
- RAW: ```
g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( M _ { p \leq q } ( v _ { p } ) ) & = g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( w _ { q } ) = g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( v _ { q } ) = g \circ i _ { q } ^ { U } ( v _ { q } ) \\ & = i _ { q } ^ { \partial I } ( v _ { q } ) = [ v _ { q } ] _ { \partial I } .
```
  FIX: ```
$$
g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( M _ { p \leq q } ( v _ { p } ) ) & = g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( w _ { q } ) = g \circ h ^ { - 1 } \circ i _ { q } ^ { M } ( v _ { q } ) = g \circ i _ { q } ^ { U } ( v _ { q } ) \\ & = i _ { q } ^ { \partial I } ( v _ { q } ) = [ v _ { q } ] _ { \partial I } .
$$
```

