[Page 2]

# Reversible jump Markov chain Monte Carlo computation and Bayesian model determination

**Peter J. Green**

Department of Mathematics; University of Bristol, Bristol BS8 1TW, UK.

## Summary

Markov chain Monte Carlo methods for Bayesian computation have until recently been restricted to problems  where the joint distribution of all variables has a density with respect to some fixed standard underlying measure. have therefore not been available for application to Bayesian model determination; where the dimensionality of the parameter vector is typically not fixed. This paper proposes a new framework for the construction of reversible Markov chain samplers that jump between parameter subspaces of differing dimensionality, which is flexible and entirely constructive It should therefore have wide applicability in model determination problems. The methodology is illustrated with appli cations to multiple change-point analysis in one and two dimensions; and to a Bayesian comparison of binomial experiments: They

Some key words: Change-point analysis; Image segmentation; Jump diffusion; Markov chain Monte Carlo; Multiple binomial experiments; Multiple shrinkage; Step function; Voronoi tessellation.

## 1. Introduction

There are a number of challenging statistical problems; often involving inference about curves; surfaces or images, where the dimension of the object of inference is not fixed. One example discussed in detail later in this paper concerns the multiple change-point problem for Poisson processes; where it is assumed that the rate is piecewise constant; but changes an unknown number of times. The times of change and the different rates are unknown. The object of inference is therefore a step function.

There are many problems of broadly similar vein; with the same general ingredients: a discrete choice   between a set of  models, a parameter vector with an interpretation depending on the model in question; and data, influenced by the model and parameter values, to be used as a basis for inference. Some examples are:

(a) factorial experiments, with a allowing factor effects to tie; prior

variable selection in regression;

non-nested regression models;

mixture deconvolution with an unknown number of components;

Bayesian choice between models with different numbers of parameters;

(f) multiple change-point problems;

image segmentation; the two-dimensional analogue of the change-point problem;

(h) object recognition; approached via marked spatial processes. point

Model criticism; model choice, model selection; model averaging, etc, all require the same basic computational tasks; and it is a technology for these tasks that is the focus here. The aim of this paper is to add further weight to the assertions (i) that a Bayesian approach is attractive for such problems; and (ii) that the computations for such inference can be handled by Markov chain Monte Carlo methods. In particular, in $ 3 we introduce à novel class of such methods capable of jumping between subspaces of differing dimensionality. This   considerably  extends the scope of   Metropolis-Hastings  methods; and applies to very many varying-dimension problems.
