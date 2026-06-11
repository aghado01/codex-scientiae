[Page 647]

we obtain the beta recursion given by (13.38). Again, we can verify that the beta variables themselves are equivalent by noting that (8.70) implies that the initial message send by the root variable node is µz

N→fN(zN) = 1, which is identical to the initialization of β(zN) given in Section 13.2.2.

The sum-product algorithm also speciﬁes how to evaluate the marginals once all the messages have been evaluated. In particular, the result (8.63) shows that the local marginal at the node zn is given by the product of the incoming messages. Because we have conditioned on the variables X = {x1,...,xN}, we are computing the joint distribution

n+1→zn(zn) = α(zn)β(zn). (13.53) Dividing both sides by p(X), we then obtain

p(zn,X) = µf

n→zn(zn)µf

p(zn,X) p(X)

γ(zn) =

α(zn)β(zn) p(X)

=

(13.54)

- Exercise 13.11 in agreement with (13.33). The result (13.43) can similarly be derived from (8.72).


###### 13.2.4 Scaling factors

There is an important issue that must be addressed before we can make use of the forward backward algorithm in practice. From the recursion relation (13.36), we note that at each step the new value α(zn) is obtained from the previous value α(zn−1) by multiplying by quantities p(zn|zn−1) and p(xn|zn). Because these probabilities are often signiﬁcantly less than unity, as we work our way forward along the chain, the values of α(zn) can go to zero exponentially quickly. For moderate lengths of chain (say 100 or so), the calculation of the α(zn) will soon exceed the dynamic range of the computer, even if double precision ﬂoating point is used.

In the case of i.i.d. data, we implicitly circumvented this problem with the evaluation of likelihood functions by taking logarithms. Unfortunately, this will not help here because we are forming sums of products of small numbers (we are in fact implicitly summing over all possible paths through the lattice diagram of Figure 13.7). We therefore work with re-scaled versions of α(zn) and β(zn) whose values remain of order unity. As we shall see, the corresponding scaling factors cancel out when we use these re-scaled quantities in the EM algorithm.

In (13.34), we deﬁned α(zn) = p(x1,...,xn,zn) representing the joint distribution of all the observations up to xn and the latent variable zn. Now we deﬁne a normalized version of α given by

α(zn) p(x1,...,xn)

α(zn) = p(zn|x1,...,xn) =

(13.55)

which we expect to be well behaved numerically because it is a probability distribution over K variables for any value of n. In order to relate the scaled and original alpha variables, we introduce scaling factors deﬁned by conditional distributions over the observed variables

cn = p(xn|x1,...,xn−1). (13.56)
