[Page 357]

Figure 7.5 Plot of the ‘hinge’ error function used in support vector machines, shown in blue, along with the error function for logistic regression, rescaled by a factor of 1/ ln(2) so that it passes through the point (0, 1), shown in red. Also shown are the misclassiﬁcation error in black and the squared error in green.

E(z)

−2 −1 0 1 2

z

remaining points we have ξn = 1 − yntn. Thus the objective function (7.21) can be written (up to an overall multiplicative constant) in the form

�N

ESV(yntn) + λ�w�2 (7.44)

n=1

where λ = (2C)−1, and ESV(·) is the hinge error function deﬁned by

ESV(yntn) = [1 − yntn]+ (7.45)

where [·]+ denotes the positive part. The hinge error function, so-called because of its shape, is plotted in Figure 7.5. It can be viewed as an approximation to the misclassiﬁcation error, i.e., the error function that ideally we would like to minimize, which is also shown in Figure 7.5.

When we considered the logistic regression model in Section 4.3.2, we found it convenient to work with target variable t ∈ {0,1}. For comparison with the support vector machine, we ﬁrst reformulate maximum likelihood logistic regression using the target variable t ∈ {−1,1}. To do this, we note that p(t = 1|y) = σ(y) where y(x) is given by (7.1), and σ(y) is the logistic sigmoid function deﬁned by (4.59). It follows that p(t = −1|y) = 1 − σ(y) = σ(−y), where we have used the properties of the logistic sigmoid function, and so we can write

p(t|y) = σ(yt). (7.46)

From this we can construct an error function by taking the negative logarithm of the Exercise 7.6 likelihood function that, with a quadratic regularizer, takes the form

where

�N

ELR(yntn) + λ�w�2. (7.47)

n=1

ELR(yt) = ln(1 + exp(−yt)). (7.48)
