[Page 27]

Remark 4.10. It is evident that the intermediate ﬁlter reduces to the ﬁlter if we let \( v \to \infty \); thus Conjecture 4.1 would be established for translation-invariant models if the limits as \( k \to \infty \) and \( v \to \infty \) could be exchanged in Theorem 4.5. Similarly, we could aim to obtain the conclusion of Conjecture 4.1 for the prediction ﬁlter by letting \( v \to -\infty \). However, we do not know how to establish the validity of Theorem 4.5 in either limit.

To obtain some insight into this idea, let us rewrite Theorem 4.5 in a measure-theoretic manner. Using the Markov property and translation invariance, we obtain

$$
v ^ { < v } ] = P [ X _ { t } \in A | Y _ { t } \ \ Y _ { t } \ Y ^ { < v } ] | =
$$

$$
& \text {E} | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \text {P} [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] | = \\ & \text {E} | P [ X _ { 0 } \in A | Y _ { 0 } ^ { < v } , Y _ { - 1 } , Y _ { - 2 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ] - \text {P} [ X _ { 0 } \in A | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots , Y _ { - k + 1 } ] |
$$

as in the proof of Proposition 4.7. Letting \( k \to \infty \) and using Theorem 4.5 yields

$$
0 & = \lim _ { k \to \infty } \mathbf E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] | \\ & = \mathbf E | \mathbf P [ X _ { 0 } \in A | \bigcap _ { k } ( y _ { _ { - } } ^ { v } \vee X _ { - k } ) ] - \mathbf P [ X _ { 0 } \in A | y _ { _ { - } } ^ { v } ] | ,
$$

  where we deﬁned the \( \sigma \)-ﬁelds \( \mathcal{X}_{-k} = \sigma\{X_{-k}, X_{-k-1}, \dots\} \) and \( \mathcal{Y}_-^v = \sigma\{Y_0^{<v}, Y_{-1}, Y_{-2}, \dots\} \). Now let us attempt to take the limit as \( v \to -\infty \). This yields

$$
E | P [ X _ { 0 } \in A | \bigcap _ { k , v } ( y _ { - } ^ { v } \vee X _ { - k } ) ] - P [ X _ { 0 } \in A | \bigcap _ { v } y _ { - } ^ { v } ] | = 0 .
$$

This does not suﬃce to establish Conjecture 4.1 for the prediction ﬁlter. In order to deduce the latter, we would need to establish the identity

$$
\bigcap _ { v } y _ { - } ^ { v } = y _ { - } \colon = \sigma \{ Y _ { - 1 } , Y _ { - 2 } , \dots \} \mod P
$$

(the notation \( \mathcal{F} = \mathcal{G} \mod P \) indicates that the \( P \)-completions of the \( \sigma \)-ﬁelds \( \mathcal{F} \) and \( \mathcal{G} \) coincide). Indeed, if this is the case, then we obtain by Jensen’s inequality

$$
& \lim _ { k \to \infty } E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k - 1 } ] | \\ & = E | P [ X _ { 0 } \in A | \bigcap _ { k } ( y _ { - } \vee x _ { - k } ) ] - P [ X _ { 0 } \in A | y _ { - } ] | \\ & \leq E | P [ X _ { 0 } \in A | \bigcap _ { k , v } ( y _ { - } ^ { v } \vee x _ { - k } ) ] - P [ X _ { 0 } \in A | y _ { - } ] | = 0 ,
$$

where we used \( \bigcap_{k,v} (\mathcal{Y}_-^v \vee \mathcal{X}_{-k}) \supseteq \bigcap_k (\mathcal{Y}_- \vee \mathcal{X}_{-k}) \supseteq \mathcal{Y}_- \). Similarly, let us take \( v \to \infty \). This yields

$$
E | P [ X _ { 0 } \in A | V _ { v } \cap _ { k } ( y _ { _ { - } } ^ { v } \vee X _ { _ { - } k } ) ] - P [ X _ { 0 } \in A | V _ { v } \mathcal { Y } _ { _ { - } } ^ { v } ] | = 0 .
$$

In order to establish Conjecture 4.1, we would now need the identity

$$
\bigvee _ { v } \bigcap _ { k } ( y _ { - } ^ { v } \vee x _ { - k } ) = \bigcap _ { k } \bigvee _ { v } ( y _ { - } ^ { v } \vee x _ { - k } ) \mod P ,
$$

the remainder of the argument proceeding in the same manner as for \( v \to -\infty \).

Neither of the above measure-theoretic identities appears to be obvious; indeed, the problem of establishing such identities is closely related to the ﬁlter stability problem itself (cf. section 6.1). Nonetheless, the conclusion of Theorem 4.5 appears to be tantalizingly close to establishing Conjecture 4.1 for translation-invariant systems, and the fact that the latter does not appear to follow directly from the former provides one more indication of the delicacy of the ﬁlter stability problem in inﬁnite dimension. A very similar argument will be used in the following section to resolve the continuous-time analogue of the problem; the key distinction in this case is that an appropriate measure-theoretic identity can in fact be established (Lemma 4.15 below).
