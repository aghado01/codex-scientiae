[Page 135]

Making use of the constraint (2.209), the multinomial distribution in this representation then becomes

exp� M

xk lnµk�

�

k=1

= exp�M−1

xk lnµk + �1 −

xk�ln�1 −

µk��

M�−1

M�−1

�

k=1

k=1

k=1

= exp�M−1

xk ln� µk 1 − �M−1

� + ln�1 −

µk��. (2.211)

M�−1

�

j=1 µj

k=1

k=1

We now identify

ln� µk 1 − �

� = ηk (2.212)

j µj

which we can solve for µk by ﬁrst summing both sides over k and then rearranging and back-substituting to give

exp(ηk) 1 +

µk =

. (2.213)

�

j exp(ηj)

This is called the softmax function, or the normalized exponential. In this representation, the multinomial distribution therefore takes the form

p(x|η) = �1 +

exp(ηk)�−1 exp(ηTx). (2.214)

M�−1

k=1

This is the standard form of the exponential family, with parameter vector η = (η1,...,ηM−1)T in which

u(x) = x (2.215) h(x) = 1 (2.216)

g(η) = �1 +

exp(ηk)�−1 . (2.217)

M�−1

k=1

Finally, let us consider the Gaussian distribution. For the univariate Gaussian, we have

exp�−

(x − µ)2� (2.218)

1 (2πσ2)1/2

1 2σ2

p(x|µ,σ2) =

exp�−

µ2� (2.219)

1 (2πσ2)1/2

1 2σ2

1 2σ2

µ σ2

=

x2 +

x −
