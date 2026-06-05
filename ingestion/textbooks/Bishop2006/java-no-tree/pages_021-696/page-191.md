[Page 191]

single variable x is given by

1 N

σML2 =

N

(xn − µML)2 (3.96)

n=1

and that this estimate is biased because the maximum likelihood solution µML for the mean has ﬁtted some of the noise on the data. In effect, this has used up one degree of freedom in the model. The corresponding unbiased estimate is given by (1.59) and takes the form

N

1 N − 1

σMAP2 =

(xn − µML)2. (3.97)

n=1

We shall see in Section 10.1.3 that this result can be obtained from a Bayesian treatment in which we marginalize over the unknown mean. The factor of N − 1 in the denominator of the Bayesian result takes account of the fact that one degree of freedom has been used in ﬁtting the mean and removes the bias of maximum likelihood. Now consider the corresponding results for the linear regression model. The mean of the target distribution is now given by the function wTφ(x), which contains M parameters. However, not all of these parameters are tuned to the data. The effective number of parameters that are determined by the data is γ, with the remaining M −γ parameters set to small values by the prior. This is reﬂected in the Bayesian result for the variance that has a factor N − γ in the denominator, thereby correcting for the bias of the maximum likelihood result.

We can illustrate the evidence framework for setting hyperparameters using the sinusoidal synthetic data set from Section 1.1, together with the Gaussian basis function model comprising 9 basis functions, so that the total number of parameters in the model is given by M = 10 including the bias. Here, for simplicity of illustration, we have set β to its true value of 11.1 and then used the evidence framework to determine α, as shown in Figure 3.16.

We can also see how the parameter α controls the magnitude of the parameters

{wi}, by plotting the individual parameters versus the effective number γ of parameters, as shown in Figure 3.17.

If we consider the limit N M in which the number of data points is large in relation to the number of parameters, then from (3.87) all of the parameters will be well determined by the data because ΦTΦ involves an implicit sum over data points, and so the eigenvalues λi increase with the size of the data set. In this case, γ = M, and the re-estimation equations for α and β become

α =

β =

M 2EW(mN)

N 2ED(mN)

(3.98)

(3.99)

where EW and ED are deﬁned by (3.25) and (3.26), respectively. These results can be used as an easy-to-compute approximation to the full evidence re-estimation
