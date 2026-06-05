[Page 272]

###### 5.4.3 Inverse Hessian

We can use the outer-product approximation to develop a computationally efﬁcient procedure for approximating the inverse of the Hessian (Hassibi and Stork, 1993). First we write the outer-product approximation in matrix notation as

N

HN =

bnbTn (5.86)

n=1

where bn ≡ ∇wan is the contribution to the gradient of the output unit activation arising from data point n. We now derive a sequential procedure for building up the Hessian by including data points one at a time. Suppose we have already obtained the inverse Hessian using the ﬁrst L data points. By separating off the contribution from data point L + 1, we obtain

HL+1 = HL + bL+1bTL+1. (5.87) In order to evaluate the inverse of the Hessian, we now consider the matrix identity

(M−1v) vTM−1 1 + vTM−1v

M + vvT −1 = M−1 −

(5.88)

where I is the unit matrix, which is simply a special case of the Woodbury identity (C.7). If we now identify HL with M and bL+1 with v, we obtain

H−1

L bL+1bTL+1H−1

L 1 + bTL+1H−1

H−1

L+1 = H−1

. (5.89)

L −

L bL+1

In this way, data points are sequentially absorbed until L+1 = N and the whole data set has been processed. This result therefore represents a procedure for evaluating the inverse of the Hessian using a single pass through the data set. The initial matrix H0 is chosen to be αI, where α is a small quantity, so that the algorithm actually ﬁnds the inverse of H + αI. The results are not particularly sensitive to the precise value of α. Extension of this algorithm to networks having more than one output is

- Exercise 5.21 straightforward. We note here that the Hessian matrix can sometimes be calculated indirectly as


part of the network training algorithm. In particular, quasi-Newton nonlinear optimization algorithms gradually build up an approximation to the inverse of the Hessian during training. Such algorithms are discussed in detail in Bishop and Nabney (2008).

###### 5.4.4 Finite differences

As in the case of the ﬁrst derivatives of the error function, we can ﬁnd the second derivatives by using ﬁnite differences, with accuracy limited by numerical precision. If we perturb each possible pair of weights in turn, we obtain

1

∂2E ∂wji∂wlk

4 2 {E(wji +  ,wlk + ) − E(wji +  ,wlk − ) −E(wji −  ,wlk + ) + E(wji −  ,wlk − )} + O( 2). (5.90)

=
