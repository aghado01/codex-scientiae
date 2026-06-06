[Page 90]

Figure 2.1 Histogram plot of the binomial distribution (2.9) as a function of $m$ for $N = 10$ and $\mu = 0.25$.

![The image depicts a bar chart with a categorical scale starting from 0.1 and ending at 10. The x-axis is labeled m and the y-axis is labeled m. The chart is divided into four categories: 0.1, 1, 2, and 3. Each category has a corresponding bar corresponding to it. The bars are color-coded, with the color of the bar corresponding to the category. ### Description of the Chart: - **X-Axis (m):** The x-axis is labeled m and has a categorical scale starting from 0.1 to 10. - **Y-Axis (m):** The y-axis is labeled m and has a categorical scale starting from 0.1 to 10. ### Bar Chart Description: - **Bars:** The chart has four bars. The first bar is labeled 0.1 and is](../images/imageFile40.png)

which is also known as the sample mean. If we denote the number of observations of $x = 1$ (heads) within this data set by $m$, then we can write (2.7) in the form
$$
\mu_{\text{ML}} = \frac{m}{N}
\tag{2.8}
$$
so that the probability of landing heads is given, in this maximum likelihood framework, by the fraction of observations of heads in the data set.

Now suppose we ﬂip a coin, say, 3 times and happen to observe 3 heads. Then $N = m = 3$ and $\mu_{\text{ML}} = 1$. In this case, the maximum likelihood result would predict that all future observations should give heads. Common sense tells us that this is unreasonable, and in fact this is an extreme example of the over-ﬁtting associated with maximum likelihood. We shall see shortly how to arrive at more sensible conclusions through the introduction of a prior distribution over $\mu$.

We can also work out the distribution of the number $m$ of observations of $x = 1$, given that the data set has size $N$. This is called the binomial distribution, and from (2.5) we see that it is proportional to $\mu^m(1 - \mu)^{N-m}$. In order to obtain the normalization coefﬁcient we note that out of $N$ coin ﬂips, we have to add up all of the possible ways of obtaining $m$ heads, so that the binomial distribution can be written
$$
\text{Bin}(m|N,\mu) = \binom{N}{m} \mu^m (1 - \mu)^{N-m}
\tag{2.9}
$$
where
$$
\binom{N}{m} \equiv \frac{N!}{(N - m)!m!}
\tag{2.10}
$$
is the number of ways of choosing $m$ objects out of a total of $N$ identical objects. Figure 2.1 shows a plot of the binomial distribution for $N = 10$ and $\mu = 0.25$.

The mean and variance of the binomial distribution can be found by using the result of Exercise 1.10, which shows that for independent events the mean of the sum is the sum of the means, and the variance of the sum is the sum of the variances. Because $m = x_1 + \dots + x_N$, and for each observation the mean and variance are
