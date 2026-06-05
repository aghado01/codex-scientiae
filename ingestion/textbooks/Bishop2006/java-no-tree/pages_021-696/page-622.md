[Page 622]

![image 159](../../../../../images/imageFile159.png)

###### 602 12. CONTINUOUS LATENT VARIABLES

- 12.22 (**) Write down an expression for the expected complete-data log likelihood function for the factor analysis model, and hence derive the corresponding M step equations (12.69) and (12.70).
- 12.23 (*) III!I Draw a directed probabilistic graphical model representing a discrete

mixture of probabilistic PCA models in which each PCA model has its own values of W, JL, and 0-

2

• Now draw a modified graph in which these parameter values are shared between the components of the mixture.

- 12.24 (***) We saw in Section 2.3.7 that Student's t-distribution can be viewed as an infinite mixture of Gaussians in which we marginalize with respect to a continuous latent variable. By exploiting this representation, formulate an EM algorithm for maximizing the log likelihood function for a multivariate Student's t-distribution given an observed set of data points, and derive the forms of the E and M step equations.
- 12.25 (**)III!I Consideralinear-Gaussianlatent-variablemodel having alatentspace

distribution p(z) = N(xIO, I) and a conditional distribution for the observed variable p(xlz) = N(xlWz + IL, <p) where <P is an arbitrary symmetric, positivedefinite noise covariance matrix. Now suppose that we make a nonsingular linear transformation of the data variables x ---t Ax, where A is a D x D matrix. If JLML' W ML and <PML represent the maximum likelihood solution corresponding to the original untransformed data, show that AJLML' AWML, and A<PMLAT will represent the corresponding maximum likelihood solution for the transformed data set. Finally, show that the form of the model is preserved in two cases: (i) A is a diagonal matrix and <P is a diagonal matrix. This corresponds to the case of factor analysis. The transformed <P remains diagonal, and hence factor analysis is covariant under component-wise re-scaling of the data variables; (ii) A is orthogonal and <P is proportional to the unit matrix so that <P = 0-

21. This corresponds to probabilistic PCA. The transformed <P matrix remains proportional to the unit matrix, and hence probabilistic PCA is covariant under a rotation of the axes of data space, as is the case for conventional PCA.

- 12.26 (**) Show that any vector\ ai that satisfies (12.80) will also satisfy (12.79). Also, show that for any solution of (12.80) having eigenvalue A, we can add any multiple of an eigenvector of K having zero eigenvalue, and obtain a solution to (12.79) that also has eigenvalue A. Finally, show that such modifications do not affect the principal-component projection given by (12.82).
- 12.27 (**) Show that the conventional linear PCA algorithm is recovered as a special case of kernel PCA if we choose the linear kernel function given by k(x, x') = xTx'.
- 12.28 (**)III!I Use the transformation property (1.27) ofa probability density under


a change of variable to show that any density p(y) can be obtained from a fixed density q(x) that is everywhere nonzero by making a nonlinear change of variable y = f(x) in which f(x) is a monotonic function so that 0 :::; j'(x) < 00. Write down the differential equation satisfied by f (x) and draw a diagram illustrating the transformation of the density.
