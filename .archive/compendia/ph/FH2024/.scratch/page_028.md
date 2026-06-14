[Page 28]

with the property that for any other cone \( ( A, ( \rho_p )_{p \in P} ) \) there exist a unique morphism \( u \colon A \to L \) such that \( \rho_p = \psi_p \circ u \) for all \( p \in P \) .

Definition A.3 Let \( F \colon ( P, \leq ) \to C \) be a diagram indexed by \( ( P, \leq ) \) . A cocone of \( F \) is an object \( B \) of \( C \) together with a family \( ( \tau_p )_{p \in P} \) of morphisms \( \tau_p \colon F_p \to B \) , such that for any morphism \( \phi_{p,q} \colon F_p \to F_q \) we have that \( \tau_p = \tau_q \circ \phi_{p,q} \) .

A colimit of the diagram \( F \) is a universal cocone in the following sense: it is a cocone \( ( C, ( \sigma_p )_{p \in P} ) \) with the property that for any other cone \( ( B, ( \tau_p )_{p \in P} ) \) there exist a unique morphism \( u \colon C \to B \) such that \( \tau_p = u \circ \sigma_p \) for all \( p \in P \) .

Note that the limit and colimit, respectively, are essentially unique , meaning that they are only unique up to an unique isomorphism.

# A.2 Kan extensions

In order to extend persistence modules indexed by a poset \( P \) to persistence modules indexed by another poset \( Q \) , which is a superset of \( P \) , we use categorical concepts that are called Kan extensions . We will directly apply it to the setting of posets and functors between posets, however, the general definitions can be found in introductory books on category theory, for example in [22].

For a given functor between two posets \( F \colon A \to B \) and a given \( b \in B \) we define the sets

$$
\[
\[
A ( F \leq b ) \colon = \{ a \in A \colon F ( a ) \leq b \} \quad \text {and} \quad A ( F \geq b ) \colon = \{ a \in A \colon F ( a ) \geq b \} .
\]
\]
$$

Let \( M \colon A \to \mathrm{Vec} \) be a persistence module, then the left Kan extension along the functor \( F \colon A \to B \) is a persistence module \( \mathrm{Lan}_F ( M ) \colon B \to \mathrm{Vec} \) defined by

$$
\[
\mathrm{Lan}_{F}(M)(b) \colon = \varinjlim M|_{A(F \leq b)} .
\]
$$

The structure maps \( \mathrm{Lan}_F ( M )( b ) \to \mathrm{Lan}_F ( M )( b' ) \) for \( b \leq b' \) are given by the universal property of colimits. Again by universality of colimits, a morphism \( f \colon M \to N \) between persistence modules \( M,N \in \mathrm{Vec}^A \) induces a morphism \( \mathrm{Lan}_F ( f ) \colon \mathrm{Lan}_F ( M ) \to \mathrm{Lan}_F ( N ) \) , making the left Kan extension a functor.

In an analogous way we define the right Kan extension of a persistence module \( M \colon A \to \mathrm{Vec} \) along a functor \( F \colon A \to B \) as

$$
\[
\mathrm{Ran}_{F}(M)(b) \colon = \varprojlim_{\longleftrightarrow} M|_{A(F \geq b)}
\]
$$

with structure maps \( \mathrm{Ran}_F ( M )( b ) \to \mathrm{Ran}_F ( M )( b' ) \) for \( b \leq b' \) given by the universal property of limits. As in the previous case, due to the universality of limits the right Kan extension is functorial meaning that it sends a morphism between persistence modules \( f \colon M \to N \) to an induced morphism \( \mathrm{Ran}_F ( f ) \colon \mathrm{Ran}_F ( M ) \to \mathrm{Ran}_F ( N ) \) .

Remark A.4 Kan extensions are useful for the definition of continuous extensions of discrete persistence modules. Given a \( n \)-indexed module, one obtains a \( n \)-indexed module for example by taking the left Kan extension of the \( n \)-indexed module along the inclusion functor \( \iota \colon n \to n \) .

# B Proof of Theorem 2.23

For the proof of Theorem 2.23, we closely follow the proof of Theorem 3.12 in [9]. However, in the part where we proof \( \psi_M^{\partial I} = g \circ \xi \circ f \) , we have to extend the proof to make the theorem hold for a slightly more general class of paths \( \Gamma_{\partial I} \) .
