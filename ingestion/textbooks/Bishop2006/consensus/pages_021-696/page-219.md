[Page 219]

![The image is a bar chart that shows the values of two variables, labeled x and y. The x-axis is labeled x and the y-axis is labeled y. The chart is divided into two sections, each labeled 1 and 1.1. The x-axis is labeled x and the y-axis is labeled y. The chart has a legend at the bottom right corner that indicates the values of x and y. ### Description of the Chart: - **Title**: The title of the chart is x and y. - **X-Axis**: The x-axis is labeled x and is marked with intervals of 0.0. - **Y-Axis**: The y-axis is labeled y and is marked with intervals of 0.1. - **Legend**: The legend at the bottom right corner of the chart indicates the values of](../images/imageFile22.png)

Figure 4.10 The left-hand plot shows the class-conditional densities for two classes, denoted red and blue. On the right is the corresponding posterior probability $p(\mathcal{C}_1|\mathbf{x})$, which is given by a logistic sigmoid of a linear function of $\mathbf{x}$. The surface in the right-hand plot is coloured using a proportion of red ink given by $p(\mathcal{C}_1|\mathbf{x})$ and a proportion of blue ink given by $p(\mathcal{C}_2|\mathbf{x}) = 1 - p(\mathcal{C}_1|\mathbf{x})$.

decision boundaries correspond to surfaces along which the posterior probabilities $p(\mathcal{C}_k|\mathbf{x})$ are constant and so will be given by linear functions of $\mathbf{x}$, and therefore the decision boundaries are linear in input space. The prior probabilities $p(\mathcal{C}_k)$ enter only through the bias parameter $w_0$ so that changes in the priors have the effect of making parallel shifts of the decision boundary and more generally of the parallel contours of constant posterior probability.

For the general case of $K$ classes we have, from (4.62) and (4.63),

$$
a_k(\mathbf{x}) = \mathbf{w}_k^{\text{T}}\mathbf{x} + w_{k0} \tag{4.68}
$$

where we have defined

$$
\mathbf{w}_k = \boldsymbol{\Sigma}^{-1}\boldsymbol{\mu}_k \tag{4.69}
$$

$$
w_{k0} = -\frac{1}{2}\boldsymbol{\mu}_k^{\text{T}}\boldsymbol{\Sigma}^{-1}\boldsymbol{\mu}_k + \ln p(\mathcal{C}_k). \tag{4.70}
$$

We see that the $a_k(\mathbf{x})$ are again linear functions of $\mathbf{x}$ as a consequence of the cancellation of the quadratic terms due to the shared covariances. The resulting decision boundaries, corresponding to the minimum misclassification rate, will occur when two of the posterior probabilities (the two largest) are equal, and so will be defined by linear functions of $\mathbf{x}$, and so again we have a generalized linear model.

If we relax the assumption of a shared covariance matrix and allow each class-conditional density $p(\mathbf{x}|\mathcal{C}_k)$ to have its own covariance matrix $\boldsymbol{\Sigma}_k$, then the earlier cancellations will no longer occur, and we will obtain quadratic functions of $\mathbf{x}$, giving rise to a quadratic discriminant. The linear and quadratic decision boundaries are illustrated in Figure 4.11.
