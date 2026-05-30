## 14. Combining Models

In earlier chapters, we have explored a range of different models for solving classification and regression problems. It is often found that improved performance can be obtained by combining multiple models together in some way, instead of just using a single model in isolation. For instance, we might train L different models and then make predictions using the average of the predictions made by each model. Such combinations of models are sometimes called committees. In Section 14.2, we discuss ways to apply the committee concept in practice, and we also give some insight into why it can sometimes be an effective procedure.

One important variant of the committee method, known as boosting, involves training multiple models in sequence in which the error function used to train a particular model depends on the performance of the previous models. This can produce substantial improvements in performance compared to the use of a single model and is discussed in Section 14.3.

Instead of averaging the predictions of a set of models, an alternative form of model combination is to select one of the models to make the prediction, in which the choice of model is a function of the input variables. Thus different models become responsible for making predictions in different regions of input space. One widely used framework of this kind is known as a decision tree in which the selection process can be described as a sequence of binary selections corresponding to the traversal of a tree structure and is discussed in Section 14.4. In this case, the individual models are generally chosen to be very simple, and the overall flexibility of the model arises from the input-dependent selection process. Decision trees can be applied to both classification and regression problems.

One limitation of decision trees is that the division of input space is based on hard splits in which only one model is responsible for making predictions for any given value of the input variables. The decision process can be softened by moving to a probabilistic framework for combining models, as discussed in Section 14.5. For example, if we have a set of K models for a conditional distribution p (t | x,k) where x is the input variable, t is the target variable, and k = 1,...,K indexes the model, then we can form a probabilistic mixture of the form

$$
p (t | x) =\sum _ { k = 1 } ^ { K }\pi _ { k } (x) p (t | x, k)\\ =\sigma (k | x)\,\text { represent the input dependent mixing coefficients}\,\text { such }
$$

in which π k (x) = p (k | x) represent the input-dependent mixing coefficients. Such models can be viewed as mixture distributions in which the component densities, as well as the mixing coefficients, are conditioned on the input variables and are known as mixtures of experts. They are closely related to the mixture density network model discussed in Section 5.6.

### 14.1 Bayesian Model Averaging

It is important to distinguish between model combination methods and Bayesian model averaging, as the two are often confused. To understand the difference, consider the example of density estimation using a mixture of Gaussians in which several Gaussian components are combined probabilistically. The model contains a binary latent variable z that indicates which component of the mixture is responsible for generating the corresponding data point. Thus the model is specified in terms of a joint distribution

$$
p (x, z)
$$

and the corresponding density over the observed variable x is obtained by marginalizing over the latent variable

$$
p (x) =\sum _ { z } p (x, z).
$$

Exercise 14.1

In the case of our Gaussian mixture example, this leads to a distribution of the form

$$
p (x) =\sum _ { k = 1 } ^ { K }\pi _ { k }\mathcal { N } (x |\mu _ { k },\Sigma _ { k })\\\text {terpretation of the symbols. This is an example of model combi-}
$$

with the usual interpretation of the symbols. This is an example of model combination. For independent, identically distributed data, we can use (14.3) to write the marginal probability of a data set X = { x 1,..., x N } in the form

$$
p (X) & =\prod _ { n = 1 } ^ { N } p (x _ { n }) =\prod _ { n = 1 } ^ { N }\left [\sum _ { z _ { n } } p (x _ { n }, z _ { n })\right].\\\intertext { s e t h a t e a l c h o w s } &\,\text {see that each observed data point } x _ { n }\,\text { has a corresponding latent variable } z _ { n }.
$$

Thus we see that each observed data point x n has a corresponding latent variable z n. Now suppose we have several different models indexed by = 1 with h,...,H prior probabilities p (h). For instance one model might be a mixture of Gaussians and another model might be a mixture of Cauchy distributions. The marginal distribution over the data set is given by

$$
p (X) =\sum _ { h = 1 } ^ { H } p (X | h) p (h).\\\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ this $ summa $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n p r e t a t i o n $ of $ $ X $ $ }\intertext { o f $ B a v e r a g i n $ e x t r a d e r a $ T i n
$$

This is an example of Bayesian model averaging. The interpretation of this summation over h is that just one model is responsible for generating the whole data set, and the probability distribution over h simply reflects our uncertainty as to which model that is. As the size of the data set increases, this uncertainty reduces, and the posterior probabilities p (h | X) become increasingly focussed on just one of the models.

This highlights the key difference between Bayesian model averaging and model combination, because in Bayesian model averaging the whole data set is generated by a single model. By contrast, when we combine multiple models, as in (14.5), we see that different data points within the data set can potentially be generated from different values of the latent variable z and hence by different components.

Although we have considered the marginal probability p (X), the same considerations apply for the predictive density p (x | X) or for conditional distributions such as p (t | x, X, T).

### 14.2 Committees

The simplest way to construct a committee is to average the predictions of a set of individual models. Such a procedure can be motivated from a frequentist perspective by considering the trade-off between bias and variance, which decomposes the error due to a model into the bias component that arises from differences between the model and the true function to be predicted, and the variance component that represents the sensitivity of the model to the individual data points. Recall from Figure 3.5 that when we trained multiple polynomials using the sinusoidal data, and then averaged the resulting functions, the contribution arising from the variance term tended to cancel, leading to improved predictions. When we averaged a set of low-bias models (corresponding to higher order polynomials), we obtained accurate predictions for the underlying sinusoidal function from which the data were generated.

In practice, of course, we have only a single data set, and so we have to find a way to introduce variability between the different models within the committee. One approach is to use bootstrap data sets, discussed in Section 1.2.3. Consider a regression problem in which we are trying to predict the value of a single continuous variable, and suppose we generate M bootstrap data sets and then use each to train a separate copy y m (x) of a predictive model where m = 1,...,M. The committee prediction is given by

$$
y _ {\ } y c o m (x) & =\frac { 1 } { M }\sum _ { m = 1 } ^ { M } y _ { m } (x).\\\intertext { k n o w n }\text {known as bootstrap aggregation or bagging } (B e r i m a n, 1 9 9 6).
$$

This procedure is known as bootstrap aggregation or bagging (Breiman, 1996).

Suppose the true regression function that we are trying to predict is given by h (x), so that the output of each of the models can be written as the true value plus an error in the form

$$
y _ { m } (x) = h (x) +\epsilon _ { m } (x).
$$

The average sum-of-squares error then takes the form

$$
\mathbb { E } _ { x }\left [\{ y _ { m } (x) - h (x)\} ^ { 2 }\right] & =\mathbb { E } _ { x }\left [\epsilon _ { m } (x) ^ { 2 }\right]\\\intertext {] }\detotes a f r e q u i n t i s t e x p e c t i o n w i s t r e f o r t a d i s t o r }\intertext { r } x,\,\text {The average error made by the models }\text {acting independently}\, i s\,\text {there}\, f o r }
$$

