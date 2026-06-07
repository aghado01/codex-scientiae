[Page 322]

the input variable, which is given by

$$
\begin{aligned}
y(\mathbf{x}) = \mathbb{E}[t|\mathbf{x}] &= \int_{-\infty}^{\infty} t p(t|\mathbf{x}) dt \\
&= \frac{\int tp(\mathbf{x},t) dt}{\int p(\mathbf{x},t) dt} \\
&= \frac{\sum_n \int t f(\mathbf{x} - \mathbf{x}_n, t - t_n) dt}{\sum_m \int f(\mathbf{x} - \mathbf{x}_m, t - t_m) dt}.
\end{aligned} \tag{6.43}
$$

We now assume for simplicity that the component density functions have zero mean so that

$$
\int_{-\infty}^{\infty} f(\mathbf{x},t) t dt = 0 \tag{6.44}
$$

for all values of $\mathbf{x}$. Using a simple change of variable, we then obtain

$$
\begin{aligned}
y(\mathbf{x}) &= \frac{\sum_n g(\mathbf{x} - \mathbf{x}_n)t_n}{\sum_m g(\mathbf{x} - \mathbf{x}_m)} \\
&= \sum_n k(\mathbf{x},\mathbf{x}_n) t_n
\end{aligned} \tag{6.45}
$$

where $n,m = 1,\dots,N$ and the kernel function $k(\mathbf{x},\mathbf{x}_n)$ is given by

$$
k(\mathbf{x},\mathbf{x}_n) = \frac{g(\mathbf{x} - \mathbf{x}_n)}{\sum_m g(\mathbf{x} - \mathbf{x}_m)} \tag{6.46}
$$

and we have deﬁned

$$
g(\mathbf{x}) = \int_{-\infty}^{\infty} f(\mathbf{x},t) dt. \tag{6.47}
$$

The result (6.45) is known as the Nadaraya-Watson model, or kernel regression (Nadaraya, 1964; Watson, 1964). For a localized kernel function, it has the property of giving more weight to the data points $\mathbf{x}_n$ that are close to $\mathbf{x}$. Note that the kernel (6.46) satisﬁes the summation constraint

$$
\sum_{n=1}^N k(\mathbf{x},\mathbf{x}_n) = 1.
$$
