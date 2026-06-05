[Page 341]

- 6.11 ( ) By making use of the expansion (6.25), and then expanding the middle factor as a power series, show that the Gaussian kernel (6.23) can be expressed as the inner product of an inﬁnite-dimensional feature vector.
- 6.12 ( ) www Consider the space of all possible subsets A of a given ﬁxed set D. Show that the kernel function (6.27) corresponds to an inner product in a feature space of dimensionality 2|D| deﬁned by the mapping φ(A) where A is a subset of D and the element φU(A), indexed by the subset U, is given by

φU(A) =

1, if U ⊆ A; 0, otherwise.

(6.95)

Here U ⊆ A denotes that U is either a subset of A or is equal to A.

- 6.13 ( ) Show that the Fisher kernel, deﬁned by (6.33), remains invariant if we make a nonlinear transformation of the parameter vector θ → ψ(θ), where the function ψ(·) is invertible and differentiable.
- 6.14 ( ) www Write down the form of the Fisher kernel, deﬁned by (6.33), for the case of a distribution p(x|µ) = N(x|µ,S) that is Gaussian with mean µ and ﬁxed covariance S.

- 6.15 ( ) By considering the determinant of a 2 × 2 Gram matrix, show that a positivedeﬁnite kernel function k(x,x ) satisﬁes the Cauchy-Schwartz inequality

k(x1,x2)2 k(x1,x1)k(x2,x2). (6.96)

- 6.16 ( ) Consider a parametric model governed by the parameter vector w together

with a data set of input values x1,...,xN and a nonlinear feature mapping φ(x). Suppose that the dependence of the error function on w takes the form

J(w) = f(wTφ(x1),...,wTφ(xN)) + g(wTw) (6.97) where g(·) is a monotonically increasing function. By writing w in the form

w =

N

n=1

αnφ(xn) + w⊥ (6.98)

show that the value of w that minimizes J(w) takes the form of a linear combination of the basis functions φ(xn) for n = 1,...,N.

- 6.17 ( ) www Consider the sum-of-squares error function (6.39) for data having noisy inputs, where ν(ξ) is the distribution of the noise. Use the calculus of variations to minimize this error function with respect to the function y(x), and hence show that the optimal solution is given by an expansion of the form (6.40) in which the basis functions are given by (6.41).
