[Page 274]

- 2. Both weights in the first layer:

$$
\begin{aligned}
\frac{\partial^{2}E_{n}}{\partial w_{ji}^{(1)} \partial w_{j'i'}^{(1)}} &= x_{i} x_{i'} h''(a_{j'}) I_{jj'} \sum_{k} w_{kj'}^{(2)} \delta_{k} \\
&\quad + x_{i} x_{i'} h'(a_{j'}) h'(a_{j}) \sum_{k} \sum_{k'} w_{k'j'}^{(2)} w_{kj}^{(2)} M_{kk'} .
\end{aligned}
\tag{5.94}
$$

- 3. One weight in each layer:

$$
\frac{\partial^{2}E_{n}}{\partial w_{ji}^{(1)} \partial w_{kj'}^{(2)}} = x_{i} h'(a_{j'}) \left\{ \delta_{k} I_{jj'} + z_{j} \sum_{k'} w_{k'j'}^{(2)} H_{kk'} \right\} .
\tag{5.95}
$$

Here $I_{jj'}$ is the $j,j'$ element of the identity matrix. If one or both of the weights is a bias term, then the corresponding expressions are obtained simply by setting the appropriate activation(s) to 1. Inclusion of skip-layer connections is straightforward.

### 5.4.6 Fast multiplication by the Hessian

For many applications of the Hessian, the quantity of interest is not the Hessian matrix $\mathbf{H}$ itself but the product of $\mathbf{H}$ with some vector $\mathbf{v}$. We have seen that the evaluation of the Hessian takes $\mathcal{O}(W^2)$ operations, and it also requires storage that is $\mathcal{O}(W^2)$. The vector $\mathbf{v}^{\mathrm{T}}\mathbf{H}$ that we wish to calculate, however, has only $W$ elements, so instead of computing the Hessian as an intermediate step, we can instead try to find an efficient approach to evaluating $\mathbf{v}^{\mathrm{T}}\mathbf{H}$ directly in a way that requires only $\mathcal{O}(W)$ operations.

To do this, we first note that

$$
\mathbf{v}^{\mathrm{T}}\mathbf{H} = \mathbf{v}^{\mathrm{T}}\nabla(\nabla E)
\tag{5.96}
$$

where $\nabla$ denotes the gradient operator in weight space. We can then write down the standard forward-propagation and backpropagation equations for the evaluation of $\nabla E$ and apply (5.96) to these equations to give a set of forward-propagation and backpropagation equations for the evaluation of $\mathbf{v}^{\mathrm{T}}\mathbf{H}$ (Møller, 1993; Pearlmutter, 1994). This corresponds to acting on the original forward-propagation and backpropagation equations with a differential operator $\mathbf{v}^{\mathrm{T}}\nabla$. Pearlmutter (1994) used the notation $\mathcal{R}\{\cdot\}$ to denote the operator $\mathbf{v}^{\mathrm{T}}\nabla$, and we shall follow this convention. The analysis is straightforward and makes use of the usual rules of differential calculus, together with the result

$$
\mathcal{R}\{\mathbf{w}\} = \mathbf{v}.
\tag{5.97}
$$

The technique is best illustrated with a simple example, and again we choose a two-layer network of the form shown in Figure 5.1, with linear output units and a sum-of-squares error function. As before, we consider the contribution to the error function from one pattern in the data set. The required vector is then obtained as
