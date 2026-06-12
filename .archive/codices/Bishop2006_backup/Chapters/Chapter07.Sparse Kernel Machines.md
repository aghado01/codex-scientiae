## 7. Sparse Kernel Machines

### 7.1 Maximum Margin Classiﬁers

We begin our discussion of support vector machines by returning to the two-class classiﬁcation problem using linear models of the form

y(x) = wTφ(x) + b (7.1)

where φ(x) denotes a ﬁxed feature-space transformation, and we have made the bias parameter b explicit. Note that we shall shortly introduce a dual representation expressed in terms of kernel functions, which avoids having to work explicitly in feature space. The training data set comprises N input vectors x1,...,xN, with corresponding target values t1,...,tN where tn ∈ {−1,1}, and new data points x are classiﬁed according to the sign of y(x).

We shall assume for the moment that the training data set is linearly separable in feature space, so that by deﬁnition there exists at least one choice of the parameters w and b such that a function of the form (7.1) satisﬁes y(xn) > 0 for points having tn = +1 and y(xn) < 0 for points having tn = −1, so that tny(xn) > 0 for all training data points.

There may of course exist many such solutions that separate the classes exactly. In Section 4.1.7, we described the perceptron algorithm that is guaranteed to ﬁnd a solution in a ﬁnite number of steps. The solution that it ﬁnds, however, will be dependent on the (arbitrary) initial values chosen for w and b as well as on the order in which the data points are presented. If there are multiple solutions all of which classify the training data set exactly, then we should try to ﬁnd the one that will give the smallest generalization error. The support vector machine approaches this problem through the concept of the margin, which is deﬁned to be the smallest distance between the decision boundary and any of the samples, as illustrated in Figure 7.1.

In support vector machines the decision boundary is chosen to be the one for which the margin is maximized. The maximum margin solution can be motivated us-

Section 7.1.5 using computational learning theory, also known as statistical learning theory. However, a simple insight into the origins of maximum margin has been given by Tong and Koller (2000) who consider a framework for classiﬁcation based on a hybrid of generative and discriminative approaches. They ﬁrst model the distribution over input vectors x for each class using a Parzen density estimator with Gaussian kernels

7.1. Maximum Margin Classiﬁers 327

y = 1 y = 0 y = −1

margin

y = −1

y = 0

y = 1

Figure 7.1 The margin is deﬁned as the perpendicular distance between the decision boundary and the closest of the data points, as shown on the left ﬁgure. Maximizing the margin leads to a particular choice of decision boundary, as shown on the right. The location of this boundary is determined by a subset of the data points, known as support vectors, which are indicated by the circles.

having a common parameter σ2. Together with the class priors, this deﬁnes an optimal misclassiﬁcation-rate decision boundary. However, instead of using this optimal boundary, they determine the best hyperplane by minimizing the probability of error relative to the learned density model. In the limit σ2 → 0, the optimal hyperplane is shown to be the one having maximum margin. The intuition behind this result is that as σ2 is reduced, the hyperplane is increasingly dominated by nearby data points relative to more distant ones. In the limit, the hyperplane becomes independent of data points that are not support vectors.

We shall see in Figure 10.13 that marginalization with respect to the prior distribution of the parameters in a Bayesian approach for a simple linearly separable data set leads to a decision boundary that lies in the middle of the region separating the data points. The large margin solution has similar behaviour.

Recall from Figure 4.1 that the perpendicular distance of a point x from a hyperplane deﬁned by y(x) = 0 where y(x) takes the form (7.1) is given by |y(x)|/ w . Furthermore, we are only interested in solutions for which all data points are correctly classiﬁed, so that tny(xn) > 0 for all n. Thus the distance of a point xn to the decision surface is given by

tny(xn) w

=

tn(wTφ(xn) + b) w

. (7.2)

The margin is given by the perpendicular distance to the closest point xn from the data set, and we wish to optimize the parameters w and b in order to maximize this distance. Thus the maximum margin solution is found by solving

arg max

w,b

1 w

min

n

tn wTφ(xn) + b (7.3)

where we have taken the factor 1/ w outside the optimization over n because w

does not depend on n. Direct solution of this optimization problem would be very complex, and so we shall convert it into an equivalent problem that is much easier to solve. To do this we note that if we make the rescaling w → κw and b → κb, then the distance from any point xn to the decision surface, given by tny(xn)/ w , is unchanged. We can use this freedom to set

tn wTφ(xn) + b = 1 (7.4)

