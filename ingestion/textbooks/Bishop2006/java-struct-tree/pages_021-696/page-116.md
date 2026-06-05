[Page 116]

Robbins and Monro (1951). We shall assume that the conditional variance of z is ﬁnite so that

�

�

(z − f)2 |θ

< ∞ (2.128)

E

and we shall also, without loss of generality, consider the case where f(θ) > 0 for θ > θ� and f(θ) < 0 for θ < θ�, as is the case in Figure 2.10. The Robbins-Monro procedure then deﬁnes a sequence of successive estimates of the root θ� given by

θ(N) = θ(N−1) + aN−1z(θ(N−1)) (2.129)

where z(θ(N)) is an observed value of z when θ takes the value θ(N). The coefﬁcients {aN} represent a sequence of positive numbers that satisfy the conditions

aN = 0 (2.130) �∞

lim

N→∞

aN = ∞ (2.131) �∞

N=1

a2N < ∞. (2.132)

N=1

It can then be shown (Robbins and Monro, 1951; Fukunaga, 1990) that the sequence of estimates given by (2.129) does indeed converge to the root with probability one. Note that the ﬁrst condition (2.130) ensures that the successive corrections decrease in magnitude so that the process can converge to a limiting value. The second condition (2.131) is required to ensure that the algorithm does not converge short of the root, and the third condition (2.132) is needed to ensure that the accumulated noise has ﬁnite variance and hence does not spoil convergence.

Now let us consider how a general maximum likelihood problem can be solved sequentially using the Robbins-Monro algorithm. By deﬁnition, the maximum likelihood solution θML is a stationary point of the log likelihood function and hence satisﬁes

lnp(xn|θ)��

� 1 N

� � � �

�N

∂ ∂θ

= 0. (2.133)

n=1

θML

Exchanging the derivative and the summation, and taking the limit N → ∞ we have

lnp(xn|θ) = Ex �

lnp(x|θ)� (2.134)

�N

1 N

∂ ∂θ

∂ ∂θ

lim

N→∞

n=1

and so we see that ﬁnding the maximum likelihood solution corresponds to ﬁnding the root of a regression function. We can therefore apply the Robbins-Monro procedure, which now takes the form

∂ ∂θ(N−1) lnp(xN|θ(N−1)). (2.135)

θ(N) = θ(N−1) + aN−1
