[Page 352]

Figure 7.3 Illustration of the slack variables $\xi_n \geqslant 0$. Data points with circles around them are support vectors.

![The image depicts a geometric figure consisting of a line segment labeled as (y) and a line segment labeled as (z). The line segment (y) is positioned at the top of the figure, while the line segment (z) is positioned at the bottom of the figure. Both lines are parallel to each other. ### Description of the Figure: - **Line Segment (y)**: - The line segment (y) is a straight line that extends from the top of the figure to the bottom. - The line segment (z) is a line that extends from the bottom of the figure to the top. ### Objects in the Image: - **Line Segment (y)**: - The line segment (y) is a straight line that extends from the top of the figure to the bottom. - The line segment (z) is](../images/imageFile148.png)

with $\xi_n > 1$ will be misclassiﬁed. The exact classiﬁcation constraints (7.5) are then replaced with

$$
t_ny(\mathbf{x}_n) \geqslant 1 - \xi_n, \quad n = 1,\dots,N \tag{7.20}
$$

in which the slack variables are constrained to satisfy $\xi_n \geqslant 0$. Data points for which $\xi_n = 0$ are correctly classiﬁed and are either on the margin or on the correct side of the margin. Points for which $0 < \xi_n \leqslant 1$ lie inside the margin, but on the correct side of the decision boundary, and those data points for which $\xi_n > 1$ lie on the wrong side of the decision boundary and are misclassiﬁed, as illustrated in Figure 7.3. This is sometimes described as relaxing the hard margin constraint to give a soft margin and allows some of the training set data points to be misclassiﬁed. Note that while slack variables allow for overlapping class distributions, this framework is still sensitive to outliers because the penalty for misclassiﬁcation increases linearly with $\xi$.

Our goal is now to maximize the margin while softly penalizing points that lie on the wrong side of the margin boundary. We therefore minimize

$$
C \sum_{n=1}^N \xi_n + \frac{1}{2} \|\mathbf{w}\|^2 \tag{7.21}
$$

where the parameter $C > 0$ controls the trade-off between the slack variable penalty and the margin. Because any point that is misclassiﬁed has $\xi_n > 1$, it follows that $\sum_n \xi_n$ is an upper bound on the number of misclassiﬁed points. The parameter $C$ is therefore analogous to (the inverse of) a regularization coefﬁcient because it controls the trade-off between minimizing training errors and controlling model complexity. In the limit $C \to \infty$, we will recover the earlier support vector machine for separable data.

We now wish to minimize (7.21) subject to the constraints (7.20) together with $\xi_n \geqslant 0$. The corresponding Lagrangian is given by

$$
L(\mathbf{w},b,\mathbf{a}) = \frac{1}{2} \|\mathbf{w}\|^2 + C \sum_{n=1}^N \xi_n - \sum_{n=1}^N a_n \{t_ny(\mathbf{x}_n) - 1 + \xi_n\} - \sum_{n=1}^N \mu_n\xi_n \tag{7.22}
$$