for the point that is closest to the surface. In this case, all data points will satisfy the constraints

tn wTφ(xn) + b 1, n = 1,...,N. (7.5) This is known as the canonical representation of the decision hyperplane. In the case of data points for which the equality holds, the constraints are said to be active, whereas for the remainder they are said to be inactive. By deﬁnition, there will always be at least one active constraint, because there will always be a closest point, and once the margin has been maximized there will be at least two active constraints. The optimization problem then simply requires that we maximize w −1, which is equivalent to minimizing w 2, and so we have to solve the optimization problem

1 2

arg min

w,b

w 2 (7.6)

subject to the constraints given by (7.5). The factor of 1/2 in (7.6) is included for later convenience. This is an example of a quadratic programming problem in which we are trying to minimize a quadratic function subject to a set of linear inequality constraints. It appears that the bias parameter b has disappeared from the optimization. However, it is determined implicitly via the constraints, because these require that changes to w be compensated by changes to b. We shall see how this works shortly.

In order to solve this constrained optimization problem, we introduce Lagrange Appendix E multipliers an 0, with one multiplier an for each of the constraints in (7.5), giving

the Lagrangian function

1 2

L(w,b,a) =

w 2 −

N

an tn(wTφ(xn) + b) − 1 (7.7)

n=1

where a = (a1,...,aN)T. Note the minus sign in front of the Lagrange multiplier term, because we are minimizing with respect to w and b, and maximizing with respect to a. Setting the derivatives of L(w,b,a) with respect to w and b equal to zero, we obtain the following two conditions

w =

0 =

N

antnφ(xn) (7.8)

n=1

N

antn. (7.9)

n=1

Figure 7.3 Illustration of the slack variables ξn 0. Data points with circles around them are support vectors.

y = −1

y = 0

y = 1

ξ > 1

ξ < 1

ξ = 0

ξ = 0

with ξn > 1 will be misclassiﬁed. The exact classiﬁcation constraints (7.5) are then replaced with

tny(xn) 1 − ξn, n = 1,...,N (7.20)

in which the slack variables are constrained to satisfy ξn 0. Data points for which ξn = 0 are correctly classiﬁed and are either on the margin or on the correct side of the margin. Points for which 0 < ξn 1 lie inside the margin, but on the correct side of the decision boundary, and those data points for which ξn > 1 lie on the wrong side of the decision boundary and are misclassiﬁed, as illustrated in Figure 7.3. This is sometimes described as relaxing the hard margin constraint to give a soft margin and allows some of the training set data points to be misclassiﬁed. Note that while slack variables allow for overlapping class distributions, this framework is still sensitive to outliers because the penalty for misclassiﬁcation increases linearly with ξ.

Our goal is now to maximize the margin while softly penalizing points that lie on the wrong side of the margin boundary. We therefore minimize

N

1 2

ξn +

C

n=1

w 2 (7.21)

where the parameter C > 0 controls the trade-off between the slack variable penalty and the margin. Because any point that is misclassiﬁed has ξn > 1, it follows that

n ξn is an upper bound on the number of misclassiﬁed points. The parameter C is therefore analogous to (the inverse of) a regularization coefﬁcient because it controls the trade-off between minimizing training errors and controlling model complexity. In the limit C → ∞, we will recover the earlier support vector machine for separable data.

We now wish to minimize (7.21) subject to the constraints (7.20) together with ξn 0. The corresponding Lagrangian is given by

1 2

L(w,b,a) =

N

w 2+C

n=1

N

ξn−

n=1

N

an {tny(xn) − 1 + ξn}−

n=1

µnξn (7.22)

7.1. Maximum Margin Classiﬁers 333

where {an 0} and {µn 0} are Lagrange multipliers. The corresponding set of Appendix E KKT conditions are given by

an 0 (7.23) tny(xn) − 1 + ξn 0 (7.24)

an (tny(xn) − 1 + ξn) = 0 (7.25) µn 0 (7.26) ξn 0 (7.27)

µnξn = 0 (7.28) where n = 1,...,N.

We now optimize out w, b, and {ξn} making use of the deﬁnition (7.1) of y(x) to give

N

∂L ∂w

antnφ(xn) (7.29)

= 0 ⇒ w =

n=1

N

∂L ∂b

= 0 ⇒

antn = 0 (7.30)

n=1

∂L ∂ξn

= 0 ⇒ an = C − µn. (7.31)

