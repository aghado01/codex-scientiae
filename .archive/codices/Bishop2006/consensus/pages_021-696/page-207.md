[Page 207]

![The image is a scatter plot with two sets of data points. The x-axis is labeled as 6 and the y-axis is labeled as 2. The data points are represented by dots, and each data point is colored blue. The points are scattered in a random pattern, with no clear pattern or pattern in the data. The scatter plot is titled Skewed Data and is marked with the letter S. The first set of data points is represented by the blue dots, and the second set of data points is represented by the green dots. The x-axis values are labeled as 6 and the y-axis values are labeled as 2. The data points are scattered in a random pattern, with no clear pattern or pattern in the data. The scatter plot is titled Skewed Data and is marked with the letter S. The plot is titled Skewed Data and is marked with the letter](../images/imageFile95.png)

Figure 4.5 Example of a synthetic data set comprising three classes, with training data points denoted in red ($\times$), green ($+$), and blue ($\circ$). Lines denote the decision boundaries, and the background colours denote the respective classes of the decision regions. On the left is the result of using a least-squares discriminant. We see that the region of input space assigned to the green class is too small and so most of the points from this class are misclassified. On the right is the result of using logistic regressions as described in Section 4.3.2 showing correct classification of the training data.

dimensional input vector $\mathbf{x}$ and project it down to one dimension using

$$
y = \mathbf{w}^{\mathrm{T}}\mathbf{x}.
\tag{4.20}
$$

If we place a threshold on $y$ and classify $y \ge -w_0$ as class $\mathcal{C}_1$, and otherwise class $\mathcal{C}_2$, then we obtain our standard linear classifier discussed in the previous section. In general, the projection onto one dimension leads to a considerable loss of information, and classes that are well separated in the original $D$-dimensional space may become strongly overlapping in one dimension. However, by adjusting the components of the weight vector $\mathbf{w}$, we can select a projection that maximizes the class separation. To begin with, consider a two-class problem in which there are $N_1$ points of class $\mathcal{C}_1$ and $N_2$ points of class $\mathcal{C}_2$, so that the mean vectors of the two classes are given by

$$
\mathbf{m}_1 = \frac{1}{N_1} \sum_{n \in \mathcal{C}_1} \mathbf{x}_n, \quad \mathbf{m}_2 = \frac{1}{N_2} \sum_{n \in \mathcal{C}_2} \mathbf{x}_n.
\tag{4.21}
$$

The simplest measure of the separation of the classes, when projected onto $\mathbf{w}$, is the separation of the projected class means. This suggests that we might choose $\mathbf{w}$ so as to maximize

$$
m_2 - m_1 = \mathbf{w}^{\mathrm{T}}(\mathbf{m}_2 - \mathbf{m}_1)
\tag{4.22}
$$

where

$$
m_k = \mathbf{w}^{\mathrm{T}}\mathbf{m}_k
\tag{4.23}
$$
