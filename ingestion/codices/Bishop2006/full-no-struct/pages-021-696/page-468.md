[Page 468]

24

2

4

![The image contains 5 rows and 3 columns. The first row has the number 24 in blue, the second row has the number 4 in blue, and the third row has the number 8 in blue.](../images/imageFile37.png)

4

3

4

3

Figure 9.10 Illustration of the Bernoulli mixture model in which the top row shows examples from the digits data set after converting the pixel values from grey scale to binary using a threshold of 0 . 5 . On the bottom row the ﬁrst three images show the parameters µ ki for each of the three components in the mixture model. As a comparison, we also ﬁt the same data set using a single multivariate Bernoulli distribution, again using maximum likelihood. This amounts to simply averaging the counts in each pixel and is shown by the right-most image on the bottom row.

Exercise 9.18

Exercise 9.19

additional effective observations of x . We can similarly introduce priors into the Bernoulli mixture model, and use EM to maximize the posterior probability distributions.

It is straightforward to extend the analysis of Bernoulli mixtures to the case of multinomial binary variables having M > 2 states by making use of the discrete distribution (2.26). Again, we can introduce Dirichlet priors over the model parameters if desired.

# 9.3.4 EM for Bayesian linear regression

As a third example of the application of EM, we return to the evidence approximation for Bayesian linear regression. In Section 3.5.2, we obtained the reestimation equations for the hyperparameters α and β by evaluation of the evidence and then setting the derivatives of the resulting expression to zero. We now turn to an alternative approach for ﬁnding α and β based on the EM algorithm. Recall that our goal is to maximize the evidence function p ( t | α,β ) given by (3.77) with respect to α and β . Because the parameter vector w is marginalized out, we can regard it as a latent variable, and hence we can optimize this marginal likelihood function using EM. In the E step, we compute the posterior distribution of w given the current setting of the parameters α and β and then use this to ﬁnd the expected complete-data log likelihood. In the M step, we maximize this quantity with respect to α and β . We have already derived the posterior distribution of w because this is given by (3.49). The complete-data log likelihood function is then given by

$$
\ln p ( \mathbf t , \mathbf w | \alpha , \beta ) = \ln p ( \mathbf t | \mathbf w , \beta ) + \ln p ( \mathbf w | \alpha )
$$
