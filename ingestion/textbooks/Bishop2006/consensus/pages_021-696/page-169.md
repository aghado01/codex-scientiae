[Page 169]

inside the braces, and then expand, we obtain
$$
\begin{aligned}
&\{y(x;\mathcal{D}) - \mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})] + \mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})] - h(x)\}^{2} \\
&= \{y(x;\mathcal{D}) - \mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})]\}^{2} + \{\mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})] - h(x)\}^{2} \\
&\quad + 2\{y(x;\mathcal{D}) - \mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})]\}\{\mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})] - h(x)\}.
\end{aligned} \tag{3.39}
$$

We now take the expectation of this expression with respect to $\mathcal{D}$ and note that the final term will vanish, giving
$$
\begin{aligned}
&\mathbb{E}_{\mathcal{D}} \left[ \{y(x;\mathcal{D}) - h(x)\}^{2} \right] \\
&= \underbrace{\{\mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})] - h(x)\}^{2}}_{(\text{bias})^{2}} + \underbrace{\mathbb{E}_{\mathcal{D}} \left[ \{y(x;\mathcal{D}) - \mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})]\}^{2} \right]}_{\text{variance}}.
\end{aligned} \tag{3.40}
$$

We see that the expected squared difference between $y(x;\mathcal{D})$ and the regression function $h(x)$ can be expressed as the sum of two terms. The first term, called the squared bias, represents the extent to which the average prediction over all data sets differs from the desired regression function. The second term, called the variance, measures the extent to which the solutions for individual data sets vary around their average, and hence this measures the extent to which the function $y(x;\mathcal{D})$ is sensitive to the particular choice of data set. We shall provide some intuition to support these definitions shortly when we consider a simple example.

So far, we have considered a single input value $x$. If we substitute this expansion back into (3.37), we obtain the following decomposition of the expected squared loss
$$
\text{expected loss} = (\text{bias})^{2} + \text{variance} + \text{noise} \tag{3.41}
$$
where
$$
(\text{bias})^{2} = \int \{\mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})] - h(x)\}^{2} p(x) \, \mathrm{d}x \tag{3.42}
$$
$$
\text{variance} = \int \mathbb{E}_{\mathcal{D}} \left[ \{y(x;\mathcal{D}) - \mathbb{E}_{\mathcal{D}}[y(x;\mathcal{D})]\}^{2} \right] p(x) \, \mathrm{d}x \tag{3.43}
$$
$$
\text{noise} = \int \{h(x) - t\}^{2} p(x,t) \, \mathrm{d}x \mathrm{d}t \tag{3.44}
$$
and the bias and variance terms now refer to integrated quantities.

Our goal is to minimize the expected loss, which we have decomposed into the sum of a (squared) bias, a variance, and a constant noise term. As we shall see, there is a trade-off between bias and variance, with very flexible models having low bias and high variance, and relatively rigid models having high bias and low variance. The model with the optimal predictive capability is the one that leads to the best balance between bias and variance. This is illustrated by considering the sinusoidal data set from Chapter 1. Here we generate $100$ data sets, each containing $N = 25$ data points, independently from the sinusoidal curve $h(x) = \sin(2\pi x)$. The data sets are indexed by $l = 1,\ldots,L$, where $L = 100$, and for each data set $\mathcal{D}^{(l)}$ we
