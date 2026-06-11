[Page 224]

| |
|---|


| |
|---|


1

- 0
- 1


φ2

x2

0.5

−1

0

−1 0 1

0 0.5 1

φ1

x1

- Figure 4.12 Illustration of the role of nonlinear basis functions in linear classiﬁcation models. The left plot shows the original input space (x1, x2) together with data points from two classes labelled red and blue. Two ‘Gaussian’ basis functions φ1(x) and φ2(x) are deﬁned in this space with centres shown by the green crosses and with contours shown by the green circles. The right-hand plot shows the corresponding feature space


(φ1, φ2) together with the linear decision boundary obtained given by a logistic regression model of the form discussed in Section 4.3.2. This corresponds to a nonlinear decision boundary in the original input space, shown by the black curve in the left-hand plot.

Bayes’ theorem, represents an example of generative modelling, because we could take such a model and generate synthetic data by drawing values of x from the marginal distribution p(x). In the direct approach, we are maximizing a likelihood function deﬁned through the conditional distribution p(Ck|x), which represents a form of discriminative training. One advantage of the discriminative approach is that there will typically be fewer adaptive parameters to be determined, as we shall see shortly. It may also lead to improved predictive performance, particularly when the class-conditional density assumptions give a poor approximation to the true distributions.

###### 4.3.1 Fixed basis functions

So far in this chapter, we have considered classiﬁcation models that work directly with the original input vector x. However, all of the algorithms are equally applicable if we ﬁrst make a ﬁxed nonlinear transformation of the inputs using a vector of basis functions φ(x). The resulting decision boundaries will be linear in the feature space φ, and these correspond to nonlinear decision boundaries in the original x space, as illustrated in Figure 4.12. Classes that are linearly separable in the feature space φ(x) need not be linearly separable in the original observation space x. Note that as in our discussion of linear models for regression, one of the
