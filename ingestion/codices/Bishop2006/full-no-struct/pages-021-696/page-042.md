[Page 42]

tion of probability. Consider the example of polynomial curve ﬁtting discussed in Section 1.1. It seems reasonable to apply the frequentist notion of probability to the random values of the observed variables t n . However, we would like to address and quantify the uncertainty that surrounds the appropriate choice for the model parameters w . We shall see that, from a Bayesian perspective, we can use the machinery of probability theory to describe the uncertainty in model parameters such as w , or indeed in the choice of model itself.

Bayes’ theorem now acquires a new signiﬁcance. Recall that in the boxes of fruit example, the observation of the identity of the fruit provided relevant information that altered the probability that the chosen box was the red one. In that example, Bayes’ theorem was used to convert a prior probability into a posterior probability by incorporating the evidence provided by the observed data. As we shall see in detail later, we can adopt a similar approach when making inferences about quantities such as the parameters w in the polynomial curve ﬁtting example. We capture our assumptions about w , before observing the data, in the form of a prior probability distribution p ( w ) . The effect of the observed data D = { t 1 ,...,t N } is expressed through the conditional probability p ( D| w ) , and we shall see later, in Section 1.2.5, how this can be represented explicitly. Bayes’ theorem, which takes the form

$$
p ( \mathbf w | \mathcal { D } ) = \frac { p ( \mathcal { D } | \mathbf w ) p ( \mathbf w ) } { p ( \mathcal { D } ) }
$$

then allows us to evaluate the uncertainty in w after we have observed D in the form of the posterior probability p ( w |D ) . The quantity p ( D| w ) on the right-hand side of Bayes’ theorem is evaluated for

the observed data set D and can be viewed as a function of the parameter vector w , in which case it is called the likelihood function . It expresses how probable the observed data set is for different settings of the parameter vector w . Note that the likelihood is not a probability distribution over w , and its integral with respect to w does not (necessarily) equal one.

Given this deﬁnition of likelihood, we can state Bayes’ theorem in words

$$
\text {poster} \, \alpha \, \text {likehood} \times \text {prior}
$$

where all of these quantities are viewed as functions of w . The denominator in (1.43) is the normalization constant, which ensures that the posterior distribution on the left-hand side is a valid probability density and integrates to one. Indeed, integrating both sides of (1.43) with respect to w , we can express the denominator in Bayes’ theorem in terms of the prior distribution and the likelihood function

$$
\int \lim i t s _ { \ } o r { \ } \text {proj} \int \lim i t s _ { \ } o r { \ } \text {lukhoid} \int \lim i t s _ { \ } o r { \ } \text {proj} \int ( \mathcal { D } | w ) p ( w ) \, d w .
$$

In both the Bayesian and frequentist paradigms, the likelihood function p ( D| w ) plays a central role. However, the manner in which it is used is fundamentally different in the two approaches. In a frequentist setting, w is considered to be a ﬁxed parameter, whose value is determined by some form of ‘estimator’, and error bars
