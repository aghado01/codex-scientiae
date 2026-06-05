[Page 182]

different models, and we shall examine this term in more detail shortly. The model evidence is sometimes also called the marginal likelihood because it can be viewed as a likelihood function over the space of models, in which the parameters have been marginalized out. The ratio of model evidences p ( D|M i ) /p ( D|M j ) for two models is known as a Bayes factor (Kass and Raftery, 1995).

Once we know the posterior distribution over models, the predictive distribution is given, from the sum and product rules, by

$$
p ( t | x , \mathcal { D } ) = \sum _ { i = 1 } ^ { L } p ( t | x , \mathcal { M } _ { i } , \mathcal { D } ) p ( \mathcal { M } _ { i } | \mathcal { D } ) . \\ \exp o r { L } = \sum _ { i = 1 } ^ { L } p ( t | x , \mathcal { M } _ { i } , \mathcal { D } ) p ( \mathcal { M } _ { i } | \mathcal { D } ) . \\
$$

This is an example of a mixture distribution in which the overall predictive distribution is obtained by averaging the predictive distributions p ( t | x , M i , D ) of individual models, weighted by the posterior probabilities p ( M i |D ) of those models. For instance, if we have two models that are a-posteriori equally likely and one predicts a narrow distribution around t = a while the other predicts a narrow distribution around t = b , the overall predictive distribution will be a bimodal distribution with modes at t = a and t = b , not a single model at t = ( a + b ) / 2 .

A simple approximation to model averaging is to use the single most probable model alone to make predictions. This is known as model selection .

For a model governed by a set of parameters w , the model evidence is given, from the sum and product rules of probability, by

$$
\sum p ( \mathcal { D } | \mathcal { M } _ { i } ) & = \int p ( \mathcal { D } | w , \mathcal { M } _ { i } ) p ( w | \mathcal { M } _ { i } ) \, d w . \\ \intertext { s u m i n g p a r s e c t i v e } \text {sampling perspective} \, \colon \, the \, m a g r i n a l \, l i k l i o h o d \, c a n \, b e \, v i e w e d \, as \, t h e \, \proba- }
$$

From a sampling perspective, the marginal likelihood can be viewed as the probability of generating the data set D from a model whose parameters are sampled at random from the prior. It is also interesting to note that the evidence is precisely the normalizing term that appears in the denominator in Bayes’ theorem when evaluating the posterior distribution over parameters because

$$
p ( w | \mathcal { D } , \mathcal { M } _ { i } ) = \frac { p ( \mathcal { D } | w , \mathcal { M } _ { i } ) p ( w | \mathcal { M } _ { i } ) } { p ( \mathcal { D } | \mathcal { M } _ { i } ) } . \\
$$

We can obtain some insight into the model evidence by making a simple approximation to the integral over parameters. Consider ﬁrst the case of a model having a single parameter w . The posterior distribution over parameters is proportional to p ( D| w ) p ( w ) , where we omit the dependence on the model M i to keep the notation uncluttered. If we assume that the posterior distribution is sharply peaked around the most probable value w MAP , with width ∆ w posterior , then we can approximate the integral by the value of the integrand at its maximum times the width of the peak. If we further assume that the prior is ﬂat with width ∆ w prior so that p ( w ) = 1 / ∆ w prior , then we have

$$
\text { when we have } & & p ( \mathcal { D } ) = \int p ( \mathcal { D } | w ) p ( w ) \, d w \simeq p ( \mathcal { D } | w _ { \text {MAP} } ) \frac { \Delta w _ { \text {posterior} } } { \Delta w _ { \text {prior} } }
$$
