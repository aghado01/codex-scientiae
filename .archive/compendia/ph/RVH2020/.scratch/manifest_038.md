# Manifest: Page 038

## REPAIR_PROSE

- RAW: `We do not know how to prove such a conjecture in a general setting. However, we will presently establish the validity of such a result under monotonicity assumptions on the underlying ﬁeld. This provides an entirely diﬀerent mechanism for the inheritance of ergodicity than the observability theory that was developed in section 4 above.`
  FIX: `We do not know how to prove such a conjecture in a general setting. However, we will presently establish the validity of such a result under monotonicity assumptions on the underlying field. This provides an entirely different mechanism for the inheritance of ergodicity than the observability theory that was developed in section 4 above.`

- RAW: ```
see Remark 5.17 below.

glyph[negationslash]

Nonetheless, the result
```
  FIX: ```
see Remark 5.17 below.

Nonetheless, the result
```

## REPAIR_MATH

- RAW: `If the underlying random ﬁeld X is mixing, then the model is conditionally mixing.`
  FIX: `If the underlying random field \( X \) is mixing, then the model is conditionally mixing.`

- RAW: `In such models, the direct observation structure Y v = X v ξ v ensures that monotonicity properties are preserved under conditioning on the observations, which greatly facilitates the analysis of the conditional random ﬁeld. The arguments used here are directly inspired by the methods used in [26, 19, 17] to investigate the global Markov property of random ﬁelds.`
  FIX: `In such models, the direct observation structure \( Y_v = X_v \xi_v \) ensures that monotonicity properties are preserved under conditioning on the observations, which greatly facilitates the analysis of the conditional random field. The arguments used here are directly inspired by the methods used in [26, 19, 17] to investigate the global Markov property of random fields.`

- RAW: `In this section, we will assume that E = F = {− 1 , 1 } . Fix a speciﬁcation γ and a Markov random ﬁeld X = ( X v ) v ∈ Z d speciﬁed by γ , and introduce the observations`
  FIX: `In this section, we will assume that \( E = F = \{-1, 1\} \). Fix a specification \( \gamma \) and a Markov random field \( X = (X_v)_{v \in \mathbb{Z}^d} \) specified by \( \gamma \), and introduce the observations`

- RAW: ```
$$
Y _ { v } = X _ { v } \xi _ { v } , \quad ( \xi _ { v } ) _ { v \in \mathbb { Z } ^ { 2 } } \text { are independent } \mathbb { L } \ X \text { with } P [ \xi _ { v } = - 1 ] = p _ { v } .
$$
```
  FIX: ```
$$
Y_v = X_v \xi_v, \quad (\xi_v)_{v \in \mathbb{Z}^d} \text{ are independent } \perp \!\!\! \perp X \text{ with } P[\xi_v = -1] = p_v.
$$
```

- RAW: `For simplicity, we will assume throughout this section that 0 < p v ≤ 1 / 2 for all v . 8`
  FIX: `For simplicity, we will assume throughout this section that \( 0 < p_v \leq 1/2 \) for all \( v \). 8`

- RAW: `Here a function f : {− 1 , 1 } Z d → R is called increasing if f ( x ) ≥ f ( z ) whenever x v ≥ z v for all v ∈ Z d .`
  FIX: `Here a function \( f : \{-1, 1\}^{\mathbb{Z}^d} \to \mathbb{R} \) is called increasing if \( f(x) \geq f(z) \) whenever \( x_v \geq z_v \) for all \( v \in \mathbb{Z}^d \).`

- RAW: `Deﬁnition 5.11. A speciﬁcation γ for a {− 1 , 1 } -valued random ﬁeld is called monotone if for every bounded increasing function f and V ⊂⊂ Z d , the function γ V f is increasing.`
  FIX: `Definition 5.11. A specification \( \gamma \) for a \( \{-1, 1\} \)-valued random field is called monotone if for every bounded increasing function \( f \) and \( V \Subset \mathbb{Z}^d \), the function \( \gamma_V f \) is increasing.`

- RAW: `Theorem 5.12. For the model of this section, suppose that the speciﬁcation γ is monotone. Then | G ( γ ) | = 1 implies that | G ( γ Y ) | = 1 a.s. In particular, under the monotonicity assumption, uniqueness of the underlying random ﬁeld implies conditional mixing.`
  FIX: `Theorem 5.12. For the model of this section, suppose that the specification \( \gamma \) is monotone. Then \( |\mathcal{G}(\gamma)| = 1 \) implies that \( |\mathcal{G}(\gamma^Y)| = 1 \) a.s. In particular, under the monotonicity assumption, uniqueness of the underlying random field implies conditional mixing.`

- RAW: `Under the monotonicity assumption, Theorem 5.12 essentially resolves the analogue of Conjecture 5.10 for uniqueness rather than extremality (this is the special case p v = p = 1 / 2 for all v ). A partial result on the inheritance of extremality when the ﬁeld is not unique can be deduced from the proof as well, see Remark 5.17 below.`
  FIX: `Under the monotonicity assumption, Theorem 5.12 essentially resolves the analogue of Conjecture 5.10 for uniqueness rather than extremality (this is the special case \( p_v = p = 1/2 \) for all \( v \)). A partial result on the inheritance of extremality when the field is not unique can be deduced from the proof as well, see Remark 5.17 below.`

- RAW: `Nonetheless, the result of Theorem 5.12 is arguably quite diﬀerent in spirit from Conjecture 5.10, as it does not require the absence of observation symmetries. For example, we could choose the noise parameters p v such that p v = 1 2 for alternating sites in the lattice Z d : then there is certainly a large class of observation symmetries, as only every other site in the lattice is observed.`
  FIX: `Nonetheless, the result of Theorem 5.12 is arguably quite different in spirit from Conjecture 5.10, as it does not require the absence of observation symmetries. For example, we could choose the noise parameters \( p_v \) such that \( p_v = 1/2 \) for alternating sites in the lattice \( \mathbb{Z}^d \): then there is certainly a large class of observation symmetries, as only every other site in the lattice is observed.`

- RAW: `8 The assumption p v > 0 ensures local nondegeneracy, which is convenient in view of Proposition 5.7 but is not essential for the results in this section. The assumption p v ≤ 1 / 2 does not entail any loss of generality: if p v > 1 / 2, we can reduce to p v < 1 / 2 by considering the inverted observation − Y v instead of Y v .`
  FIX: `8 The assumption \( p_v > 0 \) ensures local nondegeneracy, which is convenient in view of Proposition 5.7 but is not essential for the results in this section. The assumption \( p_v \leq 1/2 \) does not entail any loss of generality: if \( p_v > 1/2 \), we can reduce to \( p_v < 1/2 \) by considering the inverted observation \( -Y_v \) instead of \( Y_v \).`
