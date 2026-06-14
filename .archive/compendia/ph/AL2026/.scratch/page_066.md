[Page 66]

Remark 6.2. In Example 6.1 above, we see that \( d_{R(M)}(V_{I'}) = 0 \) as follows. Assume that it is nonzero. Then \( M' \coloneqq R(M) \) has a direct summand \( X \) such that there is an isomorphism \( \alpha \colon V_{I'} \to X \), say \( M' = X \oplus Y \). For each vertex \( (i,j) \) of \( Z \), let \( \{v_{ij}\} \) be the standard basis of \( V_{I'}(i,j) \), and set \( a_{ij} \coloneqq \alpha(v_{ij}) \), and then \( \{a_{ij}\} \) becomes a basis of \( X(i,j) \). In Fig. 5, we denote the 1-cycle \( \{a,b\} + \{b,c\} + \{c,a\} \) by \( (abc) \) for short. Then \( M'(1,2) \) and \( M'(2,1) \) have bases \( \{(124), (234)\} \) and \( \{(134), (234)\} \), respectively. Then we can write \( X(1,2) = k a_{12} \) and \( X(2,1) = k a_{21} \) with \( a_{12} = s(124) + t(234) \), \( a_{21} = u(134) + v(234) \) for some \( s,t,u,v \in k \). Since \( X(p_{22,12})(a_{12}) = a_{22} = X(p_{22,21})(a_{21}) \) by construction, we have \( s(124) + t(234) = u(134) + v(234) \) in \( M'(2,2) \) that has a basis \( \{(124), (134), (234)\} \), which shows that \( t = v \neq 0 \) and \( s = u = 0 \). Hence \( a_{12} = t(234) \) and \( a_{21} = t(234) \), and we have \( X(5,1) = k(234) \). Since \( X(1,1) = 0 \), we have \( (234) \in M'(1,1) = Y(1,1) \), and hence \( (234) = Y(p_{51,11})(234) \in Y(5,1) \). Therefore, \( X(5,1) \cap Y(5,1) \ni (234) \neq 0 \), a contradiction. In fact, the decomposition of \( R(M) \) is given by



$$
R ( M ) = [ \begin{matrix} 1 1 0 1 \\ 0 0 0 0 \end{matrix} ] \oplus [ \begin{matrix} 0 0 1 0 \\ 0 0 1 1 \end{matrix} ] \oplus [ \begin{matrix} 0 0 0 1 \\ 0 0 0 0 \end{matrix} ] \oplus [ \begin{matrix} 0 1 1 0 \\ 0 1 1 1 \end{matrix} ] \oplus [ \begin{matrix} 1 1 1 0 \\ 1 1 1 1 \end{matrix} ] \, ,
$$

where all summands are interval modules presented by their dimension vectors.

However, we remark that the interval rank of \( I \) under the total compression system defined in Asashiba et al. (2024), or equivalently, the generalized rank of \( I \) defined in Kim and Mémoli (2021) is at least 1 (actually equal to 1) because the restriction \( R_I(M) \) of \( M \) to \( I \) has a direct summand \( X \) isomorphic to \( V_I \) with spaces \( X(i) = k(234) \) for all \( i \in I \). In summary, the “generalized” rank of interval \( I \subseteq P \) only need information inside of \( I \), while its multiplicity need extra information outside of \( I \), causing their distinctions.

Example 6.3. Let \( P = G_{6,2} \) and consider the following interval of \( P \):

$$
I \coloneqq \begin{array} { c c c } ( 2 , 2 ) \longrightarrow ( 3 , 2 ) & \longrightarrow ( 4 , 2 ) \\ & \uparrow & \uparrow \\ ( 3 , 1 ) \longrightarrow ( 4 , 1 ) & \longrightarrow ( 5 , 1 ) \end{array} .
$$

We compute the interval multiplicity of \( V_I \). For brevity we set \( a_1 \coloneqq (3, 1) \), \( a_2 \coloneqq (2, 2) \), \( b_1 \coloneqq (5, 1) \), \( b_2 \coloneqq (4, 2) \) by adopting Notation 3.28. Then \( a_{12} = a_1 \vee a_2 = (3, 2) \), \( b_{12} = b_1 \wedge b_2 = (4, 1) \), \( \operatorname{sc}(\Uparrow I) = \{ a'_1, a'_2 \} = \{ (6, 1), (5, 2) \} \), and \( \operatorname{sk}(\Downarrow I) = \{ b'_1, b'_2 \} = \{ (2, 1), (1, 2) \} \).

By Theorem 4.7, there exists a multiplicity matrix \( g = \left[ \begin{smallmatrix} g_1 & 0 \\ g_3 & g_2 \end{smallmatrix} \right] \) for \( I \). Here \( g \) may be taken as the form:

$$
g \coloneqq \left [ \frac { g _ { 1 } } { g _ { 3 } } \right ] _ { g _ { 2 } } = \left [ \frac { p _ { a _ { 1 2 } , a _ { 1 } } - p _ { a _ { 1 2 } , a _ { 2 } } } { p _ { x _ { 1 } } } \right ] _ { 0 } \, \left | \begin{array} { c c c c } 0 & 0 & 0 & 0 \\ 0 & 0 & 0 & 0 \\ 0 & 0 & 0 & 0 \\ 0 & 0 & p _ { b _ { 1 } , y _ { 1 } } & 0 & p _ { b _ { 1 } , b _ { 1 2 } } \\ 0 & 0 & 0 & p _ { b _ { 2 } , y _ { 2 } } & - p _ { b _ { 2 } , b _ { 1 2 } } \end{array} \right ] \, .
$$
