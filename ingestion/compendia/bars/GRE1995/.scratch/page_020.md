[Page 20]

The samplers were also completely specified above; except for the scale factor 0, which we took as 50, after a little experimentation, and the probabilities assigned to each move type. We took the birth and death rates $b_g$ and $d_g$ each to be $0.3$ for all $g$, except for the extreme partitions where $d(g) = 1$ or $n$ ($= 4$) where $b_g$ and $d_g$ were taken as $(0.6, 0)$ and $(0, 0.6)$. At each transition, $\sigma$ was updated with probability $0.2$, and similarly for the $(\alpha, q)$ pair.

Results  are presented in Table 1, based on run lengths of 40 000 attempted updates; after burn-in periods of 4000; such runs took 36 seconds on a Sun Sparc 2 Posterior expectations of {0;} are close to those obtained by Consonni & Veronese: For the case where 9 was taken as random; with the hyperprior specified above; its posterior mean and standard deviation were estimated as 181 and 58. The sampling-based computation

**Table 1.** Mortality of pine seedlings: posterior means and standard deviations (in parentheses) of $\{\theta_i\}$

| Experiment | $y_i$ | C&V $q=100$ | C&V $q=200$ | C&V $q=300$ | RJMCMC $q=100$ | RJMCMC $q=200$ | RJMCMC $q=300$ | RJMCMC random $q$ |
|---|---|---|---|---|---|---|---|---|
| LH | 59 | 0.589 (0.059) | 0.588 (0.056) | 0.588 (0.054) | 0.587 (0.049) | 0.585 (0.050) | 0.586 (0.047) | 0.588 (0.049) |
| LD | 89 | — | 0.894 (0.028) | 0.895 (0.027) | 0.892 (0.027) | 0.893 (0.026) | 0.894 (0.025) | 0.893 (0.026) |
| SH | 88 | 0.886 (0.032) | 0.889 (0.029) | 0.891 (0.028) | 0.886 (0.027) | 0.890 (0.026) | 0.890 (0.026) | 0.888 (0.026) |
| SD | 95 | 0.929 (0.027) | 0.924 (0.026) | 0.922 (0.026) | 0.930 (0.023) | 0.926 (0.025) | 0.921 (0.025) | 0.926 (0.024) |

C&V = Consonni & Veronese; RJMCMC = Reversible Jump Markov Chain Monte Carlo. H, planting too high; D, planting too deep; L, longleaf seedling; S, slash seedling.

We show posterior density estimates for the $\{\theta_i\}$, under the random $q$ version of the model, together with the raw data, plotted with tick marks at the points $y_i/w_i$. The adaptive multiple shrinkage is evident — estimates are shrunk together, and correspondingly have smaller posterior variance. The data suggest that treatment H increases mortality, but only on seedlings of type L: a more subtle conclusion than from the logistic regression analysis, which simply concludes that both treatment and variety factors have significant effects.
