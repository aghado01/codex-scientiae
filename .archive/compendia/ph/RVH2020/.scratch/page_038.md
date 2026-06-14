[Page 38]

If the underlying random ﬁeld X is mixing, then the model is conditionally mixing.

We do not know how to prove such a conjecture in a general setting. However, we will presently establish the validity of such a result under monotonicity assumptions on the underlying ﬁeld. This provides an entirely diﬀerent mechanism for the inheritance of ergodicity than the observability theory that was developed in section 4 above.

## 5.3 Monotonicity

The goal of this section is to prove a variant of Conjecture 5.10 under monotonicity assumptions on the underlying ﬁeld. In such models, the direct observation structure Y v = X v ξ v ensures that monotonicity properties are preserved under conditioning on the observations, which greatly facilitates the analysis of the conditional random ﬁeld. The arguments used here are directly inspired by the methods used in [26, 19, 17] to investigate the global Markov property of random ﬁelds.

In this section, we will assume that E = F = {− 1 , 1 } . Fix a speciﬁcation γ and a Markov random ﬁeld X = ( X v ) v ∈ Z d speciﬁed by γ , and introduce the observations

$$
Y_v = X_v \xi_v, \quad (\xi_v)_{v \in \mathbb{Z}^d} \text{ are independent } \perp \!\!\! \perp X \text{ with } P[\xi_v = -1] = p_v.
$$

For simplicity, we will assume throughout this section that 0 < p v ≤ 1 / 2 for all v . 8

The following monotonicity property is the key assumption of this section. This property has various useful characterizations, cf. [28, Theorem 2.27]. Here a function f : {− 1 , 1 } Z d → R is called increasing if f ( x ) ≥ f ( z ) whenever x v ≥ z v for all v ∈ Z d .

Deﬁnition 5.11. A speciﬁcation γ for a {− 1 , 1 } -valued random ﬁeld is called monotone if for every bounded increasing function f and V ⊂⊂ Z d , the function γ V f is increasing.

We can now formulate the main result of this section.

Theorem 5.12. For the model of this section, suppose that the speciﬁcation γ is monotone. Then | G ( γ ) | = 1 implies that | G ( γ Y ) | = 1 a.s. In particular, under the monotonicity assumption, uniqueness of the underlying random ﬁeld implies conditional mixing.

Under the monotonicity assumption, Theorem 5.12 essentially resolves the analogue of Conjecture 5.10 for uniqueness rather than extremality (this is the special case p v = p = 1 / 2 for all v ). A partial result on the inheritance of extremality when the ﬁeld is not unique can be deduced from the proof as well, see Remark 5.17 below.

Nonetheless, the result of Theorem 5.12 is arguably quite diﬀerent in spirit from Conjecture 5.10, as it does not require the absence of observation symmetries. For example, we could choose the noise parameters p v such that p v = 1 2 for alternating sites in the lattice Z d : then there is certainly a large class of observation symmetries, as only every other site in the lattice is observed. Thus Theorem 5.12 is not addressing a symmetry-breaking phenomenon of the type that motivated the observability conjecture in section 4. On the other hand, as will become clear in the proof of Theorem 5.12, the present approach directly implements the idea that ergodicity is inherited from the underlying model to the conditional distribution, in contrast with the observability theory of section 4 which does not exploit at all the ergodic properties of the model.

8 The assumption p v > 0 ensures local nondegeneracy, which is convenient in view of Proposition 5.7 but is not essential for the results in this section. The assumption p v ≤ 1 / 2 does not entail any loss of generality: if p v > 1 / 2, we can reduce to p v < 1 / 2 by considering the inverted observation − Y v instead of Y v .
