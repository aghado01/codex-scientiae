[Page 19]

stability (as well as spatial decay of correlations in inﬁnite dimension) for the performance of practical ﬁltering algorithms [40].

It is not diﬃcult to understand the mechanism that causes the ﬁlter to be unstable in Theorem 3.1. In this model, the observations possess a global symmetry: the conditional law of \( Y \) is unchanged under the transformation \( X \to -X \). This symmetry renders the ﬁlter trivially unstable in the absence of observation noise, in precise analogy with Example 2.1. In the ﬁnite-dimensional case, however, Theorem 2.2 shows that the addition of any observation noise suﬃces to ensure that ergodicity of the underlying model is not broken by the additional symmetry introduced by conditioning. The surprise in inﬁnite dimension is that the qualitative eﬀect of the added symmetry still persists in the presence of observation noise. Thus local nondegeneracy in itself does not suﬃce to ensure the inheritance of ergodicity under conditioning.

On the other hand, the phenomenon exhibited in Theorem 3.1 evidently cannot arise in models that do not possess observation symmetries. It seems natural to conjecture that the presence of such symmetries is the only possible obstruction to inheritance of ergodicity under conditioning: that is, inheritance of ergodicity is ensured once observation symmetries are ruled out. It is not entirely obvious, however, how such a principle can be rigorously formulated. On the other hand, even in the absence of a general deﬁnition, this intuitive notion should certainly be satisﬁed in many elementary observation models. For example, let us state the following simple conjecture, which encapsulates the essence of the above intuition in the simplest possible setting.

Conjecture 4.1. Let \( (X_k, Y_k)_{k \in \mathbb{Z}} \) be a stationary inﬁnite-dimensional hidden Markov model as in section 2.2 with \( X_k \in \{-1, 1\}^\mathbb{Z} \) and with \( Y_k \in \{-1, 1\}^\mathbb{Z} \) of the form

\[
Y_k^v = X_k^v \xi_k^v, \quad (\xi_k^v)_{k,v \in \mathbb{Z}} \text{ are i.i.d. } \perp X \text{ with } P[\xi_k^v = -1] = p.
\]

If the underlying process \( (X_k)_{k \in \mathbb{Z}} \) is stable, then the ﬁlter is stable.

The idea behind this conjecture is that the direct observation structure \( Y_k^v = X_k^v \xi_k^v \) is evidently devoid of symmetries for any \( p \neq 1/2 \): every conﬁguration \( x \in \{-1, 1\}^\mathbb{Z} \) gives rise to a distinct observation law \( P[Y_k \in \cdot \mid X_k = x] \) (the case \( p = 1/2 \) is trivial as then \( Y \perp\!\!\!\perp X \); we will therefore assume \( p \neq 1/2 \) in the sequel). Thus any mechanism of the type exhibited by Theorem 3.1 is ruled out, and it seems hard to imagine another mechanism by which ergodicity of the underlying process could be obstructed due to conditioning on such informative observations. Despite the seemingly obvious nature of this conjecture, we were not able to prove such a result in a general setting.

The idea that stability of the ﬁlter is related to the absence of symmetries is not new in the inﬁnite-dimensional setting. It arises already in classical ﬁltering models for a somewhat diﬀerent reason: it may happen that the ﬁlter is stable even when the underlying model is not ergodic. In such situations, stability properties can emerge under the conditional distribution due to the informative nature of the observations; in essence, the ﬁlter will ‘forget’ its initial distribution as the information contained therein is superseded by the information in the observations. 3 This phenomenon was made precise in the papers [48, 49, 51]. While the theory developed in these papers is closely related to the symmetry breaking

3 This is not the only mechanism that gives rise to stability of nonlinear ﬁlters in classical nonergodic models; it is also possible to exploit the local ergodicity of the model, cf. [15] and the references therein. However, this approach is unrelated to the symmetric breaking mechanism that is developed in this section.
