[Page 677]

Exercise 14.3

then we obtain

$$
E _ { \text {COM} } = \frac { 1 } { M } E _ { \text {AV} } .
$$

This apparently dramatic result suggests that the average error of a model can be reduced by a factor of M simply by averaging M versions of the model. Unfortunately, it depends on the key assumption that the errors due to the individual models are uncorrelated. In practice, the errors are typically highly correlated, and the reduction in overall error is generally small. It can, however, be shown that the expected committee error will not exceed the expected error of the constituent models, so that E COM E AV . In order to achieve more signiﬁcant improvements, we turn to a more sophisticated technique for building committees, known as boosting.

# 14.3. Boosting

Boosting is a powerful technique for combining multiple ‘base’ classiﬁers to produce a form of committee whose performance can be signiﬁcantly better than that of any of the base classiﬁers. Here we describe the most widely used form of boosting algorithm called AdaBoost , short for ‘adaptive boosting’, developed by Freund and Schapire (1996). Boosting can give good results even if the base classiﬁers have a performance that is only slightly better than random, and hence sometimes the base classiﬁers are known as weak learners . Originally designed for solving classiﬁcation problems, boosting can also be extended to regression (Friedman, 2001).

The principal difference between boosting and the committee methods such as bagging discussed above, is that the base classiﬁers are trained in sequence, and each base classiﬁer is trained using a weighted form of the data set in which the weighting coefﬁcient associated with each data point depends on the performance of the previous classiﬁers. In particular, points that are misclassiﬁed by one of the base classiﬁers are given greater weight when used to train the next classiﬁer in the sequence. Once all the classiﬁers have been trained, their predictions are then combined through a weighted majority voting scheme, as illustrated schematically in Figure 14.1.

Consider a two-class classiﬁcation problem, in which the training data comprises input vectors x 1 ,..., x N along with corresponding binary target variables t 1 ,...,t N where t n ∈ {− 1 , 1 } . Each data point is given an associated weighting parameter w n , which is initially set 1 /N for all data points. We shall suppose that we have a procedure available for training a base classiﬁer using weighted data to give a function y ( x ) ∈ {− 1 , 1 } . At each stage of the algorithm, AdaBoost trains a new classiﬁer using a data set in which the weighting coefﬁcients are adjusted according to the performance of the previously trained classiﬁer so as to give greater weight to the misclassiﬁed data points. Finally, when the desired number of base classiﬁers have been trained, they are combined to form a committee using coefﬁcients that give different weight to different base classiﬁers. The precise form of the AdaBoost algorithm is given below.
