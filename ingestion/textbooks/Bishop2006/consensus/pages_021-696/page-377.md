[Page 377]

###### Exercises

7.1 ( $\star$ ) www Suppose we have a data set of input vectors $\{\mathbf{x}_n\}$ with corresponding target values $t_n \in \{-1, 1\}$, and suppose that we model the density of input vectors within each class separately using a Parzen kernel density estimator (see Section 2.5.1) with a kernel $k(\mathbf{x}, \mathbf{x}')$. Write down the minimum misclassiﬁcation-rate decision rule assuming the two classes have equal prior probability. Show also that, if the kernel is chosen to be $k(\mathbf{x}, \mathbf{x}') = \mathbf{x}^T\mathbf{x}'$, then the classiﬁcation rule reduces to simply assigning a new input vector to the class having the closest mean. Finally, show that, if the kernel takes the form $k(\mathbf{x}, \mathbf{x}') = \phi(\mathbf{x})^T\boldsymbol{\phi}(\mathbf{x}')$, that the classiﬁcation is based on the closest mean in the feature space $\boldsymbol{\phi}(\mathbf{x})$.

7.2 ( $\star$ ) Show that, if the $1$ on the right-hand side of the constraint (7.5) is replaced by some arbitrary constant $\gamma > 0$, the solution for the maximum margin hyperplane is unchanged.

7.3 ( $\star$ ) Show that, irrespective of the dimensionality of the data space, a data set consisting of just two data points, one from each class, is sufﬁcient to determine the location of the maximum-margin hyperplane.

7.4 ( $\star\star$ ) www Show that the value $\rho$ of the margin for the maximum-margin hyperplane is given by

$$
\frac{1}{\rho^2} = \sum_{n=1}^N a_n \tag{7.123}
$$

where $\{a_n\}$ are given by maximizing (7.10) subject to the constraints (7.11) and (7.12).

7.5 ( $\star\star$ ) Show that the values of $\rho$ and $\{a_n\}$ in the previous exercise also satisfy

$$
\frac{1}{\rho^2} = 2 \widetilde{L}(\mathbf{a}) \tag{7.124}
$$

where $\widetilde{L}(\mathbf{a})$ is deﬁned by (7.10). Similarly, show that

$$
\frac{1}{\rho^2} = \|\mathbf{w}\|^2. \tag{7.125}
$$

7.6 ( $\star$ ) Consider the logistic regression model with a target variable $t \in \{-1, 1\}$. If we deﬁne $p(t = 1|y) = \sigma(y)$ where $y(\mathbf{x})$ is given by (7.1), show that the negative log likelihood, with the addition of a quadratic regularization term, takes the form (7.47).

7.7 ( $\star\star$ ) Consider the Lagrangian (7.56) for the regression support vector machine. By setting the derivatives of the Lagrangian with respect to $\mathbf{w}$, $b$, $\xi_n$, and $\widehat{\xi}_n$ to zero and then back substituting to eliminate the corresponding variables, show that the dual Lagrangian is given by (7.61).
