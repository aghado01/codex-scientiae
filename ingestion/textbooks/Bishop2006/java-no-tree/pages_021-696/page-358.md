[Page 358]

For comparison with other error functions, we can divide by ln(2) so that the error function passes through the point (0,1). This rescaled error function is also plotted in Figure 7.5 and we see that it has a similar form to the support vector error function. The key difference is that the ﬂat region in ESV(yt) leads to sparse solutions.

Both the logistic error and the hinge loss can be viewed as continuous approximations to the misclassiﬁcation error. Another continuous error function that has sometimes been used to solve classiﬁcation problems is the squared error, which is again plotted in Figure 7.5. It has the property, however, of placing increasing emphasis on data points that are correctly classiﬁed but that are a long way from the decision boundary on the correct side. Such points will be strongly weighted at the expense of misclassiﬁed points, and so if the objective is to minimize the misclassiﬁcation rate, then a monotonically decreasing error function would be a better choice.

###### 7.1.3 Multiclass SVMs

The support vector machine is fundamentally a two-class classiﬁer. In practice, however, we often have to tackle problems involving K > 2 classes. Various methods have therefore been proposed for combining multiple two-class SVMs in order to build a multiclass classiﬁer.

One commonly used approach (Vapnik, 1998) is to construct K separate SVMs, in which the kth model yk(x) is trained using the data from class Ck as the positive examples and the data from the remaining K − 1 classes as the negative examples. This is known as the one-versus-the-rest approach. However, in Figure 4.2 we saw that using the decisions of the individual classiﬁers can lead to inconsistent results in which an input is assigned to multiple classes simultaneously. This problem is sometimes addressed by making predictions for new inputs x using

yk(x). (7.49)

y(x) = max

k

Unfortunately, this heuristic approach suffers from the problem that the different classiﬁers were trained on different tasks, and there is no guarantee that the realvalued quantities yk(x) for different classiﬁers will have appropriate scales.

Another problem with the one-versus-the-rest approach is that the training sets are imbalanced. For instance, if we have ten classes each with equal numbers of training data points, then the individual classiﬁers are trained on data sets comprising 90% negative examples and only 10% positive examples, and the symmetry of the original problem is lost. A variant of the one-versus-the-rest scheme was proposed by Lee et al. (2001) who modify the target values so that the positive class has target +1 and the negative class has target −1/(K − 1).

Weston and Watkins (1999) deﬁne a single objective function for training all K SVMs simultaneously, based on maximizing the margin from each to remaining classes. However, this can result in much slower training because, instead of solving K separate optimization problems each over N data points with an overall cost of O(KN2), a single optimization problem of size (K −1)N must be solved giving an overall cost of O(K2N2).
