[Page 275]

usual by summing over the contributions from each of the patterns separately. For the two-layer network, the forward-propagation equations are given by
$$
\begin{align}
a_j &= \sum_{i} w_{ji} x_i \tag{5.98} \\
z_j &= h(a_j) \tag{5.99} \\
y_k &= \sum_{j} w_{kj} z_j. \tag{5.100}
\end{align}
$$

We now act on these equations using the $\mathcal{R}\{\cdot\}$ operator to obtain a set of forward propagation equations in the form
$$
\begin{align}
\mathcal{R}\{a_j\} &= \sum_{i} v_{ji} x_i \tag{5.101} \\
\mathcal{R}\{z_j\} &= h'(a_j) \mathcal{R}\{a_j\} \tag{5.102} \\
\mathcal{R}\{y_k\} &= \sum_{j} w_{kj} \mathcal{R}\{z_j\} + \sum_{j} v_{kj} z_j \tag{5.103}
\end{align}
$$

where $v_{ji}$ is the element of the vector $\mathbf{v}$ that corresponds to the weight $w_{ji}$. Quantities of the form $\mathcal{R}\{z_j\}$, $\mathcal{R}\{a_j\}$, and $\mathcal{R}\{y_k\}$ are to be regarded as new variables whose values are found using the above equations.

Because we are considering a sum-of-squares error function, we have the following standard backpropagation expressions:
$$
\begin{align}
\delta_k &= y_k - t_k \tag{5.104} \\
\delta_j &= h'(a_j) \sum_{k} w_{kj} \delta_k. \tag{5.105}
\end{align}
$$

Again, we act on these equations with the $\mathcal{R}\{\cdot\}$ operator to obtain a set of backpropagation equations in the form
$$
\begin{align}
\mathcal{R}\{\delta_k\} &= \mathcal{R}\{y_k\} \tag{5.106} \\
\mathcal{R}\{\delta_j\} &= h''(a_j) \mathcal{R}\{a_j\} \sum_{k} w_{kj} \delta_k \nonumber \\
&\quad + h'(a_j) \sum_{k} v_{kj} \delta_k + h'(a_j) \sum_{k} w_{kj} \mathcal{R}\{\delta_k\}. \tag{5.107}
\end{align}
$$

Finally, we have the usual equations for the first derivatives of the error
$$
\begin{align}
\frac{\partial E}{\partial w_{kj}} &= \delta_k z_j \tag{5.108} \\
\frac{\partial E}{\partial w_{ji}} &= \delta_j x_i \tag{5.109}
\end{align}
$$