Using these results to eliminate w, b, and {ξn} from the Lagrangian, we obtain the dual Lagrangian in the form

N

L(a) =

an −

n=1

N

N

1 2

anamtntmk(xn,xm) (7.32)

n=1

m=1

which is identical to the separable case, except that the constraints are somewhat different. To see what these constraints are, we note that an 0 is required because these are Lagrange multipliers. Furthermore, (7.31) together with µn 0 implies an C. We therefore have to minimize (7.32) with respect to the dual variables {an} subject to

0 an C (7.33) N

antn = 0 (7.34)

n=1

for n = 1,...,N, where (7.33) are known as box constraints. This again represents a quadratic programming problem. If we substitute (7.29) into (7.1), we see that predictions for new data points are again made by using (7.13).

We can now interpret the resulting solution. As before, a subset of the data points may have an = 0, in which case they do not contribute to the predictive

model (7.13). The remaining data points constitute the support vectors. These have an > 0 and hence from (7.25) must satisfy

tny(xn) = 1 − ξn. (7.35)

If an < C, then (7.31) implies that µn > 0, which from (7.28) requires ξn = 0 and hence such points lie on the margin. Points with an = C can lie inside the margin and can either be correctly classiﬁed if ξn 1 or misclassiﬁed if ξn > 1.

To determine the parameter b in (7.1), we note that those support vectors for which 0 < an < C have ξn = 0 so that tny(xn) = 1 and hence will satisfy

amtmk(xn,xm) + b = 1. (7.36)

tn

m∈S

Again, a numerically stable solution is obtained by averaging to give

1 NM

b =

amtmk(xn,xm) (7.37)

tn −

n∈M

m∈S

where M denotes the set of indices of data points having 0 < an < C.

An alternative, equivalent formulation of the support vector machine, known as the ν-SVM, has been proposed by Sch¨olkopf et al. (2000). This involves maximizing

1 2

L(a) = −

N

n=1

subject to the constraints

anamtntmk(xn,xm) (7.38)

m=1

0 an 1/N (7.39)

N

antn = 0 (7.40)

n=1

N

an ν. (7.41)

n=1

This approach has the advantage that the parameter ν, which replaces C, can be interpreted as both an upper bound on the fraction of margin errors (points for which ξn > 0 and hence which lie on the wrong side of the margin boundary and which may or may not be misclassiﬁed) and a lower bound on the fraction of support vectors. An example of the ν-SVM applied to a synthetic data set is shown in Figure 7.4. Here Gaussian kernels of the form exp(−γ x − x 2) have been used, with γ = 0.45.

Although predictions for new inputs are made using only the support vectors, the training phase (i.e., the determination of the parameters a and b) makes use of the whole data set, and so it is important to have efﬁcient algorithms for solving

For comparison with other error functions, we can divide by ln(2) so that the error function passes through the point (0,1). This rescaled error function is also plotted in Figure 7.5 and we see that it has a similar form to the support vector error function. The key difference is that the ﬂat region in ESV(yt) leads to sparse solutions.

Both the logistic error and the hinge loss can be viewed as continuous approximations to the misclassiﬁcation error. Another continuous error function that has sometimes been used to solve classiﬁcation problems is the squared error, which is again plotted in Figure 7.5. It has the property, however, of placing increasing emphasis on data points that are correctly classiﬁed but that are a long way from the decision boundary on the correct side. Such points will be strongly weighted at the expense of misclassiﬁed points, and so if the objective is to minimize the misclassiﬁcation rate, then a monotonically decreasing error function would be a better choice.

#### 7.1.3 Multiclass SVMs

The support vector machine is fundamentally a two-class classiﬁer. In practice, however, we often have to tackle problems involving K > 2 classes. Various methods have therefore been proposed for combining multiple two-class SVMs in order to build a multiclass classiﬁer.

One commonly used approach (Vapnik, 1998) is to construct K separate SVMs, in which the kth model yk(x) is trained using the data from class Ck as the positive examples and the data from the remaining K − 1 classes as the negative examples. This is known as the one-versus-the-rest approach. However, in Figure 4.2 we saw that using the decisions of the individual classiﬁers can lead to inconsistent results in which an input is assigned to multiple classes simultaneously. This problem is sometimes addressed by making predictions for new inputs x using

yk(x). (7.49)

y(x) = max

k

Unfortunately, this heuristic approach suffers from the problem that the different classiﬁers were trained on different tasks, and there is no guarantee that the realvalued quantities yk(x) for different classiﬁers will have appropriate scales.

