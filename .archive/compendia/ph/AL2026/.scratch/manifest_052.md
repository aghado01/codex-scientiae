# Manifest: Page 052

## REPAIR_MATH
- RAW: ```
\begin{bmatrix} p _ { 2 ^ { \prime } , 1 ^ { \prime } } & - p _ { 2 ^ { \prime } , 2 } & 0 \\ p _ { 4 ^ { \prime } , 1 ^ { \prime } } & 0 & 0 \\ 0 & 0 & p _ { 4 ^ { \prime } , 3 ^ { \prime } } \end{bmatrix} \colon ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) \to ( 2 ^ { \prime } , 4 ^ { \prime } , 4 ^ { \prime } ) .
```
  FIX: ```
$$
\begin{bmatrix} p _ { 2 ^ { \prime } , 1 ^ { \prime } } & - p _ { 2 ^ { \prime } , 2 } & 0 \\ p _ { 4 ^ { \prime } , 1 ^ { \prime } } & 0 & 0 \\ 0 & 0 & p _ { 4 ^ { \prime } , 3 ^ { \prime } } \end{bmatrix} \colon ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) \to ( 2 ^ { \prime } , 4 ^ { \prime } , 4 ^ { \prime } ) .
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) & = \text {rank} \, E _ { 1 } ( \alpha ) + \text {rank} \, E _ { 2 } ( \alpha ) - \text {rank} \, V _ { I } ( \alpha ) - \text {rank} \, ( \tau V _ { I } ) ( \alpha ) \\ & = \text {rank} \, \left [ \begin{smallmatrix} 1 & 0 & 0 \\ 0 & - 1 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] + \text {rank} \, \left [ \begin{smallmatrix} 1 & - 1 & 0 \\ 1 & 0 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] - \text {rank} \, \left [ \begin{smallmatrix} 1 & - 1 & 0 \\ 9 & 0 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] - \text {rank} \, \left [ \begin{smallmatrix} 1 & 0 & 0 \\ 0 & - 1 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] \\ & = 2 + 3 - 1 - 3 = 1 .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) & = \text {rank} \, E _ { 1 } ( \alpha ) + \text {rank} \, E _ { 2 } ( \alpha ) - \text {rank} \, V _ { I } ( \alpha ) - \text {rank} \, ( \tau V _ { I } ) ( \alpha ) \\ & = \text {rank} \, \left [ \begin{smallmatrix} 1 & 0 & 0 \\ 0 & - 1 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] + \text {rank} \, \left [ \begin{smallmatrix} 1 & - 1 & 0 \\ 1 & 0 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] - \text {rank} \, \left [ \begin{smallmatrix} 1 & - 1 & 0 \\ 9 & 0 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] - \text {rank} \, \left [ \begin{smallmatrix} 1 & 0 & 0 \\ 0 & - 1 & 0 \\ 0 & 0 & 0 \end{smallmatrix} \right ] \\ & = 2 + 3 - 1 - 3 = 1 .
$$
```
- RAW: ```
d _ { M } ( V _ { J } ) = \text {rank} \left [ \begin{smallmatrix} 0 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 1 \end{smallmatrix} \right ] - \text {rank} \left [ \begin{smallmatrix} 0 & - 1 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 1 \end{smallmatrix} \right ] + 1 = 0 .
```
  FIX: ```
$$
d _ { M } ( V _ { J } ) = \text {rank} \left [ \begin{smallmatrix} 0 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 1 \end{smallmatrix} \right ] - \text {rank} \left [ \begin{smallmatrix} 0 & - 1 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 1 \end{smallmatrix} \right ] + 1 = 0 .
$$
```
- RAW: ```
P ( v ) \stackrel { P ( \beta ) } { \longrightarrow } P ( u ) \stackrel { \pi } { \rightarrow } C \rightarrow 0
```
  FIX: ```
$$
P ( v ) \stackrel { P ( \beta ) } { \longrightarrow } P ( u ) \stackrel { \pi } { \rightarrow } C \rightarrow 0
$$
```
- RAW: ```
\text {rank} \, C ( \alpha ) = \dim C ( y ) - \dim P ( u ) ( y ) + \text {rank} [ P ( \beta ) ( y ) , P ( u ) ( \alpha ) ] .
```
  FIX: ```
$$
\text {rank} \, C ( \alpha ) = \dim C ( y ) - \dim P ( u ) ( y ) + \text {rank} [ P ( \beta ) ( y ) , P ( u ) ( \alpha ) ] .
$$
```



