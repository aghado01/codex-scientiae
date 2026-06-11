[Page 507]

Figure 10.8 Probabilistic graphical model representing the joint distribution (10.90) for the Bayesian linear regression model.

β

φn

tn

N

α

w

posterior distribution given by the factorized expression

q(w,α) = q(w)q(α). (10.91)

We can ﬁnd re-estimation equations for the factors in this distribution by making use of the general result (10.9). Recall that for each factor, we take the log of the joint distribution over all variables and then average with respect to those variables not in that factor. Consider ﬁrst the distribution over α. Keeping only terms that have a functional dependence on α, we have

lnq�(α) = lnp(α) + Ew [lnp(w|α)] + const

M 2

α 2

= (a0 − 1)lnα − b0α +

E[wTw] + const. (10.92)

lnα −

We recognize this as the log of a gamma distribution, and so identifying the coefﬁcients of α and lnα we obtain

q�(α) = Gam(α|aN,bN) (10.93) where

M 2

aN = a0 +

(10.94)

1 2

E[wTw]. (10.95)

bN = b0 +

Similarly, we can ﬁnd the variational re-estimation equation for the posterior distribution over w. Again, using the general result (10.9), and keeping only those terms that have a functional dependence on w, we have

lnq�(w) = lnp(t|w) + Eα [lnp(w|α)] + const (10.96)

�N

1 2

β 2

= −

E[α]wTw + const (10.97)

{wTφn − tn}2 −

n=1

1 2

�

�

= −

E[α]I + βΦTΦ

w + βwTΦTt + const. (10.98)

wT

Because this is a quadratic form, the distribution q�(w) is Gaussian, and so we can complete the square in the usual way to identify the mean and covariance, giving

q�(w) = N(w|mN,SN) (10.99)
