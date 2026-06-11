[Page 296]

Figure 5.21 (a) Plot of the mixing coefﬁcients π k ( x ) as a function of x for the three kernel functions in a mixture density network trained on the data shown in Figure 5.19. The model has three Gaussian components, and uses a two-layer multilayer perceptron with ﬁve ‘ tanh ’ sigmoidal units in the hidden layer, and nine outputs (corresponding to the 3 means and 3 variances of the Gaussian components and the 3 mixing coefﬁcients). At both small and large values of x , where the conditional probability density of the target data is unimodal, only one of the kernels has a high value for its prior probability, while at intermediate values of x , where the conditional density is trimodal, the three mixing coefﬁcients have comparable values. (b) Plots of the means µ k ( x ) using the same colour coding as for the mixing coefﬁcients. (c) Plot of the contours of the corresponding conditional probability density of the target data for the same mixture density network. (d) Plot of the approximate conditional mode, shown by the red points, of the conditional density.

![The image is a graph with three different lines. The lines are labeled as A, B, and C. The x-axis is labeled as a, the y-axis is labeled as b, and the title of the graph is A, B, C. The lines are drawn in a way that they are all parallel to each other. The lines are colored in red, blue, and green. The red line is the highest line, and the green line is the lowest line.](../images/imageFile127.png)

1

1

0

0

0

1

0

1

(a)

(b)

1

1

0

0

0

1

0

1

(c)

(d)

We illustrate the use of a mixture density network by returning to the toy example of an inverse problem shown in Figure 5.19. Plots of the mixing coefﬁcients π k ( x ) , the means µ k ( x ) , and the conditional density contours corresponding to p ( t | x ) , are shown in Figure 5.21. The outputs of the neural network, and hence the parameters in the mixture model, are necessarily continuous single-valued functions of the input variables. However, we see from Figure 5.21(c) that the model is able to produce a conditional density that is unimodal for some values of x and trimodal for other values by modulating the amplitudes of the mixing components π k ( x ) . Once a mixture density network has been trained, it can predict the conditional

density function of the target data for any given value of the input vector. This conditional density represents a complete description of the generator of the data, so far as the problem of predicting the value of the output vector is concerned. From this density function we can calculate more speciﬁc quantities that may be of interest in different applications. One of the simplest of these is the mean, corresponding to the conditional average of the target data, and is given by

$$
\mathbb { E } \left [ t | x \right ] = \int t p ( t | x ) \, d t = \sum _ { k = 1 } ^ { K } \pi _ { k } ( x ) \mu _ { k } ( x )
$$
