[Page 37]

$$
2 . \text { If } | \mathcal { G } ( \gamma ) | = 1 , \text { when } \text { is } | \mathcal { G } ( \gamma ^ { Y } ) | = 1 \text { a.s.?}
$$

The ﬁrst question is evidently the direct spatial analogue of the ﬁlter stability problem: when is the mixing property inherited by the conditional distribution? The second question is analogous, but for the uniform mixing property. It is evident from Theorem 5.4 that | G ( γ Y ) | = 1 a.s. implies the conditional mixing property. The stronger conclusion | G ( γ Y ) | = 1 a.s. is perhaps less natural from the point of view of conditional distributions, but is of practical relevance in its own right as it is closely connected with the computational complexity of MCMC methods for Bayesian image analysis [21].

As in the ﬁlter stability problem, local nondegeneracy of the observations does not suﬃce to obtain an aﬃrmative answer to either of the above questions. In fact, we have a direct analogue of the example given in section 3.

Example 5.8. Let E = F = {− 1 , 1 } , and deﬁne the random ﬁeld ( X v ) v ∈ Z 2 such that X v are i.i.d. symmetric Bernoulli random variables. It is evident that this model is uniformly mixing in the most trivial sense (thus uniqueness and extremality both hold). d

We now attach an observation Y { v,w } to each edge { v,w } ⊂ Z , v − w = 1 by setting Y { v,w } = X v X w ξ { v,w } with ξ { v,w } i.i.d. and independent of X with P [ ξ { v,w } = − 1] = p . In this manner, we evidently obtain a direct counterpart of the model of section 3. While the observations in this model are deﬁned on the edges rather than on the vertices as we have done in this section, a result that is entirely analogous to Proposition 5.7 holds in this setting (see also Remark 5.5 above and Remark 5.9 below).

We can now proceed identically as in the proof of Theorem 3.1 to show that there exists 0 < p < 1 / 2 such that the hidden Markov random ﬁeld ( X,Y ) fails to be conditionally mixing for p < p . In fact, this is precisely the idea behind the proof of Theorem 3.1 in the ﬁrst place: the model ( X v k ,Y v k ) k,v ∈ Z is considered as a space-time random ﬁeld, and the problem is addressed using classical methods from statistical mechanics.

The present example could be considered as a toy model in image analysis. The underlying ﬁeld X represents a grid of black or white pixels of an image, and the observations Y correspond to noisy measurements of the gradient of the image at each point. Thus we see that the ability to reconstruct the image based on the noisy gradient information undergoes a phase transition at a positive signal-to-noise ratio.

Remark 5.9. The use of edge observations in Example 5.8 is merely cosmetic: the same example can be reformulated in terms of vertex observations. Indeed, let us deﬁne the random ﬁeld ( ˜ X v , ˜ Y v ) v ∈ Z d with ˜ X v ∈ {− 1 , 1 } 3 and ˜ Y v ∈ {− 1 , 1 } 2 by setting ˜ X v = ( X v ,X v +(0 , 1) ,X v +(1 , 0) ) and ˜ Y v = ( X v X v +(0 , 1) ξ { v,v +(0 , 1) } ,X v X v +(1 , 0) ξ { v,v +(1 , 0) } ), where X v and ξ { v,w } are as in Example 5.8. Then ˜ X is still a uniformly mixing Markov random ﬁeld, the observations ˜ Y are locally nondegenerate, and P [ ˜ X 1 ∈ ·| ˜ Y ] = P [ X ∈ ·| Y ]. In particular, the above conditional phase transition arises identically in this formulation.

In view of the above, the inheritance of mixing properties of random ﬁelds under conditioning cannot be taken for granted. Just as in the ﬁlter stability problem, however, it is natural to expect that conditional mixing will hold in the absence of observation symmetries. Such a conjecture is often implicit in work on Bayesian image analysis (cf. [21, p. 6]). For example, we can formulate the natural analogue of Conjecture 4.1.

Conjecture 5.10. Let ( X v ,Y v ) v ∈ Z 2 be a hidden Markov ﬁeld with E = F = {− 1 , 1 } and

$$
Y _ { v } = X _ { v } \xi _ { v } , \quad ( \xi _ { v } ) _ { v \in \mathbb { Z } ^ { 2 } } \ a r e \ i . i . d . \perp X \ w i t h \ P [ \xi _ { v } = - 1 ] = p .
$$
