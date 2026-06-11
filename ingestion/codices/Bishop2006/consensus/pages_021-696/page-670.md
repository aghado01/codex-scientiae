[Page 670]

(13.68) where the quantities $\omega(\mathbf{z}_n)$ are deﬁned by (13.70). Show that the initial condition for this recursion is given by (13.69).

**13.17** ($\star$) www Show that the directed graph for the input-output hidden Markov model, given in Figure 13.18, can be expressed as a tree-structured factor graph of the form shown in Figure 13.15 and write down expressions for the initial factor $h(\mathbf{z}_1)$ and for the general factor $f_n(\mathbf{z}_{n-1}, \mathbf{z}_n)$ where $2 \le n \le N$.

**13.18** ($\star$) Using the result of Exercise 13.17, derive the recursion equations, including the initial conditions, for the forward-backward algorithm for the input-output hidden Markov model shown in Figure 13.18.

**13.19** ($\star$) www The Kalman ﬁlter and smoother equations allow the posterior distributions over individual latent variables, conditioned on all of the observed variables, to be found efﬁciently for linear dynamical systems. Show that the sequence of latent variable values obtained by maximizing each of these posterior distributions individually is the same as the most probable sequence of latent values. To do this, simply note that the joint distribution of all latent and observed variables in a linear dynamical system is Gaussian, and hence all conditionals and marginals will also be Gaussian, and then make use of the result (2.98).

**13.20** ($\star$) www Use the result (2.115) to prove (13.87).

**13.21** ($\star\star$) Use the results (2.115) and (2.116), together with the matrix identities (C.5) and (C.7), to derive the results (13.89), (13.90), and (13.91), where the Kalman gain matrix $\mathbf{K}_n$ is deﬁned by (13.92).

**13.22** ($\star$) www Using (13.93), together with the deﬁnitions (13.76) and (13.77) and the result (2.115), derive (13.96).

**13.23** ($\star\star$) Using (13.93), together with the deﬁnitions (13.76) and (13.77) and the result (2.116), derive (13.94), (13.95) and (13.97).

**13.24** ($\star$) www Consider a generalization of (13.75) and (13.76) in which we include constant terms $\mathbf{a}$ and $\mathbf{c}$ in the Gaussian means, so that

$$
p(\mathbf{z}_n|\mathbf{z}_{n-1}) = \mathcal{N}(\mathbf{z}_n|\mathbf{A}\mathbf{z}_{n-1} + \mathbf{a}, \mathbf{\Gamma}) \tag{13.127}
$$
$$
p(\mathbf{x}_n|\mathbf{z}_n) = \mathcal{N}(\mathbf{x}_n|\mathbf{C}\mathbf{z}_n + \mathbf{c}, \mathbf{\Sigma}). \tag{13.128}
$$

Show that this extension can be re-case in the framework discussed in this chapter by deﬁning a state vector $\mathbf{z}$ with an additional component ﬁxed at unity, and then augmenting the matrices $\mathbf{A}$ and $\mathbf{C}$ using extra columns corresponding to the parameters $\mathbf{a}$ and $\mathbf{c}$.

**13.25** ($\star\star$) In this exercise, we show that when the Kalman ﬁlter equations are applied to independent observations, they reduce to the results given in Section 2.3 for the maximum likelihood solution for a single Gaussian distribution. Consider the problem of ﬁnding the mean $\boldsymbol{\mu}$ of a single Gaussian random variable $\mathbf{x}$, in which we are given a set of independent observations $\{\mathbf{x}_1, \dots, \mathbf{x}_N\}$. To model this we can use
