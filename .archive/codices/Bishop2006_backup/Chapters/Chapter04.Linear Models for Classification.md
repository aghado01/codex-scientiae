## 4. Linear Models for Classification

### 4.1 Discriminant Functions

(McCullagh and Nelder, 1989). Note, however, that in contrast to the models used for regression, they are no longer linear in the parameters due to the presence of the nonlinear function f(·). This will lead to more complex analytical and computational properties than for linear regression models. Nevertheless, these models are still relatively simple compared to the more general nonlinear models that will be studied in subsequent chapters.

The algorithms discussed in this chapter will be equally applicable if we ﬁrst make a ﬁxed nonlinear transformation of the input variables using a vector of basis functions φ(x) as we did for regression models in Chapter 3. We begin by considering classiﬁcation directly in the original input space x, while in Section 4.3 we shall ﬁnd it convenient to switch to a notation involving basis functions for consistency with later chapters.

A discriminant is a function that takes an input vector x and assigns it to one of K classes, denoted Ck. In this chapter, we shall restrict attention to linear discriminants, namely those for which the decision surfaces are hyperplanes. To simplify the discussion, we consider ﬁrst the case of two classes and then investigate the extension to K > 2 classes.

#### 4.1.1 Two classes

The simplest representation of a linear discriminant function is obtained by taking a linear function of the input vector so that

y(x) = wTx + w0 (4.4)

where w is called a weight vector, and w0 is a bias (not to be confused with bias in the statistical sense). The negative of the bias is sometimes called a threshold. An

input vector x is assigned to class C1 if y(x) 0 and to class C2 otherwise. The corresponding decision boundary is therefore deﬁned by the relation y(x) = 0, which corresponds to a (D − 1)-dimensional hyperplane within the D-dimensional input space. Consider two points xA and xB both of which lie on the decision surface. Because y(xA) = y(xB) = 0, we have wT(xA −xB) = 0 and hence the vector w is orthogonal to every vector lying within the decision surface, and so w determines the orientation of the decision surface. Similarly, if x is a point on the decision surface, then y(x) = 0, and so the normal distance from the origin to the decision surface is given by

wTx w

w0 w

= −

. (4.5)

We therefore see that the bias parameter w0 determines the location of the decision surface. These properties are illustrated for the case of D = 2 in Figure 4.1.

Furthermore, we note that the value of y(x) gives a signed measure of the perpendicular distance r of the point x from the decision surface. To see this, consider

Figure 4.3 Illustration of the decision regions for a multiclass linear discriminant, with the decision boundaries shown in red. If two points xA and xB both lie inside the same decision region Rk, then any point xb that lies on the line connecting these two points must also lie in Rk, and hence the decision region must be singly connected and convex.

Rj

Ri

Rk

xB xˆ

xA

where 0 λ 1. From the linearity of the discriminant functions, it follows that

yk( x) = λyk(xA) + (1 − λ)yk(xB). (4.12)

Because both xA and xB lie inside Rk, it follows that yk(xA) > yj(xA), and yk(xB) > yj(xB), for all j = k, and hence yk( x) > yj( x), and so x also lies inside Rk. Thus Rk is singly connected and convex.

Note that for two classes, we can either employ the formalism discussed here,

based on two discriminant functions y1(x) and y2(x), or else use the simpler but equivalent formulation described in Section 4.1.1 based on a single discriminant function y(x).

We now explore three approaches to learning the parameters of linear discriminant functions, based on least squares, Fisher’s linear discriminant, and the perceptron algorithm.

#### 4.1.3 Least squares for classification

In Chapter 3, we considered models that were linear functions of the parameters, and we saw that the minimization of a sum-of-squares error function led to a simple closed-form solution for the parameter values. It is therefore tempting to see if we can apply the same formalism to classiﬁcation problems. Consider a general classiﬁcation problem with K classes, with a 1-of-K binary coding scheme for the target vector t. One justiﬁcation for using least squares in such a context is that it approximates the conditional expectation E[t|x] of the target values given the input vector. For the binary coding scheme, this conditional expectation is given by the vector of posterior class probabilities. Unfortunately, however, these probabilities are typically approximated rather poorly, indeed the approximations can have values outside the range (0,1), due to the limited ﬂexibility of a linear model as we shall see shortly.

Each class Ck is described by its own linear model so that
yk(x) = wkTx + wk0 (4.13)

where k = 1,...,K. We can conveniently group these together using vector notation so that
y(x) = WT x (4.14)

where W is a matrix whose kth column comprises the D + 1-dimensional vector wk = (wk0,wkT)T and x is the corresponding augmented input vector (1,xT)T with a dummy input x0 = 1. This representation was discussed in detail in Section 3.1. A new input x is then assigned to the class for which the output yk = wkT x is largest.

We now determine the parameter matrix W by minimizing a sum-of-squares error function, as we did for regression in Chapter 3. Consider a training data set {xn,tn} where n = 1,...,N, and deﬁne a matrix T whose nth row is the vector tTn, together with a matrix X whose nth row is xTn. The sum-of-squares error function can then be written as

1 2

ED( W) =

Tr ( X W − T)T( X W − T) . (4.15)

Setting the derivative with respect to W to zero, and rearranging, we then obtain the solution for W in the form

W = ( XT X)−1 XTT = X†T (4.16)

where X† is the pseudo-inverse of the matrix X, as discussed in Section 3.1.1. We then obtain the discriminant function in the form

y(x) = WT x = TT X†

T

x. (4.17)

An interesting property of least-squares solutions with multiple target variables is that if every target vector in the training set satisﬁes some linear constraint

aTtn + b = 0 (4.18) for some constants a and b, then the model prediction for any value of x will satisfy

