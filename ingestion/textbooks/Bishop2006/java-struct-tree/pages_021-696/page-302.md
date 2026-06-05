[Page 302]

this framework that arise when it is applied to classiﬁcation. Here we shall consider a network having a single logistic sigmoid output corresponding to a two-class classiﬁcation problem. The extension to networks with multiclass softmax outputs

Exercise 5.40 is straightforward. We shall build extensively on the analogous results for linear classiﬁcation models discussed in Section 4.5, and so we encourage the reader to familiarize themselves with that material before studying this section.

The log likelihood function for this model is given by

�

lnp(D|w) =

= 1N {tn lnyn + (1 − tn)ln(1 − yn)} (5.181)

n

where tn ∈ {0,1} are the target values, and yn ≡ y(xn,w). Note that there is no hyperparameter β, because the data points are assumed to be correctly labelled. As before, the prior is taken to be an isotropic Gaussian of the form (5.162).

The ﬁrst stage in applying the Laplace framework to this model is to initialize the hyperparameter α, and then to determine the parameter vector w by maximizing the log posterior distribution. This is equivalent to minimizing the regularized error function

α 2

E(w) = −lnp(D|w) +

wTw (5.182)

and can be achieved using error backpropagation combined with standard optimization algorithms, as discussed in Section 5.3.

Having found a solution wMAP for the weight vector, the next step is to evaluate the Hessian matrix H comprising the second derivatives of the negative log likelihood function. This can be done, for instance, using the exact method of Section 5.4.5, or using the outer product approximation given by (5.85). The second derivatives of the negative log posterior can again be written in the form (5.166), and the Gaussian approximation to the posterior is then given by (5.167).

To optimize the hyperparameter α, we again maximize the marginal likelihood, Exercise 5.41 which is easily shown to take the form

1 2

W 2

lnp(D|α) � −E(wMAP) −

lnα + const (5.183) where the regularized error function is deﬁned by

ln|A| +

�N

α 2

E(wMAP) = −

{tn lnyn + (1 − tn)ln(1 − yn)} +

wMAPT wMAP (5.184)

n=1

in which yn ≡ y(xn,wMAP). Maximizing this evidence function with respect to α again leads to the re-estimation equation given by (5.178).

The use of the evidence procedure to determine α is illustrated in Figure 5.22 for the synthetic two-dimensional data discussed in Appendix A.

Finally, we need the predictive distribution, which is deﬁned by (5.168). Again, this integration is intractable due to the nonlinearity of the network function. The
