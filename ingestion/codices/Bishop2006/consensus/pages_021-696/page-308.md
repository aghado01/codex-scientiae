[Page 308]

components of the weight vector parallel to the eigenvectors of the Hessian satisfy

$$
w_j^{(\tau)} \simeq w_j^{\star} \quad \text{when } \eta_j \gg (\rho \tau)^{-1} \tag{5.199}
$$

$$
|w_j^{(\tau)}| \ll |w_j^{\star}| \quad \text{when } \eta_j \ll (\rho \tau)^{-1}. \tag{5.200}
$$

Compare this result with the discussion in Section 3.5.3 of regularization with simple weight decay, and hence show that $(\rho\tau)^{-1}$ is analogous to the regularization parameter $\lambda$. The above results also show that the effective number of parameters in the network, as deﬁned by (3.91), grows as the training progresses.

5.26 ( $\star\star$ ) Consider a multilayer perceptron with arbitrary feed-forward topology, which is to be trained by minimizing the tangent propagation error function (5.127) in which the regularizing function is given by (5.128). Show that the regularization term $\Omega$ can be written as a sum over patterns of terms of the form

$$
\Omega_n = \frac{1}{2} \sum_k (\mathcal{G} y_k)^2 \tag{5.201}
$$

where $\mathcal{G}$ is a differential operator deﬁned by

$$
\mathcal{G} \equiv \sum_i \tau_i \frac{\partial}{\partial x_i}. \tag{5.202}
$$

By acting on the forward propagation equations

$$
z_j = h(a_j), \quad a_j = \sum_i w_{ji} z_i \tag{5.203}
$$

with the operator $\mathcal{G}$, show that $\Omega_n$ can be evaluated by forward propagation using the following equations:

$$
\alpha_j = h'(a_j) \beta_j, \quad \beta_j = \sum_i w_{ji} \alpha_i \tag{5.204}
$$

where we have deﬁned the new variables

$$
\alpha_j \equiv \mathcal{G} z_j, \quad \beta_j \equiv \mathcal{G} a_j. \tag{5.205}
$$

Now show that the derivatives of $\Omega_n$ with respect to a weight $w_{rs}$ in the network can be written in the form

$$
\frac{\partial \Omega_n}{\partial w_{rs}} = \sum_k \alpha_k \{\phi_{kr} z_s + \delta_{kr} \alpha_s\} \tag{5.206}
$$

where we have deﬁned

$$
\delta_{kr} \equiv \frac{\partial y_k}{\partial a_r}, \quad \phi_{kr} \equiv \mathcal{G} \delta_{kr}. \tag{5.207}
$$

Write down the backpropagation equations for $\delta_{kr}$, and hence derive a set of backpropagation equations for the evaluation of the $\phi_{kr}$.
