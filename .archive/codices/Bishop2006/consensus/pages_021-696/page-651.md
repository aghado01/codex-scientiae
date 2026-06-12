[Page 651]

Intuitively, we can understand the Viterbi algorithm as follows. Naively, we could consider explicitly all of the exponentially many paths through the lattice, evaluate the probability for each, and then select the path having the highest probability. However, we notice that we can make a dramatic saving in computational cost as follows. Suppose that for each path we evaluate its probability by summing up products of transition and emission probabilities as we work our way forward along each path through the lattice. Consider a particular time step $n$ and a particular state $k$ at that time step. There will be many possible paths converging on the corresponding node in the lattice diagram. However, we need only retain that particular path that so far has the highest probability. Because there are $K$ states at time step $n$, we need to keep track of $K$ such paths. At time step $n + 1$, there will be $K^2$ possible paths to consider, comprising $K$ possible paths leading out of each of the $K$ current states, but again we need only retain $K$ of these corresponding to the best path for each state at time $n+1$. When we reach the ﬁnal time step $N$ we will discover which state corresponds to the overall most probable path. Because there is a unique path coming into that state we can trace the path back to step $N - 1$ to see what state it occupied at that time, and so on back through the lattice to the state $n = 1$.

### 13.2.6 Extensions of the hidden Markov model

The basic hidden Markov model, along with the standard training algorithm based on maximum likelihood, has been extended in numerous ways to meet the requirements of particular applications. Here we discuss a few of the more important examples.

We see from the digits example in Figure 13.11 that hidden Markov models can be quite poor generative models for the data, because many of the synthetic digits look quite unrepresentative of the training data. If the goal is sequence classiﬁcation, there can be signiﬁcant beneﬁt in determining the parameters of hidden Markov models using discriminative rather than maximum likelihood techniques. Suppose we have a training set of $R$ observation sequences $\mathbf{X}_r$, where $r = 1, \dots, R$, each of which is labelled according to its class $m$, where $m = 1, \dots, M$. For each class, we have a separate hidden Markov model with its own parameters $\boldsymbol{\theta}_m$, and we treat the problem of determining the parameter values as a standard classiﬁcation problem in which we optimize the cross-entropy

$$
\sum_{r=1}^R \ln p(m_r|\mathbf{X}_r). \tag{13.72}
$$

Using Bayes’ theorem this can be expressed in terms of the sequence probabilities associated with the hidden Markov models

$$
\sum_{r=1}^R \ln \left\{ \frac{p(\mathbf{X}_r|\boldsymbol{\theta}_{m_r})p(m_r)}{\sum_{l=1}^M p(\mathbf{X}_r|\boldsymbol{\theta}_l)p(l)} \right\} \tag{13.73}
$$

where $p(m)$ is the prior probability of class $m$. Optimization of this cost function is more complex than for maximum likelihood (Kapadia, 1998), and in particular
