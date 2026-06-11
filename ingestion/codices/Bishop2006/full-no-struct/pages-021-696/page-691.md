[Page 691]

![The image is a scatter plot with two sets of data points. The x-axis is labeled as 1 and the y-axis is labeled as 1. The data points are represented by green dots. The plot is titled Skewed Data and has a legend at the bottom right corner that indicates the values of the data points. The scatter plot is visually represented with two sets of data points. The first set of data points is represented by a pink color and is labeled as 1 and 1. The second set of data points is represented by a purple color and is labeled as 1. The plot has a scale of range from -1 to 1 on the x-axis, and the y-axis is labeled as 1. The data points are represented by green dots. The plot is visually represented with two sets of data points, one pink and one purple. The plot is labeled as Skewed Data](../images/imageFile48.png)

1.5

1.5

0.5

0.5

~05

~0.5

415

~0.5

0.5

~0.5

0.5

Figure 14.9 The left plot shows the predictive conditional density corresponding to the converged solution in Figure 14.8. This gives a log likelihood value of − 3 . 0 . A vertical slice through one of these plots at a particular value of x represents the corresponding conditional distribution p ( t | x ) , which we see is bimodal. The plot on the right shows the predictive density for a single linear regression model ﬁtted to the same data set using maximum likelihood. This model has a smaller log likelihood of − 27 . 6 .

function is then given by

$$
\text {is then given by} \\ p ( t | \theta ) = \prod _ { n = 1 } ^ { N } \left ( \sum _ { k = 1 } ^ { K } \pi _ { k } y _ { n k } ^ { t _ { n } } \left [ 1 - y _ { n k } \right ] ^ { 1 - t _ { n } } \right ) \\ k = \sigma ( w _ { k } ^ { T } \phi _ { n } ) \text { and } t = ( t _ { 1 } , \dots , t _ { N } ) ^ { T } \cdot \ W e \text { can maximize this likelihood}
$$

where y nk = σ ( w T k φ n ) and t = ( t 1 ,...,t N ) T . We can maximize this likelihood function iteratively by making use of the EM algorithm. This involves introducing latent variables z nk that correspond to a 1-ofK coded binary indicator variable for each data point n . The complete-data likelihood function is then given by

$$
p ( t , Z | \theta ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } \left \{ \pi _ { k } y _ { n k } ^ { t _ { n } } \left [ 1 - y _ { n k } \right ] ^ { 1 - t _ { n } } \right \} ^ { z _ { n k } } \\ Z \text { is the matrix of latent variables with elements } z _ { n k } . \text { We initialize the EM }
$$

where Z is the matrix of latent variables with elements z nk . We initialize the EM algorithm by choosing an initial value θ old for the model parameters. In the E step, we then use these parameter values to evaluate the posterior probabilities of the components k for each data point n , which are given by

$$
\text { } \gamma _ { n k } = \mathbb { E } [ z _ { n k } ] = p ( k | \phi _ { n } , \theta ^ { \text {old} } ) = \frac { \pi _ { k } y _ { n k } ^ { t _ { n } } \left [ 1 - y _ { n k } \right ] ^ { 1 - t _ { n } } } { \sum _ { j } \pi _ { j } y _ { n j } ^ { t _ { n } } \left [ 1 - y _ { n j } \right ] ^ { 1 - t _ { n } } } . \\ \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { }
$$

These responsibilities are then used to ﬁnd the expected complete-data log likelihood as a function of θ , given by

$$
Q ( \theta , \theta ^ { o l d } ) & = \mathbb { E } _ { Z } \left [ \ln p ( \mathbf t , Z | \theta ) \right ] \\ & = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } \gamma _ { n k } \left \{ \ln \pi _ { k } + t _ { n } \ln y _ { n k } + ( 1 - t _ { n } ) \ln ( 1 - y _ { n k } ) \right \} .
$$