where E x [·] denotes a frequentist expectation with respect to the distribution of the input vector x. The average error made by the models acting individually is therefore

$$
E _ { A V } =\frac { 1 } { M }\sum _ { m = 1 } ^ { M }\mathbb { E } _ { x }\left [\epsilon _ { m } (x) ^ { 2 }\right].\\\text {expected error from the committee}\left (1 4. 7\right)\text { is given by}
$$

Similarly, the expected error from the committee (14.7) is given by

$$
\text {early, the expected error from the committee (14.7) is given by}\\ E _ {\text {COM} }\ =\\mathbb { E } _ { x }\left [\left\{\frac { 1 } { M }\sum _ { m = 1 } ^ { M } y _ { m } (x) - h (x)\right\} ^ { 2 }\right]\\ =\\mathbb { E } _ { x }\left [\left\{\frac { 1 } { M }\sum _ { m = 1 } ^ { M }\epsilon _ { m } (x)\right\} ^ { 2 }\right]\\\text {assume that the errors have zero mean and are uncorrelated, so that}
$$

If we assume that the errors have zero mean and are uncorrelated, so that

$$
\mathbb { E } _ { x }\left [\epsilon _ { m } (x)\right]\ =\ 0
$$

/negationslash Exercise 14.2

$$
\mathbb { E } _ { x }\left [\epsilon _ { m } (x)\epsilon _ { l } (x)\right]\ =\ 0,\quad m\neq l
$$

Exercise 14.3 then we obtain

$$
E _ {\text {COM} } =\frac { 1 } { M } E _ {\text {AV} }.
$$

This apparently dramatic result suggests that the average error of a model can be reduced by a factor of M simply by averaging M versions of the model. Unfortunately, it depends on the key assumption that the errors due to the individual models are uncorrelated. In practice, the errors are typically highly correlated, and the reduction in overall error is generally small. It can, however, be shown that the expected committee error will not exceed the expected error of the constituent models, so that E COM E AV. In order to achieve more significant improvements, we turn to a more sophisticated technique for building committees, known as boosting.

### 14.3 Boosting

Boosting is a powerful technique for combining multiple 'base' classifiers to produce a form of committee whose performance can be significantly better than that of any of the base classifiers. Here we describe the most widely used form of boosting algorithm called AdaBoost, short for 'adaptive boosting', developed by Freund and Schapire (1996). Boosting can give good results even if the base classifiers have a performance that is only slightly better than random, and hence sometimes the base classifiers are known as weak learners. Originally designed for solving classification problems, boosting can also be extended to regression (Friedman, 2001).

The principal difference between boosting and the committee methods such as bagging discussed above, is that the base classifiers are trained in sequence, and each base classifier is trained using a weighted form of the data set in which the weighting coefficient associated with each data point depends on the performance of the previous classifiers. In particular, points that are misclassified by one of the base classifiers are given greater weight when used to train the next classifier in the sequence. Once all the classifiers have been trained, their predictions are then combined through a weighted majority voting scheme, as illustrated schematically in Figure 14.1.

Consider a two-class classification problem, in which the training data comprises input vectors x 1,..., x N along with corresponding binary target variables t 1,...,t N where t n ∈ {− 1, 1 }. Each data point is given an associated weighting parameter w n, which is initially set 1 /N for all data points. We shall suppose that we have a procedure available for training a base classifier using weighted data to give a function y (x) ∈ {− 1, 1 }. At each stage of the algorithm, AdaBoost trains a new classifier using a data set in which the weighting coefficients are adjusted according to the performance of the previously trained classifier so as to give greater weight to the misclassified data points. Finally, when the desired number of base classifiers have been trained, they are combined to form a committee using coefficients that give different weight to different base classifiers. The precise form of the AdaBoost algorithm is given below.

Figure 14.1

Schematic illustration of the boosting framework. Each base classifier y m (x) is trained on a weighted form of the training set (blue arrows) in which the weights w (m) n depend on the performance of the previous base classifier y m − 1 (x) (green arrows). Once all base classifiers have been trained, they are combined to give the final classifier Y M (x) (red arrows).

![image 325](Bishop2006_images/imageFile325.png)

$$
Y M (x) = sign (M ∑ m α m y m (x))
$$

#### AdaBoost

- 1. Initialize the data weighting coefficients { w n } by setting w (1) n = 1 /N for n = 1,...,N.
- 2. For m = 1,...,M:

(a) Fit a classifier y m (x) to the training data by minimizing the weighted error function

$$
J _ { m } =\sum _ { n = 1 } ^ { N } w _ { n } ^ { (m) } I (y _ { m } (x _ { n })\neq t _ { n }) & & (1 4. 1 5)\\
$$

