[Page 196]

Show that the corresponding posterior distribution takes the same functional form, so that

p(w,β|t) = N(w|mN,β−1SN)Gam(β|aN,bN) (3.113) and ﬁnd expressions for the posterior parameters mN, SN, aN, and bN.

3.13 (��) Show that the predictive distribution p(t|x,t) for the model discussed in Ex-

ercise 3.12 is given by a Student’s t-distribution of the form

p(t|x,t) = St(t|µ,λ,ν) (3.114) and obtain expressions for µ, λ and ν.

3.14 (��) In this exercise, we explore in more detail the properties of the equivalent kernel deﬁned by (3.62), where SN is deﬁned by (3.54). Suppose that the basis functions φj(x) are linearly independent and that the number N of data points is greater than the number M of basis functions. Furthermore, let one of the basis functions be constant, say φ0(x) = 1. By taking suitable linear combinations of these basis functions, we can construct a new basis set ψj(x) spanning the same space but that are orthonormal, so that

�N

ψj(xn)ψk(xn) = Ijk (3.115)

n=1

where Ijk is deﬁned to be 1 if j = k and 0 otherwise, and we take ψ0(x) = 1. Show that for α = 0, the equivalent kernel can be written as k(x,x�) = ψ(x)Tψ(x�)

where ψ = (ψ1,...,ψM)T. Use this result to show that the kernel satisﬁes the summation constraint

�N

k(x,xn) = 1. (3.116)

n=1

3.15 (�) www Consider a linear basis function model for regression in which the parameters α and β are set using the evidence framework. Show that the function E(mN) deﬁned by (3.82) satisﬁes the relation 2E(mN) = N.

3.16 (��) Derive the result (3.86) for the log evidence function p(t|α,β) of the linear

regression model by making use of (2.115) to evaluate the integral (3.77) directly.

3.17 (�) Show that the evidence function for the Bayesian linear regression model can

be written in the form (3.78) in which E(w) is deﬁned by (3.79).

3.18 (��) www By completing the square over w, show that the error function (3.79)

in Bayesian linear regression can be written in the form (3.80).

3.19 (��) Show that the integration over w in the Bayesian linear regression model gives

the result (3.85). Hence show that the log marginal likelihood is given by (3.86).
