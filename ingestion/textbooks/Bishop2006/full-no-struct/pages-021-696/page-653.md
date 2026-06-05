[Page 653]

Figure 13.18 Example of an input-output hidden Markov model. In this case, both the emission probabilities and the transition probabilities depend on the values of a sequence of observations u 1 , . . . , u N .

![In the image there are four circles connected by a line. Each circle has a different color. The circles are connected by a line.](../images/imageFile318.png)

-

n

n

1

+1

n

u

u

u

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

Exercise 13.18

We have seen that the autoregressive HMM appears as a natural extension of the standard HMM when viewed as a graphical model. In fact the probabilistic graphical modelling viewpoint motivates a plethora of different graphical structures based on the HMM. Another example is the input-output hidden Markov model (Bengio and Frasconi, 1995), in which we have a sequence of observed variables u 1 ,..., u N , in addition to the output variables x 1 ,..., x N , whose values inﬂuence either the distribution of latent variables or output variables, or both. An example is shown in Figure 13.18. This extends the HMM framework to the domain of supervised learning for sequential data. It is again easy to show, through the use of the d-separation criterion, that the Markov property (13.5) for the chain of latent variables still holds. To verify this, simply note that there is only one path from node z n − 1 to node z n +1 and this is head-to-tail with respect to the observed node z n . This conditional independence property again allows the formulation of a computationally efﬁcient learning algorithm. In particular, we can determine the parameters θ of the model by maximizing the likelihood function L ( θ ) = p ( X | U , θ ) where U is a matrix whose rows are given by u T n . As a consequence of the conditional independence property (13.5) this likelihood function can be maximized efﬁciently using an EM algorithm in which the E step involves forward and backward recursions.

Another variant of the HMM worthy of mention is the factorial hidden Markov model (Ghahramani and Jordan, 1997), in which there are multiple independent
