[Page 40]

\( M \) and \( M^\prime \) with \( P_0^M = P_0(M) \):

$$
and M ^ { \prime } \text { with } P _ { 0 } ^ { M } = P _ { 0 } ( M ) \colon \\ 0 \longrightarrow P _ { 1 } ^ { M } \xrightarrow { \left [ \frac { 1 } { 0 } \right ] } P _ { 1 } ^ { M } \oplus P _ { 0 } ( M ^ { \prime } ) \xrightarrow { [ 0 , 1 ] } P _ { 0 } ( M ^ { \prime } ) \longrightarrow 0 \\ \gamma _ { 1 } \xlongmapsto \begin{smallmatrix} \varepsilon _ { 1 } ^ { M } & \varepsilon _ { 1 } ^ { \eta _ { 1 } } & \varepsilon _ { 1 } ^ { \eta _ { 1 } } \xlongmapsto \begin{smallmatrix} \eta _ { 1 } & \eta _ { 1 } \end{smallmatrix} \end{smallmatrix} \\ 0 \longrightarrow \Omega ( M ) \xlongmapsto P _ { 0 } ( M ) \xlongmapsto \begin{smallmatrix} \sigma _ { M } & \sigma _ { 1 } & \xlongmapsto \begin{smallmatrix} \varepsilon _ { 1 } & \eta _ { 1 } & \varepsilon _ { 1 } ^ { \eta _ { 1 } } \end{smallmatrix} & \xlongmapsto 0 \\ \xlongmapsto \begin{smallmatrix} \coprod & \coprod & \xlongmapsto \begin{smallmatrix} \varepsilon _ { 0 } & \varepsilon _ { 1 } \\ \end{smallmatrix} & \xlongmapsto \begin{smallmatrix} \pi & & \\ \end{smallmatrix} \\ 0 \longrightarrow \text {Coker} \varepsilon _ { 1 } \longrightarrow V _ { 1 } \longrightarrow 0 \\ \xlongmapsto \begin{smallmatrix} \downarrow & & \downarrow \\ & & 0 \\ 0 & & 0 \end{smallmatrix} \\ \text {are we have } \varepsilon _ { 1 } = [ \varepsilon _ { 1 } ^ { M } , \eta _ { 1 } ] , \, P _ { 0 } ( M ) = P _ { 0 } ( V _ { 1 } ) = P _ { \text {sc} ( I ) } , \, P _ { 1 } ^ { M } = P _ { \text {sc} _ { 1 } ( I ) } , \, \text {and } P _ { 0 } ( M ^ { \prime } ) =
$$

Here we have \( \varepsilon_1 = [\varepsilon_1^M, \eta_{11}] \), \( P_0(M) = P_0(V_I) = P_{\text{sc}(I)} \), \( P_1^M = P_{\text{sc}_1(I)} \), and \( P_0(M^\prime) = P_{\text{sc}(\uparrow I)} \). In particular, we have \( \text{supp}(\text{top} P_0(M^\prime)) = \text{sc}(\uparrow I) \). Since (3.18) is a projective resolution of \( V_I \) with \( \varepsilon_0 \) a projective cover of \( V_I \), we have \( \text{Im} \varepsilon_1 = \Omega(V_I) \), and the morphism \( \varepsilon_1 \) restricts to an epimorphism \( P_1^M \oplus P_0(M^\prime) \to \Omega(V_I) \) that has a projective domain. Therefore, we have

$$
P _ { 1 } ^ { M } \oplus P _ { 0 } ( M ^ { \prime } ) = P ^ { \prime } \oplus P _ { 0 } ( \Omega ( V _ { I } ) )
$$

for some \( P^\prime \subseteq \text{Ker} \varepsilon_1 \). By the Krull–Schmidt theorem, it is enough to show that \( P_0(M^\prime) \) is a direct summand of \( P_0(\Omega(V_I)) \).

Decompose \( P^\prime \) by two parts as follows:

$$
P ^ { \prime } & = P _ { 0 } ^ { \prime } \oplus P _ { 1 } ^ { \prime } , \ P _ { 0 } ^ { \prime } \cong \bigoplus _ { i \in [ m ] } P _ { x _ { i } } , \ P _ { 1 } ^ { \prime } \cong \bigoplus _ { j \in [ n ] } P _ { y _ { j } } , \text { where} \\ & \{ x _ { i } \, | \, i \in [ m ] \} \subseteq \sup ( \text {top} \, P _ { 0 } ( M ^ { \prime } ) ) = \text {sc} ( \uparrow I ) , \text { and}
$$

