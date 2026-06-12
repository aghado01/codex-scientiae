[Page 637]

and make use of the deﬁnitions of γ and ξ , we obtain

�K

�N

�K

�K

Q(θ,θold) =

γ(z1k)lnπk +

ξ(zn−1,j,znk)lnAjk

n=2

j=1

k=1

k=1

�N

�K

+

γ(znk)lnp(xn|φk). (13.17)

n=1

k=1

The goal of the E step will be to evaluate the quantities γ(zn) and ξ(zn−1,zn) efﬁciently, and we shall discuss this in detail shortly.

In the M step, we maximize Q(θ,θold) with respect to the parameters θ =

{π,A,φ} in which we treat γ(zn) and ξ(zn−1,zn) as constant. Maximization with respect to π and A is easily achieved using appropriate Lagrange multipliers with

Exercise 13.5 the results

γ(z1k) �K

πk =

(13.18)

γ(z1j)

j=1

�N

ξ(zn−1,j,znk) �K

n=2

Ajk =

. (13.19)

�N

ξ(zn−1,j,znl)

n=2

l=1

The EM algorithm must be initialized by choosing starting values for π and A, which should of course respect the summation constraints associated with their probabilistic interpretation. Note that any elements of π or A that are set to zero initially will

Exercise 13.6 remain zero in subsequent EM updates. A typical initialization procedure would involve selecting random starting values for these parameters subject to the summation and non-negativity constraints. Note that no particular modiﬁcation to the EM results are required for the case of left-to-right models beyond choosing initial values for the elements Ajk in which the appropriate elements are set to zero, because these will remain zero throughout.

To maximize Q(θ,θold) with respect to φk, we notice that only the ﬁnal term in (13.17) depends on φk, and furthermore this term has exactly the same form as the data-dependent term in the corresponding function for a standard mixture distribution for i.i.d. data, as can be seen by comparison with (9.40) for the case of a Gaussian mixture. Here the quantities γ(znk) are playing the role of the responsibilities. If the parameters φk are independent for the different components, then this term decouples into a sum of terms one for each value of k, each of which can be maximized independently. We are then simply maximizing the weighted log likelihood function for the emission density p(x|φk) with weights γ(znk). Here we shall suppose that this maximization can be done efﬁciently. For instance, in the case of
