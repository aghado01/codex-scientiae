[Page 97]

Figure 2.4 The Dirichlet distribution over three variables $\mu_1$, $\mu_2$, $\mu_3$ is conﬁned to a simplex (a bounded linear manifold) of the form shown, as a consequence of the constraints $0 \le \mu_k \le 1$ and $\sum_k \mu_k = 1$.

Plots of the Dirichlet distribution over the simplex, for various settings of the parameters $\alpha_k$, are shown in Figure 2.5.

Multiplying the prior (2.38) by the likelihood function (2.34), we obtain the posterior distribution for the parameters $\{\mu_k\}$ in the form

$$
p(\boldsymbol{\mu} \mid \mathcal{D}, \boldsymbol{\alpha}) \propto p(\mathcal{D} \mid \boldsymbol{\mu})p(\boldsymbol{\mu} \mid \boldsymbol{\alpha}) \propto \prod_{k=1}^{K} \mu_k^{\alpha_k + m_k - 1}. \tag{2.40}
$$

We see that the posterior distribution again takes the form of a Dirichlet distribution, conﬁrming that the Dirichlet is indeed a conjugate prior for the multinomial. This allows us to determine the normalization coefﬁcient by comparison with (2.38) so that

$$
p(\boldsymbol{\mu} \mid \mathcal{D}, \boldsymbol{\alpha}) = \operatorname{Dir}(\boldsymbol{\mu} \mid \boldsymbol{\alpha} + \mathbf{m}) = \frac{\Gamma(\alpha_0 + N)}{\Gamma(\alpha_1 + m_1)\cdots\Gamma(\alpha_K + m_K)} \prod_{k=1}^{K} \mu_k^{\alpha_k + m_k - 1}. \tag{2.41}
$$

where we have denoted $\mathbf{m} = (m_1, \ldots, m_K)^T$. As for the case of the binomial distribution with its beta prior, we can interpret the parameters $\alpha_k$ of the Dirichlet prior as an effective number of observations of $x_k = 1$.

Note that two-state quantities can either be represented as binary variables and modelled using the binomial distribution (2.9) or as 1-of-2 variables and modelled using the multinomial distribution (2.34) with $K = 2$.

###### Lejeune Dirichlet

![image 21](../../../../../images/imageFile21.png)

###### 1805–1859

Johann Peter Gustav Lejeune Dirichlet was a modest and reserved mathematician who made contributions in number theory, mechanics, and astronomy, and who gave the ﬁrst rigorous analysis of Fourier series. His family originated from Richelet in Belgium, and the name Lejeune Dirichlet comes from ‘le jeune de Richelet’ (the young person from Richelet). Dirichlet’s ﬁrst paper, which was published in 1825, brought him instant fame. It concerned Fermat’s last theorem, which claims that there are no positive integer solutions to $x^n + y^n = z^n$ for $n > 2$. Dirichlet gave a partial proof for the case $n = 5$, which was sent to Legendre for review and who in turn completed the proof. Later, Dirichlet gave a complete proof for $n = 14$, although a full proof of Fermat’s last theorem for arbitrary $n$ had to wait until the work of Andrew Wiles in the closing years of the 20th century.
