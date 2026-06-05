[Page 221]

the log likelihood function that depend on π are

###### N

{tn lnπ + (1 − tn)ln(1 − π)}. (4.72)

n=1

Setting the derivative with respect to π equal to zero and rearranging, we obtain

N

1 N

N1 N

π =

tn =

n=1

N1 N1 + N2

=

(4.73)

where N1 denotes the total number of data points in class C1, and N2 denotes the total number of data points in class C2. Thus the maximum likelihood estimate for π is simply the fraction of points in class C1 as expected. This result is easily generalized to the multiclass case where again the maximum likelihood estimate of the prior probability associated with class Ck is given by the fraction of the training set points

- Exercise 4.9 assigned to that class.


Now consider the maximization with respect to µ1. Again we can pick out of the log likelihood function those terms that depend on µ1 giving

###### N

- 1

- 2


tn lnN(xn|µ1,Σ) = −

n=1

N

tn(xn − µ1)TΣ−1(xn − µ1) + const. (4.74)

n=1

Setting the derivative with respect to µ1 to zero and rearranging, we obtain

1 N1

µ1 =

N

tnxn (4.75)

n=1

which is simply the mean of all the input vectors xn assigned to class C1. By a similar argument, the corresponding result for µ2 is given by

1 N2

µ2 =

N

(1 − tn)xn (4.76)

n=1

which again is the mean of all the input vectors xn assigned to class C2.

Finally, consider the maximum likelihood solution for the shared covariance matrix Σ. Picking out the terms in the log likelihood function that depend on Σ, we have

N

N

1 2

1 2

tn(xn − µ1)TΣ−1(xn − µ1)

tn ln|Σ| −

−

n=1

n=1

N

N

- 1

- 2


- 1

- 2


(1 − tn)(xn − µ2)TΣ−1(xn − µ2)

(1 − tn)ln|Σ| −

−

n=1

n=1

N 2

N 2

Tr Σ−1S (4.77)

= −

ln|Σ| −
