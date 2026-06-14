[Page 24]

It will become evident in the proof that the intermediate ﬁlter is the natural inﬁnitedimensional object that arises in extending the observability theory of section 4.1 to translation-invariant systems. On the other hand, from the practical point of view, the intermediate ﬁlter is a somewhat strange object. Unlike the prediction ﬁlter, which arises when predicting the next state given the observations to date, and the ﬁlter, which arises when tracking the current state given the observation history, the intermediate ﬁlter uses an unnatural subset of the observations in the current time step. In particular, Theorem 4.5 falls short of establishing either Conjecture 4.1 or its natural prediction ﬁlter counterpart. Nonetheless, Theorem 4.5 could provide a step towards establishing Conjecture 4.1 for translation-invariant models (cf. Remark 4.10 below). Moreover, in section 4.3 below, we will see that this shortcoming of Theorem 4.5 can be resolved for the natural continuous-time analogue of Conjecture 4.1.

Remark 4.6. Note that Theorem 4.5 does not impose any ergodicity assumption on the underlying hidden Markov model: only observability was used to establish the result. In this sense, this result goes beyond the spirit of Conjecture 4.1, which states that ergodicity of the underlying model is inherited by the ﬁlter in models with informative observations. Indeed, the result of Theorem 4.5 cannot be interpreted as establishing the inheritance of ergodicity, as ergodicity plays no role in the argument; rather, the intermediate ﬁlter is rendered stable here entirely due to the the absence of observation symmetries, even when the underlying model is not ergodic.

One might therefore expect that ergodicity should play no role in Conjecture 4.1 either: after all, the mechanism by which we are exploiting the absence of observation symmetries appears to be independent of the ergodic properties of the model. However, it is possible that ergodicity must nonetheless enter the picture in order to extend the conclusion of Theorem 4.5 from the intermediate ﬁlter to the ﬁlter, so that neither ergodicity nor observability suﬃces by itself to ensure stability of the ﬁlter in inﬁnite dimensional models. Some evidence for this possibility will be discussed in section 6.3. On the other hand, the continuous-time results of section 4.3 below could be viewed as evidence to the contrary. New ideas appear to be needed to resolve these questions.

We now turn to the proof of Theorem 4.5. To this end we begin by proving the following result, which replaces the key step in the proof of Proposition 4.4.

Proposition 4.7. For the model of this section, we have

$$
H ( Y _ { k } ^ { v } | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) - H ( Y _ { k } ^ { v } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) \stackrel { k \to \infty } { \longrightarrow } 0
$$

for every v ∈ Z .

Remark 4.8. Consider a stationary stochastic process ( Z k ) k ∈ Z such that Z k takes values in a ﬁnite set. The entropy rate h ( Z ) of the process can be expressed as

$$
h ( Z ) \coloneqq \lim _ { n \to \infty } \frac { H ( Z _ { 1 } , \dots , Z _ { n } ) } { n } = \lim _ { n \to \infty } \frac { 1 } { n } \sum _ { k = 1 } ^ { n } H ( Z _ { k } | Z _ { 1 } , \dots , Z _ { k - 1 } ) = H ( Z _ { 1 } | Z _ { 0 } , Z _ { - 1 } , \dots ) ,
$$

where we used the chain rule and stationarity, respectively. This can be used to derive nontrivial identities for conditional entropies. Of particular importance in the present context is that if Z k = ( X k ,Y k ) (still taking values in a ﬁnite set), then [24, Lemma 18.2]

$$
\lim _ { n \to \infty } H ( Y _ { 1 } | Y _ { 0 } , Y _ { - 1 } , \dots ; X _ { - n } , X _ { - n - 1 } , \dots ) = H ( Y _ { 1 } | Y _ { 0 } , Y _ { - 1 } , \dots ) .
$$
