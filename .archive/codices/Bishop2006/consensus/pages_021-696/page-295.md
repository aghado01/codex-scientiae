[Page 295]

directly by the network output activations

$$
\mu_{kj}(\mathbf{x}) = a_{kj}^{\mu}. \tag{5.152}
$$

The adaptive parameters of the mixture density network comprise the vector $\mathbf{w}$ of weights and biases in the neural network, that can be set by maximum likelihood, or equivalently by minimizing an error function deﬁned to be the negative logarithm of the likelihood. For independent data, this error function takes the form

$$
E(\mathbf{w}) = - \sum_{n=1}^{N} \ln \left\{ \sum_{k=1}^{K} \pi_{k}(\mathbf{x}_{n}, \mathbf{w}) \mathcal{N} \left( \mathbf{t}_{n} | \boldsymbol{\mu}_{k}(\mathbf{x}_{n}, \mathbf{w}), \sigma_{k}^{2}(\mathbf{x}_{n}, \mathbf{w}) \right) \right\} \tag{5.153}
$$

where we have made the dependencies on $\mathbf{w}$ explicit.

In order to minimize the error function, we need to calculate the derivatives of the error $E(\mathbf{w})$ with respect to the components of $\mathbf{w}$. These can be evaluated by using the standard backpropagation procedure, provided we obtain suitable expressions for the derivatives of the error with respect to the output-unit activations. These represent error signals $\delta$ for each pattern and for each output unit, and can be backpropagated to the hidden units and the error function derivatives evaluated in the usual way. Because the error function (5.153) is composed of a sum of terms, one for each training data point, we can consider the derivatives for a particular pattern $n$ and then ﬁnd the derivatives of $E$ by summing over all patterns.

Because we are dealing with mixture distributions, it is convenient to view the mixing coefﬁcients $\pi_k(\mathbf{x})$ as $\mathbf{x}$-dependent prior probabilities and to introduce the corresponding posterior probabilities given by

$$
\gamma_{k}(\mathbf{t}|\mathbf{x}) = \frac{\pi_{k} \mathcal{N}_{nk}}{\sum_{l=1}^{K} \pi_{l} \mathcal{N}_{nl}} \tag{5.154}
$$

where $\mathcal{N}_{nk}$ denotes $\mathcal{N}(\mathbf{t}_n | \boldsymbol{\mu}_k(\mathbf{x}_n), \sigma_k^2(\mathbf{x}_n))$.

The derivatives with respect to the network output activations governing the mixing coefﬁcients are given by

$$
\frac{\partial E_n}{\partial a_{k}^{\pi}} = \pi_k - \gamma_k. \tag{5.155}
$$

Similarly, the derivatives with respect to the output activations controlling the component means are given by

$$
\frac{\partial E_n}{\partial a_{kl}^{\mu}} = \gamma_k \left\{ \frac{\mu_{kl} - t_{l}}{\sigma_k^2} \right\}. \tag{5.156}
$$

Finally, the derivatives with respect to the output activations controlling the component variances are given by

$$
\frac{\partial E_n}{\partial a_{k}^{\sigma}} = - \gamma_k \left\{ \frac{\|\mathbf{t}_n - \boldsymbol{\mu}_k\|^2}{\sigma_k^3} - \frac{1}{\sigma_k} \right\}. \tag{5.157}
$$
