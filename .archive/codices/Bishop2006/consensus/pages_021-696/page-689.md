[Page 689]

problem, in which the term corresponding to the $n^{\text{th}}$ data point carries a weighting coefﬁcient given by $\beta \gamma_{nk}$, which could be interpreted as an effective precision for each data point. We see that each component linear regression model in the mixture, governed by its own parameter vector $\mathbf{w}_k$, is ﬁtted separately to the whole data set in the M step, but with each data point $n$ weighted by the responsibility $\gamma_{nk}$ that model $k$ takes for that data point. Setting the derivative of (14.39) with respect to $\mathbf{w}_k$ equal to zero gives

$$
0 = \sum_{n=1}^N \gamma_{nk} (t_n - \mathbf{w}_k^{\text{T}}\boldsymbol{\phi}_n)\boldsymbol{\phi}_n \tag{14.40}
$$

which we can write in matrix notation as

$$
0 = \boldsymbol{\Phi}^{\text{T}} \mathbf{R}_k (\mathbf{t} - \boldsymbol{\Phi}\mathbf{w}_k) \tag{14.41}
$$

where $\mathbf{R}_k = \text{diag}(\gamma_{nk})$ is a diagonal matrix of size $N \times N$. Solving for $\mathbf{w}_k$, we obtain

$$
\mathbf{w}_k = (\boldsymbol{\Phi}^{\text{T}} \mathbf{R}_k \boldsymbol{\Phi})^{-1} \boldsymbol{\Phi}^{\text{T}} \mathbf{R}_k \mathbf{t}. \tag{14.42}
$$

This represents a set of modiﬁed normal equations corresponding to the weighted least squares problem, of the same form as (4.99) found in the context of logistic regression. Note that after each E step, the matrix $\mathbf{R}_k$ will change and so we will have to solve the normal equations afresh in the subsequent M step.

Finally, we maximize $Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}})$ with respect to $\beta$. Keeping only terms that depend on $\beta$, the function $Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}})$ can be written

$$
Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}}) = \sum_{n=1}^N \sum_{k=1}^K \gamma_{nk} \left\{ \frac{1}{2} \ln \beta - \frac{\beta}{2} (t_n - \mathbf{w}_k^{\text{T}}\boldsymbol{\phi}_n)^2 \right\}. \tag{14.43}
$$

Setting the derivative with respect to $\beta$ equal to zero, and rearranging, we obtain the M-step equation for $\beta$ in the form

$$
\frac{1}{\beta} = \frac{1}{N} \sum_{n=1}^N \sum_{k=1}^K \gamma_{nk} (t_n - \mathbf{w}_k^{\text{T}}\boldsymbol{\phi}_n)^2. \tag{14.44}
$$

In Figure 14.8, we illustrate this EM algorithm using the simple example of ﬁtting a mixture of two straight lines to a data set having one input variable $x$ and one target variable $t$. The predictive density (14.34) is plotted in Figure 14.9 using the converged parameter values obtained from the EM algorithm, corresponding to the right-hand plot in Figure 14.8. Also shown in this ﬁgure is the result of ﬁtting a single linear regression model, which gives a unimodal predictive density. We see that the mixture model gives a much better representation of the data distribution, and this is reﬂected in the higher likelihood value. However, the mixture model also assigns signiﬁcant probability mass to regions where there is no data because its predictive distribution is bimodal for all values of $x$. This problem can be resolved by extending the model to allow the mixture coefﬁcients themselves to be functions of $x$, leading to models such as the mixture density networks discussed in Section 5.6, and hierarchical mixture of experts discussed in Section 14.5.3.