Exercise 4.2 the same constraint so that

aTy(x) + b = 0. (4.19)

Thus if we use a 1-of-K coding scheme for K classes, then the predictions made by the model will have the property that the elements of y(x) will sum to 1 for any value of x. However, this summation constraint alone is not sufﬁcient to allow the model outputs to be interpreted as probabilities because they are not constrained to lie within the interval (0,1).

The least-squares approach gives an exact closed-form solution for the discriminant function parameters. However, even as a discriminant function (where we use it to make decisions directly and dispense with any probabilistic interpretation) it suf-

Section 2.3.7 fers from some severe problems. We have already seen that least-squares solutions lack robustness to outliers, and this applies equally to the classiﬁcation application, as illustrated in Figure 4.4. Here we see that the additional data points in the righthand ﬁgure produce a signiﬁcant change in the location of the decision boundary, even though these point would be correctly classiﬁed by the original decision boundary in the left-hand ﬁgure. The sum-of-squares error function penalizes predictions that are ‘too correct’ in that they lie a long way on the correct side of the decision

wTSBw wTSWw

J(w) =

where SB is the between-class covariance matrix and is given by

(4.26)

SB = (m2 − m1)(m2 − m1)T (4.27) and SW is the total within-class covariance matrix, given by

SW =

(xn − m1)(xn − m1)T +

(xn − m2)(xn − m2)T. (4.28)

n∈C1

n∈C2

Differentiating (4.26) with respect to w, we ﬁnd that J(w) is maximized when

(wTSBw)SWw = (wTSWw)SBw. (4.29)

From (4.27), we see that SBw is always in the direction of (m2−m1). Furthermore, we do not care about the magnitude of w, only its direction, and so we can drop the

scalar factors (wTSBw) and (wTSWw). Multiplying both sides of (4.29) by S−1

W

we then obtain

w ∝ S−1

W (m2 − m1). (4.30)

Note that if the within-class covariance is isotropic, so that SW is proportional to the unit matrix, we ﬁnd that w is proportional to the difference of the class means, as discussed above.

The result (4.30) is known as Fisher’s linear discriminant, although strictly it is not a discriminant but rather a speciﬁc choice of direction for projection of the data down to one dimension. However, the projected data can subsequently be used to construct a discriminant, by choosing a threshold y0 so that we classify a new point as belonging to C1 if y(x) y0 and classify it as belonging to C2 otherwise. For example, we can model the class-conditional densities p(y|Ck) using Gaussian distributions and then use the techniques of Section 1.2.4 to ﬁnd the parameters of the Gaussian distributions by maximum likelihood. Having found Gaussian approximations to the projected classes, the formalism of Section 1.5.1 then gives an expression for the optimal threshold. Some justiﬁcation for the Gaussian assumption comes from the central limit theorem by noting that y = wTx is the sum of a set of random variables.

#### 4.1.5 Relation to least squares

The least-squares approach to the determination of a linear discriminant was based on the goal of making the model predictions as close as possible to a set of target values. By contrast, the Fisher criterion was derived by requiring maximum class separation in the output space. It is interesting to see the relationship between these two approaches. In particular, we shall show that, for the two-class problem, the Fisher criterion can be obtained as a special case of least squares.

So far we have considered 1-of-K coding for the target values. If, however, we adopt a slightly different target coding scheme, then the least-squares solution for

#### 4.1.6 Fisher’s discriminant for multiple classes

We now consider the generalization of the Fisher discriminant to K > 2 classes, and we shall assume that the dimensionality D of the input space is greater than the number K of classes. Next, we introduce D > 1 linear ‘features’ yk = wkTx, where k = 1,...,D . These feature values can conveniently be grouped together to form a vector y. Similarly, the weight vectors {wk} can be considered to be the columns of a matrix W, so that

y = WTx. (4.39)

Note that again we are not including any bias parameters in the deﬁnition of y. The generalization of the within-class covariance matrix to the case of K classes follows from (4.28) to give

K

SW =

Sk (4.40)

k=1

where

Sk =

(xn − mk)(xn − mk)T (4.41)

n∈Ck

1 Nk

mk =

xn (4.42)

n∈Ck

and Nk is the number of patterns in class Ck. In order to ﬁnd a generalization of the between-class covariance matrix, we follow Duda and Hart (1973) and consider ﬁrst the total covariance matrix

N

ST =

(xn − m)(xn − m)T (4.43)

n=1

where m is the mean of the total data set

N

K

1 N

1 N

m =

xn =

Nkmk (4.44)

n=1

k=1

and N = k Nk is the total number of data points. The total covariance matrix can be decomposed into the sum of the within-class covariance matrix, given by (4.40)

and (4.41), plus an additional matrix SB, which we identify as a measure of the between-class covariance

ST = SW + SB (4.45) where

K

SB =

Nk(mk − m)(mk − m)T. (4.46)

k=1

These covariance matrices have been deﬁned in the original x-space. We can now deﬁne similar matrices in the projected D -dimensional y-space

K

sW =

(yn − µk)(yn − µk)T (4.47)

k=1 n∈Ck

and

K

sB =

Nk(µk − µ)(µk − µ)T (4.48)

k=1

where

K

1 Nk

1 N

µk =

yn, µ =

Nkµk. (4.49)

n∈Ck

k=1

Again we wish to construct a scalar that is large when the between-class covariance is large and when the within-class covariance is small. There are now many possible choices of criterion (Fukunaga, 1990). One example is given by

J(W) = Tr s−1

W sB . (4.50)

This criterion can then be rewritten as an explicit function of the projection matrix W in the form

J(w) = Tr (WSWWT)−1(WSBWT) . (4.51)

