[Page 235]

![The image is a graph that shows the relationship between two variables, specifically the values of two variables, x and y. The x-axis represents the values of x, and the y-axis represents the values of y. The graph is a line graph, and the line is drawn from the bottom left to the top right. The line is relatively steep, indicating that the values of x and y are increasing at a constant rate. The graph shows two lines, one for x and one for y. The line for x is a straight line with a positive slope, meaning that as x increases, y also increases. The line for y is a straight line with a negative slope, meaning that as x increases, y decreases. The graph also shows a small amount of data at the top of the graph, which is the value of x. This data is represented by a small red dot on the graph. The x-axis is labeled with the values of x, and the](../images/imageFile105.png)

0.8

40

0.6

30

0.4

20

0.2

10

0

0

-2

−1

0

1

2

3

4

-2

−1

0

1

2

3

4

Figure 4.14 Illustration of the Laplace approximation applied to the distribution p ( z ) ∝ exp( − z 2 / 2) σ (20 z + 4) where σ ( z ) is the logistic sigmoid function deﬁned by σ ( z ) = (1 + e − z ) − 1 . The left plot shows the normalized distribution p ( z ) in yellow, together with the Laplace approximation centred on the mode z 0 of p ( z ) in red. The right plot shows the negative logarithms of the corresponding curves.

We can extend the Laplace method to approximate a distribution p ( z ) = f ( z ) /Z deﬁned over an M -dimensional space z . At a stationary point z 0 the gradient ∇ f ( z ) will vanish. Expanding around this stationary point we have

$$
\ln f ( z ) \simeq \ln f ( z _ { 0 } ) - \frac { 1 } { 2 } ( z - z _ { 0 } ) ^ { \top } A ( z - z _ { 0 } )
$$

where the M × M Hessian matrix A is deﬁned by

$$
A = - \nabla \nabla \ln f ( z ) | _ { z = z _ { 0 } }
$$

and ∇ is the gradient operator. Taking the exponential of both sides we obtain

$$
\i s \text { the gradient operator.} \ \text {taking} \ \text {exp} \ \text {cubic than or both} \ \text {slices} \ \text {we obtain} \\ f ( z ) \simeq f ( z _ { 0 } ) \exp \left \{ - \frac { 1 } { 2 } ( z - z _ { 0 } ) ^ { \top } A ( z - z _ { 0 } ) \right \} . \\ \text {with} \ \text {slices} \ \text {and} \ \text {the} \ \text {exp} \ \text {slices} \ \text {with} \ \text {slices} \ \text {with} \ \text {slices} \ \text {with} \ \text {slices}
$$

The distribution q ( z ) is proportional to f ( z ) and the appropriate normalization coefﬁcient can be found by inspection, using the standard result (2.43) for a normalized multivariate Gaussian, giving

$$
\ m a t h s c r { D } u ( z ) & = \frac { | A | ^ { 1 / 2 } } { ( 2 \pi ) ^ { M / 2 } } \exp \left \{ - \frac { 1 } { 2 } ( z - z _ { 0 } ) ^ { \top } A ( z - z _ { 0 } ) \right \} = \mathcal { N } ( z | z _ { 0 } , A ^ { - 1 } ) \quad ( 4 . 1 3 ) \\ \ m a t h s c r { D } u & \leq | A | \cdot \ m a t h s c r { D } u \cdot \ m a t h s c r { D } u \cdot \ m a t h s c r { D } u \cdot \ m a t h s c r { D } u \cdot \ m a t h s c r { D } u \cdot \ m a t h s c r { D } u
$$

where | A | denotes the determinant of A . This Gaussian distribution will be well deﬁned provided its precision matrix, given by A , is positive deﬁnite, which implies that the stationary point z 0 must be a local maximum, not a minimum or a saddle point.

In order to apply the Laplace approximation we first need to find the mode z 0 , and then evaluate the Hessian matrix at that mode. In practice a mode will typically be found by running some form of numerical optimization algorithm (Bishop and Nabney, 2008). Many of the distributions encountered in practice will be multimodal and so there will be different Laplace approximations according to which mode is being considered. Note that the normalization constant Z of the true distribution does not need to be known in order to apply the Laplace method. As a result of the central limit theorem, the posterior distribution for a model is expected to become increasingly better approximated by a Gaussian as the number of observed data points is increased, and so we would expect the Laplace approximation to be most useful in situations where the number of data points is relatively large.
