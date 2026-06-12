[Page 103]

where again we have changed variables using z = x − µ. Note that the cross-terms involving µzT and µTz will again vanish by symmetry. The term µµT is constant and can be taken outside the integral, which itself is unity because the Gaussian distribution is normalized. Consider the term involving zzT. Again, we can make use of the eigenvector expansion of the covariance matrix given by (2.45), together with the completeness of the set of eigenvectors, to write

D

z =

yjuj (2.60)

j=1

where yj = uTj z, which gives

1 (2π)D/2

1 |Σ|1/2

- 1

- 2


###### zTΣ−1z zzT dz

exp −

D

###### D

D

1 |Σ|1/2

1 (2π)D/2

yk2 2λk

uiuTj exp −

yiyj dy

=

i=1

j=1

k=1

D

uiuTi λi = Σ (2.61)

=

i=1

where we have made use of the eigenvector equation (2.45), together with the fact that the integral on the right-hand side of the middle line vanishes by symmetry unless i = j, and in the ﬁnal line we have made use of the results (1.50) and (2.55), together with (2.48). Thus we have

###### E[xxT] = µµT + Σ. (2.62)

For single random variables, we subtracted the mean before taking second moments in order to deﬁne a variance. Similarly, in the multivariate case it is again convenient to subtract off the mean, giving rise to the covariance of a random vector x deﬁned by

cov[x] = E (x − E[x])(x − E[x])T . (2.63)

For the speciﬁc case of a Gaussian distribution, we can make use of E[x] = µ, together with the result (2.62), to give

###### cov[x] = Σ. (2.64)

Because the parameter matrix Σ governs the covariance of x under the Gaussian distribution, it is called the covariance matrix.

Although the Gaussian distribution (2.43) is widely used as a density model, it suffers from some signiﬁcant limitations. Consider the number of free parameters in the distribution. A general symmetric covariance matrix Σ will have D(D + 1)/2

- Exercise 2.21 independent parameters, and there are another D independent parameters in µ, giving D(D + 3)/2 parameters in total. For large D, the total number of parameters
