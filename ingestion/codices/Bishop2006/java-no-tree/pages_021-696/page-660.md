[Page 660]

zn−1 zn zn

Figure 13.21 The linear dynamical system can be viewed as a sequence of steps in which increasing uncertainty in the state variable due to diffusion is compensated by the arrival of new data. In the left-hand plot, the blue curve shows the distribution p(zn−1|x1, . . . , xn−1), which incorporates all the data up to step n − 1. The diffusion arising from the nonzero variance of the transition probability p(zn|zn−1) gives the distribution p(zn|x1, . . . , xn−1), shown in red in the centre plot. Note that this is broader and shifted relative to the blue curve (which is shown dashed in the centre plot for comparison). The next data observation xn contributes through the emission density p(xn|zn), which is shown as a function of zn in green on the right-hand plot. Note that this is not a density with respect to zn and so is not normalized to one. Inclusion of this new data point leads to a revised distribution p(zn|x1, . . . , xn) for the state density shown in blue. We see that observation of the data has shifted and narrowed the distribution compared to p(zn|x1, . . . , xn−1) (which is shown in dashed in the right-hand plot for comparison).

If we consider a situation in which the measurement noise is small compared to the rate at which the latent variable is evolving, then we ﬁnd that the posterior

- Exercise 13.27 distribution for zn depends only on the current measurement xn, in accordance with the intuition from our simple example at the start of the section. Similarly, if the latent variable is evolving slowly relative to the observation noise level, we ﬁnd that the posterior mean for zn is obtained by averaging all of the measurements obtained
- Exercise 13.28 up to that time. One of the most important applications of the Kalman ﬁlter is to tracking, and


this is illustrated using a simple example of an object moving in two dimensions in Figure 13.22.

So far, we have solved the inference problem of ﬁnding the posterior marginal for a node zn given observations from x1 up to xn. Next we turn to the problem of ﬁnding the marginal for a node zn given all observations x1 to xN. For temporal data, this corresponds to the inclusion of future as well as past observations. Although this cannot be used for real-time prediction, it plays a key role in learning the parameters of the model. By analogy with the hidden Markov model, this problem can be solved by propagating messages from node xN back to node x1 and combining this information with that obtained during the forward message passing stage used to compute the α(zn).

In the LDS literature, it is usual to formulate this backward recursion in terms

of γ(zn) = α(zn) β(zn) rather than in terms of β(zn). Because γ(zn) must also be Gaussian, we write it in the form

γ(zn) = α(zn) β(zn) = N(zn| µn, Vn). (13.98) To derive the required recursion, we start from the backward recursion (13.62) for
