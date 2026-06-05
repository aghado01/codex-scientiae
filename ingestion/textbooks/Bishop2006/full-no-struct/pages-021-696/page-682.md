[Page 682]

Figure 14.3 Plot of the exponential (green) and rescaled cross-entropy (red) error functions along with the hinge error (blue) used in support vector machines, and the misclassiﬁcation error (black). Note that for large negative values of z = ty ( x ) , the cross-entropy gives a linearly increasing penalty, whereas the exponential loss gives an exponentially increasing penalty.

![The image is a graph with two lines. The first line is blue and red, and the second line is green and blue. The x-axis is labeled as E(z) and the y-axis is labeled as z. The graph shows two lines, one blue and one red, and two points on the graph. The blue line is represented by the points 1 and 2, and the red line is represented by the points 1 and 2. The graph shows that the blue line is decreasing, while the red line is increasing. The blue line is decreasing by 1 unit, while the red line is increasing by 1 unit. The graph also shows that the blue line is on the left side of the x-axis, while the red line is on the right side of the x-axis. The blue line is on the left side of the x-axis, while the red line is on the right side of the x-](../images/imageFile327.png)

E

(

z

)

z

-

-

2

1

0

1

2

Section 7.1.2

Exercise 14.8

Section 4.3.4

Exercise 14.9

which is half the log-odds. Thus the AdaBoost algorithm is seeking the best approximation to the log odds ratio, within the space of functions represented by the linear combination of base classiﬁers, subject to the constrained minimization resulting from the sequential optimization strategy. This result motivates the use of the sign function in (14.19) to arrive at the ﬁnal classiﬁcation decision.

We have already seen that the minimizer y ( x ) of the cross-entropy error (4.90) for two-class classiﬁcation is given by the posterior class probability. In the case of a target variable t ∈ {− 1 , 1 } , we have seen that the error function is given by ln(1 + exp( − yt )) . This is compared with the exponential error function in Figure 14.3, where we have divided the cross-entropy error by a constant factor ln(2) so that it passes through the point (0 , 1) for ease of comparison. We see that both can be seen as continuous approximations to the ideal misclassiﬁcation error function. An advantage of the exponential error is that its sequential minimization leads to the simple AdaBoost scheme. One drawback, however, is that it penalizes large negative values of ty ( x ) much more strongly than cross-entropy. In particular, we see that for large negative values of ty , the cross-entropy grows linearly with | ty | , whereas the exponential error function grows exponentially with | ty | . Thus the exponential error function will be much less robust to outliers or misclassiﬁed data points. Another important difference between cross-entropy and the exponential error function is that the latter cannot be interpreted as the log likelihood function of any well-deﬁned probabilistic model. Furthermore, the exponential error does not generalize to classiﬁcation problems having K > 2 classes, again in contrast to the cross-entropy for a probabilistic model, which is easily generalized to give (4.108).

The interpretation of boosting as the sequential optimization of an additive model under an exponential error (Friedman et al. , 2000) opens the door to a wide range of boosting-like algorithms, including multiclass extensions, by altering the choice of error function. It also motivates the extension to regression problems (Friedman, 2001). If we consider a sum-of-squares error function for regression, then sequential minimization of an additive model of the form (14.21) simply involves ﬁtting each new base classiﬁer to the residual errors t n − f m − 1 ( x n ) from the previous model. As we have noted, however, the sum-of-squares error is not robust to outliers, and this