Maximization of such criteria is straightforward, though somewhat involved, and is discussed at length in Fukunaga (1990). The weight values are determined by those eigenvectors of S−1

W SB that correspond to the D largest eigenvalues.

There is one important result that is common to all such criteria, which is worth emphasizing. We ﬁrst note from (4.46) that SB is composed of the sum of K matrices, each of which is an outer product of two vectors and therefore of rank 1. In addition, only (K −1) of these matrices are independent as a result of the constraint (4.44). Thus, SB has rank at most equal to (K −1) and so there are at most (K − 1) nonzero eigenvalues. This shows that the projection onto the (K − 1)-dimensional subspace spanned by the eigenvectors of SB does not alter the value of J(w), and so we are therefore unable to ﬁnd more than (K − 1) linear ‘features’ by this means (Fukunaga, 1990).

#### 4.1.7 The perceptron algorithm

Another example of a linear discriminant model is the perceptron of Rosenblatt (1962), which occupies an important place in the history of pattern recognition algorithms. It corresponds to a two-class model in which the input vector x is ﬁrst transformed using a ﬁxed nonlinear transformation to give a feature vector φ(x), and this is then used to construct a generalized linear model of the form

y(x) = f wTφ(x) (4.52)

where the nonlinear activation function f(·) is given by a step function of the form

+1, a 0 −1, a < 0.

f(a) =

(4.53)

The vector φ(x) will typically include a bias component φ0(x) = 1. In earlier discussions of two-class classiﬁcation problems, we have focussed on a target coding scheme in which t ∈ {0,1}, which is appropriate in the context of probabilistic models. For the perceptron, however, it is more convenient to use target values t = +1 for class C1 and t = −1 for class C2, which matches the choice of activation function.

The algorithm used to determine the parameters w of the perceptron can most easily be motivated by error function minimization. A natural choice of error function would be the total number of misclassiﬁed patterns. However, this does not lead to a simple learning algorithm because the error is a piecewise constant function of w, with discontinuities wherever a change in w causes the decision boundary to move across one of the data points. Methods based on changing w using the gradient of the error function cannot then be applied, because the gradient is zero almost everywhere.

We therefore consider an alternative error function known as the perceptron criterion. To derive this, we note that we are seeking a weight vector w such that patterns xn in class C1 will have wTφ(xn) > 0, whereas patterns xn in class C2 have wTφ(xn) < 0. Using the t ∈ {−1,+1} target coding scheme it follows that we would like all patterns to satisfy wTφ(xn)tn > 0. The perceptron criterion associates zero error with any pattern that is correctly classiﬁed, whereas for a misclassiﬁed pattern xn it tries to minimize the quantity −wTφ(xn)tn. The perceptron criterion is therefore given by

EP(w) = −

wTφntn (4.54)

n∈M

Frank Rosenblatt

![image 40](Bishop2006_images/imageFile40.png)

1928–1969

Rosenblatt’s perceptron played an important role in the history of machine learning. Initially, Rosenblatt simulated the perceptron on an IBM 704 computer at Cornell in 1957, but by the early 1960s he had built

special-purpose hardware that provided a direct, parallel implementation of perceptron learning. Many of his ideas were encapsulated in “Principles of Neurodynamics: Perceptrons and the Theory of Brain Mechanisms” published in 1962. Rosenblatt’s work was criticized by Marvin Minksy, whose objections were published in the book “Perceptrons”, co-authored with

Seymour Papert. This book was widely misinterpreted at the time as showing that neural networks were fatally ﬂawed and could only learn solutions for linearly separable problems. In fact, it only proved such limitations in the case of single-layer networks such as the perceptron and merely conjectured (incorrectly) that they applied to more general network models. Unfortunately, however, this book contributed to the substantial decline in research funding for neural computing, a situation that was not reversed until the mid-1980s. Today, there are many hundreds, if not thousands, of applications of neural networks in widespread use, with examples in areas such as handwriting recognition and information retrieval being used routinely by millions of people.

where M denotes the set of all misclassiﬁed patterns. The contribution to the error associated with a particular misclassiﬁed pattern is a linear function of w in regions of w space where the pattern is misclassiﬁed and zero in regions where it is correctly classiﬁed. The total error function is therefore piecewise linear. Section 3.1.3 We now apply the stochastic gradient descent algorithm to this error function.

The change in the weight vector w is then given by

w(τ+1) = w(τ) − η∇EP(w) = w(τ) + ηφntn (4.55)

where η is the learning rate parameter and τ is an integer that indexes the steps of the algorithm. Because the perceptron function y(x,w) is unchanged if we multiply w by a constant, we can set the learning rate parameter η equal to 1 without of generality. Note that, as the weight vector evolves during training, the set of patterns that are misclassiﬁed will change.

The perceptron learning algorithm has a simple interpretation, as follows. We

cycle through the training patterns in turn, and for each pattern xn we evaluate the perceptron function (4.52). If the pattern is correctly classiﬁed, then the weight

vector remains unchanged, whereas if it is incorrectly classiﬁed, then for class C1 we add the vector φ(xn) onto the current estimate of weight vector w while for class C2 we subtract the vector φ(xn) from w. The perceptron learning algorithm is illustrated in Figure 4.7.

If we consider the effect of a single update in the perceptron learning algorithm, we see that the contribution to the error from a misclassiﬁed pattern will be reduced because from (4.55) we have

−w(τ+1)Tφntn = −w(τ)Tφntn − (φntn)Tφntn < −w(τ)Tφntn (4.56)

where we have set η = 1, and made use of φntn 2 > 0. Of course, this does not imply that the contribution to the error function from the other misclassiﬁed patterns will have been reduced. Furthermore, the change in weight vector may have caused some previously correctly classiﬁed patterns to become misclassiﬁed. Thus the perceptron learning rule is not guaranteed to reduce the total error function at each stage.

