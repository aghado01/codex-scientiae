[Page 311]

# 6

![image 80](../../../../../images/imageFile80.png)

###### Kernel Methods

In Chapters 3 and 4, we considered linear parametric models for regression and classiﬁcation in which the form of the mapping $y(\mathbf{x},\mathbf{w})$ from input $\mathbf{x}$ to output $y$ is governed by a vector $\mathbf{w}$ of adaptive parameters. During the learning phase, a set of training data is used either to obtain a point estimate of the parameter vector or to determine a posterior distribution over this vector. The training data is then discarded, and predictions for new inputs are based purely on the learned parameter vector $\mathbf{w}$. This approach is also used in nonlinear parametric models such as neural networks.

However, there is a class of pattern recognition techniques, in which the training data points, or a subset of them, are kept and used also during the prediction phase. For instance, the Parzen probability density model comprised a linear combination of ‘kernel’ functions each one centred on one of the training data points. Similarly, in Section 2.5.2 we introduced a simple technique for classiﬁcation called nearest neighbours, which involved assigning to each new test vector the same label as the
