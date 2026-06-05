[Page 534]

Evidence

Posterior mean

|ep<br><br>laplace vb<br><br>|
|---|


|ep<br><br>vb<br><br>laplace<br><br>|
|---|


100

10−200

Error

Error

10−202

10−5

10−204

104 106

104 106

FLOPS

FLOPS

- Figure 10.17 Comparison of expectation propagation, variational inference, and the Laplace approximation on the clutter problem. The left-hand plot shows the error in the predicted posterior mean versus the number of ﬂoating point operations, and the right-hand plot shows the corresponding results for the model evidence.


We shall focus on the case in which the approximating distribution is fully factorized, and we shall show that in this case expectation propagation reduces to loopy belief propagation (Minka, 2001a). To start with, we show this in the context of a simple example, and then we shall explore the general case.

First of all, recall from (10.17) that if we minimize the Kullback-Leibler divergence KL(p q) with respect to a factorized distribution q, then the optimal solution for each factor is simply the corresponding marginal of p.

Now consider the factor graph shown on the left in Figure 10.18, which was Section 8.4.4 introduced earlier in the context of the sum-product algorithm. The joint distribution

is given by

- p(x) = fa(x1,x2)fb(x2,x3)fc(x2,x4). (10.225) We seek an approximation q(x) that has the same factorization, so that
- q(x) ∝ fa(x1,x2) fb(x2,x3) fc(x2,x4). (10.226)


Note that normalization constants have been omitted, and these can be re-instated at the end by local normalization, as is generally done in belief propagation. Now suppose we restrict attention to approximations in which the factors themselves factorize with respect to the individual variables so that

###### q(x) ∝ fa1(x1) fa2(x2) fb2(x2) fb3(x3) fc2(x2) fc4(x4) (10.227)

which corresponds to the factor graph shown on the right in Figure 10.18. Because the individual factors are factorized, the overall distribution q(x) is itself fully factorized.

Now we apply the EP algorithm using the fully factorized approximation. Suppose that we have initialized all of the factors and that we choose to reﬁne factor
