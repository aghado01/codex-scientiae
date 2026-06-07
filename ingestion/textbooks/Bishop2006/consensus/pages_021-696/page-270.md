[Page 270]

An important consideration for many applications of the Hessian is the efficiency with which it can be evaluated. If there are $W$ parameters (weights and biases) in the network, then the Hessian matrix has dimensions $W \times W$ and so the computational effort needed to evaluate the Hessian will scale like $O(W^{2})$ for each pattern in the data set. As we shall see, there are efficient methods for evaluating the Hessian whose scaling is indeed $O(W^{2})$.

### 5.4.1 Diagonal approximation

Some of the applications for the Hessian matrix discussed above require the inverse of the Hessian, rather than the Hessian itself. For this reason, there has been some interest in using a diagonal approximation to the Hessian, in other words one that simply replaces the off-diagonal elements with zeros, because its inverse is trivial to evaluate. Again, we shall consider an error function that consists of a sum of terms, one for each pattern in the data set, so that $E = \sum_{n} E_{n}$. The Hessian can then be obtained by considering one pattern at a time, and then summing the results over all patterns. From (5.48), the diagonal elements of the Hessian, for pattern $n$, can be written
$$
\frac{\partial^{2} E_{n}}{\partial w_{j i}^{2}} = \frac{\partial^{2} E_{n}}{\partial a_{j}^{2}} z_{i}^{2}.
\tag{5.79}
$$

Using (5.48) and (5.49), the second derivatives on the right-hand side of (5.79) can be found recursively using the chain rule of differential calculus to give a backpropagation equation of the form
$$
\frac{\partial^{2} E_{n}}{\partial a_{j}^{2}} = h'(a_{j})^{2} \sum_{k} \sum_{k'} w_{k j} w_{k' j} \frac{\partial^{2} E_{n}}{\partial a_{k} \partial a_{k'}} + h''(a_{j}) \sum_{k} w_{k j} \frac{\partial E_{n}}{\partial a_{k}}.
\tag{5.80}
$$

If we now neglect off-diagonal elements in the second-derivative terms, we obtain (Becker and Le Cun, 1989; Le Cun et al., 1990)
$$
\frac{\partial^{2} E_{n}}{\partial a_{j}^{2}} = h'(a_{j})^{2} \sum_{k} w_{k j}^{2} \frac{\partial^{2} E_{n}}{\partial a_{k}^{2}} + h''(a_{j}) \sum_{k} w_{k j} \frac{\partial E_{n}}{\partial a_{k}}.
\tag{5.81}
$$

Note that the number of computational steps required to evaluate this approximation is $O(W)$, where $W$ is the total number of weight and bias parameters in the network, compared with $O(W^{2})$ for the full Hessian.

Ricotti et al. (1988) also used the diagonal approximation to the Hessian, but they retained all terms in the evaluation of $\partial^{2} E_{n}/\partial a_{j}^{2}$ and so obtained exact expressions for the diagonal terms. Note that this no longer has $O(W)$ scaling. The major problem with diagonal approximations, however, is that in practice the Hessian is typically found to be strongly nondiagonal, and so these approximations, which are driven mainly by computational convenience, must be treated with care.