However, the perceptron convergence theorem states that if there exists an exact solution (in other words, if the training data set is linearly separable), then the perceptron learning algorithm is guaranteed to ﬁnd an exact solution in a ﬁnite number of steps. Proofs of this theorem can be found for example in Rosenblatt (1962), Block (1962), Nilsson (1965), Minsky and Papert (1969), Hertz et al. (1991), and Bishop (1995a). Note, however, that the number of steps required to achieve convergence could still be substantial, and in practice, until convergence is achieved, we will not be able to distinguish between a nonseparable problem and one that is simply slow to converge.

Even when the data set is linearly separable, there may be many solutions, and which one is found will depend on the initialization of the parameters and on the order of presentation of the data points. Furthermore, for data sets that are not linearly separable, the perceptron learning algorithm will never converge.

![image 41](Bishop2006_images/imageFile41.png)

![image 42](Bishop2006_images/imageFile42.png)

![image 43](Bishop2006_images/imageFile43.png)

Figure 4.8 Illustration of the Mark 1 perceptron hardware. The photograph on the left shows how the inputs were obtained using a simple camera system in which an input scene, in this case a printed character, was illuminated by powerful lights, and an image focussed onto a 20 × 20 array of cadmium sulphide photocells, giving a primitive 400 pixel image. The perceptron also had a patch board, shown in the middle photograph, which allowed different conﬁgurations of input features to be tried. Often these were wired up at random to demonstrate the ability of the perceptron to learn without the need for precise wiring, in contrast to a modern digital computer. The photograph on the right shows one of the racks of adaptive weights. Each weight was implemented using a rotary variable resistor, also called a potentiometer, driven by an electric motor thereby allowing the value of the weight to be adjusted automatically by the learning algorithm.

Aside from difﬁculties with the learning algorithm, the perceptron does not provide probabilistic outputs, nor does it generalize readily to K > 2 classes. The most important limitation, however, arises from the fact that (in common with all of the models discussed in this chapter and the previous one) it is based on linear combinations of ﬁxed basis functions. More detailed discussions of the limitations of perceptrons can be found in Minsky and Papert (1969) and Bishop (1995a).

Analogue hardware implementations of the perceptron were built by Rosenblatt, based on motor-driven variable resistors to implement the adaptive parameters wj. These are illustrated in Figure 4.8. The inputs were obtained from a simple camera system based on an array of photo-sensors, while the basis functions φ could be chosen in a variety of ways, for example based on simple ﬁxed functions of randomly chosen subsets of pixels from the input image. Typical applications involved learning to discriminate simple shapes or characters.

At the same time that the perceptron was being developed, a closely related system called the adaline, which is short for ‘adaptive linear element’, was being explored by Widrow and co-workers. The functional form of the model was the same as for the perceptron, but a different approach to training was adopted (Widrow and Hoff, 1960; Widrow and Lehr, 1990).

### 4.2 Probabilistic Generative Models

We turn next to a probabilistic view of classiﬁcation and show how models with linear decision boundaries arise from simple assumptions about the distribution of the data. In Section 1.5.4, we discussed the distinction between the discriminative and the generative approaches to classiﬁcation. Here we shall adopt a generative

![image 44](Bishop2006_images/imageFile44.png)

![image 45](Bishop2006_images/imageFile45.png)

![image 46](Bishop2006_images/imageFile46.png)

![image 47](Bishop2006_images/imageFile47.png)

Figure 4.10 The left-hand plot shows the class-conditional densities for two classes, denoted red and blue. On the right is the corresponding posterior probability p(C1|x), which is given by a logistic sigmoid of a linear function of x. The surface in the right-hand plot is coloured using a proportion of red ink given by p(C1|x) and a proportion of blue ink given by p(C2|x) = 1 − p(C1|x).

decision boundaries correspond to surfaces along which the posterior probabilities p(Ck|x) are constant and so will be given by linear functions of x, and therefore the decision boundaries are linear in input space. The prior probabilities p(Ck) enter only through the bias parameter w0 so that changes in the priors have the effect of making parallel shifts of the decision boundary and more generally of the parallel contours of constant posterior probability.

For the general case of K classes we have, from (4.62) and (4.63),

ak(x) = wkTx + wk0 (4.68) where we have deﬁned

wk = Σ−1µk (4.69) wk0 = −

1 2

µTkΣ−1µk + lnp(Ck). (4.70)

We see that the ak(x) are again linear functions of x as a consequence of the cancellation of the quadratic terms due to the shared covariances. The resulting decision boundaries, corresponding to the minimum misclassiﬁcation rate, will occur when two of the posterior probabilities (the two largest) are equal, and so will be deﬁned by linear functions of x, and so again we have a generalized linear model.

If we relax the assumption of a shared covariance matrix and allow each classconditional density p(x|Ck) to have its own covariance matrix Σk, then the earlier cancellations will no longer occur, and we will obtain quadratic functions of x, giving rise to a quadratic discriminant. The linear and quadratic decision boundaries are illustrated in Figure 4.11.

basis functions is typically set to a constant, say φ0(x) = 1, so that the corresponding parameter w0 plays the role of a bias. For the remainder of this chapter, we shall include a ﬁxed basis function transformation φ(x), as this will highlight some useful similarities to the regression models discussed in Chapter 3.

For many problems of practical interest, there is signiﬁcant overlap between the class-conditional densities p(x|Ck). This corresponds to posterior probabilities p(Ck|x), which, for at least some values of x, are not 0 or 1. In such cases, the optimal solution is obtained by modelling the posterior probabilities accurately and then applying standard decision theory, as discussed in Chapter 1. Note that nonlinear transformations φ(x) cannot remove such class overlap. Indeed, they can increase the level of overlap, or create overlap where none existed in the original observation space. However, suitable choices of nonlinearity can make the process of modelling the posterior probabilities easier.

