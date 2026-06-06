[Page 183]

Figure 3.12 We can obtain a rough approximation to the model evidence if we assume that the posterior distribution over parameters is sharply peaked around its mode wMAP.

∆wposterior

wMAP w

∆wprior

and so taking logs we obtain

lnp(D) lnp(D|wMAP) + ln

∆wposterior ∆wprior

. (3.71)

This approximation is illustrated in Figure 3.12. The ﬁrst term represents the ﬁt to the data given by the most probable parameter values, and for a ﬂat prior this would correspond to the log likelihood. The second term penalizes the model according to its complexity. Because ∆wposterior < ∆wprior this term is negative, and it increases in magnitude as the ratio ∆wposterior/∆wprior gets smaller. Thus, if parameters are ﬁnely tuned to the data in the posterior distribution, then the penalty term is large.

For a model having a set of M parameters, we can make a similar approximation for each parameter in turn. Assuming that all parameters have the same ratio of ∆wposterior/∆wprior, we obtain

lnp(D) lnp(D|wMAP) + M ln

∆wposterior ∆wprior

. (3.72)

Thus, in this very simple approximation, the size of the complexity penalty increases linearly with the number M of adaptive parameters in the model. As we increase the complexity of the model, the ﬁrst term will typically decrease, because a more complex model is better able to ﬁt the data, whereas the second term will increase due to the dependence on M. The optimal model complexity, as determined by the maximum evidence, will be given by a trade-off between these two competing terms. We shall later develop a more reﬁned version of this approximation, based on

Section 4.4.1 a Gaussian approximation to the posterior distribution.

We can gain further insight into Bayesian model comparison and understand how the marginal likelihood can favour models of intermediate complexity by considering Figure 3.13. Here the horizontal axis is a one-dimensional representation of the space of possible data sets, so that each point on this axis corresponds to a speciﬁc data set. We now consider three models M1, M2 and M3 of successively increasing complexity. Imagine running these models generatively to produce example data sets, and then looking at the distribution of data sets that result. Any given