/negationslash

/negationslash where I (y m (x n) = t n) is the indicator function and equals 1 when y m (x n) = t n and 0 otherwise.

/negationslash (b) Evaluate the quantities

$$
\sum _ {\epsilon _ { m } =\frac { n = 1 } { n } } w _ { n } ^ { (m) } I (y _ { m } (x _ { n })\neq t _ { n })\\\sum _ { n = 1 } ^ { N } w _ { n } ^ { (m) }\\\text {use these to evaluate}
$$

/negationslash and then use these to evaluate

$$
\text {see to evaluate}\\\alpha _ { m } =\ln\left\{\frac { 1 -\epsilon _ { m } } {\epsilon _ { m } }\right\}.
$$

(c) Update the data weighting coefficients

$$
w _ { n } ^ { (m + 1) } = w _ { n } ^ { (m) }\exp\left\{\alpha _ { m } I (y _ { m } ({ x } _ { n })\neq t _ { n })\right\}
$$

/negationslash Section 14.4

3 Make predictions using the final model, which is given by

$$
d i t i o n s\, u s i g n e l\, f o r\, y _ { M } (x) = s i g n\left (\sum _ { m = 1 } ^ { M }\alpha _ { m } y _ { m } (x)\right).\\\intertext { d i t i o n s }\intertext { s i g n e l }\intertext { f o r }\intertext { y }\intertext { M }\intertext { (x) }\intertext { = s i g n }\intertext {\left (\sum _ { m = 1 } ^ { M }\alpha _ { m } y _ { m } (x)\right) }.\quad (1 4. 1 9)\\\intertext { o f r e }\intertext { s i g n e l }\intertext { f o r }\intertext { y }\intertext { s i g n e l }\intertext { o f r e }\intertext { (x) }\intertext { = s i g n e l }\intertext {\left (1 4. 1 9\right) }
$$

We see that the first base classifier y 1 (x) is trained using weighting coefficients w (1) n that are all equal, which therefore corresponds to the usual procedure for training a single classifier. From (14.18), we see that in subsequent iterations the weighting coefficients w (m) n are increased for data points that are misclassified and decreased for data points that are correctly classified. Successive classifiers are therefore forced to place greater emphasis on points that have been misclassified by previous classifiers, and data points that continue to be misclassified by successive classifiers receive ever greater weight. The quantities m represent weighted measures of the error rates of each of the base classifiers on the data set. We therefore see that the weighting coefficients α m defined by (14.17) give greater weight to the more accurate classifiers when computing the overall output given by (14.19).

The AdaBoost algorithm is illustrated in Figure 14.2, using a subset of 30 data points taken from the toy classification data set shown in Figure A.7. Here each base learners consists of a threshold on one of the input variables. This simple classifier corresponds to a form of decision tree known as a 'decision stumps', i.e., a decision tree with a single node. Thus each base learner classifies an input according to whether one of the input features exceeds some threshold and therefore simply partitions the space into two regions separated by a linear decision surface that is parallel to one of the axes.

#### 14.3.1 Minimizing exponential error

Boosting was originally motivated using statistical learning theory, leading to upper bounds on the generalization error. However, these bounds turn out to be too loose to have practical value, and the actual performance of boosting is much better than the bounds alone would suggest. Friedman et al. (2000) gave a different and very simple interpretation of boosting in terms of the sequential minimization of an exponential error function.

Consider the exponential error function defined by

$$
E =\sum _ { n = 1 } ^ { N }\exp\left\{ - t _ { n } f _ { m } (x _ { n })\right\}\\\text {classifier defined in terms of a linear combination of base classifiers}
$$

where f m (x) is a classifier defined in terms of a linear combination of base classifiers y l (x) of the form m

$$
f _ { m } (x) =\frac { 1 } { 2 }\sum _ { l = 1 } ^ { m }\alpha _ { l } y _ { l } (x)\\\intertext { r e the training set target values. O u r g o a l $ i s t o\minimize E $ with }
$$

and t n ∈ {− 1, 1 } are the training set target values. Our goal is to minimize E with respect to both the weighting coefficients α l and the parameters of the base classifiers y l (x).

![image 326](Bishop2006_images/imageFile326.png)

Figure 14.2 Illustration of boosting in which the base learners consist of simple thresholds applied to one or other of the axes. Each figure shows the number m of base learners trained so far, along with the decision boundary of the most recent base learner (dashed black line) and the combined decision boundary of the ensemble (solid green line). Each data point is depicted by a circle whose radius indicates the weight assigned to that data point when training the most recently added base learner. Thus, for instance, we see that points that are misclassified by the m = 1 base learner are given greater weight when training the m = 2 base learner.

Instead of doing a global error function minimization, however, we shall suppose that the base classifiers y 1 (x),...,y m − 1 (x) are fixed, as are their coefficients α 1,...,α m − 1, and so we are minimizing only with respect to α m and y m (x). Separating off the contribution from base classifier y m (x), we can then write the error function in the form

$$
\text {function in the form}\\ E\ =\\sum _ { n = 1 } ^ { N }\exp\left\{ - t _ { n } f _ { m - 1 } (x _ { n }) -\frac { 1 } { 2 } t _ { n }\alpha _ { m } y _ { m } (x _ { n })\right\}\\ =\\sum _ { n = 1 } ^ { N } w _ { n } ^ { (m) }\exp\left\{ -\frac { 1 } { 2 } t _ { n }\alpha _ { m } y _ { m } (x _ { n })\right\}\\\text {here the coefficients } w _ { n } ^ { (m) }\ =\\exp\{ - t _ { n } f _ { m - 1 } (x _ { n })\}\,\text { can be viewed as constants}
$$