Section 3.6 Such ﬁxed basis function models have important limitations, and these will be resolved in later chapters by allowing the basis functions themselves to adapt to the data. Notwithstanding these limitations, models with ﬁxed nonlinear basis functions play an important role in applications, and a discussion of such models will introduce many of the key concepts needed for an understanding of their more complex counterparts.

#### 4.3.2 Logistic regression

We begin our treatment of generalized linear models by considering the problem of two-class classiﬁcation. In our discussion of generative approaches in Section 4.2, we saw that under rather general assumptions, the posterior probability of class C1 can be written as a logistic sigmoid acting on a linear function of the feature vector φ so that

p(C1|φ) = y(φ) = σ wTφ (4.87)

with p(C2|φ) = 1 − p(C1|φ). Here σ(·) is the logistic sigmoid function deﬁned by (4.59). In the terminology of statistics, this model is known as logistic regression, although it should be emphasized that this is a model for classiﬁcation rather than regression.

For an M-dimensional feature space φ, this model has M adjustable parameters. By contrast, if we had ﬁtted Gaussian class conditional densities using maximum likelihood, we would have used 2M parameters for the means and M(M + 1)/2 parameters for the (shared) covariance matrix. Together with the class prior p(C1), this gives a total of M(M +5)/2+1 parameters, which grows quadratically with M, in contrast to the linear dependence on M of the number of parameters in logistic regression. For large values of M, there is a clear advantage in working with the logistic regression model directly.

We now use maximum likelihood to determine the parameters of the logistic regression model. To do this, we shall make use of the derivative of the logistic sigmoid function, which can conveniently be expressed in terms of the sigmoid function

Exercise 4.12 itself

dσ da

= σ(1 − σ). (4.88)

For a data set {φn,tn}, where tn ∈ {0,1} and φn = φ(xn), with n = 1,...,N, the likelihood function can be written

N

p(t|w) =

n=1

n {1 − yn}1−tn (4.89)

yt

n

where t = (t1,...,tN)T and yn = p(C1|φn). As usual, we can deﬁne an error function by taking the negative logarithm of the likelihood, which gives the crossentropy error function in the form

E(w) = −lnp(t|w) = −

N

{tn lnyn + (1 − tn)ln(1 − yn)} (4.90)

n=1

where yn = σ(an) and an = wTφn. Taking the gradient of the error function with Exercise 4.13 respect to w, we obtain

∇E(w) =

N

(yn − tn)φn (4.91)

n=1

where we have made use of (4.88). We see that the factor involving the derivative of the logistic sigmoid has cancelled, leading to a simpliﬁed form for the gradient of the log likelihood. In particular, the contribution to the gradient from data point n is given by the ‘error’ yn − tn between the target value and the prediction of the model, times the basis function vector φn. Furthermore, comparison with (3.13) shows that this takes precisely the same form as the gradient of the sum-of-squares

Section 3.1.1 error function for the linear regression model.

If desired, we could make use of the result (4.91) to give a sequential algorithm in which patterns are presented one at a time, in which each of the weight vectors is updated using (3.22) in which ∇En is the nth term in (4.91).

It is worth noting that maximum likelihood can exhibit severe over-ﬁtting for data sets that are linearly separable. This arises because the maximum likelihood solution occurs when the hyperplane corresponding to σ = 0.5, equivalent to wTφ = 0, separates the two classes and the magnitude of w goes to inﬁnity. In this case, the logistic sigmoid function becomes inﬁnitely steep in feature space, corresponding to a Heaviside step function, so that every training point from each class k is assigned

Exercise 4.14 a posterior probability p(Ck|x) = 1. Furthermore, there is typically a continuum of such solutions because any separating hyperplane will give rise to the same posterior probabilities at the training data points, as will be seen later in Figure 10.13. Maximum likelihood provides no way to favour one such solution over another, and which solution is found in practice will depend on the choice of optimization algorithm and on the parameter initialization. Note that the problem will arise even if the number of data points is large compared with the number of parameters in the model, so long as the training data set is linearly separable. The singularity can be avoided by inclusion of a prior and ﬁnding a MAP solution for w, or equivalently by adding a regularization term to the error function.

#### 4.3.3 Iterative reweighted least squares

In the case of the linear regression models discussed in Chapter 3, the maximum likelihood solution, on the assumption of a Gaussian noise model, leads to a closed-form solution. This was a consequence of the quadratic dependence of the log likelihood function on the parameter vector w. For logistic regression, there is no longer a closed-form solution, due to the nonlinearity of the logistic sigmoid function. However, the departure from a quadratic form is not substantial. To be precise, the error function is concave, as we shall see shortly, and hence has a unique minimum. Furthermore, the error function can be minimized by an efﬁcient iterative technique based on the Newton-Raphson iterative optimization scheme, which uses a local quadratic approximation to the log likelihood function. The Newton-Raphson update, for minimizing a function E(w), takes the form (Fletcher, 1987; Bishop and Nabney, 2008)

w(new) = w(old) − H−1∇E(w). (4.92)

where H is the Hessian matrix whose elements comprise the second derivatives of E(w) with respect to the components of w.

Let us ﬁrst of all apply the Newton-Raphson method to the linear regression model (3.3) with the sum-of-squares error function (3.12). The gradient and Hessian of this error function are given by

∇E(w) =

H = ∇∇E(w) =

N

(wTφn − tn)φn = ΦTΦw − ΦTt (4.93)

n=1

