[Page 693]

![image 166](../../../../../images/imageFile166.png)

![image 167](../../../../../images/imageFile167.png)

![image 168](../../../../../images/imageFile168.png)

![image 169](../../../../../images/imageFile169.png)

![image 170](../../../../../images/imageFile170.png)

![image 171](../../../../../images/imageFile171.png)

- Figure 14.10 Illustration of a mixture of logistic regression models. The left plot shows data points drawn from two classes denoted red and blue, in which the background colour (which varies from pure red to pure blue) denotes the true probability of the class label. The centre plot shows the result of ﬁtting a single logistic regression model using maximum likelihood, in which the background colour denotes the corresponding probability of the class label. Because the colour is a near-uniform purple, we see that the model assigns a probability of around


- 0.5 to each of the classes over most of input space. The right plot shows the result of ﬁtting a mixture of two logistic regression models, which now gives much higher probability to the correct labels for many of the points in the blue class.


are ‘experts’ at making predictions in their own regions), and the gating functions determine which components are dominant in which region.

The gating functions πk(x) must satisfy the usual constraints for mixing co-

efﬁcients, namely 0 πk(x) 1 and k πk(x) = 1. They can therefore be represented, for example, by linear softmax models of the form (4.104) and (4.105).

If the experts are also linear (regression or classiﬁcation) models, then the whole model can be ﬁtted efﬁciently using the EM algorithm, with iterative reweighted least squares being employed in the M step (Jordan and Jacobs, 1994).

Such a model still has signiﬁcant limitations due to the use of linear models for the gating and expert functions. A much more ﬂexible model is obtained by using a multilevel gating function to give the hierarchical mixture of experts, or HME model (Jordan and Jacobs, 1994). To understand the structure of this model, imagine a mixture distribution in which each component in the mixture is itself a mixture distribution. For simple unconditional mixtures, this hierarchical mixture is

- Exercise 14.17 trivially equivalent to a single ﬂat mixture distribution. However, when the mixing coefﬁcients are input dependent, this hierarchical model becomes nontrivial. The HME model can also be viewed as a probabilistic version of decision trees discussed in Section 14.4 and can again be trained efﬁciently by maximum likelihood using an


Section 4.3.3 EM algorithm with IRLS in the M step. A Bayesian treatment of the HME has been

given by Bishop and Svens´en (2003) based on variational inference.

We shall not discuss the HME in detail here. However, it is worth pointing out the close connection with the mixture density network discussed in Section 5.6. The principal advantage of the mixtures of experts model is that it can be optimized by EM in which the M step for each mixture component and gating model involves a convex optimization (although the overall optimization is nonconvex). By contrast, the advantage of the mixture density network approach is that the component