where the coefficients w (m) n = exp {− t n f m − 1 (x n) } can be viewed as constants because we are optimizing only α m and y m (x). If we denote by T m the set of data points that are correctly classified by y m (x), and if we denote the remaining misclassified points by M m, then we can in turn rewrite the error function in the

Exercise 14.7 form

$$
f o r\\ E\ =\ e ^ { -\alpha _ { m } / 2 }\sum _ { n\in\mathcal { T } _ { m } } w _ { n } ^ { (m) } + e ^ {\alpha _ { m } / 2 }\sum _ { n\in\mathcal { M } _ { m } } w _ { n } ^ { (m) }\\ =\ (e ^ {\alpha _ { m } / 2 } - e ^ { -\alpha _ { m } / 2 })\sum _ { n = 1 } ^ { N } w _ { n } ^ { (m) } I (y _ { m } (x _ { n })\neq t _ { n }) + e ^ { -\alpha _ { m } / 2 }\sum _ { n = 1 } ^ { N } w _ { n } ^ { (m) }.\\\\\\\quad\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
$$

/negationslash

When we minimize this with respect to y m (x), we see that the second term is constant, and so this is equivalent to minimizing (14.15) because the overall multiplicative factor in front of the summation does not affect the location of the minimum. Similarly, minimizing with respect to α m, we obtain (14.17) in which m is defined by (14.16).

From (14.22) we see that, having found α m and y m (x), the weights on the data points are updated using

$$
w _ { n } ^ { (m + 1) } = w _ { n } ^ { (m) }\exp\left\{ -\frac { 1 } { 2 } t _ { n }\alpha _ { m } y _ { m } (x _ { n })\right\}.
$$

Making use of the fact that

$$
t _ { n } y _ { m } (x _ { n }) = 1 - 2 I (y _ { m } (x _ { n })\neq t _ { n })
$$

/negationslash we see that the weights w (m) n are updated at the next iteration using

$$
w _ { n } ^ { (m + 1) } = w _ { n } ^ { (m) }\exp (-\alpha _ { m } / 2)\exp\left\{\alpha _ { m } I (y _ { m } (x _ { n })\neq t _ { n })\right\}.
$$

/negationslash

Because the term exp(− α m / 2) is independent of n, we see that it weights all data points by the same factor and so can be discarded. Thus we obtain (14.18).

Finally, once all the base classifiers are trained, new data points are classified by evaluating the sign of the combined function defined according to (14.21). Because the factor of 1 / 2 does not affect the sign it can be omitted, giving (14.19).

#### 14.3.2 Error functions for boosting

The exponential error function that is minimized by the AdaBoost algorithm differs from those considered in previous chapters. To gain some insight into the nature of the exponential error function, we first consider the expected error given by

$$
m a t i o n a r i m a t i o n, &\text { with respect to all possible functions } y (x),\\\text {by} &\quad\mathbb { E } _ { x, t }\left [\exp\{ - t y (x)\}\right] =\sum _ { t }\int\exp\{ - t y (x)\} p (t | x) p (x)\, d x.\\\intertext { i f w e p e r f o m a t i o n a r i m a t i o n with r e s t a p l i s b e f t a l l $ p o w s $ }
$$

If we perform a variational minimization with respect to all possible functions y (x), we obtain 1 (= 1 x)

$$
y (x) =\frac { 1 } { 2 }\ln\left\{\frac { p (t = 1 | x) } { p (t = - 1 | x) }\right\}
$$

Figure 14.3 Plot of the exponential (green) and rescaled cross-entropy (red) error functions along with the hinge error (blue) used in support vector machines, and the misclassification error (black). Note that for large negative values of z = ty (x), the cross-entropy gives a linearly increasing penalty, whereas the exponential loss gives an exponentially increasing penalty.

![image 327](Bishop2006_images/imageFile327.png)

which is half the log-odds. Thus the AdaBoost algorithm is seeking the best approximation to the log odds ratio, within the space of functions represented by the linear combination of base classifiers, subject to the constrained minimization resulting from the sequential optimization strategy. This result motivates the use of the sign function in (14.19) to arrive at the final classification decision.

We have already seen that the minimizer y (x) of the cross-entropy error (4.90) for two-class classification is given by the posterior class probability. In the case of a target variable t ∈ {− 1, 1 }, we have seen that the error function is given by ln(1 + exp(− yt)). This is compared with the exponential error function in Figure 14.3, where we have divided the cross-entropy error by a constant factor ln(2) so that it passes through the point (0, 1) for ease of comparison. We see that both can be seen as continuous approximations to the ideal misclassification error function. An advantage of the exponential error is that its sequential minimization leads to the simple AdaBoost scheme. One drawback, however, is that it penalizes large negative values of ty (x) much more strongly than cross-entropy. In particular, we see that for large negative values of ty, the cross-entropy grows linearly with | ty |, whereas the exponential error function grows exponentially with | ty |. Thus the exponential error function will be much less robust to outliers or misclassified data points. Another important difference between cross-entropy and the exponential error function is that the latter cannot be interpreted as the log likelihood function of any well-defined probabilistic model. Furthermore, the exponential error does not generalize to classification problems having K > 2 classes, again in contrast to the cross-entropy for a probabilistic model, which is easily generalized to give (4.108).

The interpretation of boosting as the sequential optimization of an additive model under an exponential error (Friedman et al., 2000) opens the door to a wide range of boosting-like algorithms, including multiclass extensions, by altering the choice of error function. It also motivates the extension to regression problems (Friedman, 2001). If we consider a sum-of-squares error function for regression, then sequential minimization of an additive model of the form (14.21) simply involves fitting each new base classifier to the residual errors t n − f m − 1 (x n) from the previous model. As we have noted, however, the sum-of-squares error is not robust to outliers, and this