$$
\{ x _ { i } \, | \, i \in [ m ] \} \subset \sup ( \text {top} \, P _ { 0 } ( M ^ { \prime } ) ) = \text {sc} ( \uparrow I ) , \text { and }
$$

$$
\{ y _ { j } \ | \ j \in [ n ] \} \cap \text {supp} ( \text {top} P _ { 0 } ( M ^ { \prime } ) ) = \varnothing .
$$

Then we can show that

$$
P _ { 0 } ^ { \prime } \subseteq P _ { 1 } ^ { M } .
$$

Indeed, choose an isomorphism \( f \colon \bigoplus_{i \in [m]} P_{x_i} \to P_0^\prime \), and for each \( i \in [m] \), let \( \sigma_i \colon P_{x_i} \to \bigoplus_{i \in [m]} P_{x_i} \) be the canonical monomorphism. Since \( P^\prime \subseteq \text{Ker} \varepsilon_1 \), we have \( \varepsilon_1 f \sigma_i = 0 \). Hence

$$
0 & = \varepsilon _ { M } \varepsilon _ { 1 } f \sigma _ { i } = \varepsilon _ { M } [ \varepsilon _ { 1 } ^ { M } , \eta _ { 1 1 } ] f \sigma _ { i } = [ \varepsilon _ { M } \sigma _ { M } \varepsilon _ { \Omega ( M ) } , \varepsilon _ { M } \eta _ { 1 1 } ] f \sigma _ { i } \\ & = [ 0 , \iota \varepsilon _ { M ^ { \prime } } ] f \sigma _ { i } = \iota \varepsilon _ { M ^ { \prime } } [ 0 , \i1 ] f \sigma _ { i } ,
$$

where \( \varepsilon_{M^\prime} \colon P_0(M^\prime) \to M^\prime \) is a projective cover. Here since \( \iota \) is a monomorphism, we have \( \varepsilon_{M^\prime} [0, 1] f \sigma_i = 0 \), and hence

$$
u _ { i } \coloneqq [ 0 , 1 ] f \sigma _ { i } ( 1 _ { x _ { i } } ) \in I m ( [ 0 , 1 ] f \sigma _ { i } ) \subseteq K e r \varepsilon _ { M ^ { \prime } } \subseteq r a d \, P _ { 0 } ( M ^ { \prime } ) .
$$

If \( u_i \neq 0 \), then (3.51) shows that \( x_i \in \text{supp}(\text{rad} P_0(M^\prime)) = \{ x \in P \mid \exists z \in \text{sc}(\uparrow I), z < x \} \). Thus \( z < x_i \) for some \( z \in \text{sc}(\uparrow I) \). But since \( z \in \text{sc}(\uparrow I) \subseteq {\uparrow I} \), we have \( x_i \notin \text{sc}(\uparrow I) \), a contradiction to (3.48). Hence \( u_i = 0 \). Since \( u_i \) is a generator of \( \text{Im}([0, 1] f \sigma_i) \), we have \( [0, 1] f \sigma_i = 0 \). This holds for all \( i \in [m] \), and thus \( [0, 1] f = 0 \). Therefore, \( P_0^\prime = \text{Im} f \subseteq P_1^M \), and (3.50) holds, as desired.


By taking the intersection with \( P_1^M \) to both hand sides of (3.47), the modularity shows that

$$
P _ { 1 } ^ { M } = P _ { 0 } ^ { \prime } \oplus [ P _ { 1 } ^ { M } \cap ( P _ { 1 } ^ { \prime } \oplus P _ { 0 } ( \Omega ( V _ { I } ) ) ) ] .
$$

 By setting \( P^{\prime\prime} \coloneqq P_1^M \cap (P_1^\prime \oplus P_0(\Omega(V_I))) \), we have \( P_1^M = P_0^\prime \oplus P^{\prime\prime} \), and hence

$$
P _ { 0 } ^ { \prime } \oplus P ^ { \prime \prime } \oplus P _ { 0 } ( M ^ { \prime } ) = P _ { 0 } ^ { \prime } \oplus P _ { 1 } ^ { \prime } \oplus P _ { 0 } ( \Omega ( V _ { I } ) ) .
$$
