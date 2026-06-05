[Page 352]

-

![The image depicts a geometric figure consisting of a line segment labeled as ( y ) and a line segment labeled as ( z ). The line segment ( y ) is positioned at the top of the figure, while the line segment ( z ) is positioned at the bottom of the figure. Both lines are parallel to each other. ### Description of the Figure: - **Line Segment ( y )**: - The line segment ( y ) is a straight line that extends from the top of the figure to the bottom. - The line segment ( z ) is a line that extends from the bottom of the figure to the top. ### Objects in the Image: - **Line Segment ( y )**: - The line segment ( y ) is a straight line that extends from the top of the figure to the bottom. - The line segment ( z ) is](../images/imageFile148.png)

y

=

1

y

= 0

y

= 1

ξ > 1

1

ξ < 1

1

ξ

= 0

ξ

= 0

$$
t _ { n } y ( x _ { n } ) & \geqslant 1 - \xi _ { n } , \quad n = 1 , \dots , N \\ \intertext { a n d } \intertext { o s l o k l , v o r i b l o s , a r o o n o r i n o d . t o s i t f i c . }
$$

Our goal is now to maximize the margin while softly penalizing points that lie on the wrong side of the margin boundary. We therefore minimize

$$
C \sum _ { n = 1 } ^ { N } \xi _ { n } + \frac { 1 } { 2 } \| w \| ^ { 2 } \\ > 0 \, \text {controls the trade-off between the slack variable penalty}
$$

where the parameter C > 0 controls the trade-off between the slack variable penalty and the margin. Because any point that is misclassiﬁed has ξ n > 1 , it follows that n ξ n is an upper bound on the number of misclassiﬁed points. The parameter C is therefore analogous to (the inverse of) a regularization coefﬁcient because it controls the trade-off between minimizing training errors and controlling model complexity. In the limit C → ∞ , we will recover the earlier support vector machine for separable data.

We now wish to minimize (7.21) subject to the constraints (7.20) together with ξ n 0 . The corresponding Lagrangian is given by

$$
L ( w , b , a ) = \frac { 1 } { 2 } \| w \| ^ { 2 } + C \sum _ { n = 1 } ^ { N } \xi _ { n } - \sum _ { n = 1 } ^ { N } a _ { n } \left \{ t _ { n } y ( x _ { n } ) - 1 + \xi _ { n } \right \} - \sum _ { n = 1 } ^ { N } \mu _ { n } \xi _ { n } \ ( 7 . 2 2 )
$$