Another problem with the one-versus-the-rest approach is that the training sets are imbalanced. For instance, if we have ten classes each with equal numbers of training data points, then the individual classiﬁers are trained on data sets comprising 90% negative examples and only 10% positive examples, and the symmetry of the original problem is lost. A variant of the one-versus-the-rest scheme was proposed by Lee et al. (2001) who modify the target values so that the positive class has target +1 and the negative class has target −1/(K − 1).

Weston and Watkins (1999) deﬁne a single objective function for training all K SVMs simultaneously, based on maximizing the margin from each to remaining classes. However, this can result in much slower training because, instead of solving K separate optimization problems each over N data points with an overall cost of O(KN2), a single optimization problem of size (K −1)N must be solved giving an overall cost of O(K2N2).

7.1. Maximum Margin Classiﬁers 339

Another approach is to train K(K −1)/2 different 2-class SVMs on all possible pairs of classes, and then to classify test points according to which class has the highest number of ‘votes’, an approach that is sometimes called one-versus-one. Again, we saw in Figure 4.2 that this can lead to ambiguities in the resulting classiﬁcation. Also, for large K this approach requires signiﬁcantly more training time than the one-versus-the-rest approach. Similarly, to evaluate test points, signiﬁcantly more computation is required.

The latter problem can be alleviated by organizing the pairwise classiﬁers into a directed acyclic graph (not to be confused with a probabilistic graphical model) leading to the DAGSVM (Platt et al., 2000). For K classes, the DAGSVM has a total of K(K − 1)/2 classiﬁers, and to classify a new test point only K − 1 pairwise classiﬁers need to be evaluated, with the particular classiﬁers used depending on which path through the graph is traversed.

A different approach to multiclass classiﬁcation, based on error-correcting output codes, was developed by Dietterich and Bakiri (1995) and applied to support vector machines by Allwein et al. (2000). This can be viewed as a generalization of the voting scheme of the one-versus-one approach in which more general partitions of the classes are used to train the individual classiﬁers. The K classes themselves are represented as particular sets of responses from the two-class classiﬁers chosen, and together with a suitable decoding scheme, this gives robustness to errors and to ambiguity in the outputs of the individual classiﬁers. Although the application of SVMs to multiclass classiﬁcation problems remains an open issue, in practice the one-versus-the-rest approach is the most widely used in spite of its ad-hoc formulation and its practical limitations.

There are also single-class support vector machines, which solve an unsupervised learning problem related to probability density estimation. Instead of modelling the density of data, however, these methods aim to ﬁnd a smooth boundary enclosing a region of high density. The boundary is chosen to represent a quantile of the density, that is, the probability that a data point drawn from the distribution will land inside that region is given by a ﬁxed number between 0 and 1 that is speciﬁed in advance. This is a more restricted problem than estimating the full density but may be sufﬁcient in speciﬁc applications. Two approaches to this problem using support vector machines have been proposed. The algorithm of Sch¨olkopf et al. (2001) tries to ﬁnd a hyperplane that separates all but a ﬁxed fraction ν of the training data from the origin while at the same time maximizing the distance (margin) of the hyperplane from the origin, while Tax and Duin (1999) look for the smallest sphere in feature space that contains all but a fraction ν of the data points. For kernels k(x,x ) that are functions only of x − x , the two algorithms are equivalent.

#### 7.1.4 SVMs for regression

We now extend support vector machines to regression problems while at the Section 3.1.4 same time preserving the property of sparseness. In simple linear regression, we

1 2

L(a, a) = −

−

N

N

(an − an)(am − am)k(xn,xm)

n=1

m=1

N

N

(an + an) +

(an − an)tn (7.61)

n=1

n=1

with respect to {an} and { an}, where we have introduced the kernel k(x,x ) = φ(x)Tφ(x ). Again, this is a constrained maximization, and to ﬁnd the constraints

we note that an 0 and an 0 are both required because these are Lagrange multipliers. Also µn 0 and µn 0 together with (7.59) and (7.60), require an C and an C, and so again we have the box constraints

0 an C (7.62) 0 an C (7.63)

together with the condition (7.58).

Substituting (7.57) into (7.1), we see that predictions for new inputs can be made using

N

(an − an)k(x,xn) + b (7.64)

y(x) =

n=1

which is again expressed in terms of the kernel function.

The corresponding Karush-Kuhn-Tucker (KKT) conditions, which state that at the solution the product of the dual variables and the constraints must vanish, are given by

