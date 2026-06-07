[Page 346]

encouraged to review the key concepts covered in Appendix E. Additional information on support vector machines can be found in Vapnik (1995), Burges (1998), Cristianini and Shawe-Taylor (2000), M¨uller et al. (2001), Sch¨olkopf and Smola (2002), and Herbrich (2002).

The SVM is a decision machine and so does not provide posterior probabilities. We have already discussed some of the beneﬁts of determining probabilities in Section 1.5.4. An alternative sparse kernel technique, known as the relevance vector machine (RVM), is based on a Bayesian formulation and provides posterior probabilistic outputs, as well as having typically much sparser solutions than the SVM.

###### 7.1. Maximum Margin Classiﬁers

We begin our discussion of support vector machines by returning to the two-class classiﬁcation problem using linear models of the form

$$
y(\mathbf{x}) = \mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}) + b \tag{7.1}
$$

where $\boldsymbol{\phi}(\mathbf{x})$ denotes a ﬁxed feature-space transformation, and we have made the bias parameter $b$ explicit. Note that we shall shortly introduce a dual representation expressed in terms of kernel functions, which avoids having to work explicitly in feature space. The training data set comprises $N$ input vectors $\mathbf{x}_1,\dots,\mathbf{x}_N$, with corresponding target values $t_1,\dots,t_N$ where $t_n \in \{-1,1\}$, and new data points $\mathbf{x}$ are classiﬁed according to the sign of $y(\mathbf{x})$.

We shall assume for the moment that the training data set is linearly separable in feature space, so that by deﬁnition there exists at least one choice of the parameters $\mathbf{w}$ and $b$ such that a function of the form (7.1) satisﬁes $y(\mathbf{x}_n) > 0$ for points having $t_n = +1$ and $y(\mathbf{x}_n) < 0$ for points having $t_n = -1$, so that $t_ny(\mathbf{x}_n) > 0$ for all training data points.

There may of course exist many such solutions that separate the classes exactly. In Section 4.1.7, we described the perceptron algorithm that is guaranteed to ﬁnd a solution in a ﬁnite number of steps. The solution that it ﬁnds, however, will be dependent on the (arbitrary) initial values chosen for $\mathbf{w}$ and $b$ as well as on the order in which the data points are presented. If there are multiple solutions all of which classify the training data set exactly, then we should try to ﬁnd the one that will give the smallest generalization error. The support vector machine approaches this problem through the concept of the margin, which is deﬁned to be the smallest distance between the decision boundary and any of the samples, as illustrated in Figure 7.1.

In support vector machines the decision boundary is chosen to be the one for which the margin is maximized. The maximum margin solution can be motivated using computational learning theory, also known as statistical learning theory. However, a simple insight into the origins of maximum margin has been given by Tong and Koller (2000) who consider a framework for classiﬁcation based on a hybrid of generative and discriminative approaches. They ﬁrst model the distribution over input vectors $\mathbf{x}$ for each class using a Parzen density estimator with Gaussian kernels having a common parameter $\sigma^2$. Together with the class priors, this deﬁnes an optimal misclassiﬁcation-rate decision boundary. However, instead of using this optimal boundary, they determine the best hyperplane by minimizing the probability of error relative to the learned density model. In the limit $\sigma^2 \to 0$, the optimal hyperplane is shown to be the one having maximum margin. The intuition behind this result is that as $\sigma^2$ is reduced, the hyperplane is increasingly dominated by nearby data points relative to more distant ones. In the limit, the hyperplane becomes independent of data points that are not support vectors.
