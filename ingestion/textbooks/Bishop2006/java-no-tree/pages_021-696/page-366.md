[Page 366]

where β = σ−2 is the noise precision (inverse noise variance), and the mean is given by a linear model of the form

y(x) =

M

wiφi(x) = wTφ(x) (7.77)

i=1

with ﬁxed nonlinear basis functions φi(x), which will typically include a constant term so that the corresponding weight parameter represents a ‘bias’.

The relevance vector machine is a speciﬁc instance of this model, which is intended to mirror the structure of the support vector machine. In particular, the basis functions are given by kernels, with one kernel associated with each of the data points from the training set. The general expression (7.77) then takes the SVM-like form

N

y(x) =

wnk(x,xn) + b (7.78)

n=1

where b is a bias parameter. The number of parameters in this case is M = N + 1, and y(x) has the same form as the predictive model (7.64) for the SVM, except that the coefﬁcients an are here denoted wn. It should be emphasized that the subsequent analysis is valid for arbitrary choices of basis function, and for generality we shall work with the form (7.77). In contrast to the SVM, there is no restriction to positivedeﬁnite kernels, nor are the basis functions tied in either number or location to the training data points.

Suppose we are given a set of N observations of the input vector x, which we

denote collectively by a data matrix X whose nth row is xTn with n = 1,...,N. The corresponding target values are given by t = (t1,...,tN)T. Thus, the likelihood function is given by

p(t|X,w,β) =

N

p(tn|xn,w,β−1). (7.79)

n=1

Next we introduce a prior distribution over the parameter vector w and as in Chapter 3, we shall consider a zero-mean Gaussian prior. However, the key difference in the RVM is that we introduce a separate hyperparameter αi for each of the weight parameters wi instead of a single shared hyperparameter. Thus the weight prior takes the form

M

N(wi|0,αi−1) (7.80)

p(w|α) =

i=1

where αi represents the precision of the corresponding parameter wi, and α denotes (α1,...,αM)T. We shall see that, when we maximize the evidence with respect to these hyperparameters, a signiﬁcant proportion of them go to inﬁnity, and the corresponding weight parameters have posterior distributions that are concentrated at zero. The basis functions associated with these parameters therefore play no role
