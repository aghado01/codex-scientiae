[Page 265]

For batch methods, the derivative of the total error $E$ can then be obtained by repeating the above steps for each pattern in the training set and then summing over all patterns:
$$
\frac{\partial E}{\partial w_{ji}} = \sum_{n} \frac{\partial E_{n}}{\partial w_{ji}} .
\tag{5.57}
$$

In the above derivation we have implicitly assumed that each hidden or output unit in the network has the same activation function $h(\cdot)$. The derivation is easily generalized, however, to allow different units to have individual activation functions, simply by keeping track of which form of $h(\cdot)$ goes with which unit.

### 5.3.2 A simple example

The above derivation of the backpropagation procedure allowed for general forms for the error function, the activation functions, and the network topology. In order to illustrate the application of this algorithm, we shall consider a particular example. This is chosen both for its simplicity and for its practical importance, because many applications of neural networks reported in the literature make use of this type of network. Specifically, we shall consider a two-layer network of the form illustrated in Figure 5.1, together with a sum-of-squares error, in which the output units have linear activation functions, so that $y_k = a_k$, while the hidden units have logistic sigmoid activation functions given by
$$
h(a) \equiv \tanh(a)
\tag{5.58}
$$
where
$$
\tanh(a) = \frac{e^a - e^{-a}}{e^a + e^{-a}} .
\tag{5.59}
$$

A useful feature of this function is that its derivative can be expressed in a particularly simple form:
$$
h'(a) = 1 - h(a)^2 .
\tag{5.60}
$$

We also consider a standard sum-of-squares error function, so that for pattern $n$ the error is given by
$$
E_n = \frac{1}{2} \sum_{k=1}^K (y_k - t_k)^2
\tag{5.61}
$$

where $y_k$ is the activation of output unit $k$, and $t_k$ is the corresponding target, for a particular input pattern $\mathbf{x}_n$.

For each pattern in the training set in turn, we first perform a forward propagation using
$$
\begin{align}
a_j &= \sum_{i=0}^D w_{ji}^{(1)} x_i \tag{5.62} \\
z_j &= \tanh(a_j) \tag{5.63}
\end{align}
$$

$$
y_k = \sum_{j=0}^M w_{kj}^{(2)} z_j .
\tag{5.64}
$$
