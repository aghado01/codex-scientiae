[Page 178]

| |
|---|


| |
|---|


- 0
- 1


- 0
- 1


t

t

−1

−1

0 1

0 1

x

x

| |
|---|


| |
|---|


- 0
- 1


- 0
- 1


t

t

−1

−1

0 1

0 1

x

x

- Figure 3.9 Plots of the function y(x, w) using samples from the posterior distributions over w corresponding to the plots in Figure 3.8.


If we used localized basis functions such as Gaussians, then in regions away from the basis function centres, the contribution from the second term in the predictive variance (3.59) will go to zero, leaving only the noise contribution β−1. Thus, the model becomes very conﬁdent in its predictions when extrapolating outside the region occupied by the basis functions, which is generally an undesirable behaviour. This problem can be avoided by adopting an alternative Bayesian approach to re-

Section 6.4 gression known as a Gaussian process.

Note that, if both w and β are treated as unknown, then we can introduce a conjugate prior distribution p(w,β) that, from the discussion in Section 2.3.6, will

- Exercise 3.12 be given by a Gaussian-gamma distribution (Denison et al., 2002). In this case, the
- Exercise 3.13 predictive distribution is a Student’s t-distribution.
