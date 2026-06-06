[Page 72]

![The image is a bar chart titled probabilities. The chart is divided into two main sections: the x-axis and the y-axis. The x-axis is labeled probabilities and the y-axis is labeled probabilities. The chart has two categories, H and H - 1.77, with a range of 0.25 to 0.55. The y-axis is labeled probabilities and has a scale of range 0.0 to 0.55. The y-axis is labeled probabilities and has a scale of range 0.0 to 0.55. The chart has two sets of bars, one for each category. The first set of bars is labeled H and the second set of bars is labeled H - 1.77. The values of the bars for each category are as follows: - H](../images/imageFile34.png)

Figure 1.30 Histograms of two probability distributions over 30 bins illustrating the higher value of the entropy $H$ for the broader distribution. The largest entropy would arise from a uniform distribution that would give $H = -\ln(1/30) = 3.40$.

from which we ﬁnd that all of the $p(x_i)$ are equal and are given by $p(x_i) = 1/M$ where $M$ is the total number of states $x_i$. The corresponding value of the entropy is then $H = \ln M$. This result can also be derived from Jensen's inequality (to be discussed shortly). To verify that the stationary point is indeed a maximum, we can evaluate the second derivative of the entropy, which gives

$$
\frac{\partial^2 \widetilde{H}}{\partial p(x_i) \partial p(x_j)} = -I_{ij} \frac{1}{p_i} \tag{1.100}
$$

where $I_{ij}$ are the elements of the identity matrix.

We can extend the deﬁnition of entropy to include distributions $p(x)$ over continuous variables $x$ as follows. First divide $x$ into bins of width $\Delta$. Then, assuming $p(x)$ is continuous, the mean value theorem (Weisstein, 1999) tells us that, for each such bin, there must exist a value $x_i$ such that

$$
\int_{i\Delta}^{(i+1)\Delta} p(x) \, dx = p(x_i)\Delta. \tag{1.101}
$$

We can now quantize the continuous variable $x$ by assigning any value $x$ to the value $x_i$ whenever $x$ falls in the $i^{\text{th}}$ bin. The probability of observing the value $x_i$ is then $p(x_i)\Delta$. This gives a discrete distribution for which the entropy takes the form

$$
H_{\Delta} = - \sum_{i} p(x_i)\Delta \ln(p(x_i)\Delta) = - \sum_{i} p(x_i)\Delta \ln p(x_i) - \ln \Delta \tag{1.102}
$$

where we have used $\sum_i p(x_i)\Delta = 1$, which follows from (1.101). We now omit the second term $-\ln \Delta$ on the right-hand side of (1.102) and then consider the limit
