[Page 185]

a Bayesian approach, like any approach to pattern recognition, needs to make assumptions about the form of the model, and if these are invalid then the results can be misleading. In particular, we see from Figure 3.12 that the model evidence can be sensitive to many aspects of the prior, such as the behaviour in the tails. Indeed, the evidence is not deﬁned if the prior is improper, as can be seen by noting that an improper prior has an arbitrary scaling factor (in other words, the normalization coefﬁcient is not deﬁned because the distribution cannot be normalized). If we consider a proper prior and then take a suitable limit in order to obtain an improper prior (for example, a Gaussian prior in which we take the limit of inﬁnite variance) then the evidence will go to zero, as can be seen from (3.70) and Figure 3.12. It may, however, be possible to consider the evidence ratio between two models ﬁrst and then take a limit to obtain a meaningful answer.

In a practical application, therefore, it will be wise to keep aside an independent test set of data on which to evaluate the overall performance of the ﬁnal system.

3.5. The Evidence Approximation

In a fully Bayesian treatment of the linear basis function model, we would introduce prior distributions over the hyperparameters α and β and make predictions by marginalizing with respect to these hyperparameters as well as with respect to the parameters w. However, although we can integrate analytically over either w or over the hyperparameters, the complete marginalization over all of these variables is analytically intractable. Here we discuss an approximation in which we set the hyperparameters to speciﬁc values determined by maximizing the marginal likelihood function obtained by ﬁrst integrating over the parameters w. This framework is known in the statistics literature as empirical Bayes (Bernardo and Smith, 1994; Gelman et al., 2004), or type 2 maximum likelihood (Berger, 1985), or generalized maximum likelihood (Wahba, 1975), and in the machine learning literature is also called the evidence approximation (Gull, 1989; MacKay, 1992a).

If we introduce hyperpriors over α and β, the predictive distribution is obtained by marginalizing over w, α and β so that

p(t|t) = ��� p(t|w,β)p(w|t,α,β)p(α,β|t)dw dαdβ (3.74)

where p(t|w,β) is given by (3.8) and p(w|t,α,β) is given by (3.49) with mN and SN deﬁned by (3.53) and (3.54) respectively. Here we have omitted the dependence on the input variable x to keep the notation uncluttered. If the posterior distribution p(α,β|t) is sharply peaked around values α� and β�, then the predictive distribution is obtained simply by marginalizing over w in which α and β are ﬁxed to the values α� and β�, so that

p(t|t) � p(t|t,α,� β�) = � p(t|w,β�)p(w|t,α,� β�)dw. (3.75)
