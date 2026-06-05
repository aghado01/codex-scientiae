[Page 633]

1

1

0.5

k = 1

k = 2

k = 3

0.5

0

0 0.5 1

0

0 0.5 1

Figure 13.8 Illustration of sampling from a hidden Markov model having a 3-state latent variable z and a Gaussian emission model p(x|z) where x is 2-dimensional. (a) Contours of constant probability density for the emission distributions corresponding to each of the three states of the latent variable. (b) A sample of 50 points drawn from the hidden Markov model, colour coded according to the component that generated them and with lines connecting the successive observations. Here the transition matrix was ﬁxed so that in any state there is a 5% probability of making a transition to each of the other states, and consequently a 90% probability of remaining in the same state.

Gaussians, we ﬁrst chose one of the components at random with probability given by the mixing coefﬁcients πk and then generate a sample vector x from the corresponding Gaussian component. This process is repeated N times to generate a data set of N independent samples. In the case of the hidden Markov model, this procedure is modiﬁed as follows. We ﬁrst choose the initial latent variable z1 with probabilities governed by the parameters πk and then sample the corresponding observation x1. Now we choose the state of the variable z2 according to the transition probabilities p(z2|z1) using the already instantiated value of z1. Thus suppose that the sample for z1 corresponds to state j. Then we choose the state k of z2 with probabilities Ajk for k = 1,...,K. Once we know z2 we can draw a sample for x2 and also sample the next latent variable z3 and so on. This is an example of ancestral sampling for

Section 8.1.2 a directed graphical model. If, for instance, we have a model in which the diagonal transition elements Akk are much larger than the off-diagonal elements, then a typical data sequence will have long runs of points generated from a single component, with infrequent transitions from one component to another. The generation of samples from a hidden Markov model is illustrated in Figure 13.8.

There are many variants of the standard HMM model, obtained for instance by imposing constraints on the form of the transition matrix A (Rabiner, 1989). Here we mention one of particular practical importance called the left-to-right HMM, which is obtained by setting the elements Ajk of A to zero if k < j, as illustrated in the
