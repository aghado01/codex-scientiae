
# Chapter 1

# Introduction

This chapter is devoted to a brief introduction to the methodology of nonparametric regression and time series. The idea is to estimate an unknown function via a finite number of basis functions. The estimation is done by using Penalized Splines (P-splines). The thesis first describes the methodology of nonparametric regression. Secondly, in Chapter 2 it will be shown that P-splines have a Linear Mixed Model (LMM) representation which can naturally be handled using a Bayesian approach. Thirdly, Chapter 3 explores spatially adaptive P-splines. These models are useful when the degree of smoothness of the underlying function varies with the covariate. Lastly, we employ spatially adaptive penalized splines in spectral estimation in Chapter 4, followed by an application to a real data set in Chapter 5. Simulations are done for each method. Markov chain Monte Carlo (MCMC) methods are used throughout the study.

# 1.1 Basis Functions

The use of P-splines was popularized by Eilers and Marx (1996). The methodology relies on a relatively small number of basis functions. Although, there is a wide variety of basis functions available, in what follows, we use truncated polynomials (Ruppert et al., 2003) given by

$$
( x - \kappa ) _ { + } ^ { p } = \begin{cases} \ ( x - \kappa ) ^ { p } & \text {if } x \geq \kappa \\ 0 & \text {otherwise } . \end{cases}
$$

 The function $(x - \kappa)_+^p$ is constructed using a covariate value $x$ and a knot $\kappa$ that is located in the range of the covariate space. Any function of the above form is referred to as a
