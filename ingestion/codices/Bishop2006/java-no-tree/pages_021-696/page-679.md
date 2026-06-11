[Page 679]

- 3. Make predictions using the ﬁnal model, which is given by


YM(x) = sign

M

αmym(x) . (14.19)

m=1

We see that the ﬁrst base classiﬁer y1(x) is trained using weighting coefﬁ-

cients wn(1) that are all equal, which therefore corresponds to the usual procedure for training a single classiﬁer. From (14.18), we see that in subsequent iterations

the weighting coefﬁcients wn(m) are increased for data points that are misclassiﬁed and decreased for data points that are correctly classiﬁed. Successive classiﬁers are therefore forced to place greater emphasis on points that have been misclassiﬁed by previous classiﬁers, and data points that continue to be misclassiﬁed by successive classiﬁers receive ever greater weight. The quantities m represent weighted measures of the error rates of each of the base classiﬁers on the data set. We therefore see that the weighting coefﬁcients αm deﬁned by (14.17) give greater weight to the more accurate classiﬁers when computing the overall output given by (14.19).

The AdaBoost algorithm is illustrated in Figure 14.2, using a subset of 30 data points taken from the toy classiﬁcation data set shown in Figure A.7. Here each base learners consists of a threshold on one of the input variables. This simple classiﬁer

Section 14.4 corresponds to a form of decision tree known as a ‘decision stumps’, i.e., a decision tree with a single node. Thus each base learner classiﬁes an input according to whether one of the input features exceeds some threshold and therefore simply partitions the space into two regions separated by a linear decision surface that is parallel to one of the axes.

###### 14.3.1 Minimizing exponential error

Boosting was originally motivated using statistical learning theory, leading to upper bounds on the generalization error. However, these bounds turn out to be too loose to have practical value, and the actual performance of boosting is much better than the bounds alone would suggest. Friedman et al. (2000) gave a different and very simple interpretation of boosting in terms of the sequential minimization of an exponential error function.

Consider the exponential error function deﬁned by

N

exp{−tnfm(xn)} (14.20)

E =

n=1

where fm(x) is a classiﬁer deﬁned in terms of a linear combination of base classiﬁers yl(x) of the form

m

1 2

fm(x) =

αlyl(x) (14.21)

l=1

and tn ∈ {−1,1} are the training set target values. Our goal is to minimize E with respect to both the weighting coefﬁcients αl and the parameters of the base classiﬁers yl(x).
