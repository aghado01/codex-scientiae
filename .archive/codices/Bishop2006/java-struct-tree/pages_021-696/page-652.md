[Page 652]

Figure 13.17 Section of an autoregressive hidden Markov model, in which the distribution of the observation xn depends on a subset of the previous observations as well as on the hidden state zn. In this example, the distribution of xn depends on the two previous observations xn−1 and xn−2.

zn−1 zn zn+1

xn−1 xn xn+1

requires that every training sequence be evaluated under each of the models in order to compute the denominator in (13.73). Hidden Markov models, coupled with discriminative training methods, are widely used in speech recognition (Kapadia, 1998).

A signiﬁcant weakness of the hidden Markov model is the way in which it represents the distribution of times for which the system remains in a given state. To see the problem, note that the probability that a sequence sampled from a given hidden Markov model will spend precisely T steps in state k and then make a transition to a different state is given by

p(T) = (Akk)T(1 − Akk) ∝ exp(−T lnAkk) (13.74)

and so is an exponentially decaying function of T. For many applications, this will be a very unrealistic model of state duration. The problem can be resolved by modelling state duration directly in which the diagonal coefﬁcients Akk are all set to zero, and each state k is explicitly associated with a probability distribution p(T|k) of possible duration times. From a generative point of view, when a state k is entered, a value T representing the number of time steps that the system will remain in state k is then drawn from p(T|k). The model then emits T values of the observed variable xt, which are generally assumed to be independent so that the corresponding emission density is simply

�T

t=1 p(xt|k). This approach requires some straightforward modiﬁcations to the EM optimization procedure (Rabiner, 1989).

Another limitation of the standard HMM is that it is poor at capturing longrange correlations between the observed variables (i.e., between variables that are separated by many time steps) because these must be mediated via the ﬁrst-order Markov chain of hidden states. Longer-range effects could in principle be included by adding extra links to the graphical model of Figure 13.5. One way to address this is to generalize the HMM to give the autoregressive hidden Markov model (Ephraim et al., 1989), an example of which is shown in Figure 13.17. For discrete observations, this corresponds to expanded tables of conditional probabilities for the emission distributions. In the case of a Gaussian emission density, we can use the linearGaussian framework in which the conditional distribution for xn given the values of the previous observations, and the value of zn, is a Gaussian whose mean is a linear combination of the values of the conditioning variables. Clearly the number of additional links in the graph must be limited to avoid an excessive the number of free parameters. In the example shown in Figure 13.17, each observation depends on
