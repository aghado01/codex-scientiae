[Page 357]

Figure 7.5 Plot of the ‘hinge’ error function used in support vector machines, shown in blue, along with the error function for logistic regression, rescaled by a factor of 1 / ln(2) so that it passes through the point (0 , 1) , shown in red. Also shown are the misclassiﬁcation error in black and the squared error in green.

![The image consists of a graph with two lines, one blue and one red, both labeled as E(z). The graph has a horizontal axis labeled z and a vertical axis labeled 2, with a scale from -2 to 1 on the x-axis. The graph shows two peaks and two troughs, indicating that the graph is not symmetrical. The blue line is labeled as E(z) and the red line is labeled as E(z). The blue line is shown to be the highest peak, while the red line is shown to be the lowest peak. The graph also includes a point labeled 2, which is located at the bottom of the graph. This point is marked with a dashed line, indicating that it is the lowest point on the graph. The graph also includes a point labeled 1, which is located at the top of the graph. This point is marked with a dashed line, indicating that it is](../images/imageFile150.png)

E

(

z

)

z

-

-

2

1

0

1

2

remaining points we have ξ n = 1 − y n t n . Thus the objective function (7.21) can be written (up to an overall multiplicative constant) in the form

$$
\sum _ { n = 1 } ^ { N } E _ { S V } ( y _ { n } t _ { n } ) + \lambda \| w \| ^ { 2 } \\ \intertext { a n d } \text { } E _ { S V } ( \cdot ) \text { is the h i n g e r $error$ function defined by }
$$

where λ = (2 C ) − 1 , and E SV ( · ) is the hinge error function deﬁned by

$$
E _ { S V } ( y _ { n } t _ { n } ) = [ 1 - y _ { n } t _ { n } ] _ { + }
$$

where [ · ] + denotes the positive part. The hinge error function, so-called because of its shape, is plotted in Figure 7.5. It can be viewed as an approximation to the misclassiﬁcation error, i.e., the error function that ideally we would like to minimize, which is also shown in Figure 7.5.

When we considered the logistic regression model in Section 4.3.2, we found it convenient to work with target variable t ∈ { 0 , 1 } . For comparison with the support vector machine, we ﬁrst reformulate maximum likelihood logistic regression using the target variable t ∈ {− 1 , 1 } . To do this, we note that p ( t = 1 | y ) = σ ( y ) where y ( x ) is given by (7.1), and σ ( y ) is the logistic sigmoid function deﬁned by (4.59). It follows that p ( t = − 1 | y ) = 1 − σ ( y ) = σ ( − y ) , where we have used the properties of the logistic sigmoid function, and so we can write

$$
p ( t | y ) = \sigma ( y t ) .
$$

From this we can construct an error function by taking the negative logarithm of the likelihood function that, with a quadratic regularizer, takes the form

where

$$
\sum _ { n = 1 } ^ { N } E _ { L R } ( y _ { n } t _ { n } ) + \lambda \| \mathbf w \| ^ { 2 } .
$$

$$
E _ { L R } ( y t ) = \ln \left ( 1 + \exp ( - y t ) \right ) .
$$
