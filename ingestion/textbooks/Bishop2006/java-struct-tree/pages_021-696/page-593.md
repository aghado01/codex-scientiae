[Page 593]

![image 130](../../../../../images/imageFile130.png)

573

12.2. Probabilistic peA

where the D x D covariance matrix C is defined by

C = WWT + 0-

21.

(12.36)

This result can also be derived more directly by noting that the predictive distribution will be Gaussian and then evaluating its mean and covariance using (12.33). This gives

IE[Wz +JL + E] = JL IE [(Wz + E)(WZ + E)T] IE [WZZTWT] +IE[EET] = WWT+ 0-

IE[x]

(12.37)

cov[x]

21

(12.38)

where we have used the fact that z and E are independent random variables and hence are uncorrelated.

Intuitively, we can think of the distribution p(x) as being defined by taking an isotropic Gaussian 'spray can' and moving it across the principal subspace spraying Gaussian ink with density determined by 0-

2 and weighted by the prior distribution. The accumulated ink density gives rise to a 'pancake' shaped distribution representing the marginal density p(x).

2

The predictive distribution p(x) is governed by the parameters JL, W, and 0-

• However, there is redundancy in this parameterization corresponding to rotations of the latent space coordinates. To see this, consider a matrix W = WR where R is an orthogonal matrix. Using the orthogonality property RRT = I, we see that the quantity WWT that appears in the covariance matrix C takes the form

(12.39)

and hence is independent of R. Thus there is a whole family of matrices W all of which give rise to the same predictive distribution. This invariance can be understood in terms of rotations within the latent space. We shall return to a discussion of the number of independent parameters in this model later.

When we evaluate the predictive distribution, we require C-1, which involves the inversion of a D x D matrix. The computation required to do this can be reduced by making use of the matrix inversion identity (C.7) to give

C-1 = 0--11 - 0--2WM-1W T (12.40) where the M x M matrix M is defined by

M = WTW + 0-

21.

(12.41)

Because we invert M rather than inverting C directly, the cost of evaluating C-1 is reduced from O(D3) to O(M3 ).

As well as the predictive distribution p(x), we will also require the posterior distributionp(zlx), which can again be written down directly using the result (2.116) for linear-Gaussian models to give

Exercise 12.8

(12.42)

Note that the posterior mean depends on x, whereas the posterior covariance is independent of x.
