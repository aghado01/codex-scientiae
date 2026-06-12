[Page 222]

where we have deﬁned

N1 N

N2 N

S =

S1 +

S2 (4.78) S1 =

N1 �

1

(xn − µ1)(xn − µ1)T (4.79)

n∈C1

N2 �

1

S2 =

(xn − µ2)(xn − µ2)T. (4.80)

n∈C2

Using the standard result for the maximum likelihood solution for a Gaussian distribution, we see that Σ = S, which represents a weighted average of the covariance matrices associated with each of the two classes separately.

This result is easily extended to the K class problem to obtain the corresponding

maximum likelihood solutions for the parameters in which each class-conditional Exercise 4.10 density is Gaussian with a shared covariance matrix. Note that the approach of ﬁtting

Gaussian distributions to the classes is not robust to outliers, because the maximum Section 2.3.7 likelihood estimation of a Gaussian is not robust.

4.2.3 Discrete features

Let us now consider the case of discrete feature values xi. For simplicity, we begin by looking at binary feature values xi ∈ {0,1} and discuss the extension to more general discrete features shortly. If there are D inputs, then a general distribution would correspond to a table of 2D numbers for each class, containing 2D − 1 independent variables (due to the summation constraint). Because this grows exponentially with the number of features, we might seek a more restricted representa-

Section 8.2.2 tion. Here we will make the naive Bayes assumption in which the feature values are

treated as independent, conditioned on the class Ck. Thus we have class-conditional distributions of the form

�D

p(x|Ck) =

ki(1 − µki)1−xi (4.81)

µx

i

i=1

which contain D independent parameters for each class. Substituting into (4.63) then gives

�D

ak(x) =

{xi lnµki + (1 − xi)ln(1 − µki)} + lnp(Ck) (4.82)

i=1

which again are linear functions of the input values xi. For the case of K = 2 classes, we can alternatively consider the logistic sigmoid formulation given by (4.57). Analogous results are obtained for discrete variables each of which can take M > 2

Exercise 4.11 states.

4.2.4 Exponential family

As we have seen, for both Gaussian distributed and discrete inputs, the posterior class probabilities are given by generalized linear models with logistic sigmoid (K =