an( + ξn + yn − tn) = 0 (7.65) an( + ξn − yn + tn) = 0 (7.66)

(C − an)ξn = 0 (7.67) (C − an) ξn = 0. (7.68)

From these we can obtain several useful results. First of all, we note that a coefﬁcient an can only be nonzero if + ξn + yn − tn = 0, which implies that the data point either lies on the upper boundary of the -tube (ξn = 0) or lies above the upper boundary (ξn > 0). Similarly, a nonzero value for an implies + ξn − yn + tn = 0, and such points must lie either on or below the lower boundary of the -tube.

Furthermore, the two constraints +ξn +yn −tn = 0 and + ξn −yn +tn = 0 are incompatible, as is easily seen by adding them together and noting that ξn and ξn are nonnegative while is strictly positive, and so for every data point xn, either an or an (or both) must be zero.

The support vectors are those data points that contribute to predictions given by

(7.64), in other words those for which either an = 0 or an = 0. These are points that lie on the boundary of the -tube or outside the tube. All points within the tube have

7.1. Maximum Margin Classiﬁers 343

an = an = 0. We again have a sparse solution, and the only terms that have to be evaluated in the predictive model (7.64) are those that involve the support vectors.

The parameter b can be found by considering a data point for which 0 < an < C, which from (7.67) must have ξn = 0, and from (7.65) must therefore satisfy

- yn − tn = 0. Using (7.1) and solving for b, we obtain b = tn − − wTφ(xn)

N

(am − am)k(xn,xm) (7.69)

= tn − −

m=1

where we have used (7.57). We can obtain an analogous result by considering a point for which 0 < an < C. In practice, it is better to average over all such estimates of b.

As with the classiﬁcation case, there is an alternative formulation of the SVM for regression in which the parameter governing complexity has a more intuitive interpretation (Sch¨olkopf et al., 2000). In particular, instead of ﬁxing the width of the insensitive region, we ﬁx instead a parameter ν that bounds the fraction of points lying outside the tube. This involves maximizing

1 2

L(a, a) = −

-

subject to the constraints

N

(an − an)(am − am)k(xn,xm)

n=1

m=1

N

(an − an)tn (7.70)

n=1

0 an C/N (7.71) 0 an C/N (7.72)

N

(an − an) = 0 (7.73)

n=1

N

(an + an) νC. (7.74)

n=1

It can be shown that there are at most νN data points falling outside the insensitive tube, while at least νN data points are support vectors and so lie either on the tube or outside it.

The use of a support vector machine to solve a regression problem is illustrated

Appendix A using the sinusoidal data set in Figure 7.8. Here the parameters ν and C have been chosen by hand. In practice, their values would typically be determined by crossvalidation.

case, because they apply to any choice for the distribution p(x,t), so long as both the training and the test examples are drawn (independently) from the same distribution, and for any choice for the function f(x) so long as it belongs to F. In real-world applications of machine learning, we deal with distributions that have signiﬁcant regularity, for example in which large regions of input space carry the same class label. As a consequence of the lack of any assumptions about the form of the distribution, the PAC bounds are very conservative, in other words they strongly over-estimate the size of data sets required to achieve a given generalization performance. For this reason, PAC bounds have found few, if any, practical applications.

One attempt to improve the tightness of the PAC bounds is the PAC-Bayesian framework (McAllester, 2003), which considers a distribution over the space F of functions, somewhat analogous to the prior in a Bayesian treatment. This still considers any possible choice for p(x,t), and so although the bounds are tighter, they are still very conservative.

### 7.2 Relevance Vector Machines

Support vector machines have been used in a variety of classiﬁcation and regression applications. Nevertheless, they suffer from a number of limitations, several of which have been highlighted already in this chapter. In particular, the outputs of an SVM represent decisions rather than posterior probabilities. Also, the SVM was originally formulated for two classes, and the extension to K > 2 classes is problematic. There is a complexity parameter C, or ν (as well as a parameter in the case of regression), that must be found using a hold-out method such as cross-validation. Finally, predictions are expressed as linear combinations of kernel functions that are centred on training data points and that are required to be positive deﬁnite.

The relevance vector machine or RVM (Tipping, 2001) is a Bayesian sparse kernel technique for regression and classiﬁcation that shares many of the characteristics of the SVM whilst avoiding its principal limitations. Additionally, it typically leads to much sparser models resulting in correspondingly faster performance on test data whilst maintaining comparable generalization error.

