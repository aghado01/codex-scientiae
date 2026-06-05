[Page 654]

Figure 13.19 A factorial hidden Markov model comprising two Markov chains of latent variables. For continuous observed variables x , one possible choice of emission model is a linear-Gaussian density in which the mean of the Gaussian is a linear combination of the states of the corresponding latent variables.

![In this image, we can see a diagram with some lines and points.](../images/imageFile319.png)

z (2)

z (2)

(2)

-

n

n

1

+1

n

z

z

z

z (1)

z (1)

(1)

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

Markov chains of latent variables, and the distribution of the observed variable at a given time step is conditional on the states of all of the corresponding latent variables at that same time step. Figure 13.19 shows the corresponding graphical model. The motivation for considering factorial HMM can be seen by noting that in order to represent, say, 10 bits of information at a given time step, a standard HMM would need K = 2 10 = 1024 latent states, whereas a factorial HMM could make use of 10 binary latent chains. The primary disadvantage of factorial HMMs, however, lies in the additional complexity of training them. The M step for the factorial HMM model is straightforward. However, observation of the x variables introduces dependencies between the latent chains, leading to difﬁculties with the E step. This can be seen by noting that in Figure 13.19, the variables z (1) n and z (2) n are connected by a path which is head-to-head at node x n and hence they are not d-separated. The exact E step for this model does not correspond to running forward and backward recursions along the M Markov chains independently. This is conﬁrmed by noting that the key conditional independence property (13.5) is not satisﬁed for the individual Markov chains in the factorial HMM model, as is shown using d-separation in Figure 13.20. Now suppose that there are M chains of hidden nodes and for simplicity suppose that all latent variables have the same number K of states. Then one approach would be to note that there are K M combinations of latent variables at a given time step

Figure 13.20

Example of a path, highlighted in green, which is head-to-head at the observed nodes x n − 1 and x n +1 , and head-to-tail at the unobserved nodes z (2) n − 1 , z (2) n and z (2) n +1 . Thus the path is not blocked and so the conditional independence property (13.5) does not hold for the individual latent chains of the factorial HMM model. As a consequence, there is no efﬁcient exact E step for this model.

![In the image there is a diagram with a line diagram. The diagram has a circle on the left side. There are two lines on the right side of the diagram. There are two points on the left side of the diagram.](../images/imageFile320.png)

z (2)

z (2)

(2)

-

n

n

1

+1

n

z

z

z

z (1)

z (1)

(1)

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
