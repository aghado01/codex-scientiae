
# 3.2. Read data

The data take the form of ( x,y ) pairs where x = t in the notation of Section 2 .

# 3.3. Find initial knot set

By default, as discussed in Section 2 , in the Poisson case the initial knot set is found using logspline . In the normal case evenly-spaced knots are placed and then backward elimination is used. Currently, an option to use evenly-spaced knots is also included for the Poisson case. (A planned improvement is to use every k -th value of t j in the data for both cases.)

# 3.4. Run MCMC

- (a) It is important to recognize that the Markov chain is on the knot sets ξ (after exact or approximate integration of ( 2 )). As described by DiMatteo et al. ( 2001 ), the algorithm randomly selects as a proposal (in the Metropolis sense) either a new knot (a “birth” step), removal of a knot (a“death”step), or a relocation of a knot. Birth and relocation steps begin by randomly selecting a knot, with equal probabilities, from among all knots in the current knot set. If the proposal involves a birth step, then a location for the potential new knot is randomly selected by first randomly selecting an existing knot and then drawing from a beta distribution centered at that knot. This beta distribution is typically quite tight around its center (with spread controlled by an optional user-defined parameter τ ) in order to propose knots that are close to existing knots (as mentioned in Section 2 ). The same beta distribution is used to propose a knot relocation (the distribution being centered on the knot to be potentially relocated). As usual, the proposal to add, delete, or relocate is evaluated, and possibly accepted, via the Metropolis-Hastings ratio.
- (b) Approximation of the integral in ( 2 ), in the Poisson case, is accomplished via BIC. This is obtained from the Poisson regression based on the proposed set of knots. This regression also produces the MLE and observed information matrix, needed in (c).
- (c) In the normal case, β ( g ) ξ is produced by a draw from the relevant multivariate normal distribution of the posterior of β ξ conditionally on ξ = ξ ( g ) , obtained analytically. In the Poisson case, for sufficiently large samples, the normal approximation to the posterior based on the MLE and observed information may be used. The algorithm always attempts to draw β ( g ) ξ from this approximating normal distribution. However, if the acceptance ratio is extremely small, a short MCMC run is used instead. We have found this to be quite important because in many of our applications a Poisson mean at some time t may be very small and thus may produce a highly skewed posterior distribution.
- (d) After β ( g ) ξ is drawn from the conditional posterior, fits may be obtained. In our applications we are often interested in maxima and their locations. Therefore, by default, we compute these.
- (e) If BIC for the newly-obtained, current ξ ( g ) is larger than BIC for all preceding knot sets then the current ξ ( g ) is retained as the current modal knot set. The MLE ˆ β ( g ) ξ (in
