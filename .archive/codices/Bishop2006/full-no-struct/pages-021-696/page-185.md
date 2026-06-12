[Page 185]

In a practical application, therefore, it will be wise to keep aside an independent test set of data on which to evaluate the overall performance of the ﬁnal system.

# 3.5. The Evidence Approximation

In a fully Bayesian treatment of the linear basis function model, we would introduce prior distributions over the hyperparameters α and β and make predictions by marginalizing with respect to these hyperparameters as well as with respect to the parameters w . However, although we can integrate analytically over either w or over the hyperparameters, the complete marginalization over all of these variables is analytically intractable. Here we discuss an approximation in which we set the hyperparameters to speciﬁc values determined by maximizing the marginal likelihood function obtained by ﬁrst integrating over the parameters w . This framework is known in the statistics literature as empirical Bayes (Bernardo and Smith, 1994; Gelman et al. , 2004), or type 2 maximum likelihood (Berger, 1985), or generalized maximum likelihood (Wahba, 1975), and in the machine learning literature is also called the evidence approximation (Gull, 1989; MacKay, 1992a).

If we introduce hyperpriors over α and β , the predictive distribution is obtained by marginalizing over w , α and β so that

$$
y \text { marginized} \, 0 \text {C} \, \text { w.} \, \alpha \text { and } \beta \text { so that} \\ p ( t | \mathfrak { t } ) = \iint p ( t | w , \beta ) p ( w | \mathfrak { t } , \alpha , \beta ) p ( \alpha , \beta | \mathfrak { t } ) \, d w \, d \alpha \, d \beta \\ y h o r \, o ( t | w , \mathfrak { t } ) \text { is given by } ( 3 . 8 ) \text { and } ( w | \mathfrak { t } , \alpha \, \mathfrak { t } ) \text { is given by } ( 3 . 4 ) \text { with } m \text {, and}
$$

where p ( t | w ,β ) is given by (3.8) and p ( w | t ,α,β ) is given by (3.49) with m N and S N deﬁned by (3.53) and (3.54) respectively. Here we have omitted the dependence on the input variable x to keep the notation uncluttered. If the posterior distribution p ( α,β | t ) is sharply peaked around values α and β , then the predictive distribution is obtained simply by marginalizing over w in which α and β are ﬁxed to the values α and β , so that p ( t | t ) p ( t | t , α, β ) = p ( t | w , β ) p ( w | t , α, β )d w . (3.75)

$$
p ( t | \mathfrak { t } ) \simeq p ( t | \mathfrak { t } , \widehat { \alpha } , \widehat { \beta } ) = \int p ( t | w , \widehat { \beta } ) p ( w | \mathfrak { t } , \widehat { \alpha } , \widehat { \beta } ) \, d w .
$$