Comparison of the squared error (green) with the absolute error (red) showing how the latter places much less emphasis on large errors and hence is more robust to outliers and mislabelled data points.

![image 328](Bishop2006_images/imageFile328.png)

can be addressed by basing the boosting algorithm on the absolute deviation | y − t | instead. These two error functions are compared in Figure 14.4.

### 14.4 Tree-based Models

There are various simple, but widely used, models that work by partitioning the input space into cuboid regions, whose edges are aligned with the axes, and then assigning a simple model (for example, a constant) to each region. They can be viewed as a model combination method in which only one model is responsible for making predictions at any given point in input space. The process of selecting a specific model, given a new input x, can be described by a sequential decision making process corresponding to the traversal of a binary tree (one that splits into two branches at each node). Here we focus on a particular tree-based framework called classification and regression trees, or CART (Breiman et al., 1984), although there are many other variants going by such names as ID3 and C4.5 (Quinlan, 1986; Quinlan, 1993).

Figure 14.5 shows an illustration of a recursive binary partitioning of the input space, along with the corresponding tree structure. In this example, the first step divides the whole of the input space into two regions according to whether x 1 /lessorequalslant θ 1 or x 1 > θ 1 where θ 1 is a parameter of the model. This creates two subregions, each of which can then be subdivided independently. For instance, the region x 1 /lessorequalslant θ 1 is further subdivided according to whether x 2 /lessorequalslant θ 2 or x 2 > θ 2, giving rise to the regions denoted A and B. The recursive subdivision can be described by the traversal of the binary tree shown in Figure 14.6. For any new input x, we determine which region it falls into by starting at the top of the tree at the root node and following a path down to a specific leaf node according to the decision criteria at each node. Note that such decision trees are not probabilistic graphical models.

Figure 14.5 Illustration of a two-dimensional input space that has been partitioned into five regions using axis-aligned boundaries.

![image 329](Bishop2006_images/imageFile329.png)

Figure 14.6 Binary tree corresponding to the partitioning of input space shown in Figure 14.5.

![image 330](Bishop2006_images/imageFile330.png)

Within each region, there is a separate model to predict the target variable. For instance, in regression we might simply predict a constant over each region, or in classification we might assign each region to a specific class. A key property of treebased models, which makes them popular in fields such as medical diagnosis, for example, is that they are readily interpretable by humans because they correspond to a sequence of binary decisions applied to the individual input variables. For instance, to predict a patient's disease, we might first ask "is their temperature greater than some threshold?". If the answer is yes, then we might next ask "is their blood pressure less than some threshold?". Each leaf of the tree is then associated with a specific diagnosis.

In order to learn such a model from a training set, we have to determine the structure of the tree, including which input variable is chosen at each node to form the split criterion as well as the value of the threshold parameter θ i for the split. We also have to determine the values of the predictive variable within each region.

Consider first a regression problem in which the goal is to predict a single target variable t from a D -dimensional vector x = (x 1,...,x D) T of input variables. The training data consists of input vectors { x 1,..., x N } along with the corresponding continuous labels { t 1,...,t N }. If the partitioning of the input space is given, and we minimize the sum-of-squares error function, then the optimal value of the predictive variable within any given region is just given by the average of the values of t n for those data points that fall in that region.

Now consider how to determine the structure of the decision tree. Even for a fixed number of nodes in the tree, the problem of determining the optimal structure (including choice of input variable for each split as well as the corresponding thresh- olds) to minimize the sum-of-squares error is usually computationally infeasible due to the combinatorially large number of possible solutions. Instead, a greedy optimization is generally done by starting with a single root node, corresponding to the whole input space, and then growing the tree by adding nodes one at a time. At each step there will be some number of candidate regions in input space that can be split, corresponding to the addition of a pair of leaf nodes to the existing tree. For each of these, there is a choice of which of the D input variables to split, as well as the value of the threshold. The joint optimization of the choice of region to split, and the choice of input variable and threshold, can be done efficiently by exhaustive search noting that, for a given choice of split variable and threshold, the optimal choice of predictive variable is given by the local average of the data, as noted earlier. This is repeated for all possible choices of variable to be split, and the one that gives the smallest residual sum-of-squares error is retained.

Given a greedy strategy for growing the tree, there remains the issue of when to stop adding nodes. A simple approach would be to stop when the reduction in residual error falls below some threshold. However, it is found empirically that often none of the available splits produces a significant reduction in error, and yet after several more splits a substantial error reduction is found. For this reason, it is common practice to grow a large tree, using a stopping criterion based on the number of data points associated with the leaf nodes, and then prune back the resulting tree. The pruning is based on a criterion that balances residual error against a measure of model complexity. If we denote the starting tree for pruning by T 0, then we define T ⊂ T 0 to be a subtree of T 0 if it can be obtained by pruning nodes from T 0 (in other words, by collapsing internal nodes by combining the corresponding regions). Suppose the leaf nodes are indexed by τ = 1,..., | T |, with leaf node τ representing a region R τ of input space having N τ data points, and | T | denoting the total number of leaf nodes. The optimal prediction for region R τ is then given by 1

$$
y _ {\tau } =\frac { 1 } { N _ {\tau } }\sum _ { x _ { n }\in\mathcal { R } _ {\tau } } t _ { n }\\\intertext { t h i n t i o n }\intertext { c o n t r i b u t i o n }
$$

and the corresponding contribution to the residual sum-of-squares is then

$$
Q _ {\tau } (T) =\sum _ { x _ { n }\in\mathcal { R } _ {\tau } }\{ t _ { n } - y _ {\tau }\} ^ { 2 }\,.
$$

The pruning criterion is then given by

$$
C (T) =\sum _ {\tau = 1 } ^ { | T | } Q _ {\tau } (T) +\lambda | T | & & (1 4. 3 1)\\\intertext { a n $\text {parameter }\lambda $ }\intertext { a n $\text {parameter }\} $ d e r m i n e s $ the trade-off between the overall residual }
$$

