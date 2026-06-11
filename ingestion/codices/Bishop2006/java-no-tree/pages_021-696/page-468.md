[Page 468]

|![image 102](../../../../../images/imageFile102.png)|
|---|


|![image 103](../../../../../images/imageFile103.png)|
|---|


|![image 104](../../../../../images/imageFile104.png)|
|---|


|![image 105](../../../../../images/imageFile105.png)|
|---|


|![image 106](../../../../../images/imageFile106.png)|
|---|


|![image 107](../../../../../images/imageFile107.png)|
|---|


|![image 108](../../../../../images/imageFile108.png)|
|---|


|![image 109](../../../../../images/imageFile109.png)|
|---|


|![image 110](../../../../../images/imageFile110.png)|
|---|


Figure 9.10 Illustration of the Bernoulli mixture model in which the top row shows examples from the digits data set after converting the pixel values from grey scale to binary using a threshold of 0.5. On the bottom row the ﬁrst three images show the parameters µki for each of the three components in the mixture model. As a comparison, we also ﬁt the same data set using a single multivariate Bernoulli distribution, again using maximum likelihood. This amounts to simply averaging the counts in each pixel and is shown by the right-most image on the bottom row.

Section 2.1.1 additional effective observations of x. We can similarly introduce priors into the Bernoulli mixture model, and use EM to maximize the posterior probability distri-

- Exercise 9.18 butions. It is straightforward to extend the analysis of Bernoulli mixtures to the case of
- Exercise 9.19 multinomial binary variables having M > 2 states by making use of the discrete distribution (2.26). Again, we can introduce Dirichlet priors over the model parameters if desired.


###### 9.3.4 EM for Bayesian linear regression

As a third example of the application of EM, we return to the evidence approximation for Bayesian linear regression. In Section 3.5.2, we obtained the reestimation equations for the hyperparameters α and β by evaluation of the evidence and then setting the derivatives of the resulting expression to zero. We now turn to an alternative approach for ﬁnding α and β based on the EM algorithm. Recall that our goal is to maximize the evidence function p(t|α,β) given by (3.77) with respect to α and β. Because the parameter vector w is marginalized out, we can regard it as a latent variable, and hence we can optimize this marginal likelihood function using EM. In the E step, we compute the posterior distribution of w given the current setting of the parameters α and β and then use this to ﬁnd the expected complete-data log likelihood. In the M step, we maximize this quantity with respect to α and β. We have already derived the posterior distribution of w because this is given by (3.49). The complete-data log likelihood function is then given by

lnp(t,w|α,β) = lnp(t|w,β) + lnp(w|α) (9.61)