N

φnφTn = ΦTΦ (4.94)

n=1

Section 3.1.1 where Φ is the N × M design matrix, whose nth row is given by φTn. The Newton-

Raphson update then takes the form

w(new) = w(old) − (ΦTΦ)−1 ΦTΦw(old) − ΦTt

= (ΦTΦ)−1ΦTt (4.95)

which we recognize as the standard least-squares solution. Note that the error function in this case is quadratic and hence the Newton-Raphson formula gives the exact solution in one step.

Now let us apply the Newton-Raphson update to the cross-entropy error function (4.90) for the logistic regression model. From (4.91) we see that the gradient and Hessian of this error function are given by

N

(yn − tn)φn = ΦT(y − t) (4.96)

∇E(w) =

n=1

N

H = ∇∇E(w) =

yn(1 − yn)φnφTn = ΦTRΦ (4.97)

n=1

where we have made use of (4.88). Also, we have introduced the N × N diagonal matrix R with elements

Rnn = yn(1 − yn). (4.98) We see that the Hessian is no longer constant but depends on w through the weighting matrix R, corresponding to the fact that the error function is no longer quadratic. Using the property 0 < yn < 1, which follows from the form of the logistic sigmoid function, we see that uTHu > 0 for an arbitrary vector u, and so the Hessian matrix H is positive deﬁnite. It follows that the error function is a concave function of w

Exercise 4.15 and hence has a unique minimum.

The Newton-Raphson update formula for the logistic regression model then becomes

w(new) = w(old) − (ΦTRΦ)−1ΦT(y − t)

= (ΦTRΦ)−1 ΦTRΦw(old) − ΦT(y − t)

= (ΦTRΦ)−1ΦTRz (4.99) where z is an N-dimensional vector with elements

z = Φw(old) − R−1(y − t). (4.100)

We see that the update formula (4.99) takes the form of a set of normal equations for a weighted least-squares problem. Because the weighing matrix R is not constant but depends on the parameter vector w, we must apply the normal equations iteratively, each time using the new weight vector w to compute a revised weighing matrix R. For this reason, the algorithm is known as iterative reweighted least squares, or IRLS (Rubin, 1983). As in the weighted least-squares problem, the elements of the diagonal weighting matrix R can be interpreted as variances because the mean and variance of t in the logistic regression model are given by

E[t] = σ(x) = y (4.101) var[t] = E[t2] − E[t]2 = σ(x) − σ(x)2 = y(1 − y) (4.102)

where we have used the property t2 = t for t ∈ {0,1}. In fact, we can interpret IRLS as the solution to a linearized problem in the space of the variable a = wTφ. The quantity zn, which corresponds to the nth element of z, can then be given a simple interpretation as an effective target value in this space obtained by making a local linear approximation to the logistic sigmoid function around the current operating point w(old)

dan dyn w

an(w) an(w(old)) +

(tn − yn)

(old)

(yn − tn) yn(1 − yn)

= zn. (4.103)

= φTnw(old) −

#### 4.3.4 Multiclass logistic regression

Section 4.2 In our discussion of generative models for multiclass classiﬁcation, we have seen that for a large class of distributions, the posterior probabilities are given by a softmax transformation of linear functions of the feature variables, so that

exp(ak) j exp(aj)

p(Ck|φ) = yk(φ) =

(4.104)

where the ‘activations’ ak are given by

ak = wkTφ. (4.105)

There we used maximum likelihood to determine separately the class-conditional densities and the class priors and then found the corresponding posterior probabilities using Bayes’ theorem, thereby implicitly determining the parameters {wk}. Here we consider the use of maximum likelihood to determine the parameters {wk} of this model directly. To do this, we will require the derivatives of yk with respect to all of

Exercise 4.17 the activations aj. These are given by

∂yk ∂aj

= yk(Ikj − yj) (4.106)

where Ikj are the elements of the identity matrix. Next we write down the likelihood function. This is most easily done using

the 1-of-K coding scheme in which the target vector tn for a feature vector φn belonging to class Ck is a binary vector with all elements zero except for element k, which equals one. The likelihood function is then given by

N

p(T|w1,...,wK) =

n=1

K

N

p(Ck|φn)tnk =

n=1

k=1

K

k=1

yt

nk (4.107)

nk

where ynk = yk(φn), and T is an N × K matrix of target variables with elements tnk. Taking the negative logarithm then gives

N

E(w1,...,wK) = −lnp(T|w1,...,wK) = −

n=1

K

tnk lnynk (4.108)

k=1

which is known as the cross-entropy error function for the multiclass classiﬁcation problem.

We now take the gradient of the error function with respect to one of the parameter vectors wj. Making use of the result (4.106) for the derivatives of the softmax

Exercise 4.18 function, we obtain

E(w1,...,wK) =

∇wj

N

(ynj − tnj)φn (4.109)

n=1

where we have made use of k tnk = 1. Once again, we see the same form arising for the gradient as was found for the sum-of-squares error function with the linear

model and the cross-entropy error for the logistic regression model, namely the product of the error (ynj − tnj) times the basis function φn. Again, we could use this to formulate a sequential algorithm in which patterns are presented one at a time, in which each of the weight vectors is updated using (3.22).

We have seen that the derivative of the log likelihood function for a linear regression model with respect to the parameter vector w for a data point n took the form of the ‘error’ yn − tn times the feature vector φn. Similarly, for the combination of logistic sigmoid activation function and cross-entropy error function (4.90), and for the softmax activation function with the multiclass cross-entropy error function (4.108), we again obtain this same simple form. This is an example of a more general result, as we shall see in Section 4.3.6.

