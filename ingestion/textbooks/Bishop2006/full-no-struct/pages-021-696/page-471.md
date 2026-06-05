[Page 471]

Figure 9.11

Illustration of the decomposition given by (9.70), which holds for any choice of distribution q ( Z ) . Because the Kullback-Leibler divergence satisﬁes KL( q p ) 0 , we see that the quantity L ( q, θ ) is a lower bound on the log likelihood function ln p ( X | θ ) .

![In this image we can see a graph.](../images/imageFile226.png)

||

KL( q

q

p

)

L

|

θ

θ

(

q,

)

ln p

p

(

)

X

# Exercise 9.24

Section 1.6.1

carefully the forms of the expressions (9.71) and (9.72), and in particular noting that they differ in sign and also that L ( q, θ ) contains the joint distribution of X and Z while KL( q p ) contains the conditional distribution of Z given X . To verify the decomposition (9.70), we ﬁrst make use of the product rule of probability to give

$$
\ln p ( X , Z | \theta ) = \ln p ( Z | X , \theta ) + \ln p ( X | \theta )
$$

which we then substitute into the expression for L ( q, θ ) . This gives rise to two terms, one of which cancels KL( q p ) while the other gives the required log likelihood ln p ( X | θ ) after noting that q ( Z ) is a normalized distribution that sums to 1 . From (9.72), we see that KL( q p ) is the Kullback-Leibler divergence between

q ( Z ) and the posterior distribution p ( Z | X , θ ) . Recall that the Kullback-Leibler divergence satisﬁes KL( q p ) 0 , with equality if, and only if, q ( Z ) = p ( Z | X , θ ) . It therefore follows from (9.70) that L ( q, θ ) ln p ( X | θ ) , in other words that L ( q, θ ) is a lower bound on ln p ( X | θ ) . The decomposition (9.70) is illustrated in Figure 9.11.

The EM algorithm is a two-stage iterative optimization technique for ﬁnding maximum likelihood solutions. We can use the decomposition (9.70) to deﬁne the EM algorithm and to demonstrate that it does indeed maximize the log likelihood. Suppose that the current value of the parameter vector is θ old . In the E step, the lower bound L ( q, θ old ) is maximized with respect to q ( Z ) while holding θ old ﬁxed. The solution to this maximization problem is easily seen by noting that the value of ln p ( X | θ old ) does not depend on q ( Z ) and so the largest value of L ( q, θ old ) will occur when the Kullback-Leibler divergence vanishes, in other words when q ( Z ) is equal to the posterior distribution p ( Z | X , θ old ) . In this case, the lower bound will equal the log likelihood, as illustrated in Figure 9.12.

In the subsequent M step, the distribution q ( Z ) is held ﬁxed and the lower bound L ( q, θ ) is maximized with respect to θ to give some new value θ new . This will cause the lower bound L to increase (unless it is already at a maximum), which will necessarily cause the corresponding log likelihood function to increase. Because the distribution q is determined using the old parameter values rather than the new values and is held ﬁxed during the M step, it will not equal the new posterior distribution p ( Z | X , θ new ) , and hence there will be a nonzero KL divergence. The increase in the log likelihood function is therefore greater than the increase in the lower bound, as
