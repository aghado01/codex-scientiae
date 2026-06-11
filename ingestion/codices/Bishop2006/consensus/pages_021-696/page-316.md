[Page 316]

###### Techniques for Constructing New Kernels.

Given valid kernels $k_1(\mathbf{x},\mathbf{x}')$ and $k_2(\mathbf{x},\mathbf{x}')$, the following new kernels will also be valid:

$$
\begin{aligned}
k(\mathbf{x},\mathbf{x}') &= c k_1(\mathbf{x},\mathbf{x}') \tag{6.13} \\
k(\mathbf{x},\mathbf{x}') &= f(\mathbf{x})k_1(\mathbf{x},\mathbf{x}')f(\mathbf{x}') \tag{6.14} \\
k(\mathbf{x},\mathbf{x}') &= q(k_1(\mathbf{x},\mathbf{x}')) \tag{6.15} \\
k(\mathbf{x},\mathbf{x}') &= \exp(k_1(\mathbf{x},\mathbf{x}')) \tag{6.16} \\
k(\mathbf{x},\mathbf{x}') &= k_1(\mathbf{x},\mathbf{x}') + k_2(\mathbf{x},\mathbf{x}') \tag{6.17} \\
k(\mathbf{x},\mathbf{x}') &= k_1(\mathbf{x},\mathbf{x}')k_2(\mathbf{x},\mathbf{x}') \tag{6.18} \\
k(\mathbf{x},\mathbf{x}') &= k_3(\boldsymbol{\phi}(\mathbf{x}),\boldsymbol{\phi}(\mathbf{x}')) \tag{6.19} \\
k(\mathbf{x},\mathbf{x}') &= \mathbf{x}^T\mathbf{A}\mathbf{x}' \tag{6.20} \\
k(\mathbf{x},\mathbf{x}') &= k_a(\mathbf{x}_a,\mathbf{x}_a') + k_b(\mathbf{x}_b,\mathbf{x}_b') \tag{6.21} \\
k(\mathbf{x},\mathbf{x}') &= k_a(\mathbf{x}_a,\mathbf{x}_a')k_b(\mathbf{x}_b,\mathbf{x}_b') \tag{6.22}
\end{aligned}
$$

where $c > 0$ is a constant, $f(\cdot)$ is any function, $q(\cdot)$ is a polynomial with nonnegative coefﬁcients, $\boldsymbol{\phi}(\mathbf{x})$ is a function from $\mathbf{x}$ to $\mathbb{R}^M$, $k_3(\cdot,\cdot)$ is a valid kernel in $\mathbb{R}^M$, $\mathbf{A}$ is a symmetric positive semideﬁnite matrix, $\mathbf{x}_a$ and $\mathbf{x}_b$ are variables (not necessarily disjoint) with $\mathbf{x} = (\mathbf{x}_a,\mathbf{x}_b)$, and $k_a$ and $k_b$ are valid kernel functions over their respective spaces.

Equipped with these properties, we can now embark on the construction of more complex kernels appropriate to speciﬁc applications. We require that the kernel $k(\mathbf{x},\mathbf{x}')$ be symmetric and positive semideﬁnite and that it expresses the appropriate form of similarity between $\mathbf{x}$ and $\mathbf{x}'$ according to the intended application. Here we consider a few common examples of kernel functions. For a more extensive discussion of ‘kernel engineering’, see Shawe-Taylor and Cristianini (2004).

We saw that the simple polynomial kernel $k(\mathbf{x},\mathbf{x}') = (\mathbf{x}^T\mathbf{x}')^2$ contains only terms of degree two. If we consider the slightly generalized kernel $k(\mathbf{x},\mathbf{x}') = (\mathbf{x}^T\mathbf{x}' + c)^2$ with $c > 0$, then the corresponding feature mapping $\boldsymbol{\phi}(\mathbf{x})$ contains constant and linear terms as well as terms of order two. Similarly, $k(\mathbf{x},\mathbf{x}') = (\mathbf{x}^T\mathbf{x}')^M$ contains all monomials of order $M$. For instance, if $\mathbf{x}$ and $\mathbf{x}'$ are two images, then the kernel represents a particular weighted sum of all possible products of $M$ pixels in the ﬁrst image with $M$ pixels in the second image. This can similarly be generalized to include all terms up to degree $M$ by considering $k(\mathbf{x},\mathbf{x}') = (\mathbf{x}^T\mathbf{x}' + c)^M$ with $c > 0$. Using the results (6.17) and (6.18) for combining kernels we see that these will all be valid kernel functions.

Another commonly used kernel takes the form

$$
k(\mathbf{x},\mathbf{x}') = \exp \left( -\frac{\|\mathbf{x} - \mathbf{x}'\|^2}{2\sigma^2} \right) \tag{6.23}
$$

and is often called a ‘Gaussian’ kernel. Note, however, that in this context it is not interpreted as a probability density, and hence the normalization coefﬁcient is