The regularization parameter λ determines the trade-off between the overall residual sum-of-squares error and the complexity of the model as measured by the number | T | of leaf nodes, and its value is chosen by cross-validation. For classification problems, the process of growing and pruning the tree is sim-

For classification problems, the process of growing and pruning the tree is similar, except that the sum-of-squares error is replaced by a more appropriate measure Exercise 14.11 of performance. If we define p τk to be the proportion of data points in region R τ assigned to class k, where k = 1,...,K, then two commonly used choices are the cross-entropy

$$
Q _ {\tau } (T) =\sum _ { k = 1 } ^ { K } p _ {\tau k }\ln p _ {\tau k }
$$

and the Gini index

$$
Q _ {\tau } (T) =\sum _ { k = 1 } ^ { K } p _ {\tau k }\left (1 - p _ {\tau k }\right).\\\intertext { h o r p _ {\tau k } = 0 and p _ {\tau k } = 1 and have a maximum at p _ {\tau k } = 0. 5. T h e y }
$$

These both vanish for p τk = 0 and p τk = 1 and have a maximum at p τk = 0. 5. They encourage the formation of regions in which a high proportion of the data points are assigned to one class. The cross entropy and the Gini index are better measures than the misclassification rate for growing the tree because they are more sensitive to the node probabilities. Also, unlike misclassification rate, they are differentiable and hence better suited to gradient based optimization methods. For subsequent pruning of the tree, the misclassification rate is generally used.

The human interpretability of a tree model such as CART is often seen as its major strength. However, in practice it is found that the particular tree structure that is learned is very sensitive to the details of the data set, so that a small change to the training data can result in a very different set of splits (Hastie et al., 2001).

There are other problems with tree-based methods of the kind considered in this section. One is that the splits are aligned with the axes of the feature space, which may be very suboptimal. For instance, to separate two classes whose optimal decision boundary runs at 45 degrees to the axes would need a large number of axis-parallel splits of the input space as compared to a single non-axis-aligned split. Furthermore, the splits in a decision tree are hard, so that each region of input space is associated with one, and only one, leaf node model. The last issue is particularly problematic in regression where we are typically aiming to model smooth functions, and yet the tree model produces piecewise-constant predictions with discontinuities at the split boundaries.

### 14.5 Conditional Mixture Models

We have seen that standard decision trees are restricted by hard, axis-aligned splits of the input space. These constraints can be relaxed, at the expense of interpretability, by allowing soft, probabilistic splits that can be functions of all of the input variables, not just one of them at a time. If we also give the leaf models a probabilistic interpretation, we arrive at a fully probabilistic tree-based model called the hierarchical mixture of experts, which we consider in Section 14.5.3.

An alternative way to motivate the hierarchical mixture of experts model is to start with a standard probabilistic mixtures of unconditional density models such as Gaussians and replace the component densities with conditional distributions. Here we consider mixtures of linear regression models (Section 14.5.1) and mixtures of

Exercise 14.13 logistic regression models (Section 14.5.2). In the simplest case, the mixing coefficients are independent of the input variables. If we make a further generalization to allow the mixing coefficients also to depend on the inputs then we obtain a mixture of experts model. Finally, if we allow each component in the mixture model to be itself a mixture of experts model, then we obtain a hierarchical mixture of experts.

#### 14.5.1 Mixtures of linear regression models

One of the many advantages of giving a probabilistic interpretation to the linear regression model is that it can then be used as a component in more complex probabilistic models. This can be done, for instance, by viewing the conditional distribution representing the linear regression model as a node in a directed probabilistic graph. Here we consider a simple example corresponding to a mixture of linear regression models, which represents a straightforward extension of the Gaussian mixture model discussed in Section 9.2 to the case of conditional Gaussian distributions.

We therefore consider K linear regression models, each governed by its own weight parameter w k. In many applications, it will be appropriate to use a common noise variance, governed by a precision parameter β, for all K components, and this is the case we consider here. We will once again restrict attention to a single target variable t, though the extension to multiple outputs is straightforward. If we denote the mixing coefficients by π k, then the mixture distribution can be written

$$
p (t |\theta) =\sum _ { k = 1 } ^ { K }\pi _ { k }\mathcal { N } (t | w _ { k } ^ {\top }\phi,\beta ^ { - 1 })\\\intertext { s t e s t o f a l l a d a p t i v e parameters in the model, n a m e l y W =\{ w _ { k }\}, }
$$

where θ denotes the set of all adaptive parameters in the model, namely W = { w k }, π = { π k }, and β. The log likelihood function for this model, given a data set of observations { φ n,t n }, then takes the form N K

$$
\text {vations}\left\{\phi _ { n }, t _ { n }\right\},\text { then takes the form}\\\ln p (\mathfrak { t } |\theta) =\sum _ { n = 1 } ^ { N }\ln\left (\sum _ { k = 1 } ^ { K }\pi _ { k }\mathcal { N } (t _ { n } | w _ { k } ^ { T }\phi _ { n },\beta ^ { - 1 })\right)\\\mathfrak { t } = (t _ { 1 },\dots, t _ { N }) ^ { T }\detnotes the vector of target variables.
$$

where t = (t 1,..., t N) T denotes the vector of target variables.

again appeal to the EM algorithm, which will turn out to be a simple extension of the EM algorithm for unconditional Gaussian mixtures of Section 9.2. We can therefore build on our experience with the unconditional mixture and introduce a set Z = { z n } of binary latent variables where z nk ∈ { 0, 1 } in which, for each data point n, all of the elements k = 1,...,K are zero except for a single value of 1 indicating which component of the mixture was responsible for generating that data point. The joint distribution over latent and observed variables can be represented by the graphical model shown in Figure 14.7.

