[Page 173]

# Exercise 3.7

# Exercise 3.8

Next we compute the posterior distribution, which is proportional to the product of the likelihood function and the prior. Due to the choice of a conjugate Gaussian prior distribution, the posterior will also be Gaussian. We can evaluate this distribution by the usual procedure of completing the square in the exponential, and then ﬁnding the normalization coefﬁcient using the standard result for a normalized Gaussian. However, we have already done the necessary work in deriving the general result (2.116), which allows us to write down the posterior distribution directly in the form

$$
p ( w | \mathbf t ) = \mathcal { N } ( w | m _ { N } , S _ { N } )
$$

where a linear model of the form y ( x, w ) = w 0 + w 1 x . Because this has just two adaptive parameters, we can plot the prior and posterior distributions directly in parameter space. We generate synthetic data from the function f ( x, a ) = a 0 + a 1 x with parameter values a 0 = -0 . 3 and a 1 = 0 . 5 by first choosing values of x n from the uniform distribution U( x |-1 , 1) , then evaluating f ( x n , a ) , and finally adding Gaussian noise with standard deviation of 0 . 2 to obtain the target values t n . Our goal is to recover the values of a 0 and a 1 from such data, and we will explore the dependence on the size of the data set. We assume here that the noise variance is known and hence we set the precision parameter to its true value β = (1 / 0 . 2) 2 = 25 . Similarly, we fix the parameter α to 2 . 0 . We shall shortly discuss strategies for determining α and β from the training data. Figure 3.7 shows the results of Bayesian learning in this model as the size of the data set is increased and demonstrates the sequential nature of Bayesian learning in which the current posterior distribution forms the prior when a new data point is observed. It is worth taking time to study this figure in detail as it illustrates several important aspects of Bayesian inference. The first row of this figure corresponds to the situation before any data points are observed and shows a plot of the prior distribution in w space together with six samples of the function y ( x, w ) in which the values of w are drawn from the prior. In the second row, we see the situation after observing a single data point. The location ( x, t ) of the data point is shown by a blue circle in the right-hand column. In the left-hand column is a plot of the likelihood function p ( t | x, w ) for this data point as a function of w . Note that the likelihood function provides a soft constraint that the line must pass close to the data point, where close is determined by the noise precision β . For comparison, the true parameter values a 0 = -0 . 3 and a 1 = 0 . 5 used to generate the data set are shown by a white cross in the plots in the left column of Figure 3.7. When we multiply this likelihood function by the prior from the top row, and normalize, we obtain the posterior distribution shown in the middle plot on the second row. Samples of the regression function y ( x, w ) obtained by drawing samples of w from this posterior distribution are shown in the right-hand plot. Note that these sample lines all pass close to the data point. The third row of this figure shows the effect of observing a second data point, again shown by a blue circle in the plot in the right-hand column. The corresponding likelihood function for this second data point alone is shown in the left plot. When we multiply this likelihood function by the posterior distribution from the second row, we obtain the posterior distribution shown in the middle plot of the third row. Note that this is exactly the same posterior distribution as would be obtained by combining the original prior with the likelihood function for the two data points. This posterior has now been influenced by two data points, and because two points are sufficient to define a line this already gives a relatively compact posterior distribution. Samples from this posterior distribution give rise to the functions shown in red in the third column, and we see that these functions pass close to both of the data points. The fourth row shows the effect of observing a total of 20 data points. The left-hand plot shows the likelihood function for the 20 th data point alone, and the middle plot shows the resulting posterior distribution that has now absorbed information from all 20 observations. Note how the posterior is much sharper than in the third row. In the limit of an infinite number of data points, the Wo Exercise 3.10

$$
\begin{array} { r c l } m _ { N } & = & S _ { N } \left ( S _ { 0 } ^ { - 1 } m _ { 0 } + \beta \Phi ^ { T } t \right ) & & \\ S _ { N } ^ { - 1 } & = & S _ { 0 } ^ { - 1 } + \beta \Phi ^ { T } \Phi . & & \\ \end{array}
$$

Note that because the posterior distribution is Gaussian, its mode coincides with its mean. Thus the maximum posterior weight vector is simply given by w MAP = m N . If we consider an inﬁnitely broad prior S 0 = α − 1 I with α → 0 , the mean m N of the posterior distribution reduces to the maximum likelihood value w ML given by (3.15). Similarly, if N = 0 , then the posterior distribution reverts to the prior. Furthermore, if data points arrive sequentially, then the posterior distribution at any stage acts as the prior distribution for the subsequent data point, such that the new posterior distribution is again given by (3.49).

For the remainder of this chapter, we shall consider a particular form of Gaussian prior in order to simplify the treatment. Speciﬁcally, we consider a zero-mean isotropic Gaussian governed by a single precision parameter α so that

$$
p ( \mathbf w | \alpha ) = \mathcal { N } ( \mathbf w | 0 , \alpha ^ { - 1 } \mathbf I )
$$

and the corresponding posterior distribution over w is then given by (3.49) with

$$
m _ { N } \ = \ \beta S _ { N } \Phi ^ { T } \mathbf t
$$

$$
S _ { N } ^ { - 1 } \ = \ \alpha I + \beta \Phi ^ { T } \Phi .
$$

The log of the posterior distribution is given by the sum of the log likelihood and the log of the prior and, as a function of w , takes the form

$$
\ln p ( w | t ) = - \frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \{ t _ { n } - w ^ { T } \phi ( x _ { n } ) \} ^ { 2 } - \frac { \alpha } { 2 } w ^ { T } w + \text {const.} \\ \\ \text {Maximization of this posterior distribution with respect to } w \text { is therefore equivalently}
$$

Maximization of this posterior distribution with respect to w is therefore equivalent to the minimization of the sum-of-squares error function with the addition of a quadratic regularization term, corresponding to (3.27) with λ = α/β .

We can illustrate Bayesian learning in a linear basis function model, as well as the sequential update of a posterior distribution, using a simple example involving straight-line ﬁtting. Consider a single input variable x , a single target variable t and
