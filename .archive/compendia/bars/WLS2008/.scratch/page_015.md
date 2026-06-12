
Remove knots through backwards elimination until a subset is found such that 1) the model fit does not fail, 2) the model has the greatest likelihood among the models with the same number of knots in which the fit does not fail, and 3) the knot subset has positive prior probability. If all models with a given number of knots fail to be fit, the model in which X D WX D has the smallest condition number is selected, and the procedure continues by trying to remove an additional knot.

If backwards elimination fails to find a valid subset, the procedure tries to fit a model with the minimum number of knots that have positive prior probability, with the knots equally spaced. If the model fails to be fit, exit .

Set M curr to the resulting model.

maxBIC



total iterations ← burnin iterations + sampling iterations for i ← 0 to total iterations − 1 u ∼ U (0 , 1) if ( u < birth probability ) s ∼ Discrete Uniform( ξ curr ) t ∼ beta ( α = sτ,β = (1 − s ) τ ) ξ cand ← ξ curr ∪ { t } k cand ← k curr + 1 Form the natural spline design basis for M cand → X D, cand Fit the Poisson regression model for M cand . if (fit of M cand failed) accept probability = 0 else dens ← q ( M cand | M curr ) k curr =   r ∈ ξ curr f beta ( t | α = rτ,β = (1 − r ) τ ) accept probability = exp(   cand −   curr + log( k curr ) − log( dens ) − 0 . 5log( n )) comment:   ∗ in the above equation is the profile likelihood,   ∗ = sup β   ( ξ ∗ ,k ∗ ,β ) else if (1 − u < death probability ) t ∼ Discrete Uniform( ξ curr ) ξ cand ← ξ curr \ { t } k cand ← k curr − 1 Form the natural spline design basis for M cand → X D, cand Fit the Poisson regression model for M cand . See function description below. if (fit of M cand failed) accept probability = 0 else dens ← q ( M curr | M cand ) k cand =   r ∈ ξ cand f beta ( t | α = rτ,β = (1 − r ) τ ) accept probability = exp(   cand −   curr − log( k cand )+log( dens )+0 . 5log( n )) else s ∼ Discrete Uniform( ξ curr )
