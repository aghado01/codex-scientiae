[Page 25]

# 3.1.2 The case where \( V_I \) is non-injective

Throughout this subsection, we assume that \( V_I \) is non-injective, and let the sequence

$$
\[
\[
\[
0 \to V _ { I } \to E \to \tau ^ { - 1 } V _ { I } \to 0
\]
\]
\]
$$

be an almost split sequence starting from \( V_I \). We identify \( k[P^{op}] \) with \( A^{op} = k[P]^{op} \) in an obvious way. To apply Theorem 3.3 and Lemma 2.10, we need to compute projective presentations of \( \tau^{-1} V_I \) and \( E \). We first do it for \( \tau^{-1} V_I \).

We denote by \( (-)^t \) the contravariant functors

$$
\[
\begin{aligned}
\mathrm{Hom}_A(-, A(\cdot, ?)) &\colon \mod A \to \mod A^{op}, \\
M &\mapsto \mathrm{Hom}_A(M, A(\cdot, ?)), \text{ and} \\
\mathrm{Hom}_{A^{op}}(-, A^{op}(\cdot, ?)) &\colon \mod A^{op} \to \mod A, \\
M &\mapsto \mathrm{Hom}_{A^{op}}(M, A^{op}(\cdot, ?)),
\end{aligned}
\]
$$

which are dualities between \( \mathrm{prj} A \) and \( \mathrm{prj} A^{op} \), where \( \mathrm{prj} B \) denotes the full subcategory of \( \mod B \) consisting of projective modules for any finite \( k \)-category \( B \). We use the notation \( P'_x \) provided in Notation 2.7. By the Yoneda lemma, we have

$$
\[
P _ { x } ^ { t } = \mathrm{Hom} _ { A } ( A ( x , ? ) , A ( \cdot , ? ) ) \cong A ( \cdot , x ) = A ^ { \mathrm{op} } ( x , \cdot ) = P _ { x } ^ { \prime }
\]
$$

for all \( x \in P \). By this natural isomorphism, we usually identify \( P'_x \) with \( P^t_x \), and \( P'_{x,y} \) with \( (P_{y,x})^t \) for all \( x,y \in P \). For this reason, we write \( P^t \) instead of \( P' \) in the sequel if there is no confusion.

Remember that \( \tau^{-1} M = \mathrm{Tr} D M \) for all \( M \in \mod A \), where for each \( N \in \mod A \), the transpose \( \mathrm{Tr} N \) of \( N \) is defined as the cokernel of some \( f^t \) with \( P_1 \xrightarrow{f} P_0 \to N \to 0 \) a minimal projective presentation of \( N \). By applying Proposition 3.18, we first obtain a projective presentation of \( D V_I \) as follows. For this sake, we note that there exists an isomorphism \( D V_I \cong V_{I^{op}} \) in \( \mod A^{op} \), and by Lemma 3.7, \( I = W \setminus W' \), where \( W := \downarrow I \) and \( W' := \Downarrow I = \downarrow I \setminus I \) are two down-sets of \( P \). By the duality, \( W^{op} = (\downarrow_P I)^{op} = \uparrow_{P^{op}} I^{op} \) and \( (W')^{op} = \uparrow_{P^{op}} I^{op} \setminus I^{op} \). Hence \( D V_I \cong V_{I^{op}} \cong V_{W^{op}} / V_{(W')^{op}} \), where

$$
\[
\begin{aligned}
& \mathrm{sc}(W^{op}) = \mathrm{sk}(W) = \mathrm{sk}(I), \quad \mathrm{sc}_1(W^{op}) = \mathrm{sk}_1(W) = \mathrm{sk}_1(I), \text{ and} \\
& \mathrm{sc}((W')^{op}) = \mathrm{sk}(W') = \mathrm{sk}(\downarrow I).
\end{aligned}
\]
$$

# Notation 3.21. Let \( I \) be an interval of \( P \).

- (1) Note that \( \mathrm{sk}(I) = \mathrm{sk}(\downarrow I) \), and hence also \( \mathrm{sk}_1(I) = \mathrm{sk}_1(\downarrow I) \).
- (2) Note that for each \( b' \in \mathrm{sk}(\Downarrow I) \), we have \( \mathrm{sk}(I) \cap \uparrow b' \neq \emptyset \) because \( b' \in \downarrow I \). Fixing one element \( b \in \mathrm{sk}(I) \cap \uparrow b' \) for each \( b' \in \mathrm{sk}(\Downarrow I) \) yields a choice map \( d \colon \mathrm{sk}(\Downarrow I) \to \mathrm{sk}(I) = \mathrm{sk}(\downarrow I) \) that sends \( b' \) to \( b \).


