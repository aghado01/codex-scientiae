# Manifest: Page 043

## REPAIR_PROSE
- RAW: `Let ( X k ,Y k ) k ∈ Z be a stationary hidden Markov model as in section 2.1. Then`
  FIX: `Let $(X_k, Y_k)_{k \in \mathbb{Z}}$ be a stationary hidden Markov model as in section 2.1. Then`

- RAW: `where we deﬁne here and below the σ -ﬁelds`
  FIX: `where we define here and below the $\sigma$-fields`

- RAW: `Thus the ﬁlter is stable if and only if`
  FIX: `Thus the filter is stable if and only if`

- RAW: `is suﬃcient for ﬁlter stability. In many cases, this identity can also be shown to be necessary [52]. In precisely the same manner, it is not diﬃcult to show that the unobserved Markov chain ( X k ) k ∈ Z is stable if and only if the tail σ -ﬁeld`
  FIX: `is sufficient for filter stability. In many cases, this identity can also be shown to be necessary [52]. In precisely the same manner, it is not difficult to show that the unobserved Markov chain $(X_k)_{k \in \mathbb{Z}}$ is stable if and only if the tail $\sigma$-field`

- RAW: `It is tempting to conclude that this is always the case: as Y 0 −∞ does not depend on k , one would expect that k ( X − k −∞ ∨ Y 0 −∞ ) ? = ( k X − k −∞ ) ∨ Y 0 −∞ and thus the ﬁlter stability property would automatically follow from stability of the underlying model. This (incorrect) reasoning was used by Kunita [29] in the proof of his main result. The conclusion is already contradicted, however, by Example 2.1! The fundamental issue is that the exchange of intersection ∩ and supremum ∨ of σ -ﬁelds is not permitted in general.`
  FIX: `It is tempting to conclude that this is always the case: as $\mathcal{Y}_{-\infty}^0$ does not depend on $k$, one would expect that $\bigcap_k (\mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^0) \stackrel{?}{=} (\bigcap_k \mathcal{X}_{-\infty}^{-k}) \vee \mathcal{Y}_{-\infty}^0$ and thus the filter stability property would automatically follow from stability of the underlying model. This (incorrect) reasoning was used by Kunita [29] in the proof of his main result. The conclusion is already contradicted, however, by Example 2.1! The fundamental issue is that the exchange of intersection $\cap$ and supremum $\vee$ of $\sigma$-fields is not permitted in general.`

- RAW: `An entirely analogous measure-theoretic formulation appears in the random ﬁeld setting of section 5. Indeed, let ( X v ,Y v ) v ∈ Z d be a partially observed random ﬁeld model as in section 5.2, and deﬁne X V := σ { X v : v ∈ V } and Y V := σ { Y v : v ∈ V } for V ⊆ Z d . Then the question whether mixing implies conditional mixing can be phrased as:`
  FIX: `An entirely analogous measure-theoretic formulation appears in the random field setting of section 5. Indeed, let $(X_v, Y_v)_{v \in \mathbb{Z}^d}$ be a partially observed random field model as in section 5.2, and define $\mathcal{X}_V := \sigma\{X_v : v \in V\}$ and $\mathcal{Y}_V := \sigma\{Y_v : v \in V\}$ for $V \subseteq \mathbb{Z}^d$. Then the question whether mixing implies conditional mixing can be phrased as:`

- RAW: ```
When does

imply

$$
\bigcap _ { V \subset \subset Z ^ { d } } X _ { \mathbb { Z } ^ { d } \vee V } \ i s \ P { \cdot } { t r i v i a l }
$$

$$
\bigcap _ { V \subset \mathbb { C } ^ { \mathbb { Z } ^ { d } } } ( x _ { \mathbb { Z } ^ { d } \vee \ Y } \, _ { \mathbb { Z } ^ { d } } ) = \mathring { y } _ { \mathbb { Z } ^ { d } } \bmod { P } \ ?
$$

$$
\exists ?
$$
```
  FIX: ```
When does
$$
\bigcap_{V \subset\subset \mathbb{Z}^d} \mathcal{X}_{\mathbb{Z}^d \setminus V} \text{ is } P\text{-trivial}
$$
imply
$$
\bigcap_{V \subset\subset \mathbb{Z}^d} (\mathcal{X}_{\mathbb{Z}^d \setminus V} \vee \mathcal{Y}_{\mathbb{Z}^d}) = \mathcal{Y}_{\mathbb{Z}^d} \pmod{P}?
$$
```

