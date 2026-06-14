[Page 7]

number_of_grid_points: The number of evenly spaced points for the grid along which fitted values will be obtained. Default value = 500.

verbose: true or false to indicate verbose output. Default value = false.

User-defined prior on number of knotsThe prior on the number of knots k is defaulted to a uniform distribution. However, as discussed by DiMatteo et al. (2001), Hansen and Kooperberg (2002), Kass and Wallstrom (2002), this prior can serve usefully to control fitting. A user may specify the prior by specifying its pdf values on a set of positive integers. This is done in a file. For example, the file

- 2 0.05
- 3 0.15
- 4 0.30
- 5 0.30
- 6 0.10
- 7 0.10


indicates that P( k = 2) = 0.05, . . . , P( k = 7) = 0.10. All zero probabilities that appear between the smallest k having non-zero probability and the largest k having non-zero probability are changed to an ε > 0. The probabilities are then scaled to sum to one. Note that very low prior probabilites may make it difficult for the chain to explore some posterior regions that have high posterior probability. For example, consider P( k = 2) = P( k = 4) = 0.499999, P( k = 3) = 0.000002. The resulting chain would generally get stuck in either the k = 2 region of the posterior, or the k = 4 region of the posterior.

## 3.2. Read data

The data take the form of ( x, y ) pairs where x = t in the notation of Section 2.

## 3.3. Find initial knot set

By default, as discussed in Section 2, in the Poisson case the initial knot set is found using logspline. In the normal case evenly-spaced knots are placed and then backward elimination is used. Currently, an option to use evenly-spaced knots is also included for the Poisson case. (A planned improvement is to use every k -th value of t j in the data for both cases.)

## 3.4. Run MCMC

a. It is important to recognize that the Markov chain is on the knot sets ξ (after exact or approximate integration of (2)). As described by DiMatteo et al. (2001), the algorithm randomly selects as a proposal (in the Metropolis sense) either a new knot (a“birth” step), removal of a knot (a“death” step), or a relocation of a knot. Birth and relocation steps begin by randomly selecting a knot, with equal probabilities, from among all knots in the current knot set. If the proposal involves a birth step, then a location for the potential new knot is randomly selected by first randomly selecting an existing knot and then drawing from a beta distribution centered at that knot. This beta distribution is typically quite tight around its center (with spread controlled by an optional user-defined parameter τ ) in order to propose knots that are close to existing knots (as mentioned in Section 2). The same beta distribution is used to propose a knot relocation (the distribution being centered on the knot to be potentially relocated). As usual, the proposal to add, delete, or relocate is evaluated, and possibly accepted, via the Metropolis-Hastings ratio.
