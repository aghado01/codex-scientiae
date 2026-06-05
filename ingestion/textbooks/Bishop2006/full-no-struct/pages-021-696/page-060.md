[Page 60]

![The image depicts a diagram involving a graph with two lines. The graph is a circle with a radius of 2. The x-axis is labeled as r1 and the y-axis is labeled as r2. The line segment connecting the points of intersection of the two lines is labeled as p(x, y). ### Graph Description: - **Line Segment P(x, y)**: - The line segment connecting the points of intersection of the two lines is labeled as p(x, y). - The line segment is a straight line with a positive slope. ### Graph Description: - **Points of Intersection**: - The line segment connecting the points of intersection of the two lines is a straight line. - The line segment is a straight line with a positive slope. ### Analysis: - **Line Segment P(x, y)**: - The line segment P(x, y](../images/imageFile29.png)

x

̂

x

0

C

p

(

x,

)

1

C

p

(

x,

)

2

x

R

R

1

2

Figure 1.24 Schematic illustration of the joint probabilities p ( x, C k ) for each of two classes plotted against x , together with the decision boundary x = b x . Values of x b x are classiﬁed as class C 2 and hence belong to decision region R 2 , whereas points x < b x are classiﬁed as C 1 and belong to R 1 . Errors arise from the blue, green, and red regions, so that for x < b x the errors are due to points from class C 2 being misclassiﬁed as C 1 (represented by the sum of the red and green regions), and conversely for points in the region x b x the errors are due to points from class C 1 being misclassiﬁed as C 2 (represented by the blue region). As we vary the location b x of the decision boundary, the combined areas of the blue and green regions remains constant, whereas the size of the red region varies. The optimal choice for b x is where the curves for p ( x, C 1 ) and p ( x, C 2 ) cross, corresponding to b x = x 0 , because in this case the red region disappears. This is equivalent to the minimum misclassiﬁcation rate decision rule, which assigns each value of x to the class having the higher posterior probability p ( C k | x ) .

probability of making a mistake is obtained if each value of x is assigned to the class for which the posterior probability p ( C k | x ) is largest. This result is illustrated for two classes, and a single input variable x , in Figure 1.24.

For the more general case of K classes, it is slightly easier to maximize the probability of being correct, which is given by

$$
p ( \text {correct} ) \ & = \ \sum _ { k = 1 } ^ { K } p ( \mathbf x \in \mathcal { R } _ { k } , \mathcal { C } _ { k } ) \\ & = \ \sum _ { k = 1 } ^ { K } \int _ { \mathcal { R } _ { k } } p ( \mathbf x , \mathcal { C } _ { k } ) \, d \mathbf x \\ \text {maximized when the regions } \mathcal { R } _ { k } \text { are chosen such that each } \mathbf x \text { is assigned}
$$

which is maximized when the regions R k are chosen such that each x is assigned to the class for which p ( x , C k ) is largest. Again, using the product rule p ( x , C k ) = p ( C k | x ) p ( x ) , and noting that the factor of p ( x ) is common to all terms, we see that each x should be assigned to the class having the largest posterior probability p ( C k | x ) .
