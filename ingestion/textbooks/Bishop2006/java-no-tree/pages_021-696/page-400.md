[Page 400]

- Figure 8.24 A graphical representation of the ‘naive Bayes’ model for classiﬁcation. Conditioned on the class label z, the components of the observed


vector x = (x1, . . . , xD)T are assumed to be independent.

###### z

x1 xD

However, if we integrate over µ, the observations are in general no longer independent

N

∞

p(D|µ)p(µ)dµ =

p(xn). (8.35)

p(D) =

0

n=1

Here µ is a latent variable, because its value is not observed.

Another example of a model representing i.i.d. data is the graph in Figure 8.7 corresponding to Bayesian polynomial regression. Here the stochastic nodes correspond to {tn}, w and t. We see that the node for w is tail-to-tail with respect to the path from t to any one of the nodes tn and so we have the following conditional independence property

t ⊥ tn | w. (8.36) Thus, conditioned on the polynomial coefﬁcients w, the predictive distribution for t is independent of the training data {t1,...,tN}. We can therefore ﬁrst use the training data to determine the posterior distribution over the coefﬁcients w and then we can discard the training data and use the posterior distribution for w to make

- Section 3.3 predictions of t for new input observations x. A related graphical structure arises in an approach to classiﬁcation called the


naive Bayes model, in which we use conditional independence assumptions to simplify the model structure. Suppose our observed variable consists of a D-dimensional vector x = (x1,...,xD)T, and we wish to assign observed values of x to one of K classes. Using the 1-of-K encoding scheme, we can represent these classes by a Kdimensional binary vector z. We can then deﬁne a generative model by introducing a multinomial prior p(z|µ) over the class labels, where the kth component µk of µ is the prior probability of class Ck, together with a conditional distribution p(x|z) for the observed vector x. The key assumption of the naive Bayes model is that, conditioned on the class z, the distributions of the input variables x1,...,xD are independent. The graphical representation of this model is shown in Figure 8.24. We see that observation of z blocks the path between xi and xj for j = i (because such paths are tail-to-tail at the node z) and so xi and xj are conditionally independent given z. If, however, we marginalize out z (so that z is unobserved) the tail-to-tail path from xi to xj is no longer blocked. This tells us that in general the marginal density p(x) will not factorize with respect to the components of x. We encountered a simple application of the naive Bayes model in the context of fusing data from different sources for medical diagnosis in Section 1.5.

If we are given a labelled training set, comprising inputs {x1,...,xN} together with their class labels, then we can ﬁt the naive Bayes model to the training data