The complete-data log likelihood function then takes the form

$$
\ln p (t, Z |\theta) =\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K } z _ { n k }\ln\left\{\pi _ { k }\mathcal { N } (t _ { n } | w _ { k } ^ {\top }\phi _ { n },\beta ^ { - 1 })\right\}.
$$

Figure 14.7 Probabilistic directed graph representing a mixture of linear regression models, defined by (14.35).

![image 331](Bishop2006_images/imageFile331.png)

$$
by & &\gamma _ { n k } =\mathbb { E } [z _ { n k }] = p (k |\phi _ { n },\theta ^ {\text {old} }) =\frac {\pi _ { k }\mathcal { N } (t _ { n } | w _ { k } ^ {\top }\phi _ { n },\beta ^ { - 1 }) } {\sum _ { j }\pi _ { j }\mathcal { N } (t _ { n } | w _ { j } ^ {\top }\phi _ { n },\beta ^ { - 1 }) }.\\ &\text {The responsibilities are then used to determine the expectation, with respect to the }\\ &\text {posterior distribution } p (Z | t,\theta ^ {\text {old} }),\text { of the complete-data log likelihood, which takes }
$$

The responsibilities are then used to determine the expectation, with respect to the posterior distribution p (Z | t, θ old), of the complete-data log likelihood, which takes the form

$$
Q (\theta,\theta ^ {\text {old} }) =\mathbb { E } _ { Z }\left [\ln p (\mathbf t, Z |\theta)\right] =\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K }\gamma _ { n k }\left\{\ln\pi _ { k } +\ln\mathcal { N } (\mathbf t _ { n } |\mathbf w _ { k } ^ {\text {f} }\phi _ { n },\beta ^ { - 1 })\right\}.\\\\\text {In the } M\text { at }\mathbf w\text { maximize the function } Q (\theta,\theta ^ {\text {old} })\text { with respect to }\theta\text {, }\text {looping the }\mathbf h\text { }
$$

In the M step, we maximize the function Q (θ, θ old) with respect to θ, keeping the γ nk fixed. For the optimization with respect to the mixing coefficients π k we need to take account of the constraint k π k = 1, which can be done with the aid of a Lagrange multiplier, leading to an M-step re-estimation equation for π k in the form

$$
\pi _ { k } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\gamma _ { n k }.\\\text {ly}\,\text {the same form as the corresponding result for a simple}
$$

Note that this has exactly the same form as the corresponding result for a simple mixture of unconditional Gaussians given by (9.22).

Next consider the maximization with respect to the parameter vector w k of the k th linear regression model. Substituting for the Gaussian distribution, we see that the function Q (θ, θ old), as a function of the parameter vector w k, takes the form

$$
Q (\theta,\theta ^ { o l d }) =\sum _ { n = 1 } ^ { N }\gamma _ { n k }\left\{ -\frac {\beta } { 2 }\left (t _ { n } - w _ { k } ^ { T }\phi _ { n }\right) ^ { 2 }\right\} +\text {const}\\\intertext { w h e r e the constant term includes the contributions from other weight vectors w i f }
$$

where the constant term includes the contributions from other weight vectors w j for j = k. Note that the quantity we are maximizing is similar to the (negative of the) standard sum-of-squares error (3.12) for a single linear regression model, but with the inclusion of the responsibilities γ nk. This represents a weighted least squares

/negationslash problem, in which the term corresponding to the n th data point carries a weighting coefficient given by βγ nk, which could be interpreted as an effective precision for each data point. We see that each component linear regression model in the mixture, governed by its own parameter vector w k, is fitted separately to the whole data set in the M step, but with each data point n weighted by the responsibility γ nk that model k takes for that data point. Setting the derivative of (14.39) with respect to w k equal to zero gives

$$
0 =\sum _ { n = 1 } ^ { N }\gamma _ { n k }\left (t _ { n } - w _ { k } ^ { T }\phi _ { n }\right)\phi _ { n } & & (1 4. 4 0)\\\intertext { i n }\text {matrix notation as } &
$$

which we can write in matrix notation as

$$
0 =\Phi ^ { T } R _ { k } (t -\Phi w _ { k }) & & (1 4. 4 1)\\)\colon &\cdot & 1\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot\cdot
$$

where R k = diag(γ nk) is a diagonal matrix of size N × N. Solving for w k, we obtain T − 1 T

$$
w _ { k } = (\Phi ^ { T } R _ { k }\Phi) ^ { - 1 }\,\Phi ^ { T } R _ { k } t.\quad & (1 4. 4 2)\\\intertext { s u t o f mod i f i n d e r $ n $ o r $ t $ e q u a l $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u $ t $ e q u
$$

This represents a set of modified normal equations corresponding to the weighted least squares problem, of the same form as (4.99) found in the context of logistic regression. Note that after each E step, the matrix R k will change and so we will have to solve the normal equations afresh in the subsequent M step. old

Finally, we maximize Q (θ, θ) with respect to β. Keeping only terms that depend on β, the function Q (θ, θ old) can be written

$$
\det\rho\left (\beta,\text {the}\lambda\right)\subset &\text {if}\left (0,\text {i}\right)\text {can be with respect}\\ Q (\theta,\theta ^ {\text {old} }) = &\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K }\gamma _ { n k }\left\{\frac { 1 } { 2 }\ln\beta -\frac {\beta } { 2 }\left (t _ { n } - w _ { k } ^ {\text {T} }\phi _ { n }\right) ^ { 2 }\right\}.\\\intertext { S t i ting the derivative with respect to } &\text {to }\beta\equiv\text {equal to zero, and rearranging, we obtain the}
$$

Setting the derivative with respect to β equal to zero, and rearranging, we obtain the M-step equation for β in the form

