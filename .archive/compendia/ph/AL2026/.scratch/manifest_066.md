# Manifest: Page 066

## REPAIR_MATH
- RAW: ```
Remark 6.2. In Example 6.1 above, we see that d R ( M ) ( V I ′ ) = 0 as follows. Assume that it is nonzero. Then M ′ : = R ( M ) has a direct summand X such that there is an isomorphism α : V I ′ → X , say M ′ = X ⊕ Y . For each vertex ( i,j ) of Z , let { v ij } be the standard basis of V I ′ ( i,j ) , and set a ij : = α ( v ij ) , and then { a ij } becomes a basis of X ( i,j ) . In Fig. 5 , we denote the 1-cycle { a,b } + { b,c } + { c,a } by ( abc ) for short. Then M ′ (1 , 2) and M ′ (2 , 1) have bases { (124) , (234) } and { (134) , (234) } , respectively. Then we can write X (1 , 2) = k a 12 and X (2 , 1) = k a 21 with a 12 = s (124) + t (234) , a 21 = u (134) + v (234) for some s,t,u,v ∈ k . Since X ( p 22 , 12 )( a 12 ) = a 22 = X ( p 22 , 21 )( a 21 ) by construction, we have s (124) + t (234) = u (134) + v (234) in M ′ (2 , 2) that has a basis { (124) , (134) , (234) } , which shows that t = v ̸ = 0 and s = u = 0 . Hence a 12 = t (234) and a 21 = t (234) , and we have X (5 , 1) = k (234) . Since X (1 , 1) = 0 , we have (234) ∈ M ′ (1 , 1) = Y (1 , 1) , and hence (234) = Y ( p 51 , 11 )(234) ∈ Y (5 , 1) . Therefore, X (5 , 1) ∩ Y (5 , 1) ∋ (234) ̸ = 0 , a contradiction. In fact, the decomposition of R ( M ) is given by
```
  FIX: ```
Remark 6.2. In Example 6.1 above, we see that \( d_{R(M)}(V_{I'}) = 0 \) as follows. Assume that it is nonzero. Then \( M' \coloneqq R(M) \) has a direct summand \( X \) such that there is an isomorphism \( \alpha \colon V_{I'} \to X \), say \( M' = X \oplus Y \). For each vertex \( (i,j) \) of \( Z \), let \( \{v_{ij}\} \) be the standard basis of \( V_{I'}(i,j) \), and set \( a_{ij} \coloneqq \alpha(v_{ij}) \), and then \( \{a_{ij}\} \) becomes a basis of \( X(i,j) \). In Fig. 5, we denote the 1-cycle \( \{a,b\} + \{b,c\} + \{c,a\} \) by \( (abc) \) for short. Then \( M'(1,2) \) and \( M'(2,1) \) have bases \( \{(124), (234)\} \) and \( \{(134), (234)\} \), respectively. Then we can write \( X(1,2) = k a_{12} \) and \( X(2,1) = k a_{21} \) with \( a_{12} = s(124) + t(234) \), \( a_{21} = u(134) + v(234) \) for some \( s,t,u,v \in k \). Since \( X(p_{22,12})(a_{12}) = a_{22} = X(p_{22,21})(a_{21}) \) by construction, we have \( s(124) + t(234) = u(134) + v(234) \) in \( M'(2,2) \) that has a basis \( \{(124), (134), (234)\} \), which shows that \( t = v \neq 0 \) and \( s = u = 0 \). Hence \( a_{12} = t(234) \) and \( a_{21} = t(234) \), and we have \( X(5,1) = k(234) \). Since \( X(1,1) = 0 \), we have \( (234) \in M'(1,1) = Y(1,1) \), and hence \( (234) = Y(p_{51,11})(234) \in Y(5,1) \). Therefore, \( X(5,1) \cap Y(5,1) \ni (234) \neq 0 \), a contradiction. In fact, the decomposition of \( R(M) \) is given by
```
- RAW: ```
However, we remark that the interval rank of I under the total compression system defined in Asashiba et al. ( 2024 ), or equivalently, the generalized rank of I defined in Kim and Mémoli ( 2021 ) is at least 1 (actually equal to 1) because the restriction R I ( M ) of M to I has a direct summand X isomorphic to V I with spaces X ( i ) = k (234) for all i ∈ I . In summary, the “generalized” rank of interval I ⊆ P only need information inside of I , while its multiplicity need extra information outside of I , causing their distinctions.
```
  FIX: ```
However, we remark that the interval rank of \( I \) under the total compression system defined in Asashiba et al. (2024), or equivalently, the generalized rank of \( I \) defined in Kim and Mémoli (2021) is at least 1 (actually equal to 1) because the restriction \( R_I(M) \) of \( M \) to \( I \) has a direct summand \( X \) isomorphic to \( V_I \) with spaces \( X(i) = k(234) \) for all \( i \in I \). In summary, the “generalized” rank of interval \( I \subseteq P \) only need information inside of \( I \), while its multiplicity need extra information outside of \( I \), causing their distinctions.
```
- RAW: ```
Example 6.3. Let P = G 6 , 2 and consider the following interval of P :
```
  FIX: ```
Example 6.3. Let \( P = G_{6,2} \) and consider the following interval of \( P \):
```

## REPAIR_PROSE
- RAW: ```
.

We compute the interval multiplicity of V I . For brevity we set a 1 : = (3 , 1) , a 2 : = (2 , 2) , b 1 : = (5 , 1) , b 2 : = (4 , 2) by adopting Notation 3.28 . Then a 12 = a 1 ∨ a 2 = (3 , 2) , b 12 = b 1 ∧ b 2 = (4 , 1) , sc( ⇑ I ) = { a ′ 1 ,a ′ 2 } = { (6 , 1) , (5 , 2) } , and sk( ⇓ I ) = { b ′ 1 ,b ′ 2 } = { (2 , 1) , (1 , 2) } .
```
  FIX: ```
We compute the interval multiplicity of \( V_I \). For brevity we set \( a_1 \coloneqq (3, 1) \), \( a_2 \coloneqq (2, 2) \), \( b_1 \coloneqq (5, 1) \), \( b_2 \coloneqq (4, 2) \) by adopting Notation 3.28. Then \( a_{12} = a_1 \vee a_2 = (3, 2) \), \( b_{12} = b_1 \wedge b_2 = (4, 1) \), \( \operatorname{sc}(\Uparrow I) = \{ a'_1, a'_2 \} = \{ (6, 1), (5, 2) \} \), and \( \operatorname{sk}(\Downarrow I) = \{ b'_1, b'_2 \} = \{ (2, 1), (1, 2) \} \).
```
- RAW: ```
By Theorem 4.7 , there exists a multiplicity matrix g = g 1 0 g 3 g 2 for I . Here g may taken as the form:

be taken as the form:
```
  FIX: ```
By Theorem 4.7, there exists a multiplicity matrix \( g = \left[ \begin{smallmatrix} g_1 & 0 \\ g_3 & g_2 \end{smallmatrix} \right] \) for \( I \). Here \( g \) may be taken as the form:
```
