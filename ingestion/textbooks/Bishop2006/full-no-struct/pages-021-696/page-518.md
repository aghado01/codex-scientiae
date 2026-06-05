[Page 518]

Although the bound σ ( a ) f ( a,ξ ) on the logistic sigmoid can be optimized exactly, the required choice for ξ depends on the value of a , so that the bound is exact for one value of a only. Because the quantity F ( ξ ) is obtained by integrating over all values of a , the value of ξ represents a compromise, weighted by the distribution p ( a ) .

# 10.6. Variational Logistic Regression

We now illustrate the use of local variational methods by returning to the Bayesian logistic regression model studied in Section 4.5. There we focussed on the use of the Laplace approximation, while here we consider a variational treatment based on the approach of Jaakkola and Jordan (2000). Like the Laplace method, this also leads to a Gaussian approximation to the posterior distribution. However, the greater ﬂexibility of the variational approximation leads to improved accuracy compared to the Laplace method. Furthermore (unlike the Laplace method), the variational approach is optimizing a well deﬁned objective function given by a rigourous bound on the model evidence. Logistic regression has also been treated by Dybowski and Roberts (2005) from a Bayesian perspective using Monte Carlo sampling techniques.

# 10.6.1 Variational posterior distribution

Here we shall make use of a variational approximation based on the local bounds introduced in Section 10.5. This allows the likelihood function for logistic regression, which is governed by the logistic sigmoid, to be approximated by the exponential of a quadratic form. It is therefore again convenient to choose a conjugate Gaussian prior of the form (4.140). For the moment, we shall treat the hyperparameters m 0 and S 0 as ﬁxed constants. In Section 10.6.3, we shall demonstrate how the variational formalism can be extended to the case where there are unknown hyperparameters whose values are to be inferred from the data.

In the variational framework, we seek to maximize a lower bound on the marginal likelihood. For the Bayesian logistic regression model, the marginal likelihood takes the form

$$
t \text { form} \\ p ( t ) = \int p ( t | w ) p ( w ) \, d w = \int \left [ \prod _ { n = 1 } ^ { N } p ( t _ { n } | w ) \right ] p ( w ) \, d w . \\ \text {We first note that the conditional distribution for $t$ can be written as}
$$

We ﬁrst note that the conditional distribution for t can be written as

$$
\text {st note that the conditional distribution for } t \text { can be written as} \\ p ( t | w ) \ = \ \sigma ( a ) ^ { t } \{ 1 - \sigma ( a ) \} ^ { 1 - t } \\ = \ \left ( \frac { 1 } { 1 + e ^ { - a } } \right ) ^ { t } \left ( 1 - \frac { 1 } { 1 + e ^ { - a } } \right ) ^ { 1 - t } \\ = \ e ^ { a t } \frac { e ^ { - a } } { 1 + e ^ { - a } } = e ^ { a t } \sigma ( - a ) \quad ( 1 0 . 1 8 ) \\ a = w ^ { T } \phi _ { 0 } \text { In order to obtain a lower bound on } p ( t ) , \text { we make use of the}
$$

where a = w T φ . In order to obtain a lower bound on p ( t ) , we make use of the variational lower bound on the logistic sigmoid function given by (10.144), which
