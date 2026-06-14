[Page 35]

Remark 5.5. For notational simplicity, we have formulated our model such that the observations are attached to individual sites \( v \in \mathbb{Z}^{d} \). One could also consider more general models, for example, where an observation \( Y_{\{v,w\}} \) is attached to every edge \( \{v,w\} \subset \mathbb{Z}^{d} \), \( |v - w| = 1 \) with \( \text{P}[Y_{\{v,w\}} \in A | X] = \Phi_{\{v,w\}}(X_{v}, X_{w}, A) \) (cf. Example 5.8). The results of this section will continue to hold in this setting with minor modiﬁcations.

We can now formulate the natural counterpart of the ﬁlter stability property in hidden Markov random ﬁelds: the model is said to be conditionally mixing if the conditional distribution of the underlying process in a ﬁnite set of sites given the observations is insensitive to knowledge of the conﬁguration of the ﬁeld at distant sites.

Deﬁnition 5.6. The hidden Markov random ﬁeld \( (X_{v}, Y_{v})_{v \in \mathbb{Z}^{d}} \) is conditionally mixing if

$$
\lim_{W \Subset \mathbb{Z}^{d}} \text{E} | \text{P}[X_{V} \in A | X_{W^{c}}, Y] - \text{P}[X_{V} \in A | Y] | = 0
$$

for every set \( A \) and \( V \Subset \mathbb{Z}^{d} \).

The basic question to be addressed in this setting is therefore: when is the mixing property inherited by conditioning , that is, when does the mixing property of the random ﬁeld \( X \) imply the conditional mixing property of \( (X, Y) \)?

It will be insightful to reformulate the problem in diﬀerent terms. For simplicity, we will assume in the sequel that the observations are locally nondegenerate, that is, that \( \Phi_{v}(x_{v}, dy_{v}) = g_{v}(x_{v}, y_{v}) \phi(dy_{v}) \) for some positive density \( g_{v}(x_{v}, y_{v}) > 0 \) for all \( x_{v}, y_{v} \) (the reference measure \( \phi(dy_{v}) \) on \( F \) may be any \( \sigma \)-ﬁnite measure.)

Proposition 5.7. Deﬁne for every \( y \in F^{\mathbb{Z}^{d}} \) and \( V \Subset \mathbb{Z}^{d} \) the transition kernel on \( E^{\mathbb{Z}^{d}} \)

$$
\gamma _ { V } ^ { y } ( x , A ) = \frac { \int 1 _ { A } ( z ) \prod _ { v \in V } g _ { v } ( z _ { v } , y _ { v } ) \, \gamma _ { V } ( x , d z ) } { \int \prod _ { v \in V } g _ { v } ( z _ { v } , y _ { v } ) \, \gamma _ { V } ( x , d z ) } .
$$

Then the following hold.

- 1. \( \gamma^{y} = (\gamma_{V}^{y})_{V \Subset \mathbb{Z}^{d}} \) is a speciﬁcation for every \( y \in F^{\mathbb{Z}^{d}} \).
- 2. \( \text{P}[X \in \cdot | Y] \) is in \( \mathcal{G}(\gamma^{Y}) \) a.s.
- 3. \( (X, Y) \) is conditionally mixing iﬀ \( \text{P}[X \in \cdot | Y] \) is extremal in \( \mathcal{G}(\gamma^{Y}) \) a.s.


Proof. We begin by verifying that γ y is a speciﬁcation. To this end, let \( W \subset V \Subset \mathbb{Z}^{d} \). As \( \gamma_{V} \gamma_{W} = \gamma_{V} \) and \( \gamma_{W}(fg) = g \gamma_{W} f \) if \( g(x) \) depends only on \( x_{W^{c}} \), we can write

$$
\begin{aligned}
\int 1 _ { A } ( z ) \prod _ { v \in V } g _ { v } ( z _ { v } , y _ { v } ) \, \gamma _ { V } ( x , d z ) 
& = \int \gamma _ { W } ^ { y } ( z , A ) \int \prod _ { w \in W } g _ { w } ( z _ { w } , y _ { w } ) \, \gamma _ { W } ( z ^ { \prime } , d z ) \prod _ { v \in V \setminus W } g _ { v } ( z ^ { \prime } _ { v } , y _ { v } ) \, \gamma _ { V } ( x , d z ^ { \prime } ) \\
& = \int \gamma _ { W } ^ { y } ( z , A ) \prod _ { v \in V } g _ { v } ( z _ { v } , y _ { v } ) \, \gamma _ { V } ( x , d z ) .
\end{aligned}
$$



Thus \( \gamma_{V}^{y} \gamma_{W}^{y} = \gamma_{V}^{y} \), and the remaining properties of a speciﬁcation hold trivially.
