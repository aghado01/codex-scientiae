[Page 205]

where $\widetilde{\mathbf{W}}$ is a matrix whose $k^{\text{th}}$ column comprises the $D+1$-dimensional vector $\widetilde{\mathbf{w}}_k = (w_{k0}, \mathbf{w}_k^{\text{T}})^{\text{T}}$ and $\widetilde{\mathbf{x}}$ is the corresponding augmented input vector $(1, \mathbf{x}^{\text{T}})^{\text{T}}$ with a dummy input $x_0 = 1$. This representation was discussed in detail in Section 3.1. A new input $\mathbf{x}$ is then assigned to the class for which the output $y_k = \widetilde{\mathbf{w}}_k^{\text{T}} \widetilde{\mathbf{x}}$ is largest.

We now determine the parameter matrix $\widetilde{\mathbf{W}}$ by minimizing a sum-of-squares error function, as we did for regression in Chapter 3. Consider a training data set $\{\mathbf{x}_n, \mathbf{t}_n\}$ where $n = 1, \ldots, N$, and define a matrix $\mathbf{T}$ whose $n^{\text{th}}$ row is the vector $\mathbf{t}_n^{\text{T}}$, together with a matrix $\widetilde{\mathbf{X}}$ whose $n^{\text{th}}$ row is $\widetilde{\mathbf{x}}_n^{\text{T}}$. The sum-of-squares error function can then be written as
$$
E_D(\widetilde{\mathbf{W}}) = \frac{1}{2} \text{Tr}\left\{ (\widetilde{\mathbf{X}}\widetilde{\mathbf{W}} - \mathbf{T})^{\text{T}} (\widetilde{\mathbf{X}}\widetilde{\mathbf{W}} - \mathbf{T}) \right\} . \tag{4.15}
$$

Setting the derivative with respect to $\widetilde{\mathbf{W}}$ to zero, and rearranging, we then obtain the solution for $\widetilde{\mathbf{W}}$ in the form
$$
\widetilde{\mathbf{W}} = (\widetilde{\mathbf{X}}^{\text{T}}\widetilde{\mathbf{X}})^{-1}\widetilde{\mathbf{X}}^{\text{T}}\mathbf{T} = \widetilde{\mathbf{X}}^{\dagger}\mathbf{T} \tag{4.16}
$$
where $\widetilde{\mathbf{X}}^{\dagger}$ is the pseudo-inverse of the matrix $\widetilde{\mathbf{X}}$, as discussed in Section 3.1.1. We then obtain the discriminant function in the form
$$
\mathbf{y}(\mathbf{x}) = \widetilde{\mathbf{W}}^{\text{T}} \widetilde{\mathbf{x}} = \mathbf{T}^{\text{T}} (\widetilde{\mathbf{X}}^{\dagger})^{\text{T}} \widetilde{\mathbf{x}}. \tag{4.17}
$$

An interesting property of least-squares solutions with multiple target variables is that if every target vector in the training set satisfies some linear constraint
$$
\mathbf{a}^{\text{T}}\mathbf{t}_n + b = 0 \tag{4.18}
$$
for some constants $\mathbf{a}$ and $b$, then the model prediction for any value of $\mathbf{x}$ will satisfy the same constraint so that
$$
\mathbf{a}^{\text{T}}\mathbf{y}(\mathbf{x}) + b = 0. \tag{4.19}
$$

Thus if we use a 1-of-$K$ coding scheme for $K$ classes, then the predictions made by the model will have the property that the elements of $\mathbf{y}(\mathbf{x})$ will sum to $1$ for any value of $\mathbf{x}$. However, this summation constraint alone is not sufficient to allow the model outputs to be interpreted as probabilities because they are not constrained to lie within the interval $(0, 1)$.

The least-squares approach gives an exact closed-form solution for the discriminant function parameters. However, even as a discriminant function (where we use it to make decisions directly and dispense with any probabilistic interpretation) it suffers from some severe problems. We have already seen that least-squares solutions lack robustness to outliers, and this applies equally to the classification application, as illustrated in Figure 4.4. Here we see that the additional data points in the right-hand figure produce a significant change in the location of the decision boundary, even though these points would be correctly classified by the original decision boundary in the left-hand figure. The sum-of-squares error function penalizes predictions that are ‘too correct’ in that they lie a long way on the correct side of the decision
