[Page 81]

Note that the precise relationship between the $w$ coefﬁcients and $\widetilde{w}$ coefﬁcients need not be made explicit. Use this result to show that the number of independent parameters $n(D, M)$, which appear at order $M$, satisﬁes the following recursion relation

$$
n(D, M) = \sum_{i=1}^{D} n(i, M - 1). \tag{1.135}
$$

Next use proof by induction to show that the following result holds

$$
\sum_{i=1}^{D} \frac{(i + M - 2)!}{(i - 1)!(M - 1)!} = \frac{(D + M - 1)!}{(D - 1)!M!}. \tag{1.136}
$$

This can be done by ﬁrst proving the result for $D = 1$ and arbitrary $M$ by making use of the result $0! = 1$, then assuming it is correct for dimension $D$ and verifying that it is correct for dimension $D + 1$. Finally, use the two previous results, together with proof by induction, to show

$$
n(D, M) = \frac{(D + M - 1)!}{(D - 1)!M!}. \tag{1.137}
$$

To do this, ﬁrst show that the result is true for $M = 2$, and any value of $D \ge 1$, by comparison with the result of Exercise 1.14. Then make use of (1.135), together with (1.136), to show that, if the result holds at order $M - 1$, then it will also hold at order $M$.

1. 16. In Exercise 1.15, we proved the result (1.135) for the number of independent parameters in the $M$th-order term of a $D$-dimensional polynomial. We now ﬁnd an expression for the total number $N(D, M)$ of independent parameters in all of the terms up to and including the $M$th order. First show that $N(D, M)$ satisﬁes

$$
N(D, M) = \sum_{m=0}^{M} n(D, m). \tag{1.138}
$$

where $n(D, m)$ is the number of independent parameters in the term of order $m$. Now make use of the result (1.137), together with proof by induction, to show that

$$
N(D, M) = \frac{(D + M)!}{D!M!}. \tag{1.139}
$$

This can be done by ﬁrst proving that the result holds for $M = 0$ and arbitrary $D \ge 1$, then assuming that it holds at order $M$, and hence showing that it holds at order $M + 1$. Finally, make use of Stirling’s approximation in the form

$$
n! \simeq n^n e^{-n}. \tag{1.140}
$$

for large $n$ to show that, for $D \gg M$, the quantity $N(D, M)$ grows like $D^M$, and for $M \gg D$ it grows like $M^D$. Consider a cubic ($M = 3$) polynomial in $D$ dimensions, and evaluate numerically the total number of independent parameters for (i) $D = 10$ and (ii) $D = 100$, which correspond to typical small-scale and medium-scale machine learning applications.
