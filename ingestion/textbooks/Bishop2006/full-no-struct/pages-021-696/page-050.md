[Page 50]

# Section 1.2.4

Again we can ﬁrst determine the parameter vector w ML governing the mean and subsequently use this to ﬁnd the precision β ML as was the case for the simple Gaussian distribution.

Having determined the parameters w and β , we can now make predictions for new values of x . Because we now have a probabilistic model, these are expressed in terms of the predictive distribution that gives the probability distribution over t , rather than simply a point estimate, and is obtained by substituting the maximum likelihood parameters into (1.60) to give

$$
& \quad \ p ( t | x , w _ { M L } , \beta _ { M L } ) = \mathcal { N } \left ( t | y ( x , w _ { M L } ) , \beta _ { M L } ^ { - 1 } \right ) . \\ & \quad \ \ w \text { let us take a step towards a more Bayesian approach and introduce a prior } \\ & \quad \text {tion over the polynomial coefficients } \, \mathbf r \text { . For simplicity, let us consider } \, o \\
$$

Now let us take a step towards a more Bayesian approach and introduce a prior distribution over the polynomial coefﬁcients w . For simplicity, let us consider a Gaussian distribution of the form

$$
p ( w | \alpha ) & = \mathcal { N } ( w | 0 , \alpha ^ { - 1 } I ) = \left ( \frac { \alpha } { 2 \pi } \right ) ^ { ( M + 1 ) / 2 } \exp \left \{ - \frac { \alpha } { 2 } w ^ { T } w \right \} \\ \intertext { w h e r $ \alpha $ i s the precision of the distribution, and $ M + 1 $ i s the total number of elements }
$$

where α is the precision of the distribution, and M +1 is the total number of elements in the vector w for an M th order polynomial. Variables such as α , which control the distribution of model parameters, are called hyperparameters . Using Bayes’ theorem, the posterior distribution for w is proportional to the product of the prior distribution and the likelihood function

$$
p ( w | \mathbf x , \mathbf t , \alpha , \beta ) \subset p ( \mathbf t | \mathbf x , w , \beta ) p ( w | \alpha ) .
$$

We can now determine w by ﬁnding the most probable value of w given the data, in other words by maximizing the posterior distribution. This technique is called maximum posterior , or simply MAP . Taking the negative logarithm of (1.66) and combining with (1.62) and (1.65), we ﬁnd that the maximum of the posterior is given by the minimum of

$$
\frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w ) - t _ { n } \} ^ { 2 } + \frac { \alpha } { 2 } w ^ { T } w . \\ \intertext { t h a t \max i m i z i n g t h e p o s t e r i o n d i s t u p e r i o n t h e q u i v a l e n t o p i m i z i n g }
$$

Thus we see that maximizing the posterior distribution is equivalent to minimizing the regularized sum-of-squares error function encountered earlier in the form (1.4), with a regularization parameter given by λ = α/β .

# 1.2.6 Bayesian curve ﬁtting

Although we have included a prior distribution p ( w | α ) , we are so far still making a point estimate of w and so this does not yet amount to a Bayesian treatment. In a fully Bayesian approach, we should consistently apply the sum and product rules of probability, which requires, as we shall see shortly, that we integrate over all values of w . Such marginalizations lie at the heart of Bayesian methods for pattern recognition.