In contrast to the SVM we shall ﬁnd it more convenient to introduce the regression form of the RVM ﬁrst and then consider the extension to classiﬁcation tasks.

#### 7.2.1 RVM for regression

The relevance vector machine for regression is a linear model of the form studied in Chapter 3 but with a modiﬁed prior that results in sparse solutions. The model deﬁnes a conditional distribution for a real-valued target variable t, given an input vector x, which takes the form

p(t|x,w,β) = N(t|y(x),β−1) (7.76)

where β = σ−2 is the noise precision (inverse noise variance), and the mean is given by a linear model of the form

y(x) =

M

wiφi(x) = wTφ(x) (7.77)

i=1

with ﬁxed nonlinear basis functions φi(x), which will typically include a constant term so that the corresponding weight parameter represents a ‘bias’.

The relevance vector machine is a speciﬁc instance of this model, which is intended to mirror the structure of the support vector machine. In particular, the basis functions are given by kernels, with one kernel associated with each of the data points from the training set. The general expression (7.77) then takes the SVM-like form

N

y(x) =

wnk(x,xn) + b (7.78)

n=1

where b is a bias parameter. The number of parameters in this case is M = N + 1, and y(x) has the same form as the predictive model (7.64) for the SVM, except that the coefﬁcients an are here denoted wn. It should be emphasized that the subsequent analysis is valid for arbitrary choices of basis function, and for generality we shall work with the form (7.77). In contrast to the SVM, there is no restriction to positivedeﬁnite kernels, nor are the basis functions tied in either number or location to the training data points.

Suppose we are given a set of N observations of the input vector x, which we

denote collectively by a data matrix X whose nth row is xTn with n = 1,...,N. The corresponding target values are given by t = (t1,...,tN)T. Thus, the likelihood function is given by

p(t|X,w,β) =

N

p(tn|xn,w,β−1). (7.79)

n=1

Next we introduce a prior distribution over the parameter vector w and as in Chapter 3, we shall consider a zero-mean Gaussian prior. However, the key difference in the RVM is that we introduce a separate hyperparameter αi for each of the weight parameters wi instead of a single shared hyperparameter. Thus the weight prior takes the form

M

N(wi|0,αi−1) (7.80)

p(w|α) =

i=1

where αi represents the precision of the corresponding parameter wi, and α denotes (α1,...,αM)T. We shall see that, when we maximize the evidence with respect to these hyperparameters, a signiﬁcant proportion of them go to inﬁnity, and the corresponding weight parameters have posterior distributions that are concentrated at zero. The basis functions associated with these parameters therefore play no role

in the predictions made by the model and so are effectively pruned out, resulting in a sparse model.

Using the result (3.49) for linear regression models, we see that the posterior distribution for the weights is again Gaussian and takes the form

p(w|t,X,α,β) = N(w|m,Σ) (7.81) where the mean and covariance are given by

m = βΣΦTt (7.82) Σ = A + βΦTΦ −1 (7.83)

where Φ is the N × M design matrix with elements Φni = φi(xn), and A = diag(αi). Note that in the speciﬁc case of the model (7.78), we have Φ = K, where K is the symmetric (N + 1) × (N + 1) kernel matrix with elements k(xn,xm).

The values of α and β are determined using type-2 maximum likelihood, also Section 3.5 known as the evidence approximation, in which we maximize the marginal likeli-

hood function obtained by integrating out the weight parameters

p(t|X,α,β) = p(t|X,w,β)p(w|α)dw. (7.84)

Exercise 7.10 Because this represents the convolution of two Gaussians, it is readily evaluated to

give the log marginal likelihood in the form

lnp(t|X,α,β) = lnN(t|0,C)

1 2

N ln(2π) + ln|C| + tTC−1t (7.85)

= −

where t = (t1,...,tN)T, and we have deﬁned the N × N matrix C given by

C = β−1I + ΦA−1ΦT. (7.86)

Our goal is now to maximize (7.85) with respect to the hyperparameters α and β. This requires only a small modiﬁcation to the results obtained in Section 3.5 for the evidence approximation in the linear regression model. Again, we can identify two approaches. In the ﬁrst, we simply set the required derivatives of the marginal

Exercise 7.12 likelihood to zero and obtain the following re-estimation equations

γi m2i

αinew =

(7.87)

t − Φm 2 N − i γi

(βnew)−1 =

(7.88)

where mi is the ith component of the posterior mean m deﬁned by (7.82). The quantity γi measures how well the corresponding parameter wi is determined by the

