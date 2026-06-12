[Page 598]

![image 135](../../../../../images/imageFile135.png)

578 12. CONTINUOUS LATENT VARIABLES

are assumed independent, the complete-data log likelihood function takes the form

N

Inp(X,ZIJL,W,(J2) = L {lnp(xnlzn) + lnp(zn)}

(12.52)

n=l

where the nth row of the matrix Z is given by Zn. We already know that the exact maximum likelihood solution for JL is given by the sample mean x defined by (12.1), and it is convenient to substitute for JL at this stage. Making use of the expressions (12.31) and (12.32) for the latent and conditional distributions, respectively, and taking the expectation with respect to the posterior distribution over the latent variables, we obtain

Note that this depends on the posterior distribution only through the sufficient statistics of the Gaussian. Thus in the E step, we use the old parameter values to evaluate

M-1WT(Xn - x)

(12.54) (12.55)

1 + lE[zn]lE[zn]T

(J2M-

which follow directly from the posterior distribution (12.42) together with the standard result lE[znz~] = cov[zn] + JE[zn]JE[zn]T. Here M is defined by (12.41).

In the M step, we maximize with respect to Wand (J2, keeping the posterior statistics fixed. Maximization with respect to (T2 is straightforward. For the maximization with respect to W we make use of (C.24), and obtain the M-step equations

Exercise 12.15

[t,exn-X)IlIZn]T] [t,Il[ZnZ~]]-'

(12.56)

W new

1 N

ND L {llxn- xl12 - 2lE[zn]TW~ew(xn - x)

(Jnew2 =

n=l

+Tr (JE[znzJ]W~ewW new)}.

(12.57)

The EM algorithm for probabilistic PCA proceeds by initializing the parameters and then alternately computing the sufficient statistics of the latent space posterior distribution using (12.54) and (12.55) in the E step and revising the parameter values using (12.56) and (12.57) in the M step.

One of the benefits of the EM algorithm for PCA is computational efficiency for large-scale applications (Roweis, 1998). Unlike conventional PCA based on an
