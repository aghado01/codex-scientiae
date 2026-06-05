[Page 60]

Figure 1.24 Schematic illustration of the joint probabilities $p(x, \mathcal{C}_k)$ for each of two classes plotted against $x$, together with the decision boundary $x = x_b$. Values of $x > x_b$ are classiﬁed as class $\mathcal{C}_2$ and hence belong to decision region $\mathcal{R}_2$, whereas points $x < x_b$ are classiﬁed as $\mathcal{C}_1$ and belong to $\mathcal{R}_1$. Errors arise from the blue, green, and red regions, so that for $x < x_b$ the errors are due to points from class $\mathcal{C}_2$ being misclassiﬁed as $\mathcal{C}_1$ (represented by the sum of the red and green regions), and conversely for points in the region $x > x_b$ the errors are due to points from class $\mathcal{C}_1$ being misclassiﬁed as $\mathcal{C}_2$ (represented by the blue region). As we vary the location $x_b$ of the decision boundary, the combined areas of the blue and green regions remain constant, whereas the size of the red region varies. The optimal choice for $x_b$ is where the curves for $p(x, \mathcal{C}_1)$ and $p(x, \mathcal{C}_2)$ cross, corresponding to $x_b = x_0$, because in this case the red region disappears. This is equivalent to the minimum misclassiﬁcation rate decision rule, which assigns each value of $x$ to the class having the higher posterior probability $p(\mathcal{C}_k \mid x)$.

![image 29](../../../../../images/imageFile29.png)

probability of making a mistake is obtained if each value of $x$ is assigned to the class for which the posterior probability $p(\mathcal{C}_k \mid x)$ is largest. This result is illustrated for two classes, and a single input variable $x$, in Figure 1.24.

For the more general case of $K$ classes, it is slightly easier to maximize the probability of being correct, which is given by

$$
p(\mathrm{correct}) = \sum_{k=1}^{K} p(\mathbf{x} \in \mathcal{R}_k, \mathcal{C}_k) = \sum_{k=1}^{K} \int_{\mathcal{R}_k} p(\mathbf{x}, \mathcal{C}_k)\, d\mathbf{x}. \tag{1.79}
$$

which is maximized when the regions $\mathcal{R}_k$ are chosen such that each $\mathbf{x}$ is assigned to the class for which $p(\mathbf{x}, \mathcal{C}_k)$ is largest. Again, using the product rule $p(\mathbf{x}, \mathcal{C}_k) = p(\mathcal{C}_k \mid \mathbf{x})p(\mathbf{x})$, and noting that the factor of $p(\mathbf{x})$ is common to all terms, we see that each $\mathbf{x}$ should be assigned to the class having the largest posterior probability $p(\mathcal{C}_k \mid \mathbf{x})$.
