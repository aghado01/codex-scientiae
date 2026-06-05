[Page 374]

Section 4.4

Exercise 7.18

where σ ( · ) is the logistic sigmoid function deﬁned by (4.59). If we introduce a Gaussian prior over the weight vector w , then we obtain the model that has been considered already in Chapter 4. The difference here is that in the RVM, this model uses the ARD prior (7.80) in which there is a separate precision hyperparameter associated with each weight parameter.

In contrast to the regression model, we can no longer integrate analytically over the parameter vector w . Here we follow Tipping (2001) and use the Laplace approximation, which was applied to the closely related problem of Bayesian logistic regression in Section 4.5.1.

We begin by initializing the hyperparameter vector α . For this given value of α , we then build a Gaussian approximation to the posterior distribution and thereby obtain an approximation to the marginal likelihood. Maximization of this approximate marginal likelihood then leads to a re-estimated value for α , and the process is repeated until convergence.

Let us consider the Laplace approximation for this model in more detail. For a ﬁxed value of α , the mode of the posterior distribution over w is obtained by maximizing

$$
\ln p ( w | t , \alpha ) & = \ln \{ p ( t | w ) p ( w | \alpha ) \} - \ln p ( t | \alpha ) \\ & = \sum _ { n = 1 } ^ { N } \{ t _ { n } \ln y _ { n } + ( 1 - t _ { n } ) \ln ( 1 - y _ { n } ) \} - \frac { 1 } { 2 } w ^ { T } A w + c o n s t \ ( 7 . 1 9 ) \\ \intertext { w h e r $ A = \delta $ } \intertext { where } A = \delta \left ( \alpha _ { 0 } \right ) , \ \text {This can be done using iterative reweighted least squares}
$$

where A = diag( α i ) . This can be done using iterative reweighted least squares (IRLS) as discussed in Section 4.3.3. For this, we need the gradient vector and Hessian matrix of the log posterior distribution, which from (7.109) are given by

$$
\nabla \ln p ( w | \mathfrak { t } , \alpha ) \ & = \ \Phi ^ { \top } ( \mathfrak { t } - y ) - A w \\ \nabla \nabla \ln p ( w | \mathfrak { t } , \alpha ) \ & = \ - \left ( \Phi ^ { \top } B \Phi + \Delta \right )
$$

$$
\nabla \ln p ( w | t , \alpha ) \ & = \ \Phi ^ { T } ( t - y ) - A w \quad \\ \nabla \nln p ( w | t , \alpha ) \ & = \ - \left ( \Phi ^ { T } B \Phi + A \right ) \\ \intertext { i s an $ N \times N $ diagonal matrix with elements $ b _ { n } = y _ { n } ( 1 - y _ { n } ) , $ the vector } \ w \cdot _ { T } \text { and } \Phi \text { is the $sigma$} \, \text { matrix with elements } \Phi \, \underset { \ } = \phi \, ( \text { $r$} ) \, \text { .} \, H o r }
$$

where B is an N × N diagonal matrix with elements b n = y n (1 − y n ) , the vector y = ( y 1 ,...,y N ) T , and Φ is the design matrix with elements Φ ni = φ i ( x n ) . Here we have used the property (4.88) for the derivative of the logistic sigmoid function. At convergence of the IRLS algorithm, the negative Hessian represents the inverse covariance matrix for the Gaussian approximation to the posterior distribution.

The mode of the resulting approximation to the posterior distribution, corresponding to the mean of the Gaussian approximation, is obtained setting (7.110) to zero, giving the mean and covariance of the Laplace approximation in the form

$$
w ^ { * } \ = \ A ^ { - 1 } \Phi ^ { T } ( t - y ) & & ( 7 . 1 1 2 ) \\ \Sigma & \ \ ( \Phi ^ { T } \Phi _ { \ } + \ A ) ^ { - 1 } & & ( 7 . 1 1 2 )
$$

$$
\begin{array} { r l r } { w ^ { * } } & { = } & { A ^ { - 1 } \Phi ^ { 1 } ( t - y ) } \\ & { \Sigma } & { = } & { ( \Phi ^ { T } B \Phi + A ) ^ { - 1 } } \\ { \Sigma } & { = } & { ( \Phi ^ { T } B \Phi + A ) ^ { - 1 } . } \end{array}
$$

We can now use this Laplace approximation to evaluate the marginal likelihood. Using the general result (4.135) for an integral evaluated using the Laplace approxi-
