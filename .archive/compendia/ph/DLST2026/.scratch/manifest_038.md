# Manifest: Page 038

## REPAIR_MATH
- RAW: ```
( \alpha _ { 1 } \dots \alpha _ { n } ) \cdot ( \beta _ { 1 } \dots \beta _ { m } ) = \alpha _ { 1 } \dots \beta _ { m }
```
  FIX: ```
\[
( \alpha _ { 1 } \dots \alpha _ { n } ) \cdot ( \beta _ { 1 } \dots \beta _ { m } ) = \alpha _ { 1 } \dots \beta _ { m }
\]
```
- RAW: ```
R = V _ { 1 } \oplus V _ { 2 } \oplus \dots \oplus V _ { n } \oplus \dots
```
  FIX: ```
\[
R = V _ { 1 } \oplus V _ { 2 } \oplus \dots \oplus V _ { n } \oplus \dots
\]
```
- RAW: ```
Therefore, Lemma 5.10 implies that B Q is also a block decomposition of P \ E . Therefore, B Q is a block decomposition both for P \ E and B q, 1 . Thus, we apply Lemma 5.10 twice to obtain Inv V 0 P \ E = Inv V 0 C V 0 ( B Q ,B q, 1 ) = Inv V 0 B q, 1 . Hence, we get the thesis by Proposition 4.18 .
```
  FIX: ```
Therefore, Lemma 5.10 implies that \( B_Q \) is also a block decomposition of \( P \setminus E \). Therefore, \( B_Q \) is a block decomposition both for \( P \setminus E \) and \( B_{q, 1} \). Thus, we apply Lemma 5.10 twice to obtain \( \mathrm{Inv}_{V_0} P \setminus E = \mathrm{Inv}_{V_0} \mathcal{C}_{V_0} (B_Q, B_{q, 1}) = \mathrm{Inv}_{V_0} B_{q, 1} \). Hence, we get the thesis by Proposition 4.18.
```
- RAW: ```
Now we focus on M q, 1 . Lemmas 5.28(b) and 5.10 imply that { B q, 1 } is a oneelement block decomposition of P \ E in V 1 . Therefore, by Remark 5.29 we have Inv V 1 P \ E = M q, 1 , and the result again follows by Proposition 4.18 . □
```
  FIX: ```
Now we focus on \( M_{q, 1} \). Lemmas 5.28(b) and 5.10 imply that \( \{ B_{q, 1} \} \) is a one-element block decomposition of \( P \setminus E \) in \( V_1 \). Therefore, by Remark 5.29 we have \( \mathrm{Inv}_{V_1} P \setminus E = M_{q, 1} \), and the result again follows by Proposition 4.18. □
```
- RAW: ```
In this section, we review some concepts from quiver representations and persistence modules. In particular, we focus on the notion of a gentle algebra, a wellknown concept from quiver representation theory that we use to study the transition diagram. Recall that, in this paper, all vector spaces are finite dimensional and defined over a fixed field k .
```
  FIX: ```
In this section, we review some concepts from quiver representations and persistence modules. In particular, we focus on the notion of a gentle algebra, a well-known concept from quiver representation theory that we use to study the transition diagram. Recall that, in this paper, all vector spaces are finite dimensional and defined over a fixed field \( k \).
```
- RAW: ```
6.1. Quivers. In this section, we summarize the main definitions of quiver theory. For a more detailed introduction we refer to [ 39 ]. A quiver , Q , consists of a set of nodes, Q 0 , a set of arrows, Q 1 , and two maps s,e : Q 1 → Q 0 , such that s and e define the source node and the target node of each arrow, respectively. We assume that Q is a finite quiver , which means that the sets Q 0 and Q 1 are finite. Given a,b ∈ Q 0 , a path with source a and target b is a sequence of arrows α 1 ...α n such that s ( α 1 ) = a , e ( α n ) = b and e ( α i ) = s ( α i +1 ) for i ∈ [1 ,n − 1] Z . Note that the convention for paths in quivers is different from paths in directed graphs: while the latter are defined on vertices, the former are defined on edges (see Section 3.2 ).
```
  FIX: ```
6.1. Quivers. In this section, we summarize the main definitions of quiver theory. For a more detailed introduction we refer to [39]. A quiver, \( Q \), consists of a set of nodes, \( Q_0 \), a set of arrows, \( Q_1 \), and two maps \( s, e : Q_1 \to Q_0 \), such that \( s \) and \( e \) define the source node and the target node of each arrow, respectively. We assume that \( Q \) is a finite quiver, which means that the sets \( Q_0 \) and \( Q_1 \) are finite. Given \( a, b \in Q_0 \), a path with source \( a \) and target \( b \) is a sequence of arrows \( \alpha_1 \dots \alpha_n \) such that \( s(\alpha_1) = a \), \( e(\alpha_n) = b \) and \( e(\alpha_i) = s(\alpha_{i+1}) \) for \( i \in [1, n-1]_\mathbb{Z} \). Note that the convention for paths in quivers is different from paths in directed graphs: while the latter are defined on vertices, the former are defined on edges (see Section 3.2).
```
- RAW: ```
The path algebra of Q , denoted kQ , is a k -algebra whose underlying vector space has the set of all paths in Q as a basis and whose product is
```
  FIX: ```
The path algebra of \( Q \), denoted \( kQ \), is a \( k \)-algebra whose underlying vector space has the set of all paths in \( Q \) as a basis and whose product is
```
- RAW: ```
if e ( α n ) = s ( β 1 ) or 0 otherwise. In order for kQ to be well defined, we need to introduce trivial paths. A trivial path ε a for the vertex a ∈ Q 0 is defined as a path of length 0 such that s ( ε a ) = e ( ε a ) = a . Note that trivial paths are not elements of Q 1 but they are elements of kQ . If e ( α ) = s ( β ) = a , we define α · ε a = α and ε a · β = β .
```
  FIX: ```
if \( e(\alpha_n) = s(\beta_1) \) or \( 0 \) otherwise. In order for \( kQ \) to be well defined, we need to introduce trivial paths. A trivial path \( \varepsilon_a \) for the vertex \( a \in Q_0 \) is defined as a path of length \( 0 \) such that \( s(\varepsilon_a) = e(\varepsilon_a) = a \). Note that trivial paths are not elements of \( Q_1 \) but they are elements of \( kQ \). If \( e(\alpha) = s(\beta) = a \), we define \( \alpha \cdot \varepsilon_a = \alpha \) and \( \varepsilon_a \cdot \beta = \beta \).
```
- RAW: ```
The product of basis elements is extended to any element of kQ by distributivity. We denote the ideal generated by all arrows in Q 1 by the arrow ideal R . It can be decomposed as the following sum of k -vector spaces
```
  FIX: ```
The product of basis elements is extended to any element of \( kQ \) by distributivity. We denote the ideal generated by all arrows in \( Q_1 \) by the arrow ideal \( R \). It can be decomposed as the following sum of \( k \)-vector spaces
```
- RAW: ```
where V n is the vector subspace of kQ generated by (the sum) of paths of length n . In particular, there are no paths of zero length in R . Given an ideal I ⊂ kQ , ( Q,I ) is said to be a bound quiver if there exists m with R m ⊆ I ⊆ R 2 . In other words, the ideal I contains all paths which are long enough.
```
  FIX: ```
where \( V_n \) is the vector subspace of \( kQ \) generated by (the sum) of paths of length \( n \). In particular, there are no paths of zero length in \( R \). Given an ideal \( I \subset kQ \), \( (Q, I) \) is said to be a bound quiver if there exists \( m \) with \( R^m \subseteq I \subseteq R^2 \). In other words, the ideal \( I \) contains all paths which are long enough.
```
- RAW: ```
Lastly, a representation M of a quiver associates to each a ∈ Q 0 a k -vector space, M ( a ), and to every arrow α from q to r a linear map M ( α ): M ( q ) → M ( r ). The evaluation of M on the path u = α 1 . . . α n is given by the composition M ( u ) = M ( α n ) ◦ . . . ◦ M ( α 1 ). The concept of evaluation extends to any element of kQ by linearity. Given a bound quiver ( Q,I ), a representation M is bound by I if for any u ∈ I , M ( u ) = 0. We also define the direct sum of two representations M 1 , M 2 , as M 1 ⊕ M 2 : Q → Vect k , where ( M 1 ⊕ M 2 )( a ) = M 1 ( a ) ⊕ M 2 ( a ) and ( M 1 ⊕ M 2 )( α ) = M 1 ( α ) ⊕ M 2 ( α ). We say a representation M is indecomposable if, whenever M ∼ = M 1 ⊕ M 2 , we have that M 1 = 0 or M 2 = 0.
```
  FIX: ```
Lastly, a representation \( M \) of a quiver associates to each \( a \in Q_0 \) a \( k \)-vector space, \( M(a) \), and to every arrow \( \alpha \) from \( q \) to \( r \) a linear map \( M(\alpha) : M(q) \to M(r) \). The evaluation of \( M \) on the path \( u = \alpha_1 \dots \alpha_n \) is given by the composition \( M(u) = M(\alpha_n) \circ \dots \circ M(\alpha_1) \). The concept of evaluation extends to any element of \( kQ \) by linearity. Given a bound quiver \( (Q, I) \), a representation \( M \) is bound by \( I \) if for any \( u \in I \), \( M(u) = 0 \). We also define the direct sum of two representations \( M_1 \), \( M_2 \), as \( M_1 \oplus M_2 : Q \to \mathbf{Vect}_k \), where \( (M_1 \oplus M_2)(a) = M_1(a) \oplus M_2(a) \) and \( (M_1 \oplus M_2)(\alpha) = M_1(\alpha) \oplus M_2(\alpha) \). We say a representation \( M \) is indecomposable if, whenever \( M \cong M_1 \oplus M_2 \), we have that \( M_1 = 0 \) or \( M_2 = 0 \).
```
