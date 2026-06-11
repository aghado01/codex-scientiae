[Page 534]

![Figure 10.17](../images/imageFile250.png)

Figure 10.17 Comparison of expectation propagation, variational inference, and the Laplace approximation on the clutter problem. The left-hand plot shows the error in the predicted posterior mean versus the number of ﬂoating point operations, and the right-hand plot shows the corresponding results for the model evidence.

We shall focus on the case in which the approximating distribution is fully factorized, and we shall show that in this case expectation propagation reduces to loopy belief propagation (Minka, 2001a). To start with, we show this in the context of a simple example, and then we shall explore the general case.

First of all, recall from (10.17) that if we minimize the Kullback-Leibler divergence $\text{KL}(p || q)$ with respect to a factorized distribution $q$, then the optimal solution for each factor is simply the corresponding marginal of $p$.

Now consider the factor graph shown on the left in Figure 10.18, which was introduced earlier in the context of the sum-product algorithm. The joint distribution is given by

$$
p(\mathbf{x}) = f_a(x_1, x_2)f_b(x_2, x_3)f_c(x_2, x_4). \tag{10.225}
$$

We seek an approximation $q(\mathbf{x})$ that has the same factorization, so that

$$
q(\mathbf{x}) \propto f_a(x_1, x_2) f_b(x_2, x_3) f_c(x_2, x_4). \tag{10.226}
$$

Note that normalization constants have been omitted, and these can be re-instated at the end by local normalization, as is generally done in belief propagation. Now suppose we restrict attention to approximations in which the factors themselves factorize with respect to the individual variables so that

$$
q(\mathbf{x}) \propto \widetilde{f}_{a1}(x_1) \widetilde{f}_{a2}(x_2) \widetilde{f}_{b2}(x_2) \widetilde{f}_{b3}(x_3) \widetilde{f}_{c2}(x_2) \widetilde{f}_{c4}(x_4) \tag{10.227}
$$

which corresponds to the factor graph shown on the right in Figure 10.18. Because the individual factors are factorized, the overall distribution $q(\mathbf{x})$ is itself fully factorized.

Now we apply the EP algorithm using the fully factorized approximation. Suppose that we have initialized all of the factors and that we choose to reﬁne factor
