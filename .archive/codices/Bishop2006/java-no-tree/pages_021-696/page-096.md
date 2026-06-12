[Page 96]

We can solve for the Lagrange multiplier λ by substituting (2.32) into the constraint

k µk = 1 to give λ = −N. Thus we obtain the maximum likelihood solution in the form

mk N

µMLk =

(2.33) which is the fraction of the N observations for which xk = 1.

We can consider the joint distribution of the quantities m1,...,mK, conditioned on the parameters µ and on the total number N of observations. From (2.29) this takes the form

Mult(m1,m2,...,mK|µ,N) =

N m1m2 ...mK

K

µm

k (2.34)

k

k=1

which is known as the multinomial distribution. The normalization coefﬁcient is the number of ways of partitioning N objects into K groups of size m1,...,mK and is given by

N! m1!m2!...mK!

N m1m2 ...mK

=

. (2.35) Note that the variables mk are subject to the constraint

###### K

mk = N. (2.36)

k=1

###### 2.2.1 The Dirichlet distribution

We now introduce a family of prior distributions for the parameters {µk} of the multinomial distribution (2.34). By inspection of the form of the multinomial distribution, we see that the conjugate prior is given by

K

p(µ|α) ∝

k=1

k−1

µα

k (2.37)

where 0 µk 1 and k µk = 1. Here α1,...,αK are the parameters of the distribution, and α denotes (α1,...,αK)T. Note that, because of the summation constraint, the distribution over the space of the {µk} is conﬁned to a simplex of dimensionality K − 1, as illustrated for K = 3 in Figure 2.4.

- Exercise 2.9 The normalized form for this distribution is by


K

Γ(α0) Γ(α1)···Γ(αK)

k−1

µα

Dir(µ|α) =

k (2.38)

k=1

which is called the Dirichlet distribution. Here Γ(x) is the gamma function deﬁned by (1.141) while

K

α0 =

αk. (2.39)

k=1
