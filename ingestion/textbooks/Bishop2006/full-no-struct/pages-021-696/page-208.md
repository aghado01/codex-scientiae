[Page 208]

![The image is a scatter plot with two sets of data. The x-axis is labeled days and the y-axis is labeled total. The plot consists of two sets of data, each set is represented by a different color. The first set of data is represented by blue and the second set is represented by red. ### Description of the Data Points: - **Blue Data Set (Days 1-2)**: - The blue data set has a relatively high value of 2. - The blue data set has a small but noticeable increase in the first few days. - The blue data set has a small but noticeable decrease in the second few days. - **Red Data Set (Days 3-5)**: - The red data set has a relatively high value of 2. - The red data set has a small but noticeable increase in the first few days. - The red data set has a small but noticeable decrease](../images/imageFile96.png)

4

4

2

2

0

0

−2

−2

−2

2

6

−2

2

6

Figure 4.6 The left plot shows samples from two classes (depicted in red and blue) along with the histograms resulting from projection onto the line joining the class means. Note that there is considerable class overlap in the projected space. The right plot shows the corresponding projection based on the Fisher linear discriminant, showing the greatly improved class separation.

is the mean of the projected data from class C k . However, this expression can be made arbitrarily large simply by increasing the magnitude of w . To solve this problem, we could constrain w to have unit length, so that i w 2 i = 1 . Using a Lagrange multiplier to perform the constrained maximization, we then ﬁnd that w ∝ ( m 2 − m 1 ) . There is still a problem with this approach, however, as illustrated in Figure 4.6. This shows two classes that are well separated in the original twodimensional space ( x 1 ,x 2 ) but that have considerable overlap when projected onto the line joining their means. This difﬁculty arises from the strongly nondiagonal covariances of the class distributions. The idea proposed by Fisher is to maximize a function that will give a large separation between the projected class means while also giving a small variance within each class, thereby minimizing the class overlap.

The projection formula (4.20) transforms the set of labelled data points in x into a labelled set in the one-dimensional space y . The within-class variance of the transformed data from class C k is therefore given by

$$
s _ { k } ^ { 2 } & = \sum _ { n \in C _ { k } } ( y _ { n } - m _ { k } ) ^ { 2 } & & ( 4 . 2 4 ) \\
$$

where y n = w T x n . We can deﬁne the total within-class variance for the whole data set to be simply s 2 1 + s 2 2 . The Fisher criterion is deﬁned to be the ratio of the between-class variance to the within-class variance and is given by

$$
J ( w ) = \frac { ( m _ { 2 } - m _ { 1 } ) ^ { 2 } } { s _ { 1 } ^ { 2 } + s _ { 2 } ^ { 2 } } .
$$

We can make the dependence on w explicit by using (4.20), (4.23), and (4.24) to rewrite the Fisher criterion in the form