Section 3.5.3 data and is deﬁned by

γi = 1 − αiΣii (7.89)

in which Σii is the ith diagonal component of the posterior covariance Σ given by (7.83). Learning therefore proceeds by choosing initial values for α and β, evaluating the mean and covariance of the posterior using (7.82) and (7.83), respectively, and then alternately re-estimating the hyperparameters, using (7.87) and (7.88), and re-estimating the posterior mean and covariance, using (7.82) and (7.83), until a suitable convergence criterion is satisﬁed.

The second approach is to use the EM algorithm, and is discussed in Section 9.3.4. These two approaches to ﬁnding the values of the hyperparameters that

Exercise 9.23 maximize the evidence are formally equivalent. Numerically, however, it is found that the direct optimization approach corresponding to (7.87) and (7.88) gives somewhat faster convergence (Tipping, 2001).

As a result of the optimization, we ﬁnd that a proportion of the hyperparameters

Section 7.2.2 {αi} are driven to large (in principle inﬁnite) values, and so the weight parameters wi corresponding to these hyperparameters have posterior distributions with mean and variance both zero. Thus those parameters, and the corresponding basis func-

tions φi(x), are removed from the model and play no role in making predictions for new inputs. In the case of models of the form (7.78), the inputs xn corresponding to the remaining nonzero weights are called relevance vectors, because they are identiﬁed through the mechanism of automatic relevance determination, and are analogous to the support vectors of an SVM. It is worth emphasizing, however, that this mechanism for achieving sparsity in probabilistic models through automatic relevance determination is quite general and can be applied to any model expressed as an adaptive linear combination of basis functions.

Having found values α and β for the hyperparameters that maximize the marginal likelihood, we can evaluate the predictive distribution over t for a new

Exercise 7.14 input x. Using (7.76) and (7.81), this is given by

p(t|x,X,t,α ,β ) = p(t|x,w,β )p(w|X,t,α ,β )dw

= N t|mTφ(x),σ2(x) . (7.90)

Thus the predictive mean is given by (7.76) with w set equal to the posterior mean m, and the variance of the predictive distribution is given by

σ2(x) = (β )−1 + φ(x)TΣφ(x) (7.91)

where Σ is given by (7.83) in which α and β are set to their optimized values α and β . This is just the familiar result (3.59) obtained in the context of linear regression. Recall that for localized basis functions, the predictive variance for linear regression models becomes small in regions of input space where there are no basis functions. In the case of an RVM with the basis functions centred on data points, the model will therefore become increasingly certain of its predictions when extrapolating outside the domain of the data (Rasmussen and Qui˜nonero-Candela, 2005), which of course

Section 6.4.2 is undesirable. The predictive distribution in Gaussian process regression does not

where σ(·) is the logistic sigmoid function deﬁned by (4.59). If we introduce a Gaussian prior over the weight vector w, then we obtain the model that has been considered already in Chapter 4. The difference here is that in the RVM, this model uses the ARD prior (7.80) in which there is a separate precision hyperparameter associated with each weight parameter.

In contrast to the regression model, we can no longer integrate analytically over the parameter vector w. Here we follow Tipping (2001) and use the Laplace ap-

Section 4.4 proximation, which was applied to the closely related problem of Bayesian logistic

regression in Section 4.5.1.

We begin by initializing the hyperparameter vector α. For this given value of α, we then build a Gaussian approximation to the posterior distribution and thereby obtain an approximation to the marginal likelihood. Maximization of this approximate marginal likelihood then leads to a re-estimated value for α, and the process is repeated until convergence.

Let us consider the Laplace approximation for this model in more detail. For a ﬁxed value of α, the mode of the posterior distribution over w is obtained by maximizing

lnp(w|t,α) = ln{p(t|w)p(w|α)} − lnp(t|α)

N

1 2

=

{tn lnyn + (1 − tn)ln(1 − yn)} −

n=1

wTAw + const (7.109)

where A = diag(αi). This can be done using iterative reweighted least squares (IRLS) as discussed in Section 4.3.3. For this, we need the gradient vector and

Exercise 7.18 Hessian matrix of the log posterior distribution, which from (7.109) are given by

∇lnp(w|t,α) = ΦT(t − y) − Aw (7.110) ∇∇lnp(w|t,α) = − ΦTBΦ + A (7.111)

