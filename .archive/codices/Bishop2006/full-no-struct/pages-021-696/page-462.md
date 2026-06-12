[Page 462]

Figure 9.9 This shows the same graph as in Figure 9.6 except that we now suppose that the discrete variables z n are observed, as well as the data variables x n .

![image 224](../images/imageFile224.png)

n

z

π

n

x

µ

Σ

N

Now consider the problem of maximizing the likelihood for the complete data set { X , Z } . From (9.10) and (9.11), this likelihood function takes the form

$$
p ( X , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( X , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) ^ { z _ { n k } } \\ \intertext { r o w. } \rho ( Z , Z | \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \pi _ { k } ^ { z _ { n k } } \math
$$

where z nk denotes the k th component of z n . Taking the logarithm, we obtain

$$
\ln p ( X , Z | \mu , \Sigma , \pi ) = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } z _ { n k } \left \{ \ln \pi _ { k } + \ln \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) \right \} . \\ \\ \text {Comparison with the log likelihood function} \left ( 9 . 1 4 \right ) \text { for the incomplete data shows}
$$

Comparison with the log likelihood function (9.14) for the incomplete data shows that the summation over k and the logarithm have been interchanged. The logarithm now acts directly on the Gaussian distribution, which itself is a member of the exponential family. Not surprisingly, this leads to a much simpler solution to the maximum likelihood problem, as we now show. Consider ﬁrst the maximization with respect to the means and covariances. Because z n is a K -dimensional vector with all elements equal to 0 except for a single element having the value 1 , the complete-data log likelihood function is simply a sum of K independent contributions, one for each mixture component. Thus the maximization with respect to a mean or a covariance is exactly as for a single Gaussian, except that it involves only the subset of data points that are ‘assigned’ to that component. For the maximization with respect to the mixing coefﬁcients, we note that these are coupled for different values of k by virtue of the summation constraint (9.9). Again, this can be enforced using a Lagrange multiplier as before, and leads to the result

$$
\pi _ { k } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } z _ { n k } \\ \intertext { i c h i v e a l u g e a l $ z $ t h e f r a t i o n s a f $ d $ a t h s $ a $ i n g e d t o }
$$

so that the mixing coefﬁcients are equal to the fractions of data points assigned to the corresponding components.

Thus we see that the complete-data log likelihood function can be maximized trivially in closed form. In practice, however, we do not have values for the latent variables so, as discussed earlier, we consider the expectation, with respect to the posterior distribution of the latent variables, of the complete-data log likelihood.
