[Page 529]

sides of (10.199) by q\i(θ) and integrating to give

###### K = fj(θ)q\j(θ)dθ (10.200)

where we have used the fact that qnew(θ) is normalized. The value of K can therefore be found by matching zeroth-order moments

###### fj(θ)q\j(θ)dθ = fj(θ)q\j(θ)dθ. (10.201)

Combining this with (10.197), we then see that K = Zj and so can be found by evaluating the integral in (10.197).

In practice, several passes are made through the set of factors, revising each factor in turn. The posterior distribution p(θ|D) is then approximated using (10.191), and the model evidence p(D) can be approximated by using (10.190) with the factors

fi(θ) replaced by their approximations fi(θ). Expectation Propagation We are given a joint distribution over observed data D and stochastic variables θ in the form of a product of factors

fi(θ) (10.202)

p(D,θ) =

i

and we wish to approximate the posterior distribution p(θ|D) by a distribution of the form

1 Z i

fi(θ). (10.203)

q(θ) =

We also wish to approximate the model evidence p(D).

- 1. Initialize all of the approximating factors fi(θ).
- 2. Initialize the posterior approximation by setting

q(θ) ∝

i

fi(θ). (10.204)

- 3. Until convergence:


- (a) Choose a factor fj(θ) to reﬁne.
- (b) Remove fj(θ) from the posterior by division


q(θ) fj(θ)

q\j(θ) =

. (10.205)
