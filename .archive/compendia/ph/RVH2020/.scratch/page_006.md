[Page 6]

Theorem 2.2 ([50]) . Suppose that the following hold.

- 1. The underlying dynamics is uniformly stable in the sense

$$
\sup _ { A } | P [ X _ { k } \in A | X _ { 0 } ] - \lambda ( A ) | \stackrel { k \to \infty } { \longrightarrow } 0 \ \ i n \ L ^ { 1 } .
$$

- 2. The observations are nondegenerate in the sense


$$
\Phi ( x ^ { \prime } , x , d y ) = g ( x ^ { \prime } , x , y ) \, \varphi ( d y ) , \quad g ( x ^ { \prime } , x , y ) > 0 \ \text {for all } x , x ^ { \prime } , y .
$$

Then the ﬁlter is uniformly stable in the sense

$$
\sup _ { A } | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \ i n \ L ^ { 1 } .
$$

This result, together with the mathematical theory behind its proof (cf. section 6.1), provides a very general qualitative understanding of the inheritance of ergodicity in classical ﬁltering models. However, as will be explained below, this theory breaks down completely in inﬁnite-dimensional models. In the remainder of this paper, we will see that new phenomena arise in the inﬁnite-dimensional setting.

Remark 2.3. The question of inheritance of ergodic properties under conditioning can be formulated in a number of diﬀerent ways. For concreteness, we focus our attention in this paper on the elementary formulation introduced above. As the choice of problem is somewhat arbitrary, let us brieﬂy describe a number of alternative formulations.

In the setting of stability of the ﬁlter, we have considered ‘forgetting’ of the initial condition X 0 under the stationary measure. Similar problems can be formulated, however, in a more general setting. Denote by P µ the law of the process ( X k ,Y k ) k ≥ 0 with the initial distribution X 0 ∼ µ . A natural notion of stability is to require that

$$
P ^ { \mu } [ X _ { k } \in \cdot ] \xrightarrow { k \to \infty } \lambda \ \text { for every } \mu
$$

in a suitable topology on probability measures. If we deﬁne the ﬁlter started at µ as π µ k := P µ [ X k ∈ ·| Y 1 ,...,Y k ], we can now investigate the general ﬁlter stability problem

$$
| \pi _ { k } ^ { \mu } ( f ) - \pi _ { k } ^ { \nu } ( f ) | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 } ( P ^ { \gamma } )
$$

for a suitable class of measures µ,ν,γ and functions f . The formulation that we consider in this paper corresponds to the special case ν = λ and µ = γ = δ x for x outside a λ -null set. Nonetheless, our formulation proves to be equivalent in a rather general setting to stability for general initial measures µ,ν,γ , cf. [13, Chapter 12] and [50, 46].

A diﬀerent and perhaps more natural formulation dates back to Blackwell [1] and Kunita [29]. Using the Markov property of the underlying model, it is not diﬃcult to show that the measure-valued stochastic process ( π k ) k ≥ 0 is itself a Markov chain, cf. [52, Appendix A]. One can now ask whether the ergodic properties of the Markov chain ( X k ) k ≥ 0 ‘lift’ to ergodic properties of the Markov chain ( π k ) k ≥ 0 . For example, if ( X k ) k ≥ 0 admits a unique stationary measure, does ( π k ) k ≥ 0 admit a unique stationary measure also? Similarly, if ( X k ) k ≥ 0 converges to its stationary measure starting from any initial condition, does the same property hold for ( π k ) k ≥ 0 ? Remarkably, while these questions appear in ﬁrst instance
