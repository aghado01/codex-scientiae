[Page 360]

Figure 7.6 Plot of an -insensitive error function (in red) in which the error increases linearly with distance beyond the insensitive region. Also shown for comparison is the quadratic error function (in green).

![The image consists of a graph with two lines. The graph is a line graph with two lines, one of which is a straight line. The line on the left side of the graph is a straight line with a positive slope. The line on the right side of the graph is a straight line with a negative slope. The line on the left side of the graph is a straight line with a positive slope. The line on the right side of the graph is a straight line with a negative slope. The graph is labeled as E(z) = 0 and the x-axis is labeled as z and the y-axis is labeled as z.](../images/imageFile151.png)

E

(

z

)

/epsilon1

z

-

/epsilon1

0

minimize a regularized error function given by

$$
\frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \{ y _ { n } - t _ { n } \} ^ { 2 } + \frac { \lambda } { 2 } \| w \| ^ { 2 } . \\ \text {options the quadratic error function is replaced by an c intrinsic}
$$

To obtain sparse solutions, the quadratic error function is replaced by an -insensitive error function (Vapnik, 1995), which gives zero error if the absolute difference between the prediction y ( x ) and the target t is less than where > 0 . A simple example of an -insensitive error function, having a linear cost associated with errors outside the insensitive region, is given by

$$
\text {Ad} \colon _ { E _ { \epsilon } ( y ( x ) - t ) } & = \left \{ \begin{array} { l l } { 0 , } & { i f | y ( x ) - t | < \epsilon ; } \\ { | y ( x ) - t | - \epsilon , } & { o t h e r w i s e } \end{array} \\
$$

and is illustrated in Figure 7.6.

We therefore minimize a regularized error function given by

$$
C \sum _ { n = 1 } ^ { N } E _ { \epsilon } ( y ( x _ { n } ) - t _ { n } ) + \frac { 1 } { 2 } \| w \| ^ { 2 } \\ \text {given by } ( 7 . 1 ) \, \text {By convention the } ( \text {inverse} ) \, \text {regularization} \, \text {operator}
$$

where y ( x ) is given by (7.1). By convention the (inverse) regularization parameter, denoted C , appears in front of the error term.

As before, we can re-express the optimization problem by introducing slack variables. For each data point x n , we now need two slack variables ξ n 0 and ξ n 0 , where ξ n > 0 corresponds to a point for which t n > y ( x n ) + , and ξ n > 0 corresponds to a point for which t n < y ( x n ) − , as illustrated in Figure 7.7. The condition for a target point to lie inside the -tube is that y n − t n y + , where y = y ( x ) . Introducing the slack variables allows points to lie outside

The condition for a target point to lie inside the /epsilon1 -tube is that y n -/epsilon1 /lessorequalslant t n /lessorequalslant y n + /epsilon1 , where y n = y ( x n ) . Introducing the slack variables allows points to lie outside the tube provided the slack variables are nonzero, and the corresponding conditions are

$$
t _ { n } \ \leqslant \ y ( \mathbf x _ { n } ) + \epsilon + \xi _ { n }
$$

$$
t _ { n } \ \geq \ y ( x _ { n } ) - \epsilon - \widehat { \xi } _ { n } .
$$
