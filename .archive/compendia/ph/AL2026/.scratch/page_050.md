[Page 50]

$$
= s + \operatorname{rank} \begin{bmatrix} L(g_1^\prime) & 0 \\ L(g_3^\prime) & L(g_2^\prime) \end{bmatrix} - \operatorname{rank} \begin{bmatrix} L(g_1^\prime) & 0 \\ 0 & L(g_2^\prime) \end{bmatrix} \geq s.
$$

Hence we have \( r = s \), and the proof is completed.


# 5 Interval multiplicities by presentations

For each \( M \in \operatorname{mod} A \) and an each interval \( I \) of \( P \), we compute, in this section, the multiplicity \( d_M(V_I) \) in terms of a projective presentation of \( M \) rather than the structure linear maps of \( M \).

In what follows, for each event \( E \) such as \( (x \leq y) \) for \( x, y \in P \), we denote by \( \delta_E \) the \( k \)-valued indicator function of \( E \): it takes value \( 1 \in k \) if \( E \) is true and \( 0 \in k \) otherwise. To shorten the notation, we write \( x \leq y, z \) for \( x \leq y \) and \( x \leq z \).

# 5.1 The formula by projective presentations

Theorem 5.1. Let \( M \in \operatorname{mod} A \) and \( I \) an interval of \( P \). Then there exists a projective presentation

$$
P(y) \xrightarrow{P(\alpha)} P(x) \xrightarrow{\varepsilon} M \to 0
$$

of \( M \) for some morphism \( \alpha : x \to y \) in \( A \), where we set \( x := (x_i)_{i \in [m]} \), \( y := (y_j)_{j \in [n]} \). Case 1: \( V_I \) is non-projective. In this case, let

$$
0 \to \tau V_I \xrightarrow{\mu_I} E_I \xrightarrow{\varepsilon_I} V_I \to 0
$$

be an almost split sequence ending in \( V_I \). Then we have the following formula:

$$
d_M(V_I) = \operatorname{rank} E_I(\alpha) - \operatorname{rank} V_I(\alpha) - \operatorname{rank} (\tau V_I)(\alpha).
$$

Case 2: \( V_I \) is projective. In this case, \( I = \uparrow a \) with \( a = \min I \). We may set \( \alpha = [\alpha_{ji}]_{(j,i) \in [n] \times [m]} \), where \( \alpha_{ji} = a_{ji} p_{y_j, x_i} \) for some \( a_{ji} \in k \) and \( \alpha_{ji} = a_{ji} = 0 \) unless \( x_i \leq y_j \) for all \( (j,i) \in [n] \times [m] \). We set \( n_{M,I} := \# \{ i \in [m] \mid x_i = a \} \). Then we have the following formula:

$$
d_M(V_I) = \operatorname{rank} [\delta_{(a < x_i, y_j)} a_{ji}]_{(j,i) \in [n] \times [m]} - \operatorname{rank} [\delta_{(a \leq x_i, y_j)} a_{ji}]_{(j,i) \in [n] \times [m]} + n_{M,I}.
$$

Note that the right hand side is directly computed by information of \( \alpha \).

Proof By Lemma 2.10 we can compute \( d_M(V_I) \) as follows:
