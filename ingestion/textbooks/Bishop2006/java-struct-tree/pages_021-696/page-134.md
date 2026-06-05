[Page 134]

which we can solve for µ to give µ = σ(η), where

1 1 + exp(−η)

σ(η) =

(2.199)

is called the logistic sigmoid function. Thus we can write the Bernoulli distribution using the standard representation (2.194) in the form

p(x|η) = σ(−η)exp(ηx) (2.200)

where we have used 1 − σ(η) = σ(−η), which is easily proved from (2.199). Comparison with (2.194) shows that

u(x) = x (2.201) h(x) = 1 (2.202) g(η) = σ(−η). (2.203)

Next consider the multinomial distribution that, for a single observation x, takes the form

k = exp� M

xk lnµk� (2.204)

�M

�

µx

p(x|µ) =

k

k=1

k=1

where x = (x1,...,xN)T. Again, we can write this in the standard representation (2.194) so that

p(x|η) = exp(ηTx) (2.205)

where ηk = lnµk, and we have deﬁned η = (η1,...,ηM)T. Again, comparing with (2.194) we have

u(x) = x (2.206) h(x) = 1 (2.207) g(η) = 1. (2.208)

Note that the parameters ηk are not independent because the parameters µk are subject to the constraint

�M

µk = 1 (2.209)

k=1

so that, given any M − 1 of the parameters µk, the value of the remaining parameter is ﬁxed. In some circumstances, it will be convenient to remove this constraint by expressing the distribution in terms of only M − 1 parameters. This can be achieved by using the relationship (2.209) to eliminate µM by expressing it in terms of the remaining {µk} where k = 1,...,M − 1, thereby leaving M − 1 parameters. Note that these remaining parameters are still subject to the constraints

0 � µk � 1,

M�−1

µk � 1. (2.210)
