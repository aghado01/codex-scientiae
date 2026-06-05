[Page 602]

![image 139](../../../../../images/imageFile139.png)

###### 582 12. CONTINUOUS LATENT VARIABLES

Figure 12.13 Probabilistic graphical model for Bayesian peA in which the distribution over the parameter matrix W is governed by a vector a of hyperparameters.

###### w

N

proximation, which is appropriate when the number of data points is relatively large and the corresponding posterior distribution is tightly peaked (Bishop, 1999a). It involves a specific choice of prior over W that allows surplus dimensions in the principal subspace to be pruned out of the model. This corresponds to an example of automatic relevance determination, or ARD, discussed in Section 7.2.2. Specifically, we define an independent Gaussian prior over each column of W, which represent the vectors defining the principal subspace. Each such Gaussian has an independent variance governed by a precision hyperparameter O:i so that

(12.60)

where Wi is the ith column of W. The resulting model can be represented using the directed graph shown in Figure 12.13.

The values for O:i will be found iteratively by maximizing the marginallikelihood function in which W has been integrated out. As a result of this optimization, some of the O:i may be driven to infinity, with the corresponding parameters vector Wi being driven to zero (the posterior distribution becomes a delta function at the origin) giving a sparse solution. The effective dimensionality of the principal subspace is then determined by the number of finite O:i values, and the corresponding vectors Wi can be thought of as 'relevant' for modelling the data distribution. In this way, the Bayesian approach is automatically making the trade-off between improving the fit to the data, by using a larger number of vectors Wi with their corresponding eigenvalues Ai each tuned to the data, and reducing the complexity of the model by suppressing some of the Wi vectors. The origins of this sparsity were discussed earlier in the context of relevance vector machines.

Section 7.2

The values of O:i are re-estimated during training by maximizing the log marginal likelihood given by

p(Xla,J-L,0'2)= Jp(XIW,J-L,O'2)p(Wla)dW (12.61)

where the log ofp(XIW, J-L, 0'2) is given by (12.43). Note that for simplicity we also treat J-L and 0'2 as parameters to be estimated, rather than defining priors over these parameters.
