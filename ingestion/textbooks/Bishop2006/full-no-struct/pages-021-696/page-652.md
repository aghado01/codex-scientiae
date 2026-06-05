[Page 652]

Figure 13.17

![The image depicts a diagram with four interconnected circles, each representing a different variable. The circles are connected by lines, and the labels on the circles indicate the values of the variables. Here is a detailed description of the image: 1. **Circle 1**: - **Label**: The first circle is labeled Zn-1. - **Value**: The value of Zn-1 is represented by the label Zn-1. 2. **Circle 2**: - **Label**: The second circle is labeled Zn-2. - **Value**: The value of Zn-2 is represented by the label Zn-2. 3. **Circle 3**: - **Label**: The third circle is labeled Zn-3. - **Value**: The value of Zn-3 is represented by the label Zn-3. 4. **Circle 4**: -](../images/imageFile317.png)

-

n

n

1

+1

n

z

z

z

-

n

n

1

+1

n

x

x

x

requires that every training sequence be evaluated under each of the models in order to compute the denominator in (13.73). Hidden Markov models, coupled with discriminative training methods, are widely used in speech recognition (Kapadia, 1998).

A signiﬁcant weakness of the hidden Markov model is the way in which it represents the distribution of times for which the system remains in a given state. To see the problem, note that the probability that a sequence sampled from a given hidden Markov model will spend precisely T steps in state k and then make a transition to a different state is given by

$$
p ( T ) = ( A _ { k k } ) ^ { T } ( 1 - A _ { k k } ) \, \infty \, \exp \left ( - T \ln A _ { k k } \right )
$$

and so is an exponentially decaying function of T . For many applications, this will be a very unrealistic model of state duration. The problem can be resolved by modelling state duration directly in which the diagonal coefﬁcients A kk are all set to zero, and each state k is explicitly associated with a probability distribution p ( T | k ) of possible duration times. From a generative point of view, when a state k is entered, a value T representing the number of time steps that the system will remain in state k is then drawn from p ( T | k ) . The model then emits T values of the observed variable x t , which are generally assumed to be independent so that the corresponding emission density is simply T t =1 p ( x t | k ) . This approach requires some straightforward modiﬁcations to the EM optimization procedure (Rabiner, 1989). Another limitation of the standard HMM is that it is poor at capturing long-

Another limitation of the standard HMM is that it is poor at capturing longrange correlations between the observed variables (i.e., between variables that are separated by many time steps) because these must be mediated via the first-order Markov chain of hidden states. Longer-range effects could in principle be included by adding extra links to the graphical model of Figure 13.5. One way to address this is to generalize the HMM to give the autoregressive hidden Markov model (Ephraim et al. , 1989), an example of which is shown in Figure 13.17. For discrete observations, this corresponds to expanded tables of conditional probabilities for the emission distributions. In the case of a Gaussian emission density, we can use the linearGaussian framework in which the conditional distribution for x n given the values of the previous observations, and the value of z n , is a Gaussian whose mean is a linear combination of the values of the conditioning variables. Clearly the number of additional links in the graph must be limited to avoid an excessive the number of free parameters. In the example shown in Figure 13.17, each observation depends on the two preceding observed variables as well as on the hidden state. Although this graph looks messy, we can again appeal to d-separation to see that in fact it still has a simple probabilistic structure. In particular, if we imagine conditioning on z n we see that, as with the standard HMM, the values of z n -1 and z n +1 are independent, corresponding to the conditional independence property (13.5). This is easily verified by noting that every path from node z n -1 to node z n +1 passes through at least one observed node that is head-to-tail with respect to that path. As a consequence, we can again use a forward-backward recursion in the E step of the EM algorithm to determine the posterior distributions of the latent variables in a computational time that is linear in the length of the chain. Similarly, the M step involves only a minor modification of the standard M-step equations. In the case of Gaussian emission densities this involves estimating the parameters using the standard linear regression equations, discussed in Chapter 3.
