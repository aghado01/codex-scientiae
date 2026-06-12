[Page 16]

t ∼ beta ( α = sτ,β = (1 − s ) τ ) ξ cand ← ( ξ curr ∪ { t } ) \ { s } k cand ← k curr Form the natural spline design basis for M cand → X D, cand Fit the Poisson regression model for M cand if (ﬁt of M cand failed) accept probability = 0 else dens 1 ← q ( M cand | M curr ) k curr = f beta ( t | α = sτ,β = (1 − s ) τ ) dens 2 ← q ( M curr | M cand ) k cand = f beta ( s | α = tτ,β = (1 − t ) τ ) accept probability = exp(   cand −   curr + log( dens 1 ) − log( dens 2 )) u ∼ U (0, 1) if ( u < accept probability ) comment: Candidate model accepted. Swap M curr and M cand.M temp ← M curr M curr ← M cand M cand ← M temp if ( i > = burnin iterations ) comment: Beyond the burn-in period. Generate Random Coeﬃcient Vector for M curr.See function description below. Calculate BIC curr and   curr for the full model using parameter values ( k curr,ξ curr,β curr ). µ D, curr ← exp( X D, curr β curr ) Form the natural spline grid basis for M curr → X G, curr µ G, curr ← exp( X G, curr β curr ) comment: Find mode and the mean function evaluated at the mode. In neuron ﬁring examples, it produces the location of the peak ﬁring rate, and the peak ﬁring rate. Use µ G, curr to form an interpolating spline. Locate mode of interpolating spline → ( x mode,µ curr ( x mode )) Write desired parameters to a ﬁle. Store desired parameters for later use. comment: update posterior modal values, if appropriate if (( BIC curr > maxBIC ) or ( i == burnin iterations )) maxBIC ← BIC curr parameter modes ← current parameter values

Use partial sorting to form conﬁdence intervals of desired stored parameters.

Calculate means of desired stored parameters.

return
