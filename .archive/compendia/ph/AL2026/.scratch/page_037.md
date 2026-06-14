[Page 37]

Notation 3.38. Let \( M \in \text{mod} A \). We set the \( 0 \)-th critical set of intervals of \( M \) to be

$$
\[
\[
\[
c r t _ { 0 } ( M ) \coloneqq \{ I \in \mathbb { I } \ | \ s c ( I ) \subseteq \sup p ( \text {top} \, M ) , \, \text {sk} ( I ) \subseteq \sup p ( \text {soc} \, M ) \} .
\]
\]
\]
$$

The following is immediate from ( 3.43 ).

Lemma 3.39. Let \( M \in \text{mod} A \) and \( I \in \mathbb{I} \). If \( V_I \) is a direct summand of \( M \), then

$$
\[
\[
\[
I \in c r t _ { 0 } ( M ) .
\]
\]
\]
$$

Namely, if \( I \notin \text{crt}_0(M) \), then \( d_M(V_I) = 0 \).

Proof This follows by \( sc(I) = \text{supp}(\text{top} \, V_I) \subseteq \text{supp}(\text{top} \, M) \), and \( sk(I) = \text{supp}(\text{soc} \, V_I) \subseteq \text{supp}(\text{soc} \, M) \). □

Consequently, to determine all interval summands of \( M \), it suffices to consider only the intervals in \( \text{crt}_0(M) \). We will further introduce smaller critical sets of intervals of \( M \) below.

Notation 3.40. For each \( M \in \text{mod} A \), we let

$$
\[
\[
\[
0 \to \Omega ( M ) \xrightarrow { \sigma _ { M } } P _ { 0 } ( M ) \xrightarrow { \varepsilon _ { M } } M \to 0
\]
\]
\]
$$

be an exact sequence with \( \varepsilon_M \) a projective cover, and

$$
\[
\[
\[
P _ { 1 } ( M ) \stackrel { \partial _ { 0 } ^ { M } } { \longrightarrow } P _ { 0 } ( M ) \stackrel { \varepsilon _ { M } } { \longrightarrow } M \to 0
\]
\]
\]
$$

a minimal projective presentation of \( M \) (so that \( P_1(M) = P_0(\Omega(M)) \) and \( \partial_0^M = \sigma_M \varepsilon_{\Omega(M)} \)). More generally, we let \( P_\bullet(M) \coloneqq (P_i(M), \partial_i^M : P_{i+1}(M) \to P_i(M))_{i \ge 0} \) be a minimal projective resolution of \( M \).

Dually, if \( Q^0(M) = \bigoplus_{j \in [m']} Q(s_j)_{x'_j} \) with \( x'_1, \dots, x'_{m'} \in P \) and \( s_j \ge 1 \) for all \( j \in [m'] \), then

$$
\[
\[
\[
0 \to M \xrightarrow { \mu _ { M } } Q ^ { 0 } ( M ) \xrightarrow { d _ { M } ^ { 0 } } Q ^ { 1 } ( M )
\]
\]
\]
$$

be a minimal injective copresentation of \( M \), and \( Q^\bullet(M) \coloneqq (Q^i(M), d_M^i : Q^i(M) \to Q^{i+1}(M))_{i \ge 0} \) a minimal injective coresolution of \( M \).

The following gives a relation between \( \text{top} \, M \) (resp. \( \text{soc} \, M \)) and the minimal projective presentation (resp. minimal injective copresentation) of \( M \).

Remark 3.41. Let \( M \in \text{mod} A \). If \( P_0(M) = \bigoplus_{i \in [m]} P(r_i)_{x_i} \) with \( x_1, \dots, x_m \in P \) and \( r_i \ge 1 \) for all \( i \in [m] \), then since \( \text{top} \, M \cong \text{top} \, P_0(M) \), we have

$$
\[
\[
\[
\sup p { ( \text {top} \, M ) } = \{ x _ { 1 } , \dots , x _ { m } \} .
\]
\]
\]
$$
