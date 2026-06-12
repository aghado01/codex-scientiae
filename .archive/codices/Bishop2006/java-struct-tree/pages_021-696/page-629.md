[Page 629]

Figure 13.5 We can represent sequential data using a Markov chain of latent variables, with each observation conditioned on the state of the corresponding latent variable. This important graphical structure forms the foundation both for the hidden Markov model and for linear dynamical systems.

z1 z2

x1 x2

zn−1 zn zn+1

xn−1 xn xn+1

Each observation is now inﬂuenced by two previous observations. We can similarly consider extensions to an Mth order Markov chain in which the conditional distribution for a particular variable depends on the previous M variables. However, we have paid a price for this increased ﬂexibility because the number of parameters in the model is now much larger. Suppose the observations are discrete variables having K states. Then the conditional distribution p(xn|xn−1) in a ﬁrst-order Markov chain will be speciﬁed by a set of K −1 parameters for each of the K states of xn−1 giving a total of K(K − 1) parameters. Now suppose we extend the model to an Mth order Markov chain, so that the joint distribution is built up from conditionals p(xn|xn−M,...,xn−1). If the variables are discrete, and if the conditional distributions are represented by general conditional probability tables, then the number of parameters in such a model will have KM−1(K − 1) parameters. Because this grows exponentially with M, it will often render this approach impractical for larger values of M.

For continuous variables, we can use linear-Gaussian conditional distributions in which each node has a Gaussian distribution whose mean is a linear function of its parents. This is known as an autoregressive or AR model (Box et al., 1994; Thiesson et al., 2004). An alternative approach is to use a parametric model for p(xn|xn−M,...,xn−1) such as a neural network. This technique is sometimes called a tapped delay line because it corresponds to storing (delaying) the previous M values of the observed variable in order to predict the next value. The number of parameters can then be much smaller than in a completely general model (for example it may grow linearly with M), although this is achieved at the expense of a restricted family of conditional distributions.

Suppose we wish to build a model for sequences that is not limited by the Markov assumption to any order and yet that can be speciﬁed using a limited number of free parameters. We can achieve this by introducing additional latent variables to permit a rich class of models to be constructed out of simple components, as we did with mixture distributions in Chapter 9 and with continuous latent variable models in Chapter 12. For each observation xn, we introduce a corresponding latent variable zn (which may be of different type or dimensionality to the observed variable). We now assume that it is the latent variables that form a Markov chain, giving rise to the graphical structure known as a state space model, which is shown in Figure 13.5. It satisﬁes the key conditional independence property that zn−1 and zn+1 are independent given zn, so that

zn+1 ⊥⊥ zn−1 | zn. (13.5)
