[Page 373]

3. Evaluate $\boldsymbol{\Sigma}$ and $\mathbf{m}$, along with $q_i$ and $s_i$ for all basis functions.
4. Select a candidate basis function $\boldsymbol{\phi}_i$.
5. If $q_i^2 > s_i$, and $\alpha_i < \infty$, so that the basis vector $\boldsymbol{\phi}_i$ is already included in the model, then update $\alpha_i$ using (7.101).
6. If $q_i^2 > s_i$, and $\alpha_i = \infty$, then add $\boldsymbol{\phi}_i$ to the model, and evaluate hyperparameter $\alpha_i$ using (7.101).
7. If $q_i^2 \leqslant s_i$, and $\alpha_i < \infty$ then remove basis function $\boldsymbol{\phi}_i$ from the model, and set $\alpha_i = \infty$.
8. If solving a regression problem, update $\beta$.
9. If converged terminate, otherwise go to 3.

Note that if $q_i^2 \leqslant s_i$ and $\alpha_i = \infty$, then the basis function $\boldsymbol{\phi}_i$ is already excluded from the model and no action is required.

In practice, it is convenient to evaluate the quantities

$$
Q_i = \boldsymbol{\phi}_i^T\mathbf{C}^{-1}\mathbf{t} \tag{7.102}
$$

$$
S_i = \boldsymbol{\phi}_i^T\mathbf{C}^{-1}\boldsymbol{\phi}_i. \tag{7.103}
$$

The quality and sparseness variables can then be expressed in the form

$$
q_i = \frac{\alpha_i Q_i}{\alpha_i - S_i} \tag{7.104}
$$

$$
s_i = \frac{\alpha_i S_i}{\alpha_i - S_i}. \tag{7.105}
$$

Note that when $\alpha_i = \infty$, we have $q_i = Q_i$ and $s_i = S_i$. Using (C.7), we can write

$$
Q_i = \beta\boldsymbol{\phi}_i^T\mathbf{t} - \beta^2\boldsymbol{\phi}_i^T\mathbf{\Phi}\boldsymbol{\Sigma}\mathbf{\Phi}^T\mathbf{t} \tag{7.106}
$$

$$
S_i = \beta\boldsymbol{\phi}_i^T\boldsymbol{\phi}_i - \beta^2\boldsymbol{\phi}_i^T\mathbf{\Phi}\boldsymbol{\Sigma}\mathbf{\Phi}^T\boldsymbol{\phi}_i \tag{7.107}
$$

where $\mathbf{\Phi}$ and $\boldsymbol{\Sigma}$ involve only those basis vectors that correspond to ﬁnite hyperparameters $\alpha_i$. At each stage the required computations therefore scale like $O(M^3)$, where $M$ is the number of active basis vectors in the model and is typically much smaller than the number $N$ of training patterns.

###### 7.2.3 RVM for classiﬁcation

We can extend the relevance vector machine framework to classiﬁcation problems by applying the ARD prior over weights to a probabilistic linear classiﬁcation model of the kind studied in Chapter 4. To start with, we consider two-class problems with a binary target variable $t \in \{0, 1\}$. The model now takes the form of a linear combination of basis functions transformed by a logistic sigmoid function

$$
y(\mathbf{x}, \mathbf{w}) = \sigma(\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x})) \tag{7.108}
$$
