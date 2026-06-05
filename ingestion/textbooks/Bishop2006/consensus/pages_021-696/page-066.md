[Page 66]

independent, so that

$$
p(x_I, x_B \mid \mathcal{C}_k) = p(x_I \mid \mathcal{C}_k)p(x_B \mid \mathcal{C}_k). \tag{1.84}
$$

This is an example of a conditional independence property, because the independence holds when the distribution is conditioned on the class $\mathcal{C}_k$. The posterior probability, given both the X-ray and blood data, is then given by

$$
p(\mathcal{C}_k \mid x_I, x_B) \propto p(x_I, x_B \mid \mathcal{C}_k)p(\mathcal{C}_k) \propto p(x_I \mid \mathcal{C}_k)p(x_B \mid \mathcal{C}_k)p(\mathcal{C}_k) \propto \frac{p(\mathcal{C}_k \mid x_I)p(\mathcal{C}_k \mid x_B)}{p(\mathcal{C}_k)}. \tag{1.85}
$$

Thus we need the class prior probabilities $p(\mathcal{C}_k)$, which we can easily estimate from the fractions of data points in each class, and then we need to normalize the resulting posterior probabilities so they sum to one. The particular conditional independence assumption (1.84) is an example of the naive Bayes model. Note that the joint marginal distribution $p(x_I, x_B)$ will typically not factorize under this model. We shall see in later chapters how to construct models for combining data that do not require the conditional independence assumption (1.84).

###### 1.5.5 Loss functions for regression

So far, we have discussed decision theory in the context of classiﬁcation problems. We now turn to the case of regression problems, such as the curve-ﬁtting example discussed earlier. The decision stage consists of choosing a speciﬁc estimate $y(x)$ of the value of $t$ for each input $x$. Suppose that in doing so, we incur a loss $L(t, y(x))$. The average, or expected, loss is then given by

$$
\mathbb{E}[L] = \iint L(t, y(x))p(x, t)\, dx\, dt. \tag{1.86}
$$

A common choice of loss function in regression problems is the squared loss given by $L(t, y(x)) = \{y(x) - t\}^2$. In this case, the expected loss can be written

$$
\mathbb{E}[L] = \iint \{y(x) - t\}^2 p(x, t)\, dx\, dt. \tag{1.87}
$$

Our goal is to choose $y(x)$ so as to minimize $\mathbb{E}[L]$. If we assume a completely ﬂexible function $y(x)$, we can do this formally using the calculus of variations to give

$$
\frac{\delta \mathbb{E}[L]}{\delta y(x)} = 2 \int \{y(x) - t\} p(x, t)\, dt = 0. \tag{1.88}
$$

Solving for $y(x)$, and using the sum and product rules of probability, we obtain

$$
y(x) = \frac{\int t p(x, t)\, dt}{p(x)} = \int t p(t \mid x)\, dt = \mathbb{E}_t[t \mid x]. \tag{1.89}
$$
