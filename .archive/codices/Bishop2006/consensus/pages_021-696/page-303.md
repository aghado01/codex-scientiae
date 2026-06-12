[Page 303]

Figure 5.22 Illustration of the evidence framework applied to a synthetic two-class data set. The green curve shows the optimal decision boundary, the black curve shows the result of ﬁtting a two-layer network with 8 hidden units by maximum likelihood, and the red curve shows the result of including a regularizer in which $\alpha$ is optimized using the evidence procedure, starting from the initial value $\alpha = 0$. Note that the evidence procedure greatly reduces the over-ﬁtting of the network.

![The image is a graphical representation of a map, specifically a choropleth map. The map is divided into different colored regions, each representing a different area. The colors are arranged in a grid pattern, with each color corresponding to a different color in the map. The map is labeled with the names of different regions, such as California, New York, and Texas. The map is labeled with the names of the regions, and the labels are written in a clear, readable font. The map is not shaded, so it does not provide any additional information beyond the labels. The map is not shaded, so it does not provide any additional information beyond the labels. There are several elements present on the map: 1. **Color Coding**: The map uses different colors to represent different regions. The colors are arranged in a grid pattern, with each color corresponding to a different color in the map. 2. **Geographical Information**: The map includes](../images/imageFile128.png)

simplest approximation is to assume that the posterior distribution is very narrow and hence make the approximation

$$
p(t|\mathbf{x},\mathcal{D}) \simeq p(t|\mathbf{x},\mathbf{w}_{\text{MAP}}). \tag{5.185}
$$

We can improve on this, however, by taking account of the variance of the posterior distribution. In this case, a linear approximation for the network outputs, as was used in the case of regression, would be inappropriate due to the logistic sigmoid outputunit activation function that constrains the output to lie in the range $(0,1)$. Instead, we make a linear approximation for the output unit activation in the form

$$
a(\mathbf{x},\mathbf{w}) \simeq a_{\text{MAP}}(\mathbf{x}) + \mathbf{b}^T(\mathbf{w} - \mathbf{w}_{\text{MAP}}) \tag{5.186}
$$

where $a_{\text{MAP}}(\mathbf{x}) = a(\mathbf{x},\mathbf{w}_{\text{MAP}})$, and the vector $\mathbf{b} \equiv \nabla a(\mathbf{x},\mathbf{w}_{\text{MAP}})$ can be found by backpropagation.

Because we now have a Gaussian approximation for the posterior distribution over $\mathbf{w}$, and a model for $a$ that is a linear function of $\mathbf{w}$, we can now appeal to the results of Section 4.5.2. The distribution of output unit activation values, induced by the distribution over network weights, is given by

$$
p(a|\mathbf{x},\mathcal{D}) = \int \delta \left( a - a_{\text{MAP}}(\mathbf{x}) - \mathbf{b}^T(\mathbf{x})(\mathbf{w} - \mathbf{w}_{\text{MAP}}) \right) q(\mathbf{w}|\mathcal{D}) \, d\mathbf{w} \tag{5.187}
$$

where $q(\mathbf{w}|\mathcal{D})$ is the Gaussian approximation to the posterior distribution given by (5.167). From Section 4.5.2, we see that this distribution is Gaussian with mean $a_{\text{MAP}} \equiv a(\mathbf{x},\mathbf{w}_{\text{MAP}})$, and variance

$$
\sigma_a^2(\mathbf{x}) = \mathbf{b}^T(\mathbf{x})\mathbf{A}^{-1}\mathbf{b}(\mathbf{x}). \tag{5.188}
$$

Finally, to obtain the predictive distribution, we must marginalize over $a$ using

$$
p(t = 1|\mathbf{x},\mathcal{D}) = \int \sigma(a)p(a|\mathbf{x},\mathcal{D}) \, da. \tag{5.189}
$$
