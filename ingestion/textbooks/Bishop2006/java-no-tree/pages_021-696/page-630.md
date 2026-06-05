[Page 630]

The joint distribution for this model is given by

p(x1,...,xN,z1,...,zN) = p(z1)

N

p(zn|zn−1)

n=2

N

p(xn|zn). (13.6)

n=1

Using the d-separation criterion, we see that there is always a path connecting any two observed variables xn and xm via the latent variables, and that this path is never blocked. Thus the predictive distribution p(xn+1|x1,...,xn) for observation xn+1 given all previous observations does not exhibit any conditional independence properties, and so our predictions for xn+1 depends on all previous observations. The observed variables, however, do not satisfy the Markov property at any order. We shall discuss how to evaluate the predictive distribution in later sections of this chapter.

There are two important models for sequential data that are described by this graph. If the latent variables are discrete, then we obtain the hidden Markov model,

- Section 13.2 or HMM (Elliott et al., 1995). Note that the observed variables in an HMM may be discrete or continuous, and a variety of different conditional distributions can be used to model them. If both the latent and the observed variables are Gaussian (with a linear-Gaussian dependence of the conditional distributions on their parents), then
- Section 13.3 we obtain the linear dynamical system.


###### 13.2. Hidden Markov Models

The hidden Markov model can be viewed as a speciﬁc instance of the state space model of Figure 13.5 in which the latent variables are discrete. However, if we examine a single time slice of the model, we see that it corresponds to a mixture distribution, with component densities given by p(x|z). It can therefore also be interpreted as an extension of a mixture model in which the choice of mixture component for each observation is not selected independently but depends on the choice of component for the previous observation. The HMM is widely used in speech recognition (Jelinek, 1997; Rabiner and Juang, 1993), natural language modelling (Manning and Sch¨utze, 1999), on-line handwriting recognition (Nag et al., 1986), and for the analysis of biological sequences such as proteins and DNA (Krogh et al., 1994; Durbin et al., 1998; Baldi and Brunak, 2001).

As in the case of a standard mixture model, the latent variables are the discrete multinomial variables zn describing which component of the mixture is responsible for generating the corresponding observation xn. Again, it is convenient to use a 1-of-K coding scheme, as used for mixture models in Chapter 9. We now allow the probability distribution of zn to depend on the state of the previous latent variable zn−1 through a conditional distribution p(zn|zn−1). Because the latent variables are K-dimensional binary variables, this conditional distribution corresponds to a table of numbers that we denote by A, the elements of which are known as transition probabilities. They are given by Ajk ≡ p(znk = 1|zn−1,j = 1), and because they are probabilities, they satisfy 0 Ajk 1 with k Ajk = 1, so that the matrix A
