[Page 43]

on this estimate are obtained by considering the distribution of possible data sets D. By contrast, from the Bayesian viewpoint there is only a single data set D (namely the one that is actually observed), and the uncertainty in the parameters is expressed through a probability distribution over w.

A widely used frequentist estimator is maximum likelihood, in which w is set to the value that maximizes the likelihood function p(D|w). This corresponds to choosing the value of w for which the probability of the observed data set is maximized. In the machine learning literature, the negative log of the likelihood function is called an error function. Because the negative logarithm is a monotonically decreasing function, maximizing the likelihood is equivalent to minimizing the error.

One approach to determining frequentist error bars is the bootstrap (Efron, 1979; Hastie et al., 2001), in which multiple data sets are created as follows. Suppose our original data set consists of N data points X = {x1,...,xN}. We can create a new data set XB by drawing N points at random from X, with replacement, so that some points in X may be replicated in XB, whereas other points in X may be absent from XB. This process can be repeated L times to generate L data sets each of size N and each obtained by sampling from the original data set X. The statistical accuracy of parameter estimates can then be evaluated by looking at the variability of predictions between the different bootstrap data sets.

One advantage of the Bayesian viewpoint is that the inclusion of prior knowledge arises naturally. Suppose, for instance, that a fair-looking coin is tossed three times and lands heads each time. A classical maximum likelihood estimate of the

Section 2.1 probability of landing heads would give 1, implying that all future tosses will land heads! By contrast, a Bayesian approach with any reasonable prior will lead to a much less extreme conclusion.

There has been much controversy and debate associated with the relative merits of the frequentist and Bayesian paradigms, which have not been helped by the fact that there is no unique frequentist, or even Bayesian, viewpoint. For instance, one common criticism of the Bayesian approach is that the prior distribution is often selected on the basis of mathematical convenience rather than as a reﬂection of any prior beliefs. Even the subjective nature of the conclusions through their dependence on the choice of prior is seen by some as a source of difﬁculty. Reducing

Section 2.4.3 the dependence on the prior is one motivation for so-called noninformative priors. However, these lead to difﬁculties when comparing different models, and indeed Bayesian methods based on poor choices of prior can give poor results with high conﬁdence. Frequentist evaluation methods offer some protection from such prob-

Section 1.3 lems, and techniques such as cross-validation remain useful in areas such as model

comparison.

This book places a strong emphasis on the Bayesian viewpoint, reﬂecting the huge growth in the practical importance of Bayesian methods in the past few years, while also discussing useful frequentist concepts as required.

Although the Bayesian framework has its origins in the 18th century, the practical application of Bayesian methods was for a long time severely limited by the difﬁculties in carrying through the full Bayesian procedure, particularly the need to marginalize (sum or integrate) over the whole of parameter space, which, as we shall
