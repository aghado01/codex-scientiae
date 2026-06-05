[Page 221]

# Exercise 4.9

the log likelihood function that depend on π are

$$
\sum _ { n = 1 } ^ { N } \{ t _ { n } \ln \pi + ( 1 - t _ { n } ) \ln ( 1 - \pi ) \} \, . \\ \text {derivative with respect to } \pi \, \text { equal to zero and rearranging. we obtain}
$$

Setting the derivative with respect to π equal to zero and rearranging, we obtain

$$
\pi = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } t _ { n } = \frac { N _ { 1 } } { N } = \frac { N _ { 1 } } { N _ { 1 } + N _ { 2 } } \\ \text {notes the total number of data points in class } \mathcal { C } _ { 1 } , \text { and } N _ { 2 } \text { denotes the total}
$$

where N 1 denotes the total number of data points in class C 1 , and N 2 denotes the total number of data points in class C 2 . Thus the maximum likelihood estimate for π is simply the fraction of points in class C 1 as expected. This result is easily generalized to the multiclass case where again the maximum likelihood estimate of the prior probability associated with class C k is given by the fraction of the training set points assigned to that class.

Now consider the maximization with respect to µ 1 . Again we can pick out of the log likelihood function those terms that depend on µ 1 giving

$$
& \sum _ { n = 1 } ^ { N } t _ { n } \ln \mathcal { N } ( x _ { n } | \mu _ { 1 } , \Sigma ) = - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } t _ { n } ( x _ { n } - \mu _ { 1 } ) ^ { T } \Sigma ^ { - 1 } ( x _ { n } - \mu _ { 1 } ) + \text {const.} \ \ ( 4 . 7 4 ) \\ & \text {Setting the derivative with respect to } \mu _ { 1 } \text { to zero and rearranging. we obtain}
$$

Setting the derivative with respect to µ 1 to zero and rearranging, we obtain

$$
\mu _ { 1 } = \frac { 1 } { N _ { 1 } } \sum _ { n = 1 } ^ { N } t _ { n } x _ { n } & & & \\ \text {mean of all the input vectors } x _ { n } \text { assigned to class } \mathcal { C } _ { 1 } \text {, by a }
$$

which is simply the mean of all the input vectors x n assigned to class C 1 . By a similar argument, the corresponding result for µ 2 is given by

$$
\mu _ { 2 } = \frac { 1 } { N _ { 2 } } \sum _ { n = 1 } ^ { N } ( 1 - t _ { n } ) x _ { n } \\ \text {mean of all the input vectors } x _ { n } \text { assigned to class } \mathcal { C } _ { 3 } .
$$

which again is the mean of all the input vectors x n assigned to class C 2 . Finally, consider the maximum likelihood solution for the shared

covariance matrix Σ . Picking out the terms in the log likelihood function that depend on Σ , we have

$$
h a v & & - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } t _ { n } \ln | \Sigma | - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } t _ { n } ( x _ { n } - \mu _ { 1 } ) ^ { T } \Sigma ^ { - 1 } ( x _ { n } - \mu _ { 1 } ) \\ & - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } ( 1 - t _ { n } ) \ln | \Sigma | - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } ( 1 - t _ { n } ) ( x _ { n } - \mu _ { 2 } ) ^ { T } \Sigma ^ { - 1 } ( x _ { n } - \mu _ { 2 } ) \\ & = - \frac { N } { 2 } \ln | \Sigma | - \frac { N } { 2 } T r \left \{ \Sigma ^ { - 1 } S \right \}
$$
