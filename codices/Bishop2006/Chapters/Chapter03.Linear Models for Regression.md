## 3. Linear Models for Regression

The focus so far in this book has been on unsupervised learning, including topics such as density estimation and data clustering. We turn now to a discussion of supervised learning, starting with regression. The goal of regression is to predict the value of one or more continuous target variables t given the value of a D -dimensional vector x of input variables. We have already encountered an example of a regression problem when we considered polynomial curve fitting in Chapter 1. The polynomial is a specific example of a broad class of functions called linear regression models, which share the property of being linear functions of the adjustable parameters, and which will form the focus of this chapter. The simplest form of linear regression models are also linear functions of the input variables. However, we can obtain a much more useful class of functions by taking linear combinations of a fixed set of nonlinear functions of the input variables, known as basis functions. Such models are linear functions of the parameters, which gives them simple analytical properties, and yet can be nonlinear with respect to the input variables.

Given a training data set comprising N observations { x n }, where n = 1,...,N, together with corresponding target values { t n }, the goal is to predict the value of t for a new value of x. In the simplest approach, this can be done by directly constructing an appropriate function y (x) whose values for new inputs x constitute the predictions for the corresponding values of t. More generally, from a probabilistic perspective, we aim to model the predictive distribution p (t | x) because this expresses our uncertainty about the value of t for each value of x. From this conditional distribution we can make predictions of t, for any new value of x, in such a way as to minimize the expected value of a suitably chosen loss function. As discussed in Section 1.5.5, a common choice of loss function for real-valued variables is the squared loss, for which the optimal solution is given by the conditional expectation of t.

Although linear models have significant limitations as practical techniques for pattern recognition, particularly for problems involving input spaces of high dimensionality, they have nice analytical properties and form the foundation for more sophisticated models to be discussed in later chapters.

### 3.1 Linear Basis Function Models

The simplest linear model for regression is one that involves a linear combination of the input variables

$$
y (x, w) = w _ { 0 } + w _ { 1 } x _ { 1 } +\dots + w _ { D } x _ { D }
$$

where x = (x 1,...,x D) T. This is often simply known as linear regression. The key property of this model is that it is a linear function of the parameters w 0,...,w D. It is also, however, a linear function of the input variables x i, and this imposes significant limitations on the model. We therefore extend the class of models by considering linear combinations of fixed nonlinear functions of the input variables, of the form

$$
y (x, w) = w _ { 0 } +\sum _ { j = 1 } ^ { M - 1 } w _ { j }\phi _ { j } (x)\\
$$

where φ j (x) are known as basis functions. By denoting the maximum value of the index j by M − 1, the total number of parameters in this model will be M. The parameter w 0 allows for any fixed offset in the data and is sometimes called a bias parameter (not to be confused with 'bias' in a statistical sense). It is often convenient to define an additional dummy 'basis function' φ 0 (x) = 1 so that

$$
y (x, w) =\sum _ { j = 0 } ^ { M - 1 } w _ { j }\phi _ { j } (x) = w ^ { T }\phi (x)\\
$$

where w = (w 0,..., w M -1) T and φ = (φ 0,..., φ M -1) T. In many practical applications of pattern recognition, we will apply some form of fixed pre-processing, or feature extraction, to the original data variables. If the original variables comprise the vector x, then the features can be expressed in terms of the basis functions { φ j (x) }.

{ j } By using nonlinear basis functions, we allow the function y (x, w) to be a nonlinear function of the input vector x. Functions of the form (3.2) are called linear models, however, because this function is linear in w. It is this linearity in the parameters that will greatly simplify the analysis of this class of models. However, it also leads to some significant limitations, as we discuss in Section 3.6.

The example of polynomial regression considered in Chapter 1 is a particular example of this model in which there is a single input variable x, and the basis functions take the form of powers of x so that φ j (x) = x j. One limitation of polynomial basis functions is that they are global functions of the input variable, so that changes in one region of input space affect all other regions. This can be resolved by dividing the input space up into regions and fit a different polynomial in each region, leading to spline functions (Hastie et al., 2001).

