[Page 678]

![Figure 14.1](../../../../../images/imageFile325.png)
**Figure 14.1** Schematic illustration of the boosting framework. Each base classiﬁer $y_m(\mathbf{x})$ is trained on a weighted form of the training set (blue arrows) in which the weights $w_n^{(m)}$ depend on the performance of the previous base classiﬁer $y_{m-1}(\mathbf{x})$ (green arrows). Once all base classiﬁers have been trained, they are combined to give the ﬁnal classiﬁer $Y_M(\mathbf{x})$ (red arrows).

$$
Y_M(\mathbf{x}) = \text{sign}\left( \sum_{m=1}^M \alpha_m y_m(\mathbf{x}) \right)
$$

## AdaBoost

1. Initialize the data weighting coefﬁcients $\{w_n\}$ by setting $w_n^{(1)} = 1/N$ for $n = 1, \dots, N$.
2. For $m = 1, \dots, M$:
    (a) Fit a classiﬁer $y_m(\mathbf{x})$ to the training data by minimizing the weighted error function
    $$
    J_m = \sum_{n=1}^N w_n^{(m)} I(y_m(\mathbf{x}_n) \ne t_n) \tag{14.15}
    $$
    where $I(y_m(\mathbf{x}_n) \ne t_n)$ is the indicator function and equals $1$ when $y_m(\mathbf{x}_n) \ne t_n$ and $0$ otherwise.
    (b) Evaluate the quantities
    $$
    \epsilon_m = \frac{\sum_{n=1}^N w_n^{(m)} I(y_m(\mathbf{x}_n) \ne t_n)}{\sum_{n=1}^N w_n^{(m)}} \tag{14.16}
    $$
    and then use these to evaluate
    $$
    \alpha_m = \ln\left\{ \frac{1 - \epsilon_m}{\epsilon_m} \right\}. \tag{14.17}
    $$
    (c) Update the data weighting coefﬁcients
    $$
    w_n^{(m+1)} = w_n^{(m)} \exp\left\{ \alpha_m I(y_m(\mathbf{x}_n) \ne t_n) \right\} \tag{14.18}
    $$
