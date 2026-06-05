[Page 347]

y = 1 y = 0 y = −1

margin

y = −1

y = 0

y = 1

Figure 7.1 The margin is deﬁned as the perpendicular distance between the decision boundary and the closest of the data points, as shown on the left ﬁgure. Maximizing the margin leads to a particular choice of decision boundary, as shown on the right. The location of this boundary is determined by a subset of the data points, known as support vectors, which are indicated by the circles.

having a common parameter σ2. Together with the class priors, this deﬁnes an optimal misclassiﬁcation-rate decision boundary. However, instead of using this optimal boundary, they determine the best hyperplane by minimizing the probability of error relative to the learned density model. In the limit σ2 → 0, the optimal hyperplane is shown to be the one having maximum margin. The intuition behind this result is that as σ2 is reduced, the hyperplane is increasingly dominated by nearby data points relative to more distant ones. In the limit, the hyperplane becomes independent of data points that are not support vectors.

We shall see in Figure 10.13 that marginalization with respect to the prior distribution of the parameters in a Bayesian approach for a simple linearly separable data set leads to a decision boundary that lies in the middle of the region separating the data points. The large margin solution has similar behaviour.

Recall from Figure 4.1 that the perpendicular distance of a point x from a hyperplane deﬁned by y(x) = 0 where y(x) takes the form (7.1) is given by |y(x)|/ w . Furthermore, we are only interested in solutions for which all data points are correctly classiﬁed, so that tny(xn) > 0 for all n. Thus the distance of a point xn to the decision surface is given by

tny(xn) w

=

tn(wTφ(xn) + b) w

. (7.2)

The margin is given by the perpendicular distance to the closest point xn from the data set, and we wish to optimize the parameters w and b in order to maximize this distance. Thus the maximum margin solution is found by solving

arg max

w,b

1 w

min

n

tn wTφ(xn) + b (7.3)

where we have taken the factor 1/ w outside the optimization over n because w