$$
\frac { 1 } {\beta } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K }\gamma _ { n k }\left (t _ { n } - w _ { k } ^ { T }\phi _ { n }\right) ^ { 2 }.\\\intertext { r e } 1 4. 8,\, w e i l u s t r a t e\, t h i s\, E M\, a l g o r i t h m\, u s i m p l e\, e x p l e\, o f
$$

In Figure 14.8, we illustrate this EM algorithm using the simple example of fitting a mixture of two straight lines to a data set having one input variable x and one target variable t. The predictive density (14.34) is plotted in Figure 14.9 using the converged parameter values obtained from the EM algorithm, corresponding to the right-hand plot in Figure 14.8. Also shown in this figure is the result of fitting a single linear regression model, which gives a unimodal predictive density. We see that the mixture model gives a much better representation of the data distribution, and this is reflected in the higher likelihood value. However, the mixture model also assigns significant probability mass to regions where there is no data because its predictive distribution is bimodal for all values of x. This problem can be resolved by extending the model to allow the mixture coefficients themselves to be functions of x, leading to models such as the mixture density networks discussed in Section 5.6, and hierarchical mixture of experts discussed in Section 14.5.3.

![image 332](Bishop2006_images/imageFile332.png)

Figure 14.8 Example of a synthetic data set, shown by the green points, having one input variable x and one target variable t, together with a mixture of two linear regression models whose mean functions y (x, w k), where k ∈ { 1, 2 }, are shown by the blue and red lines. The upper three plots show the initial configuration (left), the result of running 30 iterations of EM (centre), and the result after 50 iterations of EM (right). Here β was initialized to the reciprocal of the true variance of the set of target values. The lower three plots show the corresponding responsibilities plotted as a vertical line for each data point in which the length of the blue segment gives the posterior probability of the blue line for that data point (and similarly for the red segment).

#### 14.5.2 Mixtures of logistic models

Because the logistic regression model defines a conditional distribution for the target variable, given the input vector, it is straightforward to use it as the component distribution in a mixture model, thereby giving rise to a richer family of conditional distributions compared to a single logistic regression model. This example involves a straightforward combination of ideas encountered in earlier sections of the book and will help consolidate these for the reader.

The conditional distribution of the target variable, for a probabilistic mixture of K logistic regression models, is given by

$$
p (t |\phi,\theta) =\sum _ { k = 1 } ^ { K }\pi _ { k } y _ { k } ^ { t }\left [1 - y _ { k }\right] ^ { 1 - t } & & (1 4. 4 5)\\
$$

where φ is the feature vector, y k = σ w T k φ is the output of component k, and θ denotes the adjustable parameters namely { π k } and { w k }. Now suppose we are given a data set { φ n,t n }. The corresponding likelihood

Now suppose we are given a data set { φ n, t n }. The corresponding likelihood

![image 48](Bishop2006_images/imageFile48.png)

Figure 14.9 The left plot shows the predictive conditional density corresponding to the converged solution in Figure 14.8. This gives a log likelihood value of − 3. 0. A vertical slice through one of these plots at a particular value of x represents the corresponding conditional distribution p (t | x), which we see is bimodal. The plot on the right shows the predictive density for a single linear regression model fitted to the same data set using maximum likelihood. This model has a smaller log likelihood of − 27. 6.

function is then given by

$$
\text {is then given by}\\ p (t |\theta) =\prod _ { n = 1 } ^ { N }\left (\sum _ { k = 1 } ^ { K }\pi _ { k } y _ { n k } ^ { t _ { n } }\left [1 - y _ { n k }\right] ^ { 1 - t _ { n } }\right)\\ k =\sigma (w _ { k } ^ { T }\phi _ { n })\text { and } t = (t _ { 1 },\dots, t _ { N }) ^ { T }\cdot\ W e\text { can maximize this likelihood}
$$

where y nk = σ (w T k φ n) and t = (t 1,...,t N) T. We can maximize this likelihood function iteratively by making use of the EM algorithm. This involves introducing latent variables z nk that correspond to a 1-ofK coded binary indicator variable for each data point n. The complete-data likelihood function is then given by

$$
p (t, Z |\theta) =\prod _ { n = 1 } ^ { N }\prod _ { k = 1 } ^ { K }\left\{\pi _ { k } y _ { n k } ^ { t _ { n } }\left [1 - y _ { n k }\right] ^ { 1 - t _ { n } }\right\} ^ { z _ { n k } }\\ Z\text { is the matrix of latent variables with elements } z _ { n k }.\text { We initialize the EM }
$$

where Z is the matrix of latent variables with elements z nk. We initialize the EM algorithm by choosing an initial value θ old for the model parameters. In the E step, we then use these parameter values to evaluate the posterior probabilities of the components k for each data point n, which are given by

$$
\text { }\gamma _ { n k } =\mathbb { E } [z _ { n k }] = p (k |\phi _ { n },\theta ^ {\text {old} }) =\frac {\pi _ { k } y _ { n k } ^ { t _ { n } }\left [1 - y _ { n k }\right] ^ { 1 - t _ { n } } } {\sum _ { j }\pi _ { j } y _ { n j } ^ { t _ { n } }\left [1 - y _ { n j }\right] ^ { 1 - t _ { n } } }.\\\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }\text { }
$$

These responsibilities are then used to find the expected complete-data log likelihood as a function of θ, given by

$$
Q (\theta,\theta ^ { o l d }) & =\mathbb { E } _ { Z }\left [\ln p (\mathbf t, Z |\theta)\right]\\ & =\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K }\gamma _ { n k }\left\{\ln\pi _ { k } + t _ { n }\ln y _ { n k } + (1 - t _ { n })\ln (1 - y _ { n k })\right\}.
$$

