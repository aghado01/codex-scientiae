[Page 97]

Figure 2.4 The Dirichlet distribution over three variables µ 1 , µ 2 , µ 3 is conﬁned to a simplex (a bounded linear manifold) of the form shown, as a consequence of the constraints 0 µ k 1 and P k µ k = 1 .

µ

2

µ

1

µ

3

Plots of the Dirichlet distribution over the simplex, for various settings of the parameters α k , are shown in Figure 2.5. Multiplying the prior (2.38) by the likelihood function (2.34), we obtain the

Multiplying the prior (2.38) by the likelihood function (2.34), we obtain the posterior distribution for the parameters { µ k } in the form

$$
p ( \mu | \mathcal { D } , \alpha ) \, \in p ( \mathcal { D } | \mu ) p ( \mu | \alpha ) \, \in \prod _ { k = 1 } ^ { K } \mu _ { k } ^ { \alpha _ { k } + m _ { k } - 1 } . \\ \intertext { t h a t h the posteriori distribution again takes the form of a Dirichlet distribution }
$$

We see that the posterior distribution again takes the form of a Dirichlet distribution, conﬁrming that the Dirichlet is indeed a conjugate prior for the multinomial. This allows us to determine the normalization coefﬁcient by comparison with (2.38) so that

$$
p ( \mu | \mathcal { D } , \alpha ) & \ = \ \ D i r ( \mu | \alpha + m ) \\ & = \ \frac { \Gamma ( \alpha _ { 0 } + N ) } { \Gamma ( \alpha _ { 1 } + m _ { 1 } ) \cdots \Gamma ( \alpha _ { K } + m _ { K } ) } \prod _ { k = 1 } ^ { K } \mu _ { k } ^ { \alpha _ { k } + m _ { k } - 1 } \quad ( 2 . 4 1 ) \\ \intertext { s u r b e w h a v e d o n t e d \ m _ { K } = ( m _ { K } , \quad m _ { K } ) ^ { T } }
$$

where we have denoted m = ( m 1 ,...,m K ) T . As for the case of the binomial distribution with its beta prior, we can interpret the parameters α k of the Dirichlet prior as an effective number of observations of x k = 1 . Note that two-state quantities can either be represented as binary variables and

Note that two-state quantities can either be represented as binary variables and

![image 11](../images/imageFile11.png)

Lejeune Dirichlet 1805–1859

Johann Peter Gustav Lejeune Dirichlet was a modest and reserved mathematician who made contributions in number theory, mechanics, and astronomy, and who gave the ﬁrst rigorous analysis of His family originated from Richelet

Fourier series. His family originated from Richelet in Belgium, and the name Lejeune Dirichlet comes from 'le jeune de Richelet' (the young person from Richelet). Dirichlet's first paper, which was published in 1825, brought him instant fame. It concerned Fermat's last theorem, which claims that there are no positive integer solutions to x n + y n = z n for n > 2 . Dirichlet gave a partial proof for the case n = 5 , which was sent to Legendre for review and who in turn completed the proof. Later, Dirichlet gave a complete proof for n = 14 , although a full proof of Fermat's last theorem for arbitrary n had to wait until the work of Andrew Wiles in the closing years of the 20 th century.
