[Page 368]

###### γi = 1 − αiΣii (7.89)

in which Σii is the ith diagonal component of the posterior covariance Σ given by (7.83). Learning therefore proceeds by choosing initial values for α and β, evaluating the mean and covariance of the posterior using (7.82) and (7.83), respectively, and then alternately re-estimating the hyperparameters, using (7.87) and (7.88), and re-estimating the posterior mean and covariance, using (7.82) and (7.83), until a suitable convergence criterion is satisﬁed.

The second approach is to use the EM algorithm, and is discussed in Section 9.3.4. These two approaches to ﬁnding the values of the hyperparameters that

Exercise 9.23 maximize the evidence are formally equivalent. Numerically, however, it is found that the direct optimization approach corresponding to (7.87) and (7.88) gives somewhat faster convergence (Tipping, 2001).

As a result of the optimization, we ﬁnd that a proportion of the hyperparameters

Section 7.2.2 {αi} are driven to large (in principle inﬁnite) values, and so the weight parameters wi corresponding to these hyperparameters have posterior distributions with mean and variance both zero. Thus those parameters, and the corresponding basis func-

tions φi(x), are removed from the model and play no role in making predictions for new inputs. In the case of models of the form (7.78), the inputs xn corresponding to the remaining nonzero weights are called relevance vectors, because they are identiﬁed through the mechanism of automatic relevance determination, and are analogous to the support vectors of an SVM. It is worth emphasizing, however, that this mechanism for achieving sparsity in probabilistic models through automatic relevance determination is quite general and can be applied to any model expressed as an adaptive linear combination of basis functions.

Having found values α and β for the hyperparameters that maximize the marginal likelihood, we can evaluate the predictive distribution over t for a new

- Exercise 7.14 input x. Using (7.76) and (7.81), this is given by


p(t|x,X,t,α ,β ) = p(t|x,w,β )p(w|X,t,α ,β )dw

= N t|mTφ(x),σ2(x) . (7.90)

Thus the predictive mean is given by (7.76) with w set equal to the posterior mean m, and the variance of the predictive distribution is given by

###### σ2(x) = (β )−1 + φ(x)TΣφ(x) (7.91)

where Σ is given by (7.83) in which α and β are set to their optimized values α and β . This is just the familiar result (3.59) obtained in the context of linear regression. Recall that for localized basis functions, the predictive variance for linear regression models becomes small in regions of input space where there are no basis functions. In the case of an RVM with the basis functions centred on data points, the model will therefore become increasingly certain of its predictions when extrapolating outside the domain of the data (Rasmussen and Qui˜nonero-Candela, 2005), which of course

Section 6.4.2 is undesirable. The predictive distribution in Gaussian process regression does not
