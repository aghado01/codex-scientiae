[Page 588]

100

90

80

70

60

50

40

00'

,=~o

2

4

6

2

0

-2

-2

0

2

2

0

-2

O

B

000

0

0

08

0

0

~

cPO

0

0

tj

O~

~OOID

-2

0

2

Figure 12.6 Illustration of the effects of linear pre-processing applied to the Old Faithful data set. The plot on the left shows the original data. The centre plot shows the result of standardizing the individual variables to zero mean and unit variance. Also shown are the principal axes of this normalized data set, plotted over the range ±A~/2. The plot on the right shows the result of whitening of the data to give it zero mean and unit covariance.

Appendix A

Appendix A

where L is a D x D diagonal matrix with elements Ai, and U is a D x D orthogonal matrix with columns given by Ui. Then we define, for each data point X n , a transformed value given by

$$
y _ { n } = L ^ { - 1 / 2 } U ^ { \mathrm T } ( x _ { n } - \overline { x } )
$$

where x is the sample mean defined by (12.1). Clearly, the set {Yn} has zero mean, and its covariance is given by the identity matrix because

$$
\frac { 1 } { N } \sum _ { n = 1 } ^ { N } y _ { n } y _ { n } ^ { T } \ & = \ \frac { 1 } { N } \sum _ { n = 1 } ^ { N } L ^ { - 1 / 2 } U ^ { T } ( x _ { n } - \overline { x } ) ( x _ { n } - \overline { x } ) ^ { T } U L ^ { - 1 / 2 } \\ & = \ L ^ { - 1 / 2 } U ^ { T } S U L ^ { - 1 / 2 } = L ^ { - 1 / 2 } L L ^ { - 1 / 2 } = I . \quad ( 1 2 . 2 5 )
$$

This operation is known as whitening or sphereing the data and is illustrated for the Old Faithful data set in Figure 12.6.

It is interesting to compare PCA with the Fisher linear discriminant which was discussed in Section 4.1.4. Both methods can be viewed as techniques for linear dimensionality reduction. However, PCA is unsupervised and depends only on the values X n whereas Fisher linear discriminant also uses class-label information. This difference is highlighted by the example in Figure 12.7.

Another common application of principal component analysis is to data visualization. Here each data point is projected onto a two-dimensional (M = 2) principal subspace, so that a data point X n is plotted at Cartesian coordinates given by x'J. U1 and x'J. U2, where Ul and U2 are the eigenvectors corresponding to the largest and second largest eigenvalues. An example of such a plot, for the oil flow data set, is shown in Figure 12.8.
