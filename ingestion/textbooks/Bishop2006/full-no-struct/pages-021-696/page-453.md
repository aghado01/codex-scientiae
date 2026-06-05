[Page 453]

![The image is a scatter plot with three different colors, each represented by a different color. The x-axis is labeled as 0.5 and the y-axis is labeled as 0.5. The points on the scatter plot are scattered across the graph, with each point colored in a different color. The colors of the points are as follows: - Red: This color represents the lowest points on the graph. - Green: This color represents the mid-point of the graph. - Blue: This color represents the highest points on the graph. The points are scattered in a random pattern, with no clear pattern or pattern in the colors. The x-axis is labeled as 0.5, and the y-axis is labeled as 0.5. The points are scattered across the graph, with no clear pattern or pattern in the colors. The scatter plot is a type of plot called a scatter plot. It is used to](../images/imageFile220.png)

1

1

1

(a)

(b)

(c)

0.5

0.5

0.5

0

0

0

0

0.5

1

0

0.5

1

0

0.5

1

Figure 9.5 Example of 500 points drawn from the mixture of 3 Gaussians shown in Figure 2.23. (a) Samples from the joint distribution p ( z ) p ( x | z ) in which the three states of z , corresponding to the three components of the mixture, are depicted in red, green, and blue, and (b) the corresponding samples from the marginal distribution p ( x ) , which is obtained by simply ignoring the values of z and just plotting the x values. The data set in (a) is said to be complete , whereas that in (b) is incomplete . (c) The same samples in which the colours represent the value of the responsibilities γ ( z nk ) associated with data point x n , obtained by plotting the corresponding point using proportions of red, blue, and green ink given by γ ( z nk ) for k = 1 , 2 , 3 , respectively

matrix X in which the n th row is given by x T n . Similarly, the corresponding latent variables will be denoted by an N × K matrix Z with rows z T n . If we assume that the data points are drawn independently from the distribution, then we can express the Gaussian mixture model for this i.i.d. data set using the graphical representation shown in Figure 9.6. From (9.7) the log of the likelihood function is given by

$$
\text { within Figure 9.6. From } ( 9 . ) \text { the log of the linear method function is given by } \\ \ln p ( X | \pi , \mu , \Sigma ) = \sum _ { n = 1 } ^ { N } \ln \left \{ \sum _ { k = 1 } ^ { K } \pi _ { k } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) \right \} . \\ \text {Before discusing how to maximize this function, it is worth emphasizing that }
$$

Before discussing how to maximize this function, it is worth emphasizing that there is a signiﬁcant problem associated with the maximum likelihood framework applied to Gaussian mixture models, due to the presence of singularities. For simplicity, consider a Gaussian mixture whose components have covariance matrices given by Σ k = σ 2 k I , where I is the unit matrix, although the conclusions will hold for general covariance matrices. Suppose that one of the components of the mixture model, let us say the j th component, has its mean µ j exactly equal to one of the data

Figure 9.6 Graphical representation of a Gaussian mixture model for a set of N i.i.d. data points { x n } , with corresponding latent points { z n } , where n = 1 , . . . , N .

![image 221](../images/imageFile221.png)

n

z

π

n

x

µ

Σ

N
