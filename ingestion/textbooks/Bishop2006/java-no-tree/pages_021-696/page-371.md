[Page 371]

basis vectors ϕ1,...,ϕM a similar intuition holds, namely that if a particular basis vector is poorly aligned with the data vector t, then it is likely to be pruned from the model.

We now investigate the mechanism for sparsity from a more mathematical perspective, for a general case involving M basis functions. To motivate this analysis we ﬁrst note that, in the result (7.87) for re-estimating the parameter αi, the terms on the right-hand side are themselves also functions of αi. These results therefore represent implicit solutions, and iteration would be required even to determine a single αi with all other αj for j = i ﬁxed.

This suggests a different approach to solving the optimization problem for the RVM, in which we make explicit all of the dependence of the marginal likelihood (7.85) on a particular αi and then determine its stationary points explicitly (Faul and Tipping, 2002; Tipping and Faul, 2003). To do this, we ﬁrst pull out the contribution from αi in the matrix C deﬁned by (7.86) to give

αj−1ϕjϕTj + αi−1ϕiϕTi

C = β−1I +

j =i

= C−i + αi−1ϕiϕTi (7.93)

where ϕi denotes the ith column of Φ, in other words the N-dimensional vector with elements (φi(x1),...,φi(xN)), in contrast to φn, which denotes the nth row of Φ. The matrix C−i represents the matrix C with the contribution from basis function i removed. Using the matrix identities (C.7) and (C.15), the determinant and inverse of C can then be written

|C| = |C−i||1 + αi−1ϕTi C−1

−iϕi| (7.94) C−1 = C−1

C−1

−iϕiϕTi C−1

−i αi + ϕTi C−1

. (7.95)

−i −

−iϕi

Using these results, we can then write the log marginal likelihood function (7.85) in

###### Exercise 7.15 the form L(α) = L(α−i) + λ(αi) (7.96)

where L(α−i) is simply the log marginal likelihood with basis function ϕi omitted, and the quantity λ(αi) is deﬁned by

1 2

λ(αi) =

qi2 αi + si

lnαi − ln(αi + si) +

(7.97)

and contains all of the dependence on αi. Here we have introduced the two quantities

si = ϕTi C−1

−iϕi (7.98) qi = ϕTi C−1

−it. (7.99)

Here si is called the sparsity and qi is known as the quality of ϕi, and as we shall see, a large value of si relative to the value of qi means that the basis function ϕi
