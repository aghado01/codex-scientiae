[Page 347]

![The image depicts a geometric figure consisting of two parallel lines, labeled as ( y ) and ( z ). These lines are intersected by a line segment that is drawn from point ( z ) to point ( y ). The intersection of these lines creates a right angle at point ( z ). ### Description of the Image: 1. **Lines and Segments**: - **Line Segment ( y )**: This line segment is drawn from point ( z ) to point ( y ). - **Line Segment ( z )**: This line segment is drawn from point ( z ) to point ( y ). 2. **Intersection Point**: - **Point ( z )**: The intersection point of the two lines is marked as ( z ). 3. **Angles and Angles of Intersection**: - **Angles of Intersection**: The](../images/imageFile144.png)

y

= 1

y

= 0

-

y

=

1

margin

![In the image there is a diagram with four lines and two points labeled as y and y=1.](../images/imageFile145.png)

-

y

=

1

y

= 0

y

= 1

Figure 7.1 The margin is deﬁned as the perpendicular distance between the decision boundary and the closest of the data points, as shown on the left ﬁgure. Maximizing the margin leads to a particular choice of decision boundary, as shown on the right. The location of this boundary is determined by a subset of the data points, known as support vectors, which are indicated by the circles.

We shall see in Figure 10.13 that marginalization with respect to the prior distribution of the parameters in a Bayesian approach for a simple linearly separable data set leads to a decision boundary that lies in the middle of the region separating the data points. The large margin solution has similar behaviour.

Recall from Figure 4.1 that the perpendicular distance of a point x from a hyperplane deﬁned by y ( x ) = 0 where y ( x ) takes the form (7.1) is given by | y ( x ) | / w . Furthermore, we are only interested in solutions for which all data points are correctly classiﬁed, so that t n y ( x n ) > 0 for all n . Thus the distance of a point x n to the decision surface is given by

$$
\frac { t _ { n } y ( x _ { n } ) } { \| w \| } = \frac { t _ { n } ( w ^ { T } \phi ( x _ { n } ) + b ) } { \| w \| } .
$$

The margin is given by the perpendicular distance to the closest point x n from the data set, and we wish to optimize the parameters w and b in order to maximize this distance. Thus the maximum margin solution is found by solving

$$
\L _ { \ } \text { thus the maximum margin solution is found by solving} \\ \arg \max _ { \ w , b } \left \{ \frac { 1 } { \| w \| ^ { \ n } } \min _ { \ n } \left [ t _ { n } \left ( w ^ { T } \phi ( x _ { n } ) + b \right ) \right ] \right \} \\ \text {have taken the factor 1/ \| w \| outside the optimization over n be cause } w
$$

where we have taken the factor 1 / w outside the optimization over n because w
