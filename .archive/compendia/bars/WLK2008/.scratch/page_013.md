[Page 13]

Remove knots through backwards elimination until a subset is found such that 1) the model fit does not fail, 2) the model has the greatest likelihood among the models with the same number of knots in which the fit does not fail, and 3) the knot subset has positive prior probability. If all models with a given number of knots fail to be fit, the model in which has the smallest condition number is selected, and the procedure continues by trying to remove an additional knot.

$$
$$
< If backwards elimination fails to find a valid subset, the procedure tries to fit a model with the minimum number of knots that have positive prior probability, with the knots equally spaced.
   If the model fails to be fit, exit.

   Set M curr to the resulting model.

   maxBIC <- 0

   total iterations -- burnin iterations + sampling iterations

   for i <- 0 to total iterations - 1

   u ~ U(0, 1)

   if (u < birth probability)

   s ~ Discrete Uniform(ccurr)

   t ~ beta(a = (st, \beta = (1 - s).t)

   \cand <- (ccurr U  {t}) \ {s}

   kand <- kcurr + 1

   Form the natural spline design basis for M cand -> XD,cand

   Fit the Poisson regression model for M cand:

   if (fit of M cand failed) accept probability = 0

   else

   dens <- q(Mcand|Mcurr)kcurr = \r=ccurrbeta(t|a = rt, \beta = (1 - r).t)

   accept probability = exp(l(cand - \ccurr + log(kcurr) - log(dens) - 0.5 log(n)))

   comment::*l in the above equation is the profile likelihood, \* = supp(c(*, k*, \beta)

   else if (1 - u < death probability)

   t ~ Discrete Uniform(ccurr)

   \cand <- \ccurr \ {t}



          J Stat Software. Author manuscript; available in PMC 2009 September 22.
$$


$$