To ﬁnd a batch algorithm, we again appeal to the Newton-Raphson update to obtain the corresponding IRLS algorithm for the multiclass problem. This requires evaluation of the Hessian matrix that comprises blocks of size M × M in which block j,k is given by

N

E(w1,...,wK) = −

∇wk∇wj

n=1

ynk(Ikj − ynj)φnφTn. (4.110)

As with the two-class problem, the Hessian matrix for the multiclass logistic regresExercise 4.20 sion model is positive deﬁnite and so the error function again has a unique minimum. Practical details of IRLS for the multiclass case can be found in Bishop and Nabney

(2008).

#### 4.3.5 Probit regression

We have seen that, for a broad range of class-conditional distributions, described by the exponential family, the resulting posterior class probabilities are given by a logistic (or softmax) transformation acting on a linear function of the feature variables. However, not all choices of class-conditional density give rise to such a simple form for the posterior probabilities (for instance, if the class-conditional densities are modelled using Gaussian mixtures). This suggests that it might be worth exploring other types of discriminative probabilistic model. For the purposes of this chapter, however, we shall return to the two-class case, and again remain within the framework of generalized linear models so that

p(t = 1|a) = f(a) (4.111) where a = wTφ, and f(·) is the activation function.

One way to motivate an alternative choice for the link function is to consider a

noisy threshold model, as follows. For each input φn, we evaluate an = wTφn and then we set the target value according to

tn = 1 if an θ tn = 0 otherwise.

(4.112)

however, ﬁnd another use for the probit model when we discuss Bayesian treatments of logistic regression in Section 4.5.

One issue that can occur in practical applications is that of outliers, which can arise for instance through errors in measuring the input vector x or through mislabelling of the target value t. Because such points can lie a long way to the wrong side of the ideal decision boundary, they can seriously distort the classiﬁer. Note that the logistic and probit regression models behave differently in this respect because the tails of the logistic sigmoid decay asymptotically like exp(−x) for x → ∞, whereas for the probit activation function they decay like exp(−x2), and so the probit model can be signiﬁcantly more sensitive to outliers.

However, both the logistic and the probit models assume the data is correctly labelled. The effect of mislabelling is easily incorporated into a probabilistic model by introducing a probability that the target value t has been ﬂipped to the wrong value (Opper and Winther, 2000a), leading to a target value distribution for data point x of the form

p(t|x) = (1 − )σ(x) + (1 − σ(x))

= + (1 − 2 )σ(x) (4.117)

where σ(x) is the activation function with input vector x. Here may be set in advance, or it may be treated as a hyperparameter whose value is inferred from the data.

#### 4.3.6 Canonical link functions

For the linear regression model with a Gaussian noise distribution, the error function, corresponding to the negative log likelihood, is given by (3.12). If we take the derivative with respect to the parameter vector w of the contribution to the error function from a data point n, this takes the form of the ‘error’ yn − tn times the feature vector φn, where yn = wTφn. Similarly, for the combination of the logistic sigmoid activation function and the cross-entropy error function (4.90), and for the softmax activation function with the multiclass cross-entropy error function (4.108), we again obtain this same simple form. We now show that this is a general result of assuming a conditional distribution for the target variable from the exponential family, along with a corresponding choice for the activation function known as the canonical link function.

We again make use of the restricted form (4.84) of exponential family distributions. Note that here we are applying the assumption of exponential family distribution to the target variable t, in contrast to Section 4.2.4 where we applied it to the input vector x. We therefore consider conditional distributions of the target variable of the form

1 s

t s

ηt s

g(η)exp

p(t|η,s) =

. (4.118)

h

Using the same line of argument as led to the derivation of the result (2.226), we see that the conditional mean of t, which we denote by y, is given by

d dη

y ≡ E[t|η] = −s

lng(η). (4.119)

where θMAP is the value of θ at the mode of the posterior distribution, and A is the Hessian matrix of second derivatives of the negative log posterior

A = −∇∇lnp(D|θMAP)p(θMAP) = −∇∇lnp(θMAP|D). (4.138)

The ﬁrst term on the right hand side of (4.137) represents the log likelihood evaluated using the optimized parameters, while the remaining three terms comprise the ‘Occam factor’ which penalizes model complexity.

If we assume that the Gaussian prior distribution over parameters is broad, and Exercise 4.23 that the Hessian has full rank, then we can approximate (4.137) very roughly using

lnp(D) lnp(D|θMAP) −

1 2

M lnN (4.139)

where N is the number of data points, M is the number of parameters in θ and we have omitted additive constants. This is known as the Bayesian Information Criterion (BIC) or the Schwarz criterion (Schwarz, 1978). Note that, compared to AIC given by (1.73), this penalizes model complexity more heavily.

Complexity measures such as AIC and BIC have the virtue of being easy to evaluate, but can also give misleading results. In particular, the assumption that the Hessian matrix has full rank is often not valid since many of the parameters are not

Section 3.5.3 ‘well-determined’. We can use the result (4.137) to obtain a more accurate estimate of the model evidence starting from the Laplace approximation, as we illustrate in the context of neural networks in Section 5.7.

### 4.5 Bayesian Logistic Regression

We now turn to a Bayesian treatment of logistic regression. Exact Bayesian inference for logistic regression is intractable. In particular, evaluation of the posterior distribution would require normalization of the product of a prior distribution and a likelihood function that itself comprises a product of logistic sigmoid functions, one for every data point. Evaluation of the predictive distribution is similarly intractable. Here we consider the application of the Laplace approximation to the problem of Bayesian logistic regression (Spiegelhalter and Lauritzen, 1990; MacKay, 1992b).

#### 4.5.1 Laplace approximation

