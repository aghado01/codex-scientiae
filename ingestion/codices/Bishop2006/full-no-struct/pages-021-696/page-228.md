[Page 228]

# Exercise 4.15

$$
R _ { n n } = y _ { n } ( 1 - y _ { n } ) . \\ \intertext { r } y _ { n } = y _ { n } ( 1 - y _ { n } ) .
$$

We see that the Hessian is no longer constant but depends on w through the weighting matrix R , corresponding to the fact that the error function is no longer quadratic. Using the property 0 < y n < 1 , which follows from the form of the logistic sigmoid function, we see that u T Hu > 0 for an arbitrary vector u , and so the Hessian matrix H is positive deﬁnite. It follows that the error function is a concave function of w and hence has a unique minimum.

The Newton-Raphson update formula for the logistic regression model then becomes

$$
\begin{array} { r l } { w ^ { ( n e w ) } } & { = } & { w ^ { ( o l d ) } - ( \Phi ^ { T } R \Phi ) ^ { - 1 } \Phi ^ { T } ( y - t ) } \\ & { = } & { ( \Phi ^ { T } R \Phi ) ^ { - 1 } \{ \Phi ^ { T } R \Phi w ^ { ( o l d ) } - \Phi ^ { T } ( y - t ) \} } \\ & { = } & { ( \Phi ^ { T } R \Phi ) ^ { - 1 } \Phi ^ { T } R z } \end{array}
$$

where z is an N -dimensional vector with elements

$$
z = \Phi _ { W } ^ { ( o l d ) } - R ^ { - 1 } ( \mathbf y - \mathbf t ) .
$$

We see that the update formula (4.99) takes the form of a set of normal equations for a weighted least-squares problem. Because the weighing matrix R is not constant but depends on the parameter vector w , we must apply the normal equations iteratively, each time using the new weight vector w to compute a revised weighing matrix R . For this reason, the algorithm is known as iterative reweighted least squares , or IRLS (Rubin, 1983). As in the weighted least-squares problem, the elements of the diagonal weighting matrix R can be interpreted as variances because the mean and variance of t in the logistic regression model are given by

$$
\mathbb { E } [ t ] \ = \ \sigma ( x ) = y
$$

$$
\ v a r [ t ] \ = \ \mathbb { E } [ t ^ { 2 } ] - \mathbb { E } [ t ] ^ { 2 } = \sigma ( x ) - \sigma ( x ) ^ { 2 } = y ( 1 - y ) \quad ( 4 . 1 0 2 )
$$

where we have used the property t 2 = t for t ∈ { 0 , 1 } . In fact, we can interpret IRLS as the solution to a linearized problem in the space of the variable a = w T φ . The quantity z n , which corresponds to the n th element of z , can then be given a simple interpretation as an effective target value in this space obtained by making a local linear approximation to the logistic sigmoid function around the current operating point w (old)

$$
w ^ { ( o l d ) } & & \\ & a _ { n } ( w ) & \simeq & a _ { n } ( w ^ { ( o l d ) } ) + \frac { \mathrm d a _ { n } } { \mathrm d y _ { n } } \Big | _ { w ^ { ( o l d ) } } & ( t _ { n } - y _ { n } ) \\ & = & \phi _ { n } ^ { \top } w ^ { ( o l d ) } - \frac { ( y _ { n } - t _ { n } ) } { y _ { n } ( 1 - y _ { n } ) } = z _ { n } .
$$