There are many other possible choices for the basis functions, for example

$$
\phi _ { j } (x) =\exp\left\{ -\frac { (x -\mu _ { j }) ^ { 2 } } { 2 s ^ { 2 } }\right\}\\
$$

where the µ j govern the locations of the basis functions in input space, and the parameter s governs their spatial scale. These are usually referred to as 'Gaussian' basis functions, although it should be noted that they are not required to have a probabilistic interpretation, and in particular the normalization coefficient is unimportant because these basis functions will be multiplied by adaptive parameters w j. Another possibility is the sigmoidal basis function of the form

Another possibility is the sigmoidal basis function of the form

$$
\phi _ { j } (x) =\sigma\left (\frac { x -\mu _ { j } } { s }\right)\\\text {stochastic function defined by}
$$

where σ (a) is the logistic sigmoid function defined by

$$
\sigma (a) =\frac { 1 } { 1 +\exp (- a) }.\\
$$

Equivalently, we can use the ' tanh ' function because this is related to the logistic sigmoid by tanh(a) = 2 σ (a) − 1, and so a general linear combination of logistic sigmoid functions is equivalent to a general linear combination of ' tanh ' functions. These various choices of basis function are illustrated in Figure 3.1.

Yet another possible choice of basis function is the Fourier basis, which leads to an expansion in sinusoidal functions. Each basis function represents a specific frequency and has infinite spatial extent. By contrast, basis functions that are localized to finite regions of input space necessarily comprise a spectrum of different spatial frequencies. In many signal processing applications, it is of interest to consider basis functions that are localized in both space and frequency, leading to a class of functions known as wavelets. These are also defined to be mutually orthogonal, to simplify their application. Wavelets are most applicable when the input values live

![image 73](Bishop2006_images/imageFile73.png)

Figure 3.1 Examples of basis functions, showing polynomials on the left, Gaussians of the form (3.4) in the centre, and sigmoidal of the form (3.5) on the right.

Most of the discussion in this chapter, however, is independent of the particular choice of basis function set, and so for most of our discussion we shall not specify the particular form of the basis functions, except for the purposes of numerical illustration. Indeed, much of our discussion will be equally applicable to the situation in which the vector φ (x) of basis functions is simply the identity φ (x) = x. Furthermore, in order to keep the notation simple, we shall focus on the case of a single target variable t. However, in Section 3.1.5, we consider briefly the modifications needed to deal with multiple target variables.

#### 3.1.1 Maximum likelihood and least squares

In Chapter 1, we fitted polynomial functions to data sets by minimizing a sumof-squares error function. We also showed that this error function could be motivated as the maximum likelihood solution under an assumed Gaussian noise model. Let us return to this discussion and consider the least squares approach, and its relation to maximum likelihood, in more detail.

As before, we assume that the target variable t is given by a deterministic function y (x, w) with additive Gaussian noise so that

$$
t = y (x, w) +\epsilon
$$

where is a zero mean Gaussian random variable with precision (inverse variance) β. Thus we can write

$$
p (t | x, w,\beta) =\mathcal { N } (t | y (x, w),\beta ^ { - 1 }).
$$

Recall that, if we assume a squared loss function, then the optimal prediction, for a new value of x, will be given by the conditional mean of the target variable. In the case of a Gaussian conditional distribution of the form (3.8), the conditional mean will be simply

$$
\mathbb { E } [t | x] =\int t p (t | x)\, d t = y (x, w).\\\text {Gaussian noise assumption implies that the conditional distribution of}
$$

Note that the Gaussian noise assumption implies that the conditional distribution of t given x is unimodal, which may be inappropriate for some applications. An extension to mixtures of conditional Gaussian distributions, which permit multimodal conditional distributions, will be discussed in Section 14.5.1.