## REPAIR_MATH
- RAW: ```
Define an M ∈ mod A by M : = V I ⊕ V { 3 ′ } . Then a projective presentation of M is given by P ( y ) P ( α ) −−−→ P ( x ) → M → 0 , where the morphism α : x → y in A is given by
```
  FIX: ```
Define an \( M \in \operatorname{mod} A \) by \( M := V_I \oplus V_{\{3^\prime\}} \) . Then a projective presentation of \( M \) is given by \( P(y) \stackrel{P(\alpha)}{\longrightarrow} P(x) \to M \to 0 \) , where the morphism \( \alpha \colon x \to y \) in \( A \) is given by
```
- RAW: ```
Take J ∈ I as J : = ↑ 2 . Then V J is projective, and d M ( V J ) is computed directly from α above by Theorem 5.1 , formula ( 5.64 ). In this case, n M,J = 1 , and we have
```
  FIX: ```
Take \( J \in I \) as \( J := {\uparrow} 2 \) . Then \( V_J \) is projective, and \( d_M(V_J) \) is computed directly from \( \alpha \) above by Theorem 5.1 , formula ( 5.64 ). In this case, \( n_{M,J} = 1 \) , and we have
```
- RAW: ```
In the theorem above, the rank of C ( α ) for an A -module C is easily computed for C = V I because its structure linear maps are known. However, for C = E I or τV I those are not known at first. In that case, it would be convenient if rank C ( α ) can be computed by a projective presentation (or an injective copresentation) of C because it can be obtained from the results obtained before. In this connection, we now give a formula of rank C ( α ) using a projective presentation (or an injective copresentation) of C for any C ∈ mod A and morphism α in A .
```
  FIX: ```
In the theorem above, the rank of \( C ( \alpha ) \) for an \( A \)-module \( C \) is easily computed for \( C = V_I \) because its structure linear maps are known. However, for \( C = E_I \) or \( \tau V_I \) those are not known at first. In that case, it would be convenient if \( \operatorname{rank} C ( \alpha ) \) can be computed by a projective presentation (or an injective copresentation) of \( C \) because it can be obtained from the results obtained before. In this connection, we now give a formula of \( \operatorname{rank} C ( \alpha ) \) using a projective presentation (or an injective copresentation) of \( C \) for any \( C \in \operatorname{mod} A \) and morphism \( \alpha \) in \( A \) .
```
- RAW: ```
Proposition 5.3. Let α : x → y be a morphism in A and C ∈ mod A . Assume that C has a projective presentation
```
  FIX: ```
Proposition 5.3. Let \( \alpha \colon x \to y \) be a morphism in \( A \) and \( C \in \operatorname{mod} A \) . Assume that \( C \) has a projective presentation
```
- RAW: ```
for some morphism β : u → v in A . Then we have (see ( 2.6 ) for notations)
```
  FIX: ```
for some morphism \( \beta \colon u \to v \) in \( A \) . Then we have (see ( 2.6 ) for notations)
```
- RAW: ```
Proof We apply the salamander lemma in the proof, for which we refer the reader to Bergman ( 2012 ). In particular, we use the notations introduced by Geraschenko ( 2007 ). In a double complex with a term X , we denote by = X, X ∥ , □ X and X □ , the horizontal homology, the vertical homology, the receptor, and the donor at X , respectively (see Appendix for details). By assumption, we have the following double complex (at first ignore dashed edges, which
```
  FIX: ```
Proof We apply the salamander lemma in the proof, for which we refer the reader to Bergman ( 2012 ). In particular, we use the notations introduced by Geraschenko ( 2007 ). In a double complex with a term \( X \) , we denote by \( =X \), \( X^\parallel \), \( \square X \) and \( X^\square \) , the horizontal homology, the vertical homology, the receptor, and the donor at \( X \) , respectively (see Appendix for details). By assumption, we have the following double complex (at first ignore dashed edges, which
```

