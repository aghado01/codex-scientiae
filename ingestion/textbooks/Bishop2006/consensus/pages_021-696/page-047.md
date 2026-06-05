[Page 47]

function can be written in the form

$$
\ln p(\mathbf{x} \mid \mu, \sigma^2) = -\frac{1}{2\sigma^2} \sum_{n=1}^{N} (x_n - \mu)^2 - \frac{N}{2} \ln \sigma^2 - \frac{N}{2} \ln(2\pi). \tag{1.54}
$$

Maximizing (1.54) with respect to $\mu$, we obtain the maximum likelihood solution

given by

$$
\mu_{\mathrm{ML}} = \frac{1}{N} \sum_{n=1}^{N} x_n. \tag{1.55}
$$

which is the sample mean, i.e., the mean of the observed values $\{x_n\}$. Similarly, maximizing (1.54) with respect to $\sigma^2$, we obtain the maximum likelihood solution for the variance in the form

$$
\sigma_{\mathrm{ML}}^2 = \frac{1}{N} \sum_{n=1}^{N} (x_n - \mu_{\mathrm{ML}})^2. \tag{1.56}
$$

which is the sample variance measured with respect to the sample mean $\mu_{\mathrm{ML}}$. Note that we are performing a joint maximization of (1.54) with respect to $\mu$ and $\sigma^2$, but in the case of the Gaussian distribution the solution for $\mu$ decouples from that for $\sigma^2$ so that we can ﬁrst evaluate (1.55) and then subsequently use this result to evaluate (1.56).

Later in this chapter, and also in subsequent chapters, we shall highlight the signiﬁcant limitations of the maximum likelihood approach. Here we give an indication of the problem in the context of our solutions for the maximum likelihood parameter settings for the univariate Gaussian distribution. In particular, we shall show that the maximum likelihood approach systematically underestimates the variance of the distribution. This is an example of a phenomenon called bias and is related to the problem of over-ﬁtting encountered in the context of polynomial curve ﬁtting.

We ﬁrst note that the maximum likelihood solutions $\mu_{\mathrm{ML}}$ and $\sigma_{\mathrm{ML}}^2$ are functions of the data set values $x_1, \ldots, x_N$. Consider the expectations of these quantities with respect to the data set values, which themselves come from a Gaussian distribution

with parameters $\mu$ and $\sigma^2$. It is straightforward to show that

$$
\mathbb{E}[\mu_{\mathrm{ML}}] = \mu. \tag{1.57}
$$

$$
\mathbb{E}[\sigma_{\mathrm{ML}}^2] = \frac{N - 1}{N} \sigma^2. \tag{1.58}
$$

so that on average the maximum likelihood estimate will obtain the correct mean but will underestimate the true variance by a factor $(N - 1)/N$. The intuition behind this result is given by Figure 1.15.

From (1.58) it follows that the following estimate for the variance parameter is unbiased

$$
\sigma^2 = \frac{N}{N - 1} \sigma_{\mathrm{ML}}^2 = \frac{1}{N - 1} \sum_{n=1}^{N} (x_n - \mu_{\mathrm{ML}})^2. \tag{1.59}
$$
