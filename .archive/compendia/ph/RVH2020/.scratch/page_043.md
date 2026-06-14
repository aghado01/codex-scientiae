[Page 43]

Let ( X k ,Y k ) k ∈ Z be a stationary hidden Markov model as in section 2.1. Then

$$
\begin{align*}
E | P [ X_{k} \in A | X_{0}, Y_{1}, \dots, Y_{k} ] - P [ X_{k} \in A | Y_{1}, \dots, Y_{k} ] &= \\
E | P [ X_{0} \in A | X_{-k}, Y_{-k+1}, \dots, Y_{0} ] - P [ X_{0} \in A | Y_{-k+1}, \dots, Y_{0} ] &= \quad (\text{Markov property}) \\
E | P [ X_{0} \in A | \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ] - P [ X_{0} \in A | \mathcal{Y}_{-\infty+1}^{0} ] &\xrightarrow{ \, | \, \cdot \, | } \quad (\text{martingale cvg.}) \\
E | P [ X_{0} \in A | \bigcap (\mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0}) ] - P [ X_{0} \in A | \mathcal{Y}_{-\infty}^{0} ] &,
\end{align*}
$$

where we deﬁne here and below the σ -ﬁelds

$$
\mathcal{X}_{m}^{n} := \sigma \{ X_{m}, \dots, X_{n} \}, \quad \mathcal{Y}_{m}^{n} := \sigma \{ Y_{m}, \dots, Y_{n} \}.
$$

Thus the ﬁlter is stable if and only if

$$
P \left[ X_{0} \in \cdot \middle| \bigcap_{k} ( \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ) \right] = P \left[ X_{0} \in \cdot \middle| \mathcal{Y}_{-\infty}^{0} \right].
$$

In particular, validity of the measure-theoretic identity

$$
\bigcap_{k} ( \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ) = \mathcal{Y}_{-\infty}^{0} \pmod{P}
$$

is suﬃcient for ﬁlter stability. In many cases, this identity can also be shown to be necessary [52]. In precisely the same manner, it is not diﬃcult to show that the unobserved Markov chain ( X k ) k ∈ Z is stable if and only if the tail σ -ﬁeld

$$
\bigcap_{k} \mathcal{X}_{-\infty}^{-k} \text{ is } P\text{-trivial.}
$$

Thus we can formulate a measure-theoretic version of the ﬁlter stability problem:

$$
\text{When does } P\text{-triviality of } \bigcap_{k} \mathcal{X}_{-\infty}^{-k} \text{ imply } \bigcap_{k} ( \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ) = \mathcal{Y}_{-\infty}^{0} \pmod{P}?
$$

It is tempting to conclude that this is always the case: as Y 0 −∞ does not depend on k , one would expect that k ( X − k −∞ ∨ Y 0 −∞ ) ? = ( k X − k −∞ ) ∨ Y 0 −∞ and thus the ﬁlter stability property would automatically follow from stability of the underlying model. This (incorrect) reasoning was used by Kunita [29] in the proof of his main result. The conclusion is already contradicted, however, by Example 2.1! The fundamental issue is that the exchange of intersection ∩ and supremum ∨ of σ -ﬁelds is not permitted in general.

An entirely analogous measure-theoretic formulation appears in the random ﬁeld setting of section 5. Indeed, let ( X v ,Y v ) v ∈ Z d be a partially observed random ﬁeld model as in section 5.2, and deﬁne X V := σ { X v : v ∈ V } and Y V := σ { Y v : v ∈ V } for V ⊆ Z d . Then the question whether mixing implies conditional mixing can be phrased as:

When does
$$
\bigcap_{V \subset\subset \mathbb{Z}^d} \mathcal{X}_{\mathbb{Z}^d \setminus V} \text{ is } P\text{-trivial}
$$
imply
$$
\bigcap_{V \subset\subset \mathbb{Z}^d} (\mathcal{X}_{\mathbb{Z}^d \setminus V} \vee \mathcal{Y}_{\mathbb{Z}^d}) = \mathcal{Y}_{\mathbb{Z}^d} \pmod{P}?
$$
