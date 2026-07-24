# Chapter 14 Exercises

[Page 694]


## 14.1 Predictive distribution for Bayesian averaging ($\star$)

Consider a set models of the form $p(t|\mathbf{x}, z_h, \boldsymbol{\theta}_h, h)$ in which $\mathbf{x}$ is the input vector, $t$ is the target vector, $h$ indexes the different models, $z_h$ is a latent variable for model $h$, and $\boldsymbol{\theta}_h$ is the set of parameters for model $h$. Suppose the models have prior probabilities $p(h)$ and that we are given a training set $\mathbf{X} = \{\mathbf{x}_1, \dots, \mathbf{x}_N\}$ and $\mathbf{T} = \{t_1, \dots, t_N\}$. Write down the formulae needed to evaluate the predictive distribution $p(t|\mathbf{x}, \mathbf{X}, \mathbf{T})$ in which the latent variables and the model index are marginalized out. Use these formulae to highlight the difference between Bayesian averaging of different models and the use of latent variables within a single model.

## 14.2 Expected error of committee models ($\star$)

The expected sum-of-squares error $E_{\text{AV}}$ for a simple committee model can be defined by (14.10), and the expected error of the committee itself is given by (14.11). Assuming that the individual errors satisfy (14.12) and (14.13), derive the result (14.14).

## 14.3 Committee error bound via Jensen ($\star$)

By making use of Jensen's inequality (1.115), for the special case of the convex function $f(x) = x^2$, show that the average expected sum-of-squares error $E_{\text{AV}}$ of the members of a simple committee model, given by (14.10), and the expected error $E_{\text{COM}}$ of the committee itself, given by (14.11), satisfy

$$
E_{\text{COM}} \le E_{\text{AV}}. \tag{14.54}
$$

## 14.4 Committee error bound for convex loss ($\star$)

By making use of Jensen's in equality (1.115), show that the result (14.54) derived in the previous exercise hods for any error function $E(y)$, not just sum-ofsquares, provided it is a convex function of $y$.

## 14.5 Unequal weighting in committee models ($\star$)

Consider a committee in which we allow unequal weighting of the constituent models, so that

$$
y_{\text{COM}}(\mathbf{x}) = \sum_{m=1}^M \alpha_m y_m(\mathbf{x}). \tag{14.55}
$$

In order to ensure that the predictions $y_{\text{COM}}(\mathbf{x})$ remain within sensible limits, suppose that we require that they be bounded at each value of $\mathbf{x}$ by the minimum and maximum values given by any of the members of the committee, so that

$$
y_{\min}(\mathbf{x}) \le y_{\text{COM}}(\mathbf{x}) \le y_{\max}(\mathbf{x}). \tag{14.56}
$$

Show that a necessary and sufficient condition for this constraint is that the coefficients $\alpha_m$ satisfy

$$
\alpha_m \ge 0, \quad \sum_{m=1}^M \alpha_m = 1. \tag{14.57}
$$
[Page 695]

## 14.6 AdaBoost parameter update derivation ($\star$)

By differentiating the error function (14.23) with respect to $\alpha_m$, show that the parameters $\alpha_m$ in the AdaBoost algorithm are updated using (14.17) in which $\epsilon_m$ is defined by (14.16).

## 14.7 Minimizing expected exponential error ($\star$)

By making a variational minimization of the expected exponential error function given by (14.27) with respect to all possible functions $y(\mathbf{x})$, show that the minimizing function is given by (14.28).

## 14.8 Exponential error and log likelihood ($\star$)

Show that the exponential error function (14.20), which is minimized by the AdaBoost algorithm, does not correspond to the log likelihood of any well-behaved probabilistic model. This can be done by showing that the corresponding conditional distribution $p(t|\mathbf{x})$ cannot be correctly normalized.

## 14.9 Sequential minimization of sum-of-squares ($\star$)

Show that the sequential minimization of the sum-of-squares error function for an additive model of the form (14.21) in the style of boosting simply involves fitting each new base classifier to the residual errors $t_n - f_{m-1}(\mathbf{x}_n)$ from the previous model.

## 14.10 Optimal prediction for squared loss ($\star$)

Verify that if we minimize the sum-of-squares error between a set of training values $\{t_n\}$ and a single predictive value $t$, then the optimal solution for $t$ is given by the mean of the $\{t_n\}$.

## 14.11 Comparing classification tree splits ($\star$)

Consider a data set comprising 400 data points from class $\mathcal{C}_1$ and 400 data points from class $\mathcal{C}_2$. Suppose that a tree model A splits these into $(300, 100)$ at the first leaf node and $(100, 300)$ at the second leaf node, where $(n, m)$ denotes that $n$ points are assigned to $\mathcal{C}_1$ and $m$ points are assigned to $\mathcal{C}_2$. Similarly, suppose that a second tree model B splits them into $(200, 400)$ and $(200, 0)$. Evaluate the misclassification rates for the two trees and hence show that they are equal. Similarly, evaluate the cross-entropy (14.32) and Gini index (14.33) for the two trees and show that they are both lower for tree B than for tree A.

## 14.12 Mixture of linear regression models ($\star$)

Extend the results of Section 14.5.1 for a mixture of linear regression models to the case of multiple target values described by a vector $\mathbf{t}$. To do this, make use of the results of Section 3.1.5.

## 14.13 Log likelihood for regression mixture ($\star$)

Verify that the complete-data log likelihood function for the mixture of linear regression models is given by (14.36).

## 14.14 M-step for regression mixing coefficients ($\star$)

Use the technique of Lagrange multipliers (Appendix E) to show that the M-step re-estimation equation for the mixing coefficients in the mixture of linear regression models trained by maximum likelihood EM is given by (14.38).

## 14.15 Conditional mean for regression mixture ($\star$)

We have already noted that if we use a squared loss function in a regression problem, the corresponding optimal prediction of the target variable for a new input vector is given by the conditional mean of the predictive distribution. Show that the conditional mean for the mixture of linear regression models discussed in Section 14.5.1 is given by a linear combination of the means of each component distribution. Note that if the conditional distribution of the target data is multimodal, the conditional mean can give poor predictions.
[Page 696]

## 14.16 Mixture of softmax classifiers ($\star$)

Extend the logistic regression mixture model of Section 14.5.2 to a mixture of softmax classifiers representing $C \ge 2$ classes. Write down the EM algorithm for determining the parameters of this model through maximum likelihood.

## 14.17 Hierarchical versus single-level mixtures ($\star\star$)

Consider a mixture model for a conditional distribution $p(t|\mathbf{x})$ of the form

$$
p(t|\mathbf{x}) = \sum_{k=1}^K \pi_k \psi_k(t|\mathbf{x}) \tag{14.58}
$$

in which each mixture component $\psi_k(t|\mathbf{x})$ is itself a mixture model. Show that this two-level hierarchical mixture is equivalent to a conventional single-level mixture model. Now suppose that the mixing coefficients in both levels of such a hierarchical model are arbitrary functions of $\mathbf{x}$. Again, show that this hierarchical model is again equivalent to a single-level model with $\mathbf{x}$-dependent mixing coefficients. Finally, consider the case in which the mixing coefficients at both levels of the hierarchical mixture are constrained to be linear classification (logistic or softmax) models. Show that the hierarchical mixture cannot in general be represented by a single-level mixture having linear classification models for the mixing coefficients. Hint: to do this it is sufficient to construct a single counter-example, so consider a mixture of two components in which one of those components is itself a mixture of two components, with mixing coefficients given by linear-logistic models. Show that this cannot be represented by a single-level mixture of 3 components having mixing coefficients determined by a linear-softmax model.