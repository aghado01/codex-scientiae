[Page 39]

that the probability of x falling in an inﬁnitesimal volume δx containing the point x is given by p(x)δx. This multivariate probability density must satisfy

p(x) � 0 (1.29) � p(x)dx = 1 (1.30)

in which the integral is taken over the whole of x space. We can also consider joint probability distributions over a combination of discrete and continuous variables.

Note that if x is a discrete variable, then p(x) is sometimes called a probability mass function because it can be regarded as a set of ‘probability masses’ concentrated at the allowed values of x.

The sum and product rules of probability, as well as Bayes’ theorem, apply equally to the case of probability densities, or to combinations of discrete and continuous variables. For instance, if x and y are two real variables, then the sum and product rules take the form

p(x) = � p(x,y)dy (1.31) p(x,y) = p(y|x)p(x). (1.32)

A formal justiﬁcation of the sum and product rules for continuous variables (Feller, 1966) requires a branch of mathematics called measure theory and lies outside the scope of this book. Its validity can be seen informally, however, by dividing each real variable into intervals of width ∆ and considering the discrete probability distribution over these intervals. Taking the limit ∆ → 0 then turns sums into integrals and gives the desired result.

1.2.2 Expectations and covariances

One of the most important operations involving probabilities is that of ﬁnding weighted averages of functions. The average value of some function f(x) under a probability distribution p(x) is called the expectation of f(x) and will be denoted by E[f]. For a discrete distribution, it is given by

�

p(x)f(x) (1.33)

E[f] =

x

so that the average is weighted by the relative probabilities of the different values of x. In the case of continuous variables, expectations are expressed in terms of an integration with respect to the corresponding probability density

E[f] = � p(x)f(x)dx. (1.34)

In either case, if we are given a ﬁnite number N of points drawn from the probability distribution or probability density, then the expectation can be approximated as a
