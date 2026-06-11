[Page 694]

densities and the mixing coefﬁcients share the hidden units of the neural network. Furthermore, in the mixture density network, the splits of the input space are further relaxed compared to the hierarchical mixture of experts in that they are not only soft, and not constrained to be axis aligned, but they can also be nonlinear.

## Exercises

14.1 ($\star$) www Consider a set models of the form $p(t|\mathbf{x}, z_h, \boldsymbol{\theta}_h, h)$ in which $\mathbf{x}$ is the input vector, $t$ is the target vector, $h$ indexes the different models, $z_h$ is a latent variable for model $h$, and $\boldsymbol{\theta}_h$ is the set of parameters for model $h$. Suppose the models have prior probabilities $p(h)$ and that we are given a training set $\mathbf{X} = \{\mathbf{x}_1, \dots, \mathbf{x}_N\}$ and $\mathbf{T} = \{t_1, \dots, t_N\}$. Write down the formulae needed to evaluate the predictive distribution $p(t|\mathbf{x}, \mathbf{X}, \mathbf{T})$ in which the latent variables and the model index are marginalized out. Use these formulae to highlight the difference between Bayesian averaging of different models and the use of latent variables within a single model.

14.2 ($\star$) The expected sum-of-squares error $E_{\text{AV}}$ for a simple committee model can be deﬁned by (14.10), and the expected error of the committee itself is given by (14.11). Assuming that the individual errors satisfy (14.12) and (14.13), derive the result (14.14).

14.3 ($\star$) www By making use of Jensen's inequality (1.115), for the special case of the convex function $f(x) = x^2$, show that the average expected sum-of-squares error $E_{\text{AV}}$ of the members of a simple committee model, given by (14.10), and the expected error $E_{\text{COM}}$ of the committee itself, given by (14.11), satisfy

$$
E_{\text{COM}} \le E_{\text{AV}}. \tag{14.54}
$$

14.4 ($\star$) By making use of Jensen's in equality (1.115), show that the result (14.54) derived in the previous exercise hods for any error function $E(y)$, not just sum-ofsquares, provided it is a convex function of $y$.

14.5 ($\star$) www Consider a committee in which we allow unequal weighting of the constituent models, so that

$$
y_{\text{COM}}(\mathbf{x}) = \sum_{m=1}^M \alpha_m y_m(\mathbf{x}). \tag{14.55}
$$

In order to ensure that the predictions $y_{\text{COM}}(\mathbf{x})$ remain within sensible limits, suppose that we require that they be bounded at each value of $\mathbf{x}$ by the minimum and maximum values given by any of the members of the committee, so that

$$
y_{\min}(\mathbf{x}) \le y_{\text{COM}}(\mathbf{x}) \le y_{\max}(\mathbf{x}). \tag{14.56}
$$

Show that a necessary and sufﬁcient condition for this constraint is that the coefﬁcients $\alpha_m$ satisfy

$$
\alpha_m \ge 0, \quad \sum_{m=1}^M \alpha_m = 1. \tag{14.57}
$$
