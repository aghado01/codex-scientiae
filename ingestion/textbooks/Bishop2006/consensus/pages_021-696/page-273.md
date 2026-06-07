[Page 273]

Again, by using a symmetrical central differences formulation, we ensure that the residual errors are $O(\epsilon^2)$ rather than $O(\epsilon)$. Because there are $W^2$ elements in the Hessian matrix, and because the evaluation of each element requires four forward propagations each needing $O(W)$ operations (per pattern), we see that this approach will require $O(W^3)$ operations to evaluate the complete Hessian. It therefore has poor scaling properties, although in practice it is very useful as a check on the software implementation of backpropagation methods.

A more efficient version of numerical differentiation can be found by applying central differences to the first derivatives of the error function, which are themselves calculated using backpropagation. This gives

$$
\frac{\partial^2 E}{\partial w_{ji} \partial w_{lk}} = \frac{1}{2\epsilon} \left\{ \frac{\partial E}{\partial w_{ji}} (w_{lk} + \epsilon) - \frac{\partial E}{\partial w_{ji}} (w_{lk} - \epsilon) \right\} + O(\epsilon^2). \tag{5.91}
$$

Because there are now only $W$ weights to be perturbed, and because the gradients can be evaluated in $O(W)$ steps, we see that this method gives the Hessian in $O(W^2)$ operations.

### 5.4.5 Exact evaluation of the Hessian

So far, we have considered various approximation schemes for evaluating the Hessian matrix or its inverse. The Hessian can also be evaluated exactly, for a network of arbitrary feed-forward topology, using extension of the technique of backpropagation used to evaluate first derivatives, which shares many of its desirable features including computational efficiency (Bishop, 1991; Bishop, 1992). It can be applied to any differentiable error function that can be expressed as a function of the network outputs and to networks having arbitrary differentiable activation functions. The number of computational steps needed to evaluate the Hessian scales like $O(W^2)$. Similar algorithms have also been considered by Buntine and Weigend (1993).

Here we consider the specific case of a network having two layers of weights, for which the required equations are easily derived. We shall use indices $i$ and $i^\prime$ to denote inputs, indices $j$ and $j^\prime$ to denote hidden units, and indices $k$ and $k^\prime$ to denote outputs. We first define

$$
\delta_{k} = \frac{\partial E_{n}}{\partial a_{k}}, \quad M_{k k^\prime} \equiv \frac{\partial^2 E_{n}}{\partial a_{k} \partial a_{k^\prime}} \tag{5.92}
$$

where $E_n$ is the contribution to the error from data point $n$. The Hessian matrix for this network can then be considered in three separate blocks as follows.

1. Both weights in the second layer:

$$
\frac{\partial^2 E_n}{\partial w_{kj}^{(2)} \partial w_{k^\prime j^\prime}^{(2)}} = z_j z_{j^\prime} M_{k k^\prime}. \tag{5.93}
$$
