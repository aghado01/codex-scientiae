[Page 67]

Figure 1.28 The regression function $y(\mathbf{x})$, which minimizes the expected squared loss, is given by the mean of the conditional distribution $p(t|\mathbf{x})$.

![The image depicts a graph with two lines, labeled as y(x) and y(t). The x-axis is labeled as t and the y-axis is labeled as p(t). The graph shows a linear relationship between the two lines, where the slope of the line on the left side of the graph is constant and the slope of the line on the right side of the graph is increasing. The line on the left side of the graph is shown to be a straight line, while the line on the right side of the graph is shown to be a curved line. The graph shows a general trend of increasing slope as the x-axis increases, and a general trend of decreasing slope as the y-axis increases. The slope of the line on the left side of the graph is constant, while the slope of the line on the right side of the graph is increasing. The graph also shows a general trend of increasing and decreasing on the right side of the graph](../images/imageFile32.png)

which is the conditional average of $t$ conditioned on $\mathbf{x}$ and is known as the *regression function*. This result is illustrated in Figure 1.28. It can readily be extended to multiple target variables represented by the vector $\mathbf{t}$, in which case the optimal solution is the conditional average $\mathbf{y}(\mathbf{x}) = \mathbb{E}_{\mathbf{t}}[\mathbf{t}|\mathbf{x}]$. We can also derive this result in a slightly different way, which will also shed light on the nature of the regression problem. Armed with the knowledge that the optimal solution is the conditional expectation, we can expand the square term as follows
$$
\begin{align*}
\{y(\mathbf{x}) - t\}^{2} &= \{y(\mathbf{x}) - \mathbb{E}[t|\mathbf{x}] + \mathbb{E}[t|\mathbf{x}] - t\}^{2} \\
&= \{y(\mathbf{x}) - \mathbb{E}[t|\mathbf{x}]\}^{2} + 2\{y(\mathbf{x}) - \mathbb{E}[t|\mathbf{x}]\}\{\mathbb{E}[t|\mathbf{x}] - t\} + \{\mathbb{E}[t|\mathbf{x}] - t\}^{2}
\end{align*}
$$
where, to keep the notation uncluttered, we use $\mathbb{E}[t|\mathbf{x}]$ to denote $\mathbb{E}_{t}[t|\mathbf{x}]$. Substituting into the loss function and performing the integral over $t$, we see that the cross-term vanishes and we obtain an expression for the loss function in the form
$$
\mathbb{E}[L] = \int \{y(\mathbf{x}) - \mathbb{E}[t|\mathbf{x}]\}^{2} p(\mathbf{x})\,d\mathbf{x} + \int \{\mathbb{E}[t|\mathbf{x}] - t\}^{2} p(\mathbf{x})\,d\mathbf{x}. \tag{1.90}
$$

The function $y(\mathbf{x})$ we seek to determine enters only in the ﬁrst term, which will be minimized when $y(\mathbf{x})$ is equal to $\mathbb{E}[t|\mathbf{x}]$, in which case this term will vanish. This is simply the result that we derived previously and that shows that the optimal least squares predictor is given by the conditional mean. The second term is the variance of the distribution of $t$, averaged over $\mathbf{x}$. It represents the intrinsic variability of the target data and can be regarded as noise. Because it is independent of $y(\mathbf{x})$, it represents the irreducible minimum value of the loss function.

As with the classiﬁcation problem, we can either determine the appropriate probabilities and then use these to make optimal decisions, or we can build models that make decisions directly. Indeed, we can identify three distinct approaches to solving regression problems given, in order of decreasing complexity, by:

(a) First solve the inference problem of determining the joint density $p(\mathbf{x}, t)$. Then normalize to ﬁnd the conditional density $p(t|\mathbf{x})$, and ﬁnally marginalize to ﬁnd the conditional mean given by (1.89).
