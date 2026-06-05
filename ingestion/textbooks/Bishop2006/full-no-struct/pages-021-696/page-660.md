[Page 660]

![The image consists of three different graphs, each with a different title and a specific color. The graphs are labeled as follows: 1. The first graph is titled Lambda and has a blue line with a dashed line. The dashed line is a horizontal line that is not drawn. The graph is labeled as Lambda and has a horizontal axis labeled 2n-1 and a vertical axis labeled 2n. 2. The second graph is titled Lambda and has a blue line with a dashed line. The dashed line is a horizontal line that is not drawn. The graph is labeled as Lambda and has a horizontal axis labeled 2n-1 and a vertical axis labeled 2n. 3. The third graph is titled Lambda and has a green line with a dashed line. The dashed line is a horizontal line that is not drawn. The graph is labeled as Lambda and has a horizontal](../images/imageFile321.png)

z

z

z

-

n

1

n

n

Figure 13.21 The linear dynamical system can be viewed as a sequence of steps in which increasing uncertainty in the state variable due to diffusion is compensated by the arrival of new data. In the left-hand plot, the blue curve shows the distribution p ( z n − 1 | x 1 , . . . , x n − 1 ) , which incorporates all the data up to step n − 1 . The diffusion arising from the nonzero variance of the transition probability p ( z n | z n − 1 ) gives the distribution p ( z n | x 1 , . . . , x n − 1 ) , shown in red in the centre plot. Note that this is broader and shifted relative to the blue curve (which is shown dashed in the centre plot for comparison). The next data observation x n contributes through the emission density p ( x n | z n ) , which is shown as a function of z n in green on the right-hand plot. Note that this is not a density with respect to z n and so is not normalized to one. Inclusion of this new data point leads to a revised distribution p ( z n | x 1 , . . . , x n ) for the state density shown in blue. We see that observation of the data has shifted and narrowed the distribution compared to p ( z n | x 1 , . . . , x n − 1 ) (which is shown in dashed in the right-hand plot for comparison).

Exercise 13.27

Exercise 13.28

If we consider a situation in which the measurement noise is small compared to the rate at which the latent variable is evolving, then we ﬁnd that the posterior distribution for z n depends only on the current measurement x n , in accordance with the intuition from our simple example at the start of the section. Similarly, if the latent variable is evolving slowly relative to the observation noise level, we ﬁnd that the posterior mean for z n is obtained by averaging all of the measurements obtained up to that time.

One of the most important applications of the Kalman ﬁlter is to tracking, and this is illustrated using a simple example of an object moving in two dimensions in Figure 13.22.

So far, we have solved the inference problem of ﬁnding the posterior marginal for a node z n given observations from x 1 up to x n . Next we turn to the problem of ﬁnding the marginal for a node z n given all observations x 1 to x N . For temporal data, this corresponds to the inclusion of future as well as past observations. Although this cannot be used for real-time prediction, it plays a key role in learning the parameters of the model. By analogy with the hidden Markov model, this problem can be solved by propagating messages from node x N back to node x 1 and combining this information with that obtained during the forward message passing stage used to compute the α ( z n ) . In the LDS literature, it is usual to formulate this backward recursion in terms

̂ In the LDS literature, it is usual to formulate this backward recursion in terms of γ ( z n ) = ̂ α ( z n ) ̂ β ( z n ) rather than in terms of ̂ β ( z n ) . Because γ ( z n ) must also be Gaussian, we write it in the form

$$
\gamma ( z _ { n } ) = \widehat { \alpha } ( z _ { n } ) \widehat { \beta } ( z _ { n } ) = \mathcal { N } ( z _ { n } | \widehat { \mu } _ { n } , \widehat { V } _ { n } ) . \\ \intertext { t h e r i q u e r d r e c u r s i o n , w e t start f o r m e t h a c k w r d e c u r s i o n ( 1 3 . 6 2 ) f o r }
$$

    To derive the required recursion, we start from the backward recursion (13.62) for
