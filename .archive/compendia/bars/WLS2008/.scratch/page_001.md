
![image 1](<images/WLS2008/imageFile1.png>)

JSS

# Journal of Statistical Software

June 2008, Volume 26, Issue 1.

http://www.jstatsoft.org/

# An Implementation of Bayesian Adaptive Regression Splines (BARS) in C with S and R Wrappers

Garrick Wallstrom University of Pittsburgh Jeffrey Liebner Carnegie Mellon University

Robert E. Kass Carnegie Mellon University

# Abstract

BARS ( DiMatteo, Genovese, and Kass 2001 ) uses the powerful reversible-jump MCMC engine to perform spline-based generalized nonparametric regression. It has been shown to work well in terms of having small mean-squared error in many examples (smaller than known competitors), as well as producing visually-appealing fits that are smooth (filtering out high-frequency noise) while adapting to sudden changes (retaining high-frequency signal). However, BARS is computationally intensive. The original implementation in S was too slow to be practical in certain situations, and was found to handle some data sets incorrectly. We have implemented BARS in C for the normal and Poisson cases, the latter being important in neurophysiological and other point-process applications. The C implementation includes all needed subroutines for fitting Poisson regression, manipulating B-splines (using code created by Bates and Venables), and finding starting values for Poisson regression (using code for density estimation created by Kooperberg). The code utilizes only freely-available external libraries ( LAPACK and BLAS ) and is otherwise self-contained. We have also provided wrappers so that BARS can be used easily within S or R .

Keywords : curve-fitting, free-knot splines, nonparametric regression, peri-stimulus time histogram, Poisson process.

# 1. Introduction

Figure 1 displays a normalized histogram (called a peri-stimulus time histogram, or PSTH, in the neuroscience literature) of neuronal spiking events across time. This histogram may be considered an estimate of a Poisson process intensity function. Overlaid on the histogram is a Gaussian kernel density estimate (the dotted wiggly line) with bandwidth selected by