Now consider a data set of inputs X = { x 1,..., x N } with corresponding target values t 1,...,t N. We group the target variables { t n } into a column vector that we denote by t where the typeface is chosen to distinguish it from a single observation of a multivariate target, which would be denoted t. Making the assumption that these data points are drawn independently from the distribution (3.8), we obtain the following expression for the likelihood function, which is a function of the adjustable parameters w and β, in the form

$$
p (t | X, w,\beta) =\prod _ { n = 1 } ^ { N }\mathcal { N } (t _ { n } | w ^ { T }\phi (x _ { n }),\beta ^ { - 1 })\\\text {have used } (3\,)\text { Note that in supervised learning problems such as regulars}
$$

where we have used (3.3). Note that in supervised learning problems such as regression (and classification), we are not seeking to model the distribution of the input variables. Thus x will always appear in the set of conditioning variables, and so from now on we will drop the explicit x from expressions such as p (t | x, w,β) in order to keep the notation uncluttered. Taking the logarithm of the likelihood function, and making use of the standard form (1.46) for the univariate Gaussian, we have

$$
\ln p (t | w,\beta)\ & =\\sum _ { n = 1 } ^ { N }\ln\mathcal { N } (t _ { n } | w ^ { T }\phi (x _ { n }),\beta ^ { - 1 })\\ & =\\frac { N } { 2 }\ln\beta -\frac { N } { 2 }\ln (2\pi) -\beta E _ { D } (w)\\\intertext { r o w s }\intertext { o r w s }\intertext { a r e f u n g r o w s }\intertext { i n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { e x t i o n s }\intertext { r e f u n g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u n t a r g r o w s }\intertext { s u
$$

where the sum-of-squares error function is defined by

$$
E _ { D } (w) =\frac { 1 } { 2 }\sum _ { n = 1 } ^ { N }\{ t _ { n } - w ^ {\top }\phi (x _ { n })\} ^ { 2 }.\\\intertext { w i t t e n d w h o l i b h o d f u n c t i o n w e c a n u s e a m u i m u l i h i o d t o }
$$

Having written down the likelihood function, we can use maximum likelihood to determine w and β. Consider first the maximization with respect to w. As observed already in Section 1.2.5, we see that maximization of the likelihood function under a conditional Gaussian noise distribution for a linear model is equivalent to minimizing a sum-of-squares error function given by E D (w). The gradient of the log likelihood function (3.11) takes the form

$$
\nabla\ln p (\mathbf t | w,\beta) =\sum _ { n = 1 } ^ { N }\left\{ t _ { n } - w ^ { T }\phi (x _ { n })\right\}\phi (x _ { n }) ^ { T }.
$$

Setting this gradient to zero gives

$$
0 =\sum _ { n = 1 } ^ { N } t _ { n }\phi (x _ { n }) ^ { T } - w ^ { T }\left (\sum _ { n = 1 } ^ { N }\phi (x _ { n })\phi (x _ { n }) ^ { T }\right).\\\intertext { }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text { } }\text {
$$

Solving for w we obtain

Solving for w we obtain w ML = Φ T Φ − 1 Φ T t (3.15) which are known as the normal equations for the least squares problem. Here Φ is an N × M matrix, called the design matrix, whose elements are given by Φ nj = φ j (x n), so that φ (x) φ (x) φ (x)

$$
\Phi =\left (\begin{array} { c c c c }\phi _ { 0 } (x _ { 1 }) &\phi _ { 1 } (x _ { 1 }) &\cdots &\phi _ { M - 1 } (x _ { 1 })\\\phi _ { 0 } (x _ { 2 }) &\phi _ { 1 } (x _ { 2 }) &\cdots &\phi _ { M - 1 } (x _ { 2 })\\\vdots &\vdots &\ddots &\vdots\\\phi _ { 0 } (x _ { N }) &\phi _ { 1 } (x _ { N }) &\cdots &\phi _ { M - 1 } (x _ { N })\end{array}\right),\\\phi _ { 0 } ^ {\dagger } = (\Phi ^ { T }\Phi) ^ { - 1 }\Phi ^ { T }
$$

The quantity

$$
\Phi ^ {\dagger }\equiv (\Phi ^ { T }\Phi) ^ { - 1 }\,\Phi ^ { T }\\\text {re-Penrose pseudo-inverse of the matrix }\Phi\left (R a o\,\text { and }\text {Mita},\\\text {Loan, 1996}.\text { It can be regarded as a generalization of the }
$$

is known as the Moore-Penrose pseudo-inverse of the matrix Φ (Rao and Mitra, 1971; Golub and Van Loan, 1996). It can be regarded as a generalization of the notion of matrix inverse to nonsquare matrices. Indeed, if Φ is square and invertible, then using the property (AB) − 1 = B − 1 A − 1 we see that Φ † ≡ Φ − 1. At this point, we can gain some insight into the role of the bias parameter w 0. If

At this point, we can gain some insight into the role of the bias parameter w 0. If we make the bias parameter explicit, then the error function (3.12) becomes

$$
E _ { D } (w) =\frac { 1 } { 2 }\sum _ { n = 1 } ^ { N }\{ t _ { n } - w _ { 0 } -\sum _ { j = 1 } ^ { M - 1 } w _ { j }\phi _ { j } (x _ { n })\} ^ { 2 }.\\\intertext { t h e d r i v i a t i v e w i s p e c t h o w e a l $ t o z e r o, $ a n d $ s o l y $ i n v e o b t a i n }
$$

Setting the derivative with respect to w 0 equal to zero, and solving for w 0, we obtain where we have defined

$$
w _ { 0 } =\bar { t } -\sum _ { j = 1 } ^ { M - 1 } w _ { j }\overline {\phi _ { j } }
$$

$$
\bar { t } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N } t _ { n },\quad\overline {\phi _ { j } } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\phi _ { j } (x _ { n }).\\\intertext { h e\, b i a s\, w _ { 0 }\, c o p pens a s t a t e s\, f o r\, t h e\, d i f f e r e n e\, b e t w e n e\, t h e\, a v e r a g s\, (o v e r\, the
$$

Thus the bias w 0 compensates for the difference between the averages (over the training set) of the target values and the weighted sum of the averages of the basis function values.

We can also maximize the log likelihood function (3.11) with respect to the noise precision parameter β, giving

$$
\frac { 1 } {\beta _ { M L } } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\{ t _ { n } - w _ { M L } ^ { T }\phi (x _ { n })\} ^ { 2 }
$$

Figure 3.2 Geometrical interpretation of the least-squares solution, in an N -dimensional space whose axes are the values of t 1,..., t N. The least-squares regression function is obtained by finding the orthogonal projection of the data vector t onto the subspace spanned by the basis functions φ j (x) in which each basis function is viewed as a vector ϕ j of length N with elements φ j (x n).

![image 74](Bishop2006_images/imageFile74.png)

#### 3.1.2 Geometry of least squares

At this point, it is instructive to consider the geometrical interpretation of the least-squares solution. To do this we consider an N -dimensional space whose axes are given by the t n, so that t = (t 1,...,t N) T is a vector in this space. Each basis function φ j (x n), evaluated at the N data points, can also be represented as a vector in the same space, denoted by ϕ j, as illustrated in Figure 3.2. Note that ϕ j corresponds to the j th column of Φ, whereas φ (x n) corresponds to the n th row of Φ. If the number M of basis functions is smaller than the number N of data points, then the M vectors φ j (x n) will span a linear subspace S of dimensionality M. We define y to be an N -dimensional vector whose n th element is given by y (x n, w), where n = 1,...,N. Because y is an arbitrary linear combination of the vectors ϕ j, it can live anywhere in the M -dimensional subspace. The sum-of-squares error (3.12) is then equal (up to a factor of 1 / 2) to the squared Euclidean distance between y and t. Thus the least-squares solution for w corresponds to that choice of y that lies in subspace S and that is closest to t. Intuitively, from Figure 3.2, we anticipate that this solution corresponds to the orthogonal projection of t onto the subspace S. This is indeed the case, as can easily be verified by noting that the solution for y is given by Φw ML, and then confirming that this takes the form of an orthogonal projection.

In practice, a direct solution of the normal equations can lead to numerical difficulties when Φ T Φ is close to singular. In particular, when two or more of the basis vectors ϕ j are co-linear, or nearly so, the resulting parameter values can have large magnitudes. Such near degeneracies will not be uncommon when dealing with real data sets. The resulting numerical difficulties can be addressed using the technique of singular value decomposition, or SVD (Press et al., 1992; Bishop and Nabney, 2008). Note that the addition of a regularization term ensures that the matrix is nonsingular, even in the presence of degeneracies.

#### 3.1.3 Sequential learning

Batch techniques, such as the maximum likelihood solution (3.15), which involve processing the entire training set in one go, can be computationally costly for large data sets. As we have discussed in Chapter 1, if the data set is sufficiently large, it may be worthwhile to use sequential algorithms, also known as on-line algorithms, in which the data points are considered one at a time, and the model parameters updated after each such presentation. Sequential learning is also appropriate for realtime applications in which the data observations are arriving in a continuous stream, and predictions must be made before all of the data points are seen.

We can obtain a sequential learning algorithm by applying the technique of stochastic gradient descent, also known as sequential gradient descent, as follows. If the error function comprises a sum over data points E = n E n, then after presentation of pattern n, the stochastic gradient descent algorithm updates the parameter vector w using (τ +1) (τ)

$$
w ^ { (\tau + 1) } = w ^ { (\tau) } -\eta\nabla E _ { n }\\\intertext { w }\intertext { i t r o i t }\intertext { o n t i o r }\intertext { n o n b o r }
$$

where τ denotes the iteration number, and η is a learning rate parameter. We shall discuss the choice of value for η shortly. The value of w is initialized to some starting vector w (0). For the case of the sum-of-squares error function (3.12), this gives

$$
w ^ { (\tau + 1) } = w ^ { (\tau) } +\eta (t _ { n } - w ^ { (\tau) T }\phi _ { n })\phi _ { n }\\
$$

where φ n = φ (x n). This is known as least-mean-squares or the LMS algorithm. The value of η needs to be chosen with care to ensure that the algorithm converges (Bishop and Nabney, 2008).

#### 3.1.4 Regularized least squares

In Section 1.1, we introduced the idea of adding a regularization term to an error function in order to control over-fitting, so that the total error function to be minimized takes the form

$$
E _ { D } (\mathbf w) +\lambda E _ { W } (\mathbf w)
$$

where λ is the regularization coefficient that controls the relative importance of the data-dependent error E D (w) and the regularization term E W (w). One of the simplest forms of regularizer is given by the sum-of-squares of the weight vector elements 1

$$
E _ { W } (w) =\frac { 1 } { 2 } w ^ { T } w.
$$

If we also consider the sum-of-squares error function given by

$$
E (w) =\frac { 1 } { 2 }\sum _ { n = 1 } ^ { N }\{ t _ { n } - w ^ {\top }\phi (x _ { n })\} ^ { 2 }\\\intertext { f o r }\text { function becomes }
$$

then the total error function becomes

$$
\frac { 1 } { 2 }\sum _ { n = 1 } ^ { N }\{ t _ { n } - w ^ { T }\phi (x _ { n })\} ^ { 2 } +\frac {\lambda } { 2 } w ^ { T } w.\\\intertext { a r c o i s e f o r g u l a r i z e r $ i s $ k n $ o w n $ i n t h e m a t h e l r e a $ i s $ }
$$

This particular choice of regularizer is known in the machine learning literature as weight decay because in sequential learning algorithms, it encourages weight values to decay towards zero, unless supported by the data. In statistics, it provides an example of a parameter shrinkage method because it shrinks parameter values towards

![image 75](Bishop2006_images/imageFile75.png)

Figure 3.3 Contours of the regularization term in (3.29) for various values of the parameter q.

