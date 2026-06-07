[Page 329]

Figure 6.6 Illustration of the sampling of data points $\{t_n\}$ from a Gaussian process. The blue curve shows a sample function from the Gaussian process prior over functions, and the red points show the values of $y_n$ obtained by evaluating the function at a set of input values $\{\mathbf{x}_n\}$. The corresponding values of $\{t_n\}$, shown in green, are obtained by adding independent Gaussian noise to each of the $\{y_n\}$.

![The image is a line graph that shows the trend of a variable over time. The x-axis represents the time, ranging from 0 to 3, while the y-axis represents the value. The graph has two lines, each representing a different time period. The first line starts at 0 and goes up to 1, then goes up to 2, and finally to 3. The second line starts at 0 and goes up to 3, then goes up to 4, and finally to 5. The graph is labeled as trend, and the title of the graph is trend. The x-axis is labeled t, and the y-axis is labeled t. The graph is drawn with a simple, linear scale of range 0 to 3, with a minimum of 0 and a maximum of 3. The line graph shows a general upward trend over time. The first line starts at 0](../images/imageFile136.png)

suitable kernels.

Note that the mean (6.66) of the predictive distribution can be written, as a function of $\mathbf{x}_{N+1}$, in the form

$$
m(\mathbf{x}_{N+1}) = \sum_{n=1}^N a_n k(\mathbf{x}_n,\mathbf{x}_{N+1}) \tag{6.68}
$$

where $a_n$ is the $n^{\text{th}}$ component of $\mathbf{C}_N^{-1}\mathbf{t}$. Thus, if the kernel function $k(\mathbf{x}_n,\mathbf{x}_m)$ depends only on the distance $\|\mathbf{x}_n - \mathbf{x}_m\|$, then we obtain an expansion in radial basis functions.

The results (6.66) and (6.67) deﬁne the predictive distribution for Gaussian process regression with an arbitrary kernel function $k(\mathbf{x}_n,\mathbf{x}_m)$. In the particular case in which the kernel function $k(\mathbf{x},\mathbf{x}')$ is deﬁned in terms of a ﬁnite set of basis functions, we can derive the results obtained previously in Section 3.3.2 for linear regression starting from the Gaussian process viewpoint.

For such models, we can therefore obtain the predictive distribution either by taking a parameter space viewpoint and using the linear regression result or by taking a function space viewpoint and using the Gaussian process result.

The central computational operation in using Gaussian processes will involve the inversion of a matrix of size $N \times N$, for which standard methods require $O(N^3)$ computations. By contrast, in the basis function model we have to invert a matrix $\mathbf{S}_N$ of size $M \times M$, which has $O(M^3)$ computational complexity. Note that for both viewpoints, the matrix inversion must be performed once for the given training set. For each new test point, both methods require a vector-matrix multiply, which has cost $O(N^2)$ in the Gaussian process case and $O(M^2)$ for the linear basis function model. If the number $M$ of basis functions is smaller than the number $N$ of data points, it will be computationally more efﬁcient to work in the basis function
