[Page 1]

# Bayesian Curve-Fitting with Free-Knot Splines

**Ilaria Di Matteo, Christopher R. Genovese and Robert E. Kass**

Department of Statistics, Carnegie Mellon University, Pittsburgh, Pennsylvania 15213, U.S.A.

dimatteo@stat.cmu.edu genovese@stat.cmu.edu kass@stat.cmu.edu

## Summary

We describe a Bayesian method, for fitting curves to data drawn from an exponential family, that uses splines for which the number and locations of knots are free parameters. The method uses reversible-jump Markov chain Monte Carlo to change the knot configurations and a locality heuristic to speed up mixing. For nonnormal models, we approximate the integrated likelihood ratios needed to compute acceptance probabilities by using the Bayesian information criterion, BIC, under priors that make this approximation accurate. Our technique is based on a marginalised chain on the knot number and locations, but we provide methods for inference about the regression coefficients, and functions of them, in both normal and nonnormal models. Simulation results suggest that the method performs well, and we illustrate the method in two neuroscience applications.

Some key words: BIC; Generalised linear model; Nonparametric regression; Reversible-jump Markov chain Monte Carlo; Smoothing; Unit-information prior.

## 1. Introduction

Smoothing splines are often appealing tools for curve estimation because they provide computationally efficient estimation. They tend to do a good job in smoothing noisy data, and they have both frequentist and Bayesian interpretations (Hastie & Tibshirani, 1990; Wahba, 1990). However, in practice, smoothing splines have two shortcomings: they require specification of a global smoothness parameter; and, conditionally on the choice of smoothness, they are linear estimators and thus have difficulty adapting to functions that are heterogeneous over their domains. The first problem has been addressed through various data-driven methods, such as crossvalidation, for choosing the smoothness parameter, but such methods are not convincing in small samples and they offer no measure of uncertainty in the estimated smoothness. The second problem is more fundamental. Whereas smoothing splines use many knots located at the data, an alternative that has been explored is to use fewer knots that are well placed (Denison et al., 1998; Lindstrom, 1999; Zhou & Shen, 2001; Biller, 2000; Hansen & Kooperberg, 2000; Halpern, 1973; Genovese, 2000; Eilers & Marx, 1996; Smith & Kohn, 1996). This approach is often called curve-fitting with free-knot splines because the number of knots and their locations are determined from the data.

In this paper, we describe a fully Bayesian method for curve-fitting with free-knot splines for data drawn from an exponential family distribution, which we call Bayesian adaptive regression splines. Our implementation is based on reversible-jump Markov chain Monte Carlo (Green, 1995) and incorporates a key observation made by Zhou & Shen (2001). We compare our method's performance to both the Bayesian method of Denison et al. (1998) and the frequentist, iterative spatially adaptive regression spline method of Zhou & Shen (2001). Our method gives more accurate estimates of our test function than either of the others.
