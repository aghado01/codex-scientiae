[Page 207]

![The image is a scatter plot with two sets of data points. The x-axis is labeled as 6 and the y-axis is labeled as 2. The data points are represented by dots, and each data point is colored blue. The points are scattered in a random pattern, with no clear pattern or pattern in the data. The scatter plot is titled Skewed Data and is marked with the letter S. The first set of data points is represented by the blue dots, and the second set of data points is represented by the green dots. The x-axis values are labeled as 6 and the y-axis values are labeled as 2. The data points are scattered in a random pattern, with no clear pattern or pattern in the data. The scatter plot is titled Skewed Data and is marked with the letter S. The plot is titled Skewed Data and is marked with the letter](../images/imageFile95.png)

6

6

4

4

2

2

0

0

−2

−2

−4

−4

-6

-6

-6

−4

−2

0

2

4

6

-6

−4

−2

0

2

4

6

Figure 4.5 Example of a synthetic data set comprising three classes, with training data points denoted in red ( × ) , green (+) , and blue ( ◦ ) . Lines denote the decision boundaries, and the background colours denote the respective classes of the decision regions. On the left is the result of using a least-squares discriminant. We see that the region of input space assigned to the green class is too small and so most of the points from this class are misclassiﬁed. On the right is the result of using logistic regressions as described in Section 4.3.2 showing correct classiﬁcation of the training data.

$$
y = w ^ { T } x .
$$

If we place a threshold on y and classify y − w 0 as class C 1 , and otherwise class C 2 , then we obtain our standard linear classiﬁer discussed in the previous section. In general, the projection onto one dimension leads to a considerable loss of information, and classes that are well separated in the original D -dimensional space may become strongly overlapping in one dimension. However, by adjusting the components of the weight vector w , we can select a projection that maximizes the class separation. To begin with, consider a two-class problem in which there are N 1 points of class C 1 and N 2 points of class C 2 , so that the mean vectors of the two classes are given by 1 1

$$
m _ { 1 } & = \frac { 1 } { N _ { 1 } } \sum _ { n \in \mathcal { C } _ { 1 } } x _ { n } , \quad m _ { 2 } = \frac { 1 } { N _ { 2 } } \sum _ { n \in \mathcal { C } _ { 2 } } x _ { n } . \\ \text {mallest measure of the separation of the classes, when projected onto $w$ is the}
$$

The simplest measure of the separation of the classes, when projected onto w , is the separation of the projected class means. This suggests that we might choose w so as to maximize T

$$
m _ { 2 } - m _ { 1 } = w ^ { T } ( m _ { 2 } - m _ { 1 } )
$$

where Appendix E Exercise 4.4

$$
m _ { k } = w ^ { T } m _ { k }
$$
