[Page 630]

Section 13.2

Section 13.3

The joint distribution for this model is given by

$$
1 \text { the joint disunion for this model is given by} \\ p ( x _ { 1 } , \dots , x _ { N } , z _ { 1 } , \dots , z _ { N } ) = p ( z _ { 1 } ) \left [ \prod _ { n = 2 } ^ { N } p ( z _ { n } | z _ { n - 1 } ) \right ] \prod _ { n = 1 } ^ { N } p ( x _ { n } | z _ { n } ) . \quad ( 1 3 . 6 ) \\ \text {Using the $d$-separation criterion, we see that there is always a path connecting any}
$$

Using the d-separation criterion, we see that there is always a path connecting any two observed variables x n and x m via the latent variables, and that this path is never blocked. Thus the predictive distribution p ( x n +1 | x 1 ,..., x n ) for observation x n +1 given all previous observations does not exhibit any conditional independence properties, and so our predictions for x n +1 depends on all previous observations. The observed variables, however, do not satisfy the Markov property at any order. We shall discuss how to evaluate the predictive distribution in later sections of this chapter.

There are two important models for sequential data that are described by this graph. If the latent variables are discrete, then we obtain the hidden Markov model , or HMM (Elliott et al. , 1995). Note that the observed variables in an HMM may be discrete or continuous, and a variety of different conditional distributions can be used to model them. If both the latent and the observed variables are Gaussian (with a linear-Gaussian dependence of the conditional distributions on their parents), then we obtain the linear dynamical system .

# 13.2. Hidden Markov Models

The hidden Markov model can be viewed as a speciﬁc instance of the state space model of Figure 13.5 in which the latent variables are discrete. However, if we examine a single time slice of the model, we see that it corresponds to a mixture distribution, with component densities given by p ( x | z ) . It can therefore also be interpreted as an extension of a mixture model in which the choice of mixture component for each observation is not selected independently but depends on the choice of component for the previous observation. The HMM is widely used in speech recognition (Jelinek, 1997; Rabiner and Juang, 1993), natural language modelling (Manning and Sch¨ utze, 1999), on-line handwriting recognition (Nag et al. , 1986), and for the analysis of biological sequences such as proteins and DNA (Krogh et al. , 1994; Durbin et al. , 1998; Baldi and Brunak, 2001).

As in the case of a standard mixture model, the latent variables are the discrete multinomial variables z n describing which component of the mixture is responsible for generating the corresponding observation x n . Again, it is convenient to use a 1 -ofK coding scheme, as used for mixture models in Chapter 9. We now allow the probability distribution of z n to depend on the state of the previous latent variable z n − 1 through a conditional distribution p ( z n | z n − 1 ) . Because the latent variables are K -dimensional binary variables, this conditional distribution corresponds to a table of numbers that we denote by A , the elements of which are known as transition probabilities . They are given by A jk ≡ p ( z nk = 1 | z n − 1 ,j = 1) , and because they are probabilities, they satisfy 0 A jk 1 with k A jk = 1 , so that the matrix A
