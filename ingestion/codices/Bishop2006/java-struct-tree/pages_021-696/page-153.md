[Page 153]

2.29 (��) Using the partitioned matrix inversion formula (2.76), show that the inverse of

the precision matrix (2.104) is given by the covariance matrix (2.105).

2.30 (�) By starting from (2.107) and making use of the result (2.105), verify the result

(2.108).

2.31 (��) Consider two multidimensional random vectors x and z having Gaussian distributions p(x) = N(x|µx,Σx) and p(z) = N(z|µz,Σz) respectively, together with their sum y = x+z. Use the results (2.109) and (2.110) to ﬁnd an expression for the marginal distribution p(y) by considering the linear-Gaussian model comprising the product of the marginal distribution p(x) and the conditional distribution p(y|x).

2.32 (���) www This exercise and the next provide practice at manipulating the quadratic forms that arise in linear-Gaussian models, as well as giving an independent check of results derived in the main text. Consider a joint distribution p(x,y) deﬁned by the marginal and conditional distributions given by (2.99) and (2.100). By examining the quadratic form in the exponent of the joint distribution, and using the technique of ‘completing the square’ discussed in Section 2.3, ﬁnd expressions for the mean and covariance of the marginal distribution p(y) in which the variable x has been integrated out. To do this, make use of the Woodbury matrix inversion formula (2.289). Verify that these results agree with (2.109) and (2.110) obtained using the results of Chapter 2.

2.33 (���) Consider the same joint distribution as in Exercise 2.32, but now use the technique of completing the square to ﬁnd expressions for the mean and covariance of the conditional distribution p(x|y). Again, verify that these agree with the corresponding expressions (2.111) and (2.112).

2.34 (��) www To ﬁnd the maximum likelihood solution for the covariance matrix of a multivariate Gaussian, we need to maximize the log likelihood function (2.118) with respect to Σ, noting that the covariance matrix must be symmetric and positive deﬁnite. Here we proceed by ignoring these constraints and doing a straightforward maximization. Using the results (C.21), (C.26), and (C.28) from Appendix C, show that the covariance matrix Σ that maximizes the log likelihood function (2.118) is given by the sample covariance (2.122). We note that the ﬁnal result is necessarily symmetric and positive deﬁnite (provided the sample covariance is nonsingular).

2.35 (��) Use the result (2.59) to prove (2.62). Now, using the results (2.59), and (2.62),

show that

E[xnxm] = µµT + InmΣ (2.291)

where xn denotes a data point sampled from a Gaussian distribution with mean µ and covariance Σ, and Inm denotes the (n,m) element of the identity matrix. Hence prove the result (2.124).

2.36 (��) www Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the variance of a univariate Gaussian