where B is an N × N diagonal matrix with elements bn = yn(1 − yn), the vector y = (y1,...,yN)T, and Φ is the design matrix with elements Φni = φi(xn). Here we have used the property (4.88) for the derivative of the logistic sigmoid function. At convergence of the IRLS algorithm, the negative Hessian represents the inverse covariance matrix for the Gaussian approximation to the posterior distribution.

The mode of the resulting approximation to the posterior distribution, corresponding to the mean of the Gaussian approximation, is obtained setting (7.110) to zero, giving the mean and covariance of the Laplace approximation in the form

w = A−1ΦT(t − y) (7.112) Σ = ΦTBΦ + A −1 . (7.113)

We can now use this Laplace approximation to evaluate the marginal likelihood. Using the general result (4.135) for an integral evaluated using the Laplace approxi-

- 7.8 ( ) www For the regression support vector machine considered in Section 7.1.4, show that all training data points for which ξn > 0 will have an = C, and similarly all points for which ξn > 0 will have an = C.

- 7.9 ( ) Verify the results (7.82) and (7.83) for the mean and covariance of the posterior distribution over weights in the regression RVM.
- 7.10 ( ) www Derive the result (7.85) for the marginal likelihood function in the regression RVM, by performing the Gaussian integral over w in (7.84) using the technique of completing the square in the exponential.

- 7.11 ( ) Repeat the above exercise, but this time make use of the general result (2.115). 7.12 ( ) www Show that direct maximization of the log marginal likelihood (7.85) for

the regression relevance vector machine leads to the re-estimation equations (7.87) and (7.88) where γi is deﬁned by (7.89).

- 7.13 ( ) In the evidence framework for RVM regression, we obtained the re-estimation formulae (7.87) and (7.88) by maximizing the marginal likelihood given by (7.85). Extend this approach by inclusion of hyperpriors given by gamma distributions of the form (B.26) and obtain the corresponding re-estimation formulae for α and β by maximizing the corresponding posterior probability p(t,α,β|X) with respect to α and β.
- 7.14 ( ) Derive the result (7.90) for the predictive distribution in the relevance vector machine for regression. Show that the predictive variance is given by (7.91).
- 7.15 ( ) www Using the results (7.94) and (7.95), show that the marginal likelihood

(7.85) can be written in the form (7.96), where λ(αn) is deﬁned by (7.97) and the sparsity and quality factors are deﬁned by (7.98) and (7.99), respectively.

7.16 ( ) By taking the second derivative of the log marginal likelihood (7.97) for the

regression RVM with respect to the hyperparameter αi, show that the stationary point given by (7.101) is a maximum of the marginal likelihood.

7.17 ( ) Using (7.83) and (7.86), together with the matrix identity (C.7), show that

the quantities Sn and Qn deﬁned by (7.102) and (7.103) can be written in the form (7.106) and (7.107).

- 7.18 ( ) www Show that the gradient vector and Hessian matrix of the log posterior distribution (7.109) for the classiﬁcation relevance vector machine are given by (7.110) and (7.111).

- 7.19 ( ) Verify that maximization of the approximate log marginal likelihood function (7.114) for the classiﬁcation relevance vector machine leads to the result (7.116) for re-estimation of the hyperparameters.

3. Complex computations, required to perform inference and learning in sophisticated models, can be expressed in terms of graphical manipulations, in which underlying mathematical expressions are carried along implicitly.

A graph comprises nodes (also called vertices) connected by links (also known as edges or arcs). In a probabilistic graphical model, each node represents a random variable (or group of random variables), and the links express probabilistic relationships between these variables. The graph then captures the way in which the joint distribution over all of the random variables can be decomposed into a product of factors each depending only on a subset of the variables. We shall begin by discussing Bayesian networks, also known as directed graphical models, in which the links of the graphs have a particular directionality indicated by arrows. The other major class of graphical models are Markov random ﬁelds, also known as undirected graphical models, in which the links do not carry arrows and have no directional signiﬁcance. Directed graphs are useful for expressing causal relationships between random variables, whereas undirected graphs are better suited to expressing soft constraints between random variables. For the purposes of solving inference problems, it is often convenient to convert both directed and undirected graphs into a different representation called a factor graph.

In this chapter, we shall focus on the key aspects of graphical models as needed for applications in pattern recognition and machine learning. More general treatments of graphical models can be found in the books by Whittaker (1990), Lauritzen (1996), Jensen (1996), Castillo et al. (1997), Jordan (1999), Cowell et al. (1999), and Jordan (2007).
