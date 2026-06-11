[Page 60]

![The image depicts a diagram involving a graph with two lines. The graph is a circle with a radius of 2. The x-axis is labeled as r1 and the y-axis is labeled as r2. The line segment connecting the points of intersection of the two lines is labeled as p(x, y). ### Graph Description: - **Line Segment P(x, y)**: - The line segment connecting the points of intersection of the two lines is labeled as p(x, y). - The line segment is a straight line with a positive slope. ### Graph Description: - **Points of Intersection**: - The line segment connecting the points of intersection of the two lines is a straight line. - The line segment is a straight line with a positive slope. ### Analysis: - **Line Segment P(x, y)**: - The line segment P(x, y](../images/imageFile29.png)

Figure 1.24 Schematic illustration of the joint probabilities $p(x, \mathcal{C}_k)$ for each of two classes plotted against $x$, together with the decision boundary $x = \widehat{x}$. Values of $x \ge \widehat{x}$ are classified as class $\mathcal{C}_2$ and hence belong to decision region $\mathcal{R}_2$, whereas points $x < \widehat{x}$ are classified as $\mathcal{C}_1$ and belong to $\mathcal{R}_1$. Errors arise from the blue, green, and red regions, so that for $x < \widehat{x}$ the errors are due to points from class $\mathcal{C}_2$ being misclassified as $\mathcal{C}_1$ (represented by the sum of the red and green regions), and conversely for points in the region $x \ge \widehat{x}$ the errors are due to points from class $\mathcal{C}_1$ being misclassified as $\mathcal{C}_2$ (represented by the blue region). As we vary the location $\widehat{x}$ of the decision boundary, the combined areas of the blue and green regions remains constant, whereas the size of the red region varies. The optimal choice for $\widehat{x}$ is where the curves for $p(x, \mathcal{C}_1)$ and $p(x, \mathcal{C}_2)$ cross, corresponding to $\widehat{x} = x_0$, because in this case the red region disappears. This is equivalent to the minimum misclassification rate decision rule, which assigns each value of $x$ to the class having the higher posterior probability $p(\mathcal{C}_k|x)$.

probability of making a mistake is obtained if each value of $x$ is assigned to the class for which the posterior probability $p(\mathcal{C}_k|x)$ is largest. This result is illustrated for two classes, and a single input variable $x$, in Figure 1.24.

For the more general case of $K$ classes, it is slightly easier to maximize the probability of being correct, which is given by

$$
\begin{align}
p(\text{correct}) &= \sum_{k=1}^K p(\mathbf{x} \in \mathcal{R}_k, \mathcal{C}_k) \nonumber \\
&= \sum_{k=1}^K \int_{\mathcal{R}_k} p(\mathbf{x}, \mathcal{C}_k) \, \text{d}\mathbf{x} \tag{1.79}
\end{align}
$$

which is maximized when the regions $\mathcal{R}_k$ are chosen such that each $\mathbf{x}$ is assigned to the class for which $p(\mathbf{x}, \mathcal{C}_k)$ is largest. Again, using the product rule $p(\mathbf{x}, \mathcal{C}_k) = p(\mathcal{C}_k|\mathbf{x})p(\mathbf{x})$, and noting that the factor of $p(\mathbf{x})$ is common to all terms, we see that each $\mathbf{x}$ should be assigned to the class having the largest posterior probability $p(\mathcal{C}_k|\mathbf{x})$.
