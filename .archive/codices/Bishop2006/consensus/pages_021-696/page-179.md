[Page 179]

Figure 3.10 The equivalent kernel $k(x, x')$ for the Gaussian basis functions in Figure 3.1, shown as a plot of $x$ versus $x'$, together with three slices through this matrix corresponding to three different values of $x$. The data set used to generate this kernel comprised $200$ values of $x$ equally spaced over the interval $(-1, 1)$.

![The image consists of a graph. The graph is a line graph, and it is colored blue. The graph has a few lines, but they are not very clear. The lines are yellow and orange, and they are not very distinct. The graph is not very detailed, and it is not clear what the title of the graph is.](../images/imageFile18.png)

### 3.3.3 Equivalent kernel

The posterior mean solution (3.53) for the linear basis function model has an interesting interpretation that will set the stage for kernel methods, including Gaussian processes. If we substitute (3.53) into the expression (3.3), we see that the predictive mean can be written in the form

$$
y(\mathbf{x}, \mathbf{m}_N) = \mathbf{m}_N^{\text{T}}\boldsymbol{\phi}(\mathbf{x}) = \beta\boldsymbol{\phi}(\mathbf{x})^{\text{T}}\mathbf{S}_N\mathbf{\Phi}^{\text{T}}\mathbf{t} = \sum_{n=1}^N \beta\boldsymbol{\phi}(\mathbf{x})^{\text{T}}\mathbf{S}_N\boldsymbol{\phi}(\mathbf{x}_n)t_n \tag{3.60}
$$

where $\mathbf{S}_N$ is defined by (3.51). Thus the mean of the predictive distribution at a point $\mathbf{x}$ is given by a linear combination of the training set target variables $t_n$, so that we can write

$$
y(\mathbf{x}, \mathbf{m}_N) = \sum_{n=1}^N k(\mathbf{x}, \mathbf{x}_n)t_n \tag{3.61}
$$

where the function

$$
k(\mathbf{x}, \mathbf{x}') = \beta\boldsymbol{\phi}(\mathbf{x})^{\text{T}}\mathbf{S}_N\boldsymbol{\phi}(\mathbf{x}') \tag{3.62}
$$

is known as the smoother matrix or the *equivalent kernel*. Regression functions, such as this, which make predictions by taking linear combinations of the training set target values are known as *linear smoothers*. Note that the equivalent kernel depends on the input values $\mathbf{x}_n$ from the data set because these appear in the definition of $\mathbf{S}_N$. The equivalent kernel is illustrated for the case of Gaussian basis functions in Figure 3.10 in which the kernel functions $k(x, x')$ have been plotted as a function of $x'$ for three different values of $x$. We see that they are localized around $x$, and so the mean of the predictive distribution at $x$, given by $y(x, \mathbf{m}_N)$, is obtained by forming a weighted combination of the target values in which data points close to $x$ are given higher weight than points further removed from $x$. Intuitively, it seems reasonable that we should weight local evidence more strongly than distant evidence. Note that this localization property holds not only for the localized Gaussian basis functions but also for the nonlocal polynomial and sigmoidal basis functions, as illustrated in Figure 3.11.
