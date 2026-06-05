[Page 48]

Figure 1.15

Illustration of how bias arises in using maximum likelihood to determine the variance of a Gaussian. The green curve shows the true Gaussian distribution from which data is generated, and the three red curves show the Gaussian distributions obtained by ﬁtting to three data sets, each consisting of two data points shown in blue, using the maximum likelihood results (1.55) and (1.56). Averaged across the three data sets, the mean is correct, but the variance is systematically under-estimated because it is measured relative to the sample mean and not relative to the true mean.

![The image depicts a graph with two axes labeled as a and b. The graph is a line graph with two lines, one of which is a straight line and the other a curve. The line on the graph is a straight line, while the curve is a curved line. The line on the graph is a straight line, while the curve is a curved line. ### Graph Description: - **Axes**: - The x-axis (horizontal axis) is labeled a and the y-axis (vertical axis) is labeled b. - The graph is a line graph, with two lines, one of which is a straight line and the other a curved line. ### Graph Components: - **Line Graph**: - The line on the graph is a straight line. - The line is a straight line. - The line is a straight line. - **Curve Graph**: - The curve on the graph](../images/imageFile20.png)

- (a)
- (b)
- (c)

Section 1.1

In Section 10.1.3, we shall see how this result arises automatically when we adopt a Bayesian approach.

Note that the bias of the maximum likelihood solution becomes less signiﬁcant as the number N of data points increases, and in the limit N → ∞ the maximum likelihood solution for the variance equals the true variance of the distribution that generated the data. In practice, for anything other than small N , this bias will not prove to be a serious problem. However, throughout this book we shall be interested in more complex models with many parameters, for which the bias problems associated with maximum likelihood will be much more severe. In fact, as we shall see, the issue of bias in maximum likelihood lies at the root of the over-ﬁtting problem that we encountered earlier in the context of polynomial curve ﬁtting.

# 1.2.5 Curve ﬁtting re-visited

We have seen how the problem of polynomial curve ﬁtting can be expressed in terms of error minimization. Here we return to the curve ﬁtting example and view it from a probabilistic perspective, thereby gaining some insights into error functions and regularization, as well as taking us towards a full Bayesian treatment.

The goal in the curve ﬁtting problem is to be able to make predictions for the target variable t given some new value of the input variable x on the basis of a set of training data comprising N input values x = ( x 1 ,...,x N ) T and their corresponding target values t = ( t 1 ,...,t N ) T . We can express our uncertainty over the value of the target variable using a probability distribution. For this purpose, we shall assume that, given the value of x , the corresponding value of t has a Gaussian distribution with a mean equal to the value y ( x, w ) of the polynomial curve given by (1.1). Thus we have 1

$$
p ( t | x , w , \beta ) = \mathcal { N } \left ( t | y ( x , w ) , \beta ^ { - 1 } \right ) \\ \text {consistency with the notation in later chapters, we have defined a precise-
iter 8 probability of the inverse variance of the distribution. This is
}
$$

where, for consistency with the notation in later chapters, we have deﬁned a precision parameter β corresponding to the inverse variance of the distribution. This is illustrated schematically in Figure 1.16.
