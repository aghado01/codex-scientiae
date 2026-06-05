[Page 97]

Figure 2.4 The Dirichlet distribution over three variables µ1, µ2, µ3 is conﬁned to a simplex (a bounded linear manifold) of the form shown, as a consequence of the constraints 0 µk 1 and P

k µk = 1.

µ2

µ1

µ3

Plots of the Dirichlet distribution over the simplex, for various settings of the parameters αk, are shown in Figure 2.5.

Multiplying the prior (2.38) by the likelihood function (2.34), we obtain the posterior distribution for the parameters {µk} in the form

K

k+mk−1

µα

p(µ|D,α) ∝ p(D|µ)p(µ|α) ∝

k . (2.40)

k=1

We see that the posterior distribution again takes the form of a Dirichlet distribution, conﬁrming that the Dirichlet is indeed a conjugate prior for the multinomial. This allows us to determine the normalization coefﬁcient by comparison with (2.38) so that

p(µ|D,α) = Dir(µ|α + m)

K

Γ(α0 + N) Γ(α1 + m1)···Γ(αK + mK)

=

k=1

k+mk−1

µα

k (2.41)

where we have denoted m = (m1,...,mK)T. As for the case of the binomial distribution with its beta prior, we can interpret the parameters αk of the Dirichlet prior as an effective number of observations of xk = 1.

Note that two-state quantities can either be represented as binary variables and

###### Lejeune Dirichlet

![image 21](../../../../../images/imageFile21.png)

from ‘le jeune de Richelet’ (the young person from Richelet). Dirichlet’s ﬁrst paper, which was published in 1825, brought him instant fame. It concerned Fermat’s last theorem, which claims that there are no positive integer solutions to xn + yn = zn for n > 2. Dirichlet gave a partial proof for the case n = 5, which was sent to Legendre for review and who in turn completed the proof. Later, Dirichlet gave a complete proof for n = 14, although a full proof of Fermat’s last theorem for arbitrary n had to wait until the work of Andrew Wiles in the closing years of the 20th century.

###### 1805–1859

Johann Peter Gustav Lejeune Dirichlet was a modest and reserved mathematician who made contributions in number theory, mechanics, and astronomy, and who gave the ﬁrst rigorous analysis of

Fourier series. His family originated from Richelet in Belgium, and the name Lejeune Dirichlet comes
