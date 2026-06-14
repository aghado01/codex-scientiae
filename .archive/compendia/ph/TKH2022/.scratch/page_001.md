[Page 1]

![image 2](<TKH2022/imageFile2.png>)

# Systems biology

## Topological approximate Bayesian computation for parameter inference of an angiogenesis model

![image 1](<TKH2022/imageFile1.png>)

Thomas Thorne 1, *, Paul D. W. Kirk 2,3,4 and Heather A. Harrington 5,6, *

1 Department of Computer Science, University of Surrey, Guildford GU2 7XH, UK, 2 MRC Biostatistics Unit, University of Cambridge, Cambridge CB2 0SR, UK, 3 Cambridge Institute of Therapeutic Immunology & Infectious Disease (CITIID), University of Cambridge, Cambridge CB2 0AW, UK, 4 Cancer Research UK Cambridge Centre, Ovarian Cancer Programme, Cambridge CB2 0RE, UK, 5 Mathematical Institute, University of Oxford, Oxford OX2 6GG, UK and 6 Wellcome Centre for Human Genetics, University of Oxford, Oxford OX3 7BN, UK

*To whom correspondence should be addressed. Associate Editor: Jonathan Wren

Received on October 29, 2021; revised on February 7, 2022; editorial decision on February 14, 2022; accepted on February 18, 2022

## Abstract

Motivation: Inferring the parameters of models describing biological systems is an important problem in the reverse engineering of the mechanisms underlying these systems. Much work has focused on parameter inference of stochastic and ordinary differential equation models using Approximate Bayesian Computation (ABC). While there is some recent work on inference in spatial models, this remains an open problem. Simultaneously, advances in topological data analysis (TDA), a ﬁeld of computational mathematics, have enabled spatial patterns in data to be characterized.

Results: Here, we focus on recent work using TDA to study different regimes of parameter space for a well-studied model of angiogenesis. We propose a method for combining TDA with ABC to infer parameters in the Anderson– Chaplain model of angiogenesis. We demonstrate that this topological approach outperforms ABC approaches that use simpler statistics based on spatial features of the data. This is a ﬁrst step toward a general framework of spatial parameter inference for biological systems, for which there may be a variety of ﬁltrations, vectorizations and summary statistics to be considered.

Availability and implementation: All code used to produce our results is available as a Snakemake workﬂow from github.com/tt104/tabc_angio.

Contact: tom.thorne@surrey.ac.uk or harrington@maths.ox.ac.uk

## 1 Introduction

When analyzing mathematical models of biological systems, we often aim to reverse engineer the parameters of the model by fitting to observed data. The Bayesian formalism provides a principled way to perform parameter inference that quantifies our uncertainty in the model parameters (see, e.g. Kirk et al. , 2015 ), but traditionally requires us to be able to write down an analytical function (the likelihood function) that returns the likelihood of a parameter vector given the observed data.

However, for many models of interest, there is no straightforward way to write down the likelihood function associated with the model. This is often due to the intractability of deriving a closed form expression for the model likelihood. In such situations, it may nevertheless be possible to apply a simulation-based inference approach termed Approximate Bayesian Computation (ABC; see, for example, Sisson et al. , 2018), that substitutes a kernel on some statistics of the data for the model likelihood, and evaluates the fit of the model at a given set of parameter values through simulations. For given parameter realizations, the model is simulated, and the statistics of the simulated data compared with the same statistics of the observed data. Informally, regions of parameter space that correspond to simulated datasets whose statistics are 'more similar' to those of the observed data will be associated with higher posterior probability than regions corresponding to simulated datasets with statistics that are 'less similar' (where 'similarity' is quantified using a pre-specified distance function).

Applying ABC, we can derive an approximate posterior distribution over the model parameters using standard sampling techniques such as rejection sampling. This approximate posterior distribution expresses our uncertainty in the model parameters, given the model and the observed dataset. Recently, ABC parameter inference and model selection has been successfully developed for reaction-diffusion models ( Warne et al. , 2019 ). However, performing parameter inference for more general spatial models has been largely unexplored.

V C The Author(s) 2022. Published by Oxford University Press.
