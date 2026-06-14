[Page 5]

We will assume in the sequel that the Markov chain \( (X_k)_{k \ge 0} \) admits a unique invariant measure \( \lambda \). As \( \mathbf{P}[X_k, Y_k \in \cdot \mid X_{k-1}, Y_{k-1}] \) does not depend on \( Y_{k-1} \) due to the hidden Markov structure, the invariant measure \( \lambda \) extends uniquely to an invariant measure for the chain \( (X_k, Y_k)_{k \ge 0} \), and we denote the unique stationary law of this process as \( \mathbf{P} \). By stationarity, we can assume in the sequel that \( (X_k, Y_k)_{k \in \mathbb{Z}} \) is defined also for \( k < 0 \).

The ergodic property of \( (X_k)_{k \ge 0} \) that we will consider is stability in the sense that

$$
\[
| P [ X _ { k } \in A | X _ { 0 } ] - \lambda ( A ) | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 }
\]
$$

for every measurable set \( A \): that is, the law of \( X_k \) ‘forgets’ the initial condition \( X_0 \) as \( k \to \infty \). The analogous conditional property is filter stability in the sense that

$$
\[
| P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | \stackrel { k \to \infty } { \longrightarrow } 0 \ \text { in } L ^ { 1 }
\]
$$

for every measurable set \( A \): that is, the conditional distribution of \( X_k \) given the observed data ‘forgets’ the initial condition \( X_0 \) as \( k \to \infty \). It is natural to suppose that stability of the underlying dynamics will imply stability of the filter. This conclusion is incorrect, however, as is illustrated by the following classical example [1].

Example 2.1. Let \( (X_k)_{k \ge 0} \) be an i.i.d. sequence of random variables with \( \mathbf{P}[X_k = 1] = \mathbf{P}[X_k = -1] = 1/2 \), and let \( Y_k = X_k X_{k-1} \) for \( k \ge 1 \). This evidently defines a stationary hidden Markov model with \( \mathbf{P}(x, \cdot) = (\delta_1 + \delta_{-1})/2 \) and \( \Phi(x, x', \cdot) = \delta_{xx'} \). Note that

$$
\[
X _ { k } = X _ { 0 } Y _ { 1 } Y _ { 2 } \cdots Y _ { k } .
\]
$$

We can therefore easily compute for every \( k \ge 0 \)

$$
\[
\begin{aligned}
P [ X _ { k } = 1 | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] & = 1 _ { X _ { k } = 1 } , \\ P [ X _ { k } = 1 | Y _ { 1 } , \dots , Y _ { k } ] & = 1 / 2 .
\end{aligned}
\]
$$

Thus the filter is certainly not stable. On the other hand, underlying dynamics \( (X_k)_{k \ge 0} \) is an i.i.d. sequence, and is therefore stable in the strongest possible sense:

$$
\[
P [ X _ { k } \in A | X _ { 0 } ] = \lambda ( A ) \ \text { for all } k \geq 1 .
\]
$$

Moreover, even the process \( (X_k, Y_k)_{k \ge 0} \) is stable in the strongest possible sense: it is a 1-dependent sequence, so that \( \mathbf{P}[(X_k, Y_k) \in A \mid X_0, Y_0] = \mathbf{P}[(X_k, Y_k) \in A] \) for all \( k \ge 2 \).

Example 2.1 shows that the inheritance of ergodicity under conditioning cannot be taken for granted. Nonetheless, the phenomenon exhibited here is very fragile: if the observations are perturbed by any noise (for example, if we set \( Y_k = X_k X_{k-1} \xi_k \) with \( \mathbf{P}[\xi_k = -1] = 1 - \mathbf{P}[\xi_k = 1] = p \) and any \( 0 < p < 1 \)), the filter will become stable. The inheritance of ergodicity is therefore apparently obstructed by the singularity of the observation kernel \( \Phi \). To rule out such singular behavior, it is natural to require that the observation kernel \( \Phi \) possesses a positive density with respect to some reference measure \( \phi \). A model with this property is said to possess nondegenerate observations. One might now expect that nondegeneracy of the observations removes the obstruction to inheritance of ergodicity observed in Example 2.1. Unfortunately, this is still not the case in complete generality, as is demonstrated by an esoteric counterexample in [52]. However, the conclusion does hold if we use a stronger uniform notion of stability.
