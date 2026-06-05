[Page 370]

![The image depicts a geometric figure with several points and lines. Here is a detailed description of the image: - **Points and Lines:** - The diagram includes a circle with a center labeled as ( C ). - The circle is divided into two parts by two radii ( r_1 ) and ( r_2 ). - The center of the circle is marked as ( \text{center} ) ( \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center} = \text{center](../images/imageFile155.png)

t

2

t

C

t

1

![The image presents a geometric diagram involving a circle and a line segment. The circle is positioned at the center of the diagram, and the line segment is positioned at a point on the circumference of the circle. The line segment is labeled as t1 and is positioned at a distance of 2 units from the center of the circle. The diagram includes two points labeled as C and D on the circumference of the circle. Point C is located at the top of the circle, and point D is located at the bottom of the circle. The line segment t1 is drawn from point C to point D on the circumference of the circle. The diagram includes a line segment labeled as t2 that is positioned at a distance of 1 unit from point C to point D. This line segment is perpendicular to the line segment t1 and is positioned at a distance of 1](../images/imageFile156.png)

t

2

t

ϕ

C

t

1

Figure 7.10 Illustration of the mechanism for sparsity in a Bayesian linear regression model, showing a training set vector of target values given by t = ( t 1 , t 2 ) T , indicated by the cross, for a model with one basis vector ϕ = ( φ ( x 1 ) , φ ( x 2 )) T , which is poorly aligned with the target data vector t . On the left we see a model having only isotropic noise, so that C = β − 1 I , corresponding to α = ∞ , with β set to its most probable value. On the right we see the same model but with a ﬁnite value of α . In each case the red ellipse corresponds to unit Mahalanobis distance, with | C | taking the same value for both plots, while the dashed green circle shows the contrition arising from the noise term β − 1 . We see that any ﬁnite value of α reduces the probability of the observed data, and so for the most probable solution the basis vector is removed.

Before proceeding with a mathematical analysis, we ﬁrst give some informal insight into the origin of sparsity in Bayesian linear models. Consider a data set comprising N = 2 observations t 1 and t 2 , together with a model having a single basis function φ ( x ) , with hyperparameter α , along with isotropic noise having precision β . From (7.85), the marginal likelihood is given by p ( t | α,β ) = N ( t | 0 , C ) in which the covariance matrix takes the form

$$
C = \frac { 1 } { \beta } I + \frac { 1 } { \alpha } \varphi \varphi ^ { T }
$$
