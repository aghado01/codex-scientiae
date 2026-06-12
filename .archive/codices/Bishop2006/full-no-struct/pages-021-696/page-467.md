[Page 467]

# Exercise 9.15

Exercise 9.16

Exercise 9.17

Section 9.4

If we consider the sum over n in (9.55), we see that the responsibilities enter only through two terms, which can be written as

$$
N _ { k } \ = \ \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ) \\
$$

$$
\bar { x } _ { k } \ = \ \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ) x _ { n } \\ \intertext { f i t e v i c h o r } \ \text {f} e c t i o n \, d t a p i o n s \, a s o c i a t e d \, w i t h \, \text {component} \, k \ \text {.} \ \text {In the } \, \real
$$

where N k is the effective number of data points associated with component k . In the M step, we maximize the expected complete-data log likelihood with respect to the parameters µ k and π . If we set the derivative of (9.55) with respect to µ k equal to zero and rearrange the terms, we obtain

$$
\mu _ { k } = \overline { x } _ { k } .
$$

We see that this sets the mean of component k equal to a weighted mean of the data, with weighting coefﬁcients given by the responsibilities that component k takes for data points. For the maximization with respect to π k , we need to introduce a Lagrange multiplier to enforce the constraint k π k = 1 . Following analogous steps to those used for the mixture of Gaussians, we then obtain

$$
\pi _ { k } = \frac { N _ { k } } { N }
$$

which represents the intuitively reasonable result that the mixing coefﬁcient for component k is given by the effective fraction of points in the data set explained by that component.

Note that in contrast to the mixture of Gaussians, there are no singularities in which the likelihood function goes to inﬁnity. This can be seen by noting that the likelihood function is bounded above because 0 p ( x n | µ k ) 1 . There exist singularities at which the likelihood function goes to zero, but these will not be found by EM provided it is not initialized to a pathological starting point, because the EM algorithm always increases the value of the likelihood function, until a local maximum is found. We illustrate the Bernoulli mixture model in Figure 9.10 by using it to model handwritten digits. Here the digit images have been turned into binary vectors by setting all elements whose values exceed 0 . 5 to 1 and setting the remaining elements to 0 . We now ﬁt a data set of N = 600 such digits, comprising the digits ‘2’, ‘3’, and ‘4’, with a mixture of K = 3 Bernoulli distributions by running 10 iterations of the EM algorithm. The mixing coefﬁcients were initialized to π k = 1 /K , and the parameters µ kj were set to random values chosen uniformly in the range (0 . 25 , 0 . 75) and then normalized to satisfy the constraint that j µ kj = 1 . We see that a mixture of 3 Bernoulli distributions is able to ﬁnd the three clusters in the data set corresponding to the different digits.

The conjugate prior for the parameters of a Bernoulli distribution is given by the beta distribution, and we have seen that a beta prior is equivalent to introducing
