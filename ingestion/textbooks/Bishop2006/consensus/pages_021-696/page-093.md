[Page 93]

![The image consists of a graph with two axes labeled as prior and posterior. The graph is a line graph with a horizontal axis labeled as time and a vertical axis labeled as posterior. The graph shows a downward trend, indicating that the likelihood function is decreasing over time. The line is drawn from the bottom left to the top right of the graph. The graph has two peaks on the horizontal axis, labeled as prior and posterior. The line is drawn from the bottom left to the top right of the graph. The line is a straight line, with a slight curve at the top. The graph also has two peaks on the vertical axis, labeled as posterior and posterior_likelihood. The line is drawn from the bottom left to the top right of the graph. The line is a straight line, with a slight curve at the top. The graph also has two peaks on the horizontal axis,](../images/imageFile42.png)

Figure 2.3 Illustration of one step of sequential Bayesian inference. The prior is given by a beta distribution with parameters $a = 2$, $b = 2$, and the likelihood function, given by (2.9) with $N = m = 1$, corresponds to a single observation of $x = 1$, so that the posterior is given by a beta distribution with parameters $a = 3$, $b = 2$.

distribution by multiplying by the likelihood function for the new observation and then normalizing to obtain the new, revised posterior distribution. At each stage, the posterior is a beta distribution with some total number of (prior and actual) observed values for $x = 1$ and $x = 0$ given by the parameters $a$ and $b$. Incorporation of an additional observation of $x = 1$ simply corresponds to incrementing the value of $a$ by $1$, whereas for an observation of $x = 0$ we increment $b$ by $1$. Figure 2.3 illustrates one step in this process.

We see that this sequential approach to learning arises naturally when we adopt a Bayesian viewpoint. It is independent of the choice of prior and of the likelihood function and depends only on the assumption of i.i.d. data. Sequential methods make use of observations one at a time, or in small batches, and then discard them before the next observations are used. They can be used, for example, in real-time learning scenarios where a steady stream of data is arriving, and predictions must be made before all of the data is seen. Because they do not require the whole data set to be stored or loaded into memory, sequential methods are also useful for large data sets.

Section 2.3.5 Maximum likelihood methods can also be cast into a sequential framework.

If our goal is to predict, as best we can, the outcome of the next trial, then we must evaluate the predictive distribution of $x$, given the observed data set $\mathcal{D}$. From the sum and product rules of probability, this takes the form

$$
p(x = 1|\mathcal{D}) = \int_{0}^{1} p(x = 1|\mu)p(\mu|\mathcal{D}) \text{d}\mu = \int_{0}^{1} \mu p(\mu|\mathcal{D}) \text{d}\mu = \mathbb{E}[\mu|\mathcal{D}]. \tag{2.19}
$$

Using the result (2.18) for the posterior distribution $p(\mu|\mathcal{D})$, together with the result (2.15) for the mean of the beta distribution, we obtain

$$
p(x = 1|\mathcal{D}) = \frac{m + a}{m + a + l + b} \tag{2.20}
$$

which has a simple interpretation as the total fraction of observations (both real observations and fictitious prior observations) that correspond to $x = 1$. Note that in the limit of an infinitely large data set $m, l \to \infty$ the result (2.20) reduces to the maximum likelihood result (2.8). As we shall see, it is a very general property that the Bayesian and maximum likelihood results will agree in the limit of an infinitely
