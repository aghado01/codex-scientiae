[Page 200]

ways of using target values to represent class labels. For probabilistic models, the most convenient, in the case of two-class problems, is the binary representation in which there is a single target variable t ∈ {0,1} such that t = 1 represents class C1 and t = 0 represents class C2. We can interpret the value of t as the probability that the class is C1, with the values of probability taking only the extreme values of 0 and 1. For K > 2 classes, it is convenient to use a 1-of-K coding scheme in which t is a vector of length K such that if the class is Cj, then all elements tk of t are zero except element tj, which takes the value 1. For instance, if we have K = 5 classes, then a pattern from class 2 would be given the target vector

###### t = (0,1,0,0,0)T. (4.1)

Again, we can interpret the value of tk as the probability that the class is Ck. For nonprobabilistic models, alternative choices of target variable representation will sometimes prove convenient.

In Chapter 1, we identiﬁed three distinct approaches to the classiﬁcation problem. The simplest involves constructing a discriminant function that directly assigns each vector x to a speciﬁc class. A more powerful approach, however, models the conditional probability distribution p(Ck|x) in an inference stage, and then subsequently uses this distribution to make optimal decisions. By separating inference and decision, we gain numerous beneﬁts, as discussed in Section 1.5.4. There are two different approaches to determining the conditional probabilities p(Ck|x). One technique is to model them directly, for example by representing them as parametric models and then optimizing the parameters using a training set. Alternatively, we can adopt a generative approach in which we model the class-conditional densities given by p(x|Ck), together with the prior probabilities p(Ck) for the classes, and then we compute the required posterior probabilities using Bayes’ theorem

p(x|Ck)p(Ck) p(x)

p(Ck|x) =

. (4.2)

We shall discuss examples of all three approaches in this chapter.

In the linear regression models considered in Chapter 3, the model prediction y(x,w) was given by a linear function of the parameters w. In the simplest case, the model is also linear in the input variables and therefore takes the form y(x) = wTx+w0, so that y is a real number. For classiﬁcation problems, however, we wish to predict discrete class labels, or more generally posterior probabilities that lie in the range (0,1). To achieve this, we consider a generalization of this model in which we transform the linear function of w using a nonlinear function f(·) so that

###### y(x) = f wTx + w0 . (4.3)

In the machine learning literature f(·) is known as an activation function, whereas its inverse is called a link function in the statistics literature. The decision surfaces correspond to y(x) = constant, so that wTx + w0 = constant and hence the decision surfaces are linear functions of x, even if the function f(·) is nonlinear. For this reason, the class of models described by (4.3) are called generalized linear models