## REPAIR_MATH
- RAW: ```
E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] & = \\ E | P [ X _ { 0 } \in A | X _ { - k } , Y _ { - k + 1 } , \dots , Y _ { 0 } ] - P [ X _ { 0 } \in A | Y _ { - k + 1 } , \dots , Y _ { 0 } ] & = \quad ( \text {Markov property} ) \\ E | P [ X _ { 0 } \in A | X _ { - k } ^ { - k } \vee Y _ { - \infty } ^ { 0 } ] - P [ X _ { 0 } \in A | Y _ { - \infty + 1 } ^ { 0 } ] & \xrightarrow { \, | \, \cdot \, | } \quad ( \text {martingale cvg.} ) \\ E | P [ X _ { 0 } \in A | \cap ( X _ { - \infty } ^ { - k } \vee Y _ { - \infty } ^ { 0 } ) ] - P [ X _ { 0 } \in A | Y _ { - \infty } ^ { 0 } ] & ,
```
  FIX: ```
\begin{align*}
E | P [ X_{k} \in A | X_{0}, Y_{1}, \dots, Y_{k} ] - P [ X_{k} \in A | Y_{1}, \dots, Y_{k} ] &= \\
E | P [ X_{0} \in A | X_{-k}, Y_{-k+1}, \dots, Y_{0} ] - P [ X_{0} \in A | Y_{-k+1}, \dots, Y_{0} ] &= \quad (\text{Markov property}) \\
E | P [ X_{0} \in A | \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ] - P [ X_{0} \in A | \mathcal{Y}_{-\infty+1}^{0} ] &\xrightarrow{ \, | \, \cdot \, | } \quad (\text{martingale cvg.}) \\
E | P [ X_{0} \in A | \bigcap (\mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0}) ] - P [ X_{0} \in A | \mathcal{Y}_{-\infty}^{0} ] &,
\end{align*}
```
- RAW: ```
X _ { m } ^ { n } \colon = \sigma \{ X _ { m } , \dots , X _ { n } \} , \quad \ \ Y _ { m } ^ { n } \colon = \sigma \{ Y _ { m } , \dots , Y _ { n } \} .
```
  FIX: ```
\mathcal{X}_{m}^{n} := \sigma \{ X_{m}, \dots, X_{n} \}, \quad \mathcal{Y}_{m}^{n} := \sigma \{ Y_{m}, \dots, Y_{n} \}.
```
- RAW: ```
P [ X _ { 0 } \in \cdot \cdot | \bigcap _ { k } ( X _ { - \infty } ^ { - k } \vee \mathcal { Y } _ { - \infty } ^ { 0 } ) ] = P [ X _ { 0 } \in \cdot | \mathcal { Y } _ { - \infty } ^ { 0 } ] .
```
  FIX: ```
P \left[ X_{0} \in \cdot \middle| \bigcap_{k} ( \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ) \right] = P \left[ X_{0} \in \cdot \middle| \mathcal{Y}_{-\infty}^{0} \right].
```
- RAW: ```
\bigcap _ { k } ( x _ { - \infty } ^ { - k } \vee y _ { - \infty } ^ { 0 } ) = y _ { - \infty } ^ { 0 } \mod P
```
  FIX: ```
\bigcap_{k} ( \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ) = \mathcal{Y}_{-\infty}^{0} \pmod{P}
```
- RAW: ```
\bigcap _ { k } x _ { - \infty } ^ { - k } \ \text {is } P \text {-trivial.}
```
  FIX: ```
\bigcap_{k} \mathcal{X}_{-\infty}^{-k} \text{ is } P\text{-trivial.}
```
- RAW: ```
W h e n \ d o e s \ P { \text {-triviality} } { \ y f \bigcap _ { k } X _ { - \infty } ^ { - k } \ i m p l y \bigcap _ { k } ( X _ { - \infty } ^ { - k } \vee \mathcal { Y } _ { - \infty } ^ { 0 } ) } = \mathcal { Y } _ { - \infty } ^ { 0 } \bmod { P } \, ?
```
  FIX: ```
\text{When does } P\text{-triviality of } \bigcap_{k} \mathcal{X}_{-\infty}^{-k} \text{ imply } \bigcap_{k} ( \mathcal{X}_{-\infty}^{-k} \vee \mathcal{Y}_{-\infty}^{0} ) = \mathcal{Y}_{-\infty}^{0} \pmod{P}?
```
