[Page 135]

Making use of the constraint (2.209), the multinomial distribution in this representation then becomes

exp

M

k=1

= exp

= exp

We now identify

xk lnµk

M−1

M−1

M−1

xk lnµk + 1 −

xk ln 1 −

k=1

k=1

k=1

M−1

µk 1 − Mj=1−1 µj

xk ln

+ ln 1 −

k=1

µk

M−1

µk . (2.211)

k=1

µk 1 − j µj

ln

= ηk (2.212)

which we can solve for µk by ﬁrst summing both sides over k and then rearranging and back-substituting to give

exp(ηk) 1 + j exp(ηj)

µk =

. (2.213)

This is called the softmax function, or the normalized exponential. In this representation, the multinomial distribution therefore takes the form

M−1

p(x|η) = 1 +

exp(ηk)

k=1

−1

exp(ηTx). (2.214)

This is the standard form of the exponential family, with parameter vector η = (η1,...,ηM−1)T in which

u(x) = x (2.215) h(x) = 1 (2.216)

−1

M−1

g(η) = 1 +

exp(ηk)

. (2.217)

k=1

Finally, let us consider the Gaussian distribution. For the univariate Gaussian, we have

p(x|µ,σ2) =

=

1 (2πσ2)1/2

- 1

- 2σ2


exp −

1 (2πσ2)1/2

- 1

- 2σ2


exp −

(x − µ)2 (2.218)

- 1

- 2σ2


µ σ2

x2 +

µ2 (2.219)

x −
