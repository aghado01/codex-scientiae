[Page 303]

# Figure 5.22

Illustration of the evidence framework applied to a synthetic two-class data set. The green curve shows the optimal decision boundary, the black curve shows the result of ﬁtting a two-layer network with 8 hidden units by maximum likelihood, and the red curve shows the result of including a regularizer in which α is optimized using the evidence procedure, starting from the initial value α = 0 . Note that the evidence procedure greatly reduces the over-ﬁtting of the network.

3

![The image is a graphical representation of a map, specifically a choropleth map. The map is divided into different colored regions, each representing a different area. The colors are arranged in a grid pattern, with each color corresponding to a different color in the map. The map is labeled with the names of different regions, such as California, New York, and Texas. The map is labeled with the names of the regions, and the labels are written in a clear, readable font. The map is not shaded, so it does not provide any additional information beyond the labels. The map is not shaded, so it does not provide any additional information beyond the labels. There are several elements present on the map: 1. **Color Coding**: The map uses different colors to represent different regions. The colors are arranged in a grid pattern, with each color corresponding to a different color in the map. 2. **Geographical Information**: The map includes](../images/imageFile128.png)

2

1

0

- −1
- −2

−2

−1

0

1

2

simplest approximation is to assume that the posterior distribution is very narrow and hence make the approximation

$$
p ( t | x , \mathcal { D } ) \simeq p ( t | x , w _ { \text {MAP} } ) .
$$

We can improve on this, however, by taking account of the variance of the posterior distribution. In this case, a linear approximation for the network outputs, as was used in the case of regression, would be inappropriate due to the logistic sigmoid outputunit activation function that constrains the output to lie in the range (0 , 1) . Instead, we make a linear approximation for the output unit activation in the form

$$
a ( x , w ) \simeq a _ { M A P } ( x ) + b ^ { T } ( w - w _ { M A P } )
$$

where a MAP ( x ) = a ( x , w MAP ) , and the vector b ≡ ∇ a ( x , w MAP ) can be found by backpropagation.

Because we now have a Gaussian approximation for the posterior distribution over w , and a model for a that is a linear function of w , we can now appeal to the results of Section 4.5.2. The distribution of output unit activation values, induced by the distribution over network weights, is given by

$$
1 \text { where } & \int \delta \left ( a - a _ { \text {MAP} } ( x ) - b ^ { T } ( x ) ( w - w _ { \text {MAP} } ) \right ) q ( w | \mathcal { D } ) \text { w} \quad ( 5 . 1 8 ) \\ \text {where } & q ( w | \mathcal { D } ) \text { is the Gaussian approximation to the posterior distribution given by }
$$

where q ( w |D ) is the Gaussian approximation to the posterior distribution given by (5.167). From Section 4.5.2, we see that this distribution is Gaussian with mean a MAP ≡ a ( x , w MAP ) , and variance

$$
\sigma _ { a } ^ { 2 } ( x ) = b ^ { T } ( x ) A ^ { - 1 } b ( x ) .
$$

Finally, to obtain the predictive distribution, we must marginalize over a using

$$
p ( t = 1 | x , \mathcal { D } ) = \int \sigma ( a ) p ( a | x , \mathcal { D } ) \, d a .
$$