Recall from Section 4.4 that the Laplace approximation is obtained by ﬁnding the mode of the posterior distribution and then ﬁtting a Gaussian centred at that mode. This requires evaluation of the second derivatives of the log posterior, which is equivalent to ﬁnding the Hessian matrix.

Because we seek a Gaussian representation for the posterior distribution, it is natural to begin with a Gaussian prior, which we write in the general form

p(w) = N(w|m0,S0) (4.140)

where m0 and S0 are ﬁxed hyperparameters. The posterior distribution over w is given by

p(w|t) ∝ p(w)p(t|w) (4.141)

where t = (t1,...,tN)T. Taking the log of both sides, and substituting for the prior distribution using (4.140), and for the likelihood function using (4.89), we obtain

1 2

lnp(w|t) = −

-

(w − m0)TS−1

0 (w − m0)

N

{tn lnyn + (1 − tn)ln(1 − yn)} + const (4.142)

n=1

where yn = σ(wTφn). To obtain a Gaussian approximation to the posterior distribution, we ﬁrst maximize the posterior distribution to give the MAP (maximum

posterior) solution wMAP, which deﬁnes the mean of the Gaussian. The covariance is then given by the inverse of the matrix of second derivatives of the negative log likelihood, which takes the form

SN = −∇∇lnp(w|t) = S−1

0 +

N

yn(1 − yn)φnφTn. (4.143)

n=1

The Gaussian approximation to the posterior distribution therefore takes the form

q(w) = N(w|wMAP,SN). (4.144)

Having obtained a Gaussian approximation to the posterior distribution, there remains the task of marginalizing with respect to this distribution in order to make predictions.

#### 4.5.2 Predictive distribution

The predictive distribution for class C1, given a new feature vector φ(x), is obtained by marginalizing with respect to the posterior distribution p(w|t), which is itself approximated by a Gaussian distribution q(w) so that

p(C1|φ,t) = p(C1|φ,w)p(w|t)dw σ(wTφ)q(w)dw (4.145)

with the corresponding probability for class C2 given by p(C2|φ,t) = 1−p(C1|φ,t). To evaluate the predictive distribution, we ﬁrst note that the function σ(wTφ) depends on w only through its projection onto φ. Denoting a = wTφ, we have

σ(wTφ) = δ(a − wTφ)σ(a)da (4.146)

where δ(·) is the Dirac delta function. From this we obtain

σ(wTφ)q(w)dw = σ(a)p(a)da (4.147)

where

p(a) = δ(a − wTφ)q(w)dw. (4.148)

We can evaluate p(a) by noting that the delta function imposes a linear constraint on w and so forms a marginal distribution from the joint distribution q(w) by integrating out all directions orthogonal to φ. Because q(w) is Gaussian, we know from Section 2.3.2 that the marginal distribution will also be Gaussian. We can evaluate the mean and covariance of this distribution by taking moments, and interchanging the order of integration over a and w, so that

µa = E[a] = p(a)ada = q(w)wTφdw = wMAPT φ (4.149)

where we have used the result (4.144) for the variational posterior distribution q(w). Similarly

σa2 = var[a] = p(a) a2 − E[a]2 da

= q(w) (wTφ)2 − (mTNφ)2 dw = φTSNφ. (4.150)

Note that the distribution of a takes the same form as the predictive distribution (3.58) for the linear regression model, with the noise variance set to zero. Thus our variational approximation to the predictive distribution becomes

p(C1|t) = σ(a)p(a)da = σ(a)N(a|µa,σa2)da. (4.151)

This result can also be derived directly by making use of the results for the marginal Exercise 4.24 of a Gaussian distribution given in Section 2.3.2.

The integral over a represents the convolution of a Gaussian with a logistic sigmoid, and cannot be evaluated analytically. We can, however, obtain a good approximation (Spiegelhalter and Lauritzen, 1990; MacKay, 1992b; Barber and Bishop, 1998a) by making use of the close similarity between the logistic sigmoid function σ(a) deﬁned by (4.59) and the probit function Φ(a) deﬁned by (4.114). In order to obtain the best approximation to the logistic function we need to re-scale the horizontal axis, so that we approximate σ(a) by Φ(λa). We can ﬁnd a suitable value of λ by requiring that the two functions have the same slope at the origin, which gives

Exercise 4.25 λ2 = π/8. The similarity of the logistic sigmoid and the probit function, for this

choice of λ, is illustrated in Figure 4.9.

The advantage of using a probit function is that its convolution with a Gaussian can be expressed analytically in terms of another probit function. Speciﬁcally we

Exercise 4.26 can show that

Φ(λa)N(a|µ,σ2)da = Φ

µ (λ−2 + σ2)1/2

. (4.152)

We now apply the approximation σ(a) Φ(λa) to the probit functions appearing on both sides of this equation, leading to the following approximation for the convolution of a logistic sigmoid with a Gaussian

σ(a)N(a|µ,σ2)da σ κ(σ2)µ (4.153)

where we have deﬁned

κ(σ2) = (1 + πσ2/8)−1/2. (4.154)

Applying this result to (4.151) we obtain the approximate predictive distribution in the form

p(C1|φ,t) = σ κ(σa2)µa (4.155)

where µa and σa2 are deﬁned by (4.149) and (4.150), respectively, and κ(σa2) is deﬁned by (4.154).

Note that the decision boundary corresponding to p(C1|φ,t) = 0.5 is given by µa = 0, which is the same as the decision boundary obtained by using the MAP value for w. Thus if the decision criterion is based on minimizing misclassiﬁcation rate, with equal prior probabilities, then the marginalization over w has no effect. However, for more complex decision criteria it will play an important role. Marginalization of the logistic sigmoid model under a Gaussian approximation to the posterior distribution will be illustrated in the context of variational inference in Figure 10.13.

