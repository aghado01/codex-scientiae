[Page 680]

![Figure 14.2](../../../../../images/imageFile326.png)
**Figure 14.2** Illustration of boosting in which the base learners consist of simple thresholds applied to one or other of the axes. Each ﬁgure shows the number $m$ of base learners trained so far, along with the decision boundary of the most recent base learner (dashed black line) and the combined decision boundary of the ensemble (solid green line). Each data point is depicted by a circle whose radius indicates the weight assigned to that data point when training the most recently added base learner. Thus, for instance, we see that points that are misclassiﬁed by the $m = 1$ base learner are given greater weight when training the $m = 2$ base learner.

Instead of doing a global error function minimization, however, we shall suppose that the base classiﬁers $y_1(\mathbf{x}), \dots, y_{m-1}(\mathbf{x})$ are ﬁxed, as are their coefﬁcients $\alpha_1, \dots, \alpha_{m-1}$, and so we are minimizing only with respect to $\alpha_m$ and $y_m(\mathbf{x})$. Separating off the contribution from base classiﬁer $y_m(\mathbf{x})$, we can then write the error function in the form

$$
\begin{aligned}
E &= \sum_{n=1}^N \exp\left\{ -t_n f_{m-1}(\mathbf{x}_n) - \frac{1}{2} t_n \alpha_m y_m(\mathbf{x}_n) \right\} \\
&= \sum_{n=1}^N w_n^{(m)} \exp\left\{ -\frac{1}{2} t_n \alpha_m y_m(\mathbf{x}_n) \right\}
\end{aligned} \tag{14.22}
$$

where the coefﬁcients $w_n^{(m)} = \exp\{-t_n f_{m-1}(\mathbf{x}_n)\}$ can be viewed as constants because we are optimizing only $\alpha_m$ and $y_m(\mathbf{x})$. If we denote by $\mathcal{T}_m$ the set of data points that are correctly classiﬁed by $y_m(\mathbf{x})$, and if we denote the remaining misclassiﬁed points by $\mathcal{M}_m$, then we can in turn rewrite the error function in the
