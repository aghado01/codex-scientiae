[Page 189]

Multiplying through by 2α and rearranging, we obtain

1 λi + α

αmTNmN = M − α

i

= γ. (3.90)

Since there are M terms in the sum over i, the quantity γ can be written

γ =

i

λi α + λi

. (3.91)

The interpretation of the quantity γ will be discussed shortly. From (3.90) we see

- Exercise 3.20 that the value of α that maximizes the marginal likelihood satisﬁes


γ mTNmN

α =

. (3.92)

Note that this is an implicit solution for α not only because γ depends on α, but also because the mode mN of the posterior distribution itself depends on the choice of α. We therefore adopt an iterative procedure in which we make an initial choice for α and use this to ﬁnd mN, which is given by (3.53), and also to evaluate γ, which is given by (3.91). These values are then used to re-estimate α using (3.92), and the process repeated until convergence. Note that because the matrix ΦTΦ is ﬁxed, we can compute its eigenvalues once at the start and then simply multiply these by β to obtain the λi.

It should be emphasized that the value of α has been determined purely by looking at the training data. In contrast to maximum likelihood methods, no independent data set is required in order to optimize the model complexity.

We can similarly maximize the log marginal likelihood (3.86) with respect to β. To do this, we note that the eigenvalues λi deﬁned by (3.87) are proportional to β, and hence dλi/dβ = λi/β giving

1 β i

λi λi + α

d dβ

d dβ i

γ β

ln|A| =

=

ln(λi + α) =

. (3.93)

The stationary point of the marginal likelihood therefore satisﬁes

N 2β −

0 =

N

1 2

n=1

Exercise 3.22 and rearranging we obtain

γ 2β

tn − mTNφ(xn) 2 −

(3.94)

N

1 β

1 N − γ

tn − mTNφ(xn) 2 . (3.95)

=

n=1

Again, this is an implicit solution for β and can be solved by choosing an initial value for β and then using this to calculate mN and γ and then re-estimate β using (3.95), repeating until convergence. If both α and β are to be determined from the data, then their values can be re-estimated together after each update of γ.
