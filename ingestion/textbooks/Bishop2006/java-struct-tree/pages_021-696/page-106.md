[Page 106]

evaluated from the joint distribution p(x) = p(xa,xb) simply by ﬁxing xb to the observed value and normalizing the resulting expression to obtain a valid probability

distribution over xa. Instead of performing this normalization explicitly, we can obtain the solution more efﬁciently by considering the quadratic form in the exponent of the Gaussian distribution given by (2.44) and then reinstating the normalization coefﬁcient at the end of the calculation. If we make use of the partitioning (2.65), (2.66), and (2.69), we obtain

1 2

(x − µ)TΣ−1(x − µ) = −

−

1 2

1 2

(xa − µa)TΛab(xb − µb) −

(xa − µa)TΛaa(xa − µa) −

1 2

1 2

(xb − µb)TΛba(xa − µa) −

(xb − µb)TΛbb(xb − µb). (2.70)

We see that as a function of xa, this is again a quadratic form, and hence the corresponding conditional distribution p(xa|xb) will be Gaussian. Because this distribution is completely characterized by its mean and its covariance, our goal will be to identify expressions for the mean and covariance of p(xa|xb) by inspection of (2.70).

This is an example of a rather common operation associated with Gaussian distributions, sometimes called ‘completing the square’, in which we are given a quadratic form deﬁning the exponent terms in a Gaussian distribution, and we need to determine the corresponding mean and covariance. Such problems can be solved straightforwardly by noting that the exponent in a general Gaussian distribution N(x|µ,Σ) can be written

1 2

1 2

(x − µ)TΣ−1(x − µ) = −

xTΣ−1x + xTΣ−1µ + const (2.71)

−

where ‘const’ denotes terms which are independent of x, and we have made use of the symmetry of Σ. Thus if we take our general quadratic form and express it in the form given by the right-hand side of (2.71), then we can immediately equate the matrix of coefﬁcients entering the second order term in x to the inverse covariance matrix Σ−1 and the coefﬁcient of the linear term in x to Σ−1µ, from which we can obtain µ.

Now let us apply this procedure to the conditional Gaussian distribution p(xa|xb) for which the quadratic form in the exponent is given by (2.70). We will denote the mean and covariance of this distribution by µa|b and Σa|b, respectively. Consider the functional dependence of (2.70) on xa in which xb is regarded as a constant. If we pick out all terms that are second order in xa, we have

1 2

xTaΛaaxa (2.72)

−

from which we can immediately conclude that the covariance (inverse precision) of p(xa|xb) is given by

Σa|b = Λ−1

aa . (2.73)
