[Page 255]

If we consider a training set of independent observations, then the error function, which is given by the negative log likelihood, is then a cross-entropy error function of the form

�N

{tn lnyn + (1 − tn)ln(1 − yn)} (5.21)

E(w) = −

n=1

where yn denotes y(xn,w). Note that there is no analogue of the noise precision β because the target values are assumed to be correctly labelled. However, the model

Exercise 5.4 is easily extended to allow for labelling errors. Simard et al. (2003) found that using the cross-entropy error function instead of the sum-of-squares for a classiﬁcation problem leads to faster training as well as improved generalization.

If we have K separate binary classiﬁcations to perform, then we can use a network having K outputs each of which has a logistic sigmoid activation function. Associated with each output is a binary class label tk ∈ {0,1}, where k = 1,...,K. If we assume that the class labels are independent, given the input vector, then the conditional distribution of the targets is

�K

yk(x,w)tk [1 − yk(x,w)]1−t

p(t|x,w) =

. (5.22)

k

k=1

Taking the negative logarithm of the corresponding likelihood function then gives Exercise 5.5 the following error function

�N

�K

{tnk lnynk + (1 − tnk)ln(1 − ynk)} (5.23)

E(w) = −

n=1

k=1

where ynk denotes yk(xn,w). Again, the derivative of the error function with reExercise 5.6 spect to the activation for a particular output unit takes the form (5.18) just as in the

regression case.

It is interesting to contrast the neural network solution to this problem with the corresponding approach based on a linear classiﬁcation model of the kind discussed in Chapter 4. Suppose that we are using a standard two-layer network of the kind shown in Figure 5.1. We see that the weight parameters in the ﬁrst layer of the network are shared between the various outputs, whereas in the linear model each classiﬁcation problem is solved independently. The ﬁrst layer of the network can be viewed as performing a nonlinear feature extraction, and the sharing of features between the different outputs can save on computation and can also lead to improved generalization.

Finally, we consider the standard multiclass classiﬁcation problem in which each input is assigned to one of K mutually exclusive classes. The binary target variables tk ∈ {0,1} have a 1-of-K coding scheme indicating the class, and the network outputs are interpreted as yk(x,w) = p(tk = 1|x), leading to the following error function

�N

�K

tkn lnyk(xn,w). (5.24)

E(w) = −

n=1

k=1
