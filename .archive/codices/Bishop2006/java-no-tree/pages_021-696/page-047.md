[Page 47]

function can be written in the form

- 1

- 2σ2


lnp x|µ,σ2 = −

N

N 2

(xn − µ)2 −

n=1

N 2

lnσ2 −

ln(2π). (1.54)

Maximizing (1.54) with respect to µ, we obtain the maximum likelihood solution

- Exercise 1.11 given by

µML =

1 N

N

n=1

xn (1.55)

which is the sample mean, i.e., the mean of the observed values {xn}. Similarly, maximizing (1.54) with respect to σ2, we obtain the maximum likelihood solution for the variance in the form

σML2 =

1 N

N

n=1

(xn − µML)2 (1.56)

which is the sample variance measured with respect to the sample mean µML. Note that we are performing a joint maximization of (1.54) with respect to µ and σ2, but in the case of the Gaussian distribution the solution for µ decouples from that for σ2 so that we can ﬁrst evaluate (1.55) and then subsequently use this result to evaluate (1.56).

Later in this chapter, and also in subsequent chapters, we shall highlight the signiﬁcant limitations of the maximum likelihood approach. Here we give an indication of the problem in the context of our solutions for the maximum likelihood parameter settings for the univariate Gaussian distribution. In particular, we shall show that the maximum likelihood approach systematically underestimates the variance of the distribution. This is an example of a phenomenon called bias and is related

Section 1.1 to the problem of over-ﬁtting encountered in the context of polynomial curve ﬁtting.

We ﬁrst note that the maximum likelihood solutions µML and σML2 are functions of the data set values x1,...,xN. Consider the expectations of these quantities with respect to the data set values, which themselves come from a Gaussian distribution

- Exercise 1.12 with parameters µ and σ2. It is straightforward to show that E[µML] = µ (1.57)


N − 1 N

E[σML2 ] =

σ2 (1.58)

so that on average the maximum likelihood estimate will obtain the correct mean but will underestimate the true variance by a factor (N − 1)/N. The intuition behind this result is given by Figure 1.15.

From (1.58) it follows that the following estimate for the variance parameter is unbiased

N

1 N − 1

N N − 1

σ2 =

σML2 =

(xn − µML)2. (1.59)

n=1
