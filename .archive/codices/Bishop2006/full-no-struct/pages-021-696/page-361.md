[Page 361]

Figure 7.7 Illustration of SVM regression, showing the regression curve together with the insensitive ‘tube’. Also shown are examples of the slack variables ξ and b ξ . Points above the -tube have ξ > 0 and b ξ = 0 , points below the -tube have ξ = 0 and b ξ > 0 , and points inside the -tube have ξ = b ξ = 0 .

ξ = b ξ = 0

![The image depicts a curved line that appears to be a graph or a diagram. The graph is a curved line with a slight curve, indicating that it is not a straight line but a curved one. The graph is marked with a series of points, each marked with a letter. The points are connected by a curved line, which is a type of curve that is commonly used in mathematics and physics to represent data points. The graph has a specific shape: - The x-axis is labeled with the letter y and is labeled as y(x). - The y-axis is labeled with the letter x and is labeled as x. - The graph has a curved line that starts at the point labeled y(x) and extends to the point labeled x. - The line starts at point y(x) and extends to point x with a slight curve. - The line then extends to point y](../images/imageFile152.png)

y

(

x

)

y

-

/epsilon1

y

ξ >

0

-

y

/epsilon1

̂

ξ >

0

x

The error function for support vector regression can then be written as

$$
C \sum _ { n = 1 } ^ { N } ( \xi _ { n } + \widehat { \xi } _ { n } ) + \frac { 1 } { 2 } \| w \| ^ { 2 } \\ \intertext { \text {limited subject to the constraints } \xi _ { n } \geqslant 0 \text { and } \widehat { \xi } _ { n } \geqslant 0 \text { as well as } }
$$

which must be minimized subject to the constraints ξ n 0 and ξ n 0 as well as (7.53) and (7.54). This can be achieved by introducing Lagrange multipliers a n 0 , a n 0 , µ n 0 , and µ n 0 and optimizing the Lagrangian L = C N ( ξ n + ξ n ) + 1 2 w 2 − N ( µ n ξ n + µ n ξ n )

$$
\text {which must be minimized subject to the constraints $\xi^{\n}_{n}\geq 0$ and $\xi^{\n}_{n}\geq 0$ as well as} \\ (7.53) \text { and (7.54). This can be achieved by introducing Lagrange multipliers a_{n} \geqslant 0 ,} \\ \widehat { a } _ { n } \geqslant 0 , \mu _ { n } \geqslant 0 , \text { and $\mu_{n}\geqslant 0$ and optimizing the Lagrangian} \\ L & \ = \ C \sum _ { n = 1 } ^ { N } ( \xi _ { n } + \widehat { \xi } _ { n } ) + \frac { 1 } { 2 } \| w \| ^ { 2 } - \sum _ { n = 1 } ^ { N } ( \mu _ { n } \xi _ { n } + \widehat { \mu } _ { n } \widehat { \xi } _ { n } ) \\ & - \sum _ { n = 1 } ^ { N } a _ { n } ( \epsilon + \xi _ { n } + y _ { n } - t _ { n } ) - \sum _ { n = 1 } ^ { N } \widehat { a } _ { n } ( \epsilon + \widehat { \xi } _ { n } - y _ { n } + t _ { n } ) . \quad ( 7 . 5 6 ) \\ \text {We now substitute for } y ( x ) \text { using } ( 7 . 1 ) \text { and then set the derivatives of the La-} \\ \text {grillian with respect to } w , b , \xi _ { n } , \text { and } \widehat { \xi } _ { n } \text { to zero, giving}
$$

We now substitute for y ( x ) using (7.1) and then set the derivatives of the Lagrangian with respect to w , b , ξ n , and ξ n to zero, giving

$$
\text {row substitute for } y ( x ) \, \text { using } ( 7 . 1 ) \, \text { and then set the derivatives of the La-} \\ \text {with respect to } w , b , \xi _ { n } , \text { and } \widehat { \xi } _ { n } \, \text { to zero, giving} \\ \quad & \partial L \, \equiv 0 \quad \Rightarrow \quad \text {w} = \sum _ { n = 1 } ^ { N } ( a _ { n } - a _ { n } ) \phi ( x _ { n } ) \\ & \frac { \partial L } { \partial b } = 0 \quad \Rightarrow \quad \sum _ { n = 1 } ^ { N } ( a _ { n } - \widehat { a } _ { n } ) = 0
$$

$$
& \frac { \partial L } { \partial b } = 0 \quad \Rightarrow \quad \sum _ { n = 1 } ^ { N } ( a _ { n } - \widehat { a } _ { n } ) = 0 \\ & \frac { \partial L } { \partial \xi _ { n } } = 0 \quad \Rightarrow \quad a _ { n } + \mu _ { n } = C
$$

$$
\frac { \partial L } { \partial \xi _ { n } } = 0 \ \Rightarrow \ a _ { n } + \mu _ { n } = C \\
$$

$$
& \quad \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

∂ ξ n = 0 ⇒ a n + µ n = C. (7.60) Using these results to eliminate the corresponding variables from the Lagrangian, we see that the dual problem involves maximizing
