[Page 28]

## 4.3 Continuous time

In the previous section we have developed a partial result on ﬁlter stability in the case of translation-invariant models with direct observation structure. Unfortunately, that result concerns a quantity intermediate between the ﬁlter and prediction ﬁlter, and therefore falls short of resolving Conjecture 4.1 even in the translation-invariant setting. Surprisingly, however, it turns out that this problem can be resolved if we consider the natural continuous time analogue of Conjecture 4.1, providing a complete proof of ﬁlter stability in the translation-invariant setting for continuous-time models with direct observations. This idea will be developed in the remainder of this section.

To deﬁne the continuous-time counterpart of the ﬁltering model of Conjecture 4.1, we begin by considering a stationary Markov process \( X = (X_t)_{t \in \mathbb{R}} \) with càdlàg paths with values in \( \{-1, 1\}^{\mathbb{Z}} \). We will assume that \( X \) satisﬁes the Feller property, that is, that \( x \mapsto \mathbb{E}_x [f(X_t)] \) is a quasilocal function for every \( t \) and bounded quasilocal function \( f \) (a function is called quasilocal if it is the uniform limit of functions that depend on a ﬁnite number of coordinates). 5 This mild condition ensures that the dynamics are local in a very weak sense (as compared to the much stronger local structure of the model in section 2.2, which was however not used in the previous section). Markov processes of this type arise broadly in the literature on interacting particle systems, cf. [31]. To deﬁne the local observations \( (Y_t)_{t \in \mathbb{R}} \), we introduce a ‘white noise’ model of the form

$$
\[
d Y _ { t } ^ { v } = X _ { t } ^ { v } \, d t + \sigma \, d W _ { t } ^ { v } , \quad Y _ { 0 } ^ { v } = 0 , \quad v \in \mathbb { Z } ,
\]
$$

where \( (W_t^v)_{t \in \mathbb{R}} \) are i.i.d. two-sided Brownian motions independent of \( X \), and \( \sigma > 0 \) denotes the noise strength. The process \( (X_t, Y_t)_{t \in \mathbb{R}} \) is a natural continuous-time analogue of the model of Conjecture 4.1, and will be used in the remainder of this section.

Remark 4.11. The details of the present model are not essential for our results. The proof is easily extended to random ﬁelds on \( \mathbb{Z}^d \) with values in a ﬁnite state space, and to observation models other than the usual white noise model (cf. [49]). For concreteness and to avoid additional notation, we will work here in the simplest setting deﬁned above.

As in section 4.2, we will further assume that the model is translation-invariant

$$
\[
( X _ { t } ^ { v } , Y _ { t } ^ { v } ) _ { t \in \mathbb { R } , v \in \mathbb { Z } } \stackrel { \text {law} } { = } ( X _ { t + s } ^ { v + w } , Y _ { t + s } ^ { v + w } - Y _ { s } ^ { v + w } ) _ { t \in \mathbb { R } , v \in \mathbb { Z } } \text { for all } s \in \mathbb { R } , \ w \in \mathbb { Z }
\]
$$

(note that, due to the additive nature of the observations, it is the increments of \( Y \) that are translation invariant and not \( Y \) itself). In this setting, we obtain the following result.

Theorem 4.12. For the model of this section, we have

$$
\[
| \mathbf P [ X _ { t } \in A | X _ { 0 } , \{ Y _ { s } \} _ { 0 \leq s \leq t } ] - \mathbf P [ X _ { t } \in A | \{ Y _ { s } \} _ { 0 \leq s \leq t } ] | \xrightarrow { t \to \infty } 0 \ \ i n \ L ^ { 1 }
\]
$$

for every measurable set \( A \).

This result evidently resolves, in the translation-invariant case, the continuous-time analogue of Conjecture 4.1. We remark once more that stability of \( X \) is not assumed.

To prove Theorem 4.12 we require a sharper version of the entropy identity of Conze that was used in the proof of Theorem 4.5 (cf. Remark 4.8). The proof of the requisite identity, which we state presently, can be found in [10, p. 17, § 8].

5 We recall that a function on \( \{-1, 1\}^{\mathbb{Z}} \) is quasilocal if and only if it is continuous [22, Remark 2.21]. Thus the deﬁnition given here is equivalent to the usual deﬁnition of the Feller property of a Markov process.
