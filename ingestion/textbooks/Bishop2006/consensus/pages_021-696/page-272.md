[Page 272]

###### 5.4.3 Inverse Hessian

We can use the outer-product approximation to develop a computationally efficient procedure for approximating the inverse of the Hessian (Hassibi and Stork, 1993). First we write the outer-product approximation in matrix notation as
$$
\mathbf{H}_{N} = \sum_{n=1}^{N} \mathbf{b}_{n}\mathbf{b}_{n}^{T} \tag{5.86}
$$
where $\mathbf{b}_{n} \equiv \nabla_{\mathbf{w}} a_{n}$ is the contribution to the gradient of the output unit activation arising from data point $n$. We now derive a sequential procedure for building up the Hessian by including data points one at a time. Suppose we have already obtained the inverse Hessian using the first $L$ data points. By separating off the contribution from data point $L + 1$, we obtain
$$
\mathbf{H}_{L+1} = \mathbf{H}_{L} + \mathbf{b}_{L+1}\mathbf{b}_{L+1}^{T}. \tag{5.87}
$$
In order to evaluate the inverse of the Hessian, we now consider the matrix identity
$$
(\mathbf{M} + \mathbf{v}\mathbf{v}^{T})^{-1} = \mathbf{M}^{-1} - \frac{(\mathbf{M}^{-1}\mathbf{v})(\mathbf{v}^{T}\mathbf{M}^{-1})}{1 + \mathbf{v}^{T}\mathbf{M}^{-1}\mathbf{v}} \tag{5.88}
$$
where $\mathbf{I}$ is the unit matrix, which is simply a special case of the Woodbury identity (C.7). If we now identify $\mathbf{H}_{L}$ with $\mathbf{M}$ and $\mathbf{b}_{L+1}$ with $\mathbf{v}$, we obtain
$$
\mathbf{H}_{L+1}^{-1} = \mathbf{H}_{L}^{-1} - \frac{\mathbf{H}_{L}^{-1}\mathbf{b}_{L+1}\mathbf{b}_{L+1}^{T}\mathbf{H}_{L}^{-1}}{1 + \mathbf{b}_{L+1}^{T}\mathbf{H}_{L}^{-1}\mathbf{b}_{L+1}}. \tag{5.89}
$$
In this way, data points are sequentially absorbed until $L+1 = N$ and the whole data set has been processed. This result therefore represents a procedure for evaluating the inverse of the Hessian using a single pass through the data set. The initial matrix $\mathbf{H}_{0}$ is chosen to be $\alpha\mathbf{I}$, where $\alpha$ is a small quantity, so that the algorithm actually finds the inverse of $\mathbf{H} + \alpha\mathbf{I}$. The results are not particularly sensitive to the precise value of $\alpha$. Extension of this algorithm to networks having more than one output is straightforward. We note here that the Hessian matrix can sometimes be calculated indirectly as part of the network training algorithm. In particular, quasi-Newton nonlinear optimization algorithms gradually build up an approximation to the inverse of the Hessian during training. Such algorithms are discussed in detail in Bishop and Nabney (2008).

###### 5.4.4 Finite differences

As in the case of the first derivatives of the error function, we can find the second derivatives by using finite differences, with accuracy limited by numerical precision. If we perturb each possible pair of weights in turn, we obtain
$$
\begin{aligned}
\frac{\partial^{2} E}{\partial w_{ji} \partial w_{lk}} &= \frac{1}{4\epsilon^{2}} \left\{ E(w_{ji} + \epsilon, w_{lk} + \epsilon) - E(w_{ji} + \epsilon, w_{lk} - \epsilon) \right. \\
&\quad \left. - E(w_{ji} - \epsilon, w_{lk} + \epsilon) + E(w_{ji} - \epsilon, w_{lk} - \epsilon) \right\} + O(\epsilon^{2}).
\end{aligned} \tag{5.90}
$$
