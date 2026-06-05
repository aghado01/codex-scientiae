[Page 594]

![image 131](../../../../../images/imageFile131.png)

574 12. CONTINUOUS LATENT VARIABLES

Figure 12.10 The probabilistic peA model for a data set of N observations of x can be expressed as a directed graph in which each observation X n is associated with a value Zn of the latent variable.

..-+--w

N

12.2.1 Maximum likelihood peA

We next consider the determination of the model parameters using maximum

likelihood. Given a data set X = {xn } of observed data points, the probabilistic peA model can be expressed as a directed graph, as shown in Figure 12.10. The corresponding log likelihood function is given, from (12.35), by

N

Inp(XIJL,W,O'2) = L lnp(xnIW,JL,O'2)

n=l

--2-NDln(2n)- 2N lnIe[- 21""L,..(xn - JL)T 1c- (xn - JL). (12.43)

N

n=l

Setting the derivative of the log likelihood with respect to JL equal to zero gives the

expectedresult JL =xwherexis the data mean defined by (12.1). Back-substituting

we can then write the log likelihood function in the form

N

Inp(XIW, JL, 0'2) = -2 {D In(2n) + In Ie[ +Tr (C-1S)} (12.44)

where S is the data covariance matrix defined by (12.3). Because the log likelihood is a quadratic function of JL, this solution represents the unique maximum, as can be confirmed by computing second derivatives.

Maximization with respect to W and 0'2 is more complex but nonetheless has an exact closed-form solution. It was shown by Tipping and Bishop (1999b) that all of the stationary points of the log likelihood function can be written as

(12.45)

where U M is a D x M matrix whose columns are given by any subset (of size M) of the eigenvectors of the data covariance matrix S, the M x M diagonal matrix LM has elements given by the corresponding eigenvalues ..\, and R is an arbitrary M x M orthogonal matrix.

Furthermore, Tipping and Bishop (1999b) showed that the maximum of the likelihood function is obtained when the M eigenvectors are chosen to be those whose eigenvalues are the M largest (all other solutions being saddle points). A similar result was conjectured independently by Roweis (1998), although no proof was given.
