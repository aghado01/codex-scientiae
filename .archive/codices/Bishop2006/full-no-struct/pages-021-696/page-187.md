[Page 187]

# Exercise 3.18

# Exercise 3.19

where M is the dimensionality of w , and we have deﬁned

$$
\begin{array} { r l } { E ( w ) } & { = } & { \beta E _ { D } ( w ) + \alpha E _ { W } ( w ) } \\ & { = } & { \frac { \beta } { 2 } \| t - \Phi w \| ^ { 2 } + \frac { \alpha } { 2 } w ^ { T } w . } \end{array}
$$

We recognize (3.79) as being equal, up to a constant of proportionality, to the regularized sum-of-squares error function (3.27). We now complete the square over w giving 1

$$
E ( w ) & = E ( m _ { N } ) + \frac { 1 } { 2 } ( w - m _ { N } ) ^ { T } A ( w - m _ { N } ) \\
$$

where we have introduced

$$
A = \alpha I + \beta \Phi ^ { T } \Phi
$$

together with

$$
E ( m _ { N } ) = \frac { \beta } { 2 } \left \| \mathfrak { t } - \Phi m _ { N } \right \| ^ { 2 } + \frac { \alpha } { 2 } m _ { N } ^ { \text {T} } m _ { N } . \\
$$

Note that A corresponds to the matrix of second derivatives of the error function

$$
A = \nabla \nabla E ( w )
$$

and is known as the Hessian matrix . Here we have also deﬁned m N given by

$$
m _ { N } = \beta A ^ { - 1 } \Phi ^ { T } \mathbf t .
$$

Using (3.54), we see that A = S − 1 N , and hence (3.84) is equivalent to the previous deﬁnition (3.53), and therefore represents the mean of the posterior distribution.

The integral over w can now be evaluated simply by appealing to the standard result for the normalization coefﬁcient of a multivariate Gaussian, giving

$$
result & \text { for the normalization coefficient of a multivariate Gaussian, giving} \\ & \quad \int \exp \{ - E ( w ) \} \, d w \\ & \quad = \, \exp \{ - E ( m _ { N } ) \} \int \exp \left \{ - \frac { 1 } { 2 } ( w - m _ { N } ) ^ { T } A ( w - m _ { N } ) \right \} \, d w \\ & \quad = \, \exp \{ - E ( m _ { N } ) \} ( 2 \pi ) ^ { M / 2 } | A | ^ { - 1 / 2 } . \\ \text {Using (3.78) we can then write the log of the marginal likelihood in the form}
$$

Using (3.78) we can then write the log of the marginal likelihood in the form

$$
\ln p ( \mathbf t | \alpha , \beta ) = \frac { M } { 2 } \ln \alpha + \frac { N } { 2 } \ln \beta - E ( \mathbf m _ { N } ) - \frac { 1 } { 2 } \ln | A | - \frac { N } { 2 } \ln ( 2 \pi ) \quad ( 3 . 8 6 )
$$

which is the required expression for the evidence function.

Returning to the polynomial regression problem, we can plot the model evidence against the order of the polynomial, as shown in Figure 3.14. Here we have assumed a prior of the form (1.65) with the parameter α fi xed at α = 5 × 10 -3 . The form of this plot is very instructive. Referring back to Figure 1.4, we see that the M = 0 polynomial has very poor fit to the data and consequently gives a relatively low value for the evidence. Going to the M = 1 polynomial greatly improves the data fit, and hence the evidence is significantly higher. However, in going to M = 2 , the data fit is improved only very marginally, due to the fact that the underlying sinusoidal function from which the data is generated is an odd function and so has no even terms in a polynomial expansion. Indeed, Figure 1.5 shows that the residual data error is reduced only slightly in going from M = 1 to M = 2 . Because this richer model suffers a greater complexity penalty, the evidence actually falls in going from M = 1 to M = 2 . When we go to M = 3 we obtain a significant further improvement in data fit, as seen in Figure 1.4, and so the evidence is increased again, giving the highest overall evidence for any of the polynomials. Further increases in the value of M produce only small improvements in the fit to the data but suffer increasing complexity penalty, leading overall to a decrease in the evidence values. Looking again at Figure 1.5, we see that the generalization error is roughly constant between M = 3 and M = 8 , and it would be difficult to choose between these models on the basis of this plot alone. The evidence values, however, show a clear preference for M = 3 , since this is the simplest model which gives a good explanation for the observed data.
